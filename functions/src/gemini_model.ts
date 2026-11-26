/**
 * Gemini adapter for the trip assistant.
 *
 * The assistant loop (assistant.ts) speaks one provider-neutral protocol, the
 * Messages shape: text / tool_use / tool_result blocks and a stop reason. This
 * file translates that to Gemini's `generateContent` REST API and back, so the
 * provider and model can change without touching validation, tools, rate
 * limits or session storage.
 *
 * - The API key is sent only in the `x-goog-api-key` header (never in the URL or logs).
 * - Gemini 3 models return a `thoughtSignature` with function calls that must be
 *   sent back on the next request; it is kept on the stored tool_use block as
 *   `gemini_signature` (sessions are server-only, so the client never sees it).
 * - Quota / rate-limit errors (HTTP 429) become `ModelQuotaError`. There is no
 *   automatic switch to another model or paid tier.
 */
import type Anthropic from '@anthropic-ai/sdk';
import { ModelQuotaError, type ModelClient } from './assistant';

export const GEMINI_ENDPOINT = 'https://generativelanguage.googleapis.com/v1beta/models';

/** Any other non-OK answer from the provider; carries the status only, never the body. */
export class ModelHttpError extends Error {
  constructor(readonly status: number) { super(`AI model HTTP ${status}`); this.name = 'ModelHttpError'; }
}

export type FetchLike = (url: string, init: { method: string; headers: Record<string, string>; body: string; signal?: AbortSignal })
  => Promise<{ ok: boolean; status: number; json(): Promise<unknown> }>;

// ---------- Gemini wire types (only what we use) ----------

interface GeminiPart {
  text?: string;
  thought?: boolean;
  thoughtSignature?: string;
  functionCall?: { id?: string; name: string; args?: Record<string, unknown> };
  functionResponse?: { id?: string; name: string; response: Record<string, unknown> };
}
interface GeminiContent { role: 'user' | 'model'; parts: GeminiPart[] }
interface GeminiResponse {
  candidates?: { content?: { parts?: GeminiPart[] }; finishReason?: string }[];
  promptFeedback?: { blockReason?: string };
  usageMetadata?: { promptTokenCount?: number; candidatesTokenCount?: number };
}

type StoredToolUse = Anthropic.ToolUseBlockParam & { gemini_signature?: string };
type StoredText = Anthropic.TextBlockParam & { gemini_signature?: string };

const BLOCKED = new Set(['SAFETY', 'PROHIBITED_CONTENT', 'BLOCKLIST', 'SPII', 'RECITATION', 'IMAGE_SAFETY']);

/** JSON Schema → the OpenAPI subset Gemini accepts (drops `additionalProperties`). */
export function toGeminiSchema(schema: unknown): unknown {
  if (Array.isArray(schema)) return schema.map(toGeminiSchema);
  if (typeof schema !== 'object' || schema === null) return schema;
  const out: Record<string, unknown> = {};
  for (const [k, v] of Object.entries(schema)) {
    if (k === 'additionalProperties') continue;
    out[k] = k === 'properties'
      ? Object.fromEntries(Object.entries(v as Record<string, unknown>).map(([p, s]) => [p, toGeminiSchema(s)]))
      : toGeminiSchema(v);
  }
  return out;
}

function toolDeclarations(tools: Anthropic.ToolUnion[] | undefined) {
  return (tools ?? []).filter((t): t is Anthropic.Tool => 'input_schema' in t).map((t) => {
    const props = (t.input_schema.properties ?? {}) as Record<string, unknown>;
    return {
      name: t.name,
      description: t.description ?? '',
      ...(Object.keys(props).length ? { parameters: toGeminiSchema(t.input_schema) } : {}),
    };
  });
}

function systemText(system: Anthropic.MessageCreateParamsNonStreaming['system']): string {
  if (!system) return '';
  return typeof system === 'string' ? system : system.map((b) => b.text).join('\n');
}

/** A tool_result's content is our own JSON string; Gemini wants an object. */
function responseObject(block: Anthropic.ToolResultBlockParam): Record<string, unknown> {
  const raw = typeof block.content === 'string'
    ? block.content
    : (block.content ?? []).map((c) => (c.type === 'text' ? c.text : '')).join('');
  let value: unknown = raw;
  try { value = JSON.parse(raw); } catch { /* keep the text */ }
  const obj = typeof value === 'object' && value !== null && !Array.isArray(value)
    ? value as Record<string, unknown> : { result: value };
  return block.is_error ? { error: obj } : obj;
}

/** Messages history → Gemini `contents`. Unknown blocks (e.g. another provider's thinking) are skipped. */
export function toGeminiContents(messages: Anthropic.MessageParam[]): GeminiContent[] {
  const names = new Map<string, string>();
  const out: GeminiContent[] = [];
  for (const m of messages) {
    const role = m.role === 'assistant' ? 'model' : 'user';
    const parts: GeminiPart[] = [];
    if (typeof m.content === 'string') {
      parts.push({ text: m.content });
    } else {
      for (const b of m.content) {
        if (b.type === 'text') {
          const sig = (b as StoredText).gemini_signature;
          if (b.text) parts.push({ text: b.text, ...(sig ? { thoughtSignature: sig } : {}) });
        } else if (b.type === 'tool_use') {
          names.set(b.id, b.name);
          const sig = (b as StoredToolUse).gemini_signature;
          parts.push({
            functionCall: { id: b.id, name: b.name, args: (b.input ?? {}) as Record<string, unknown> },
            ...(sig ? { thoughtSignature: sig } : {}),
          });
        } else if (b.type === 'tool_result') {
          parts.push({
            functionResponse: { id: b.tool_use_id, name: names.get(b.tool_use_id) ?? 'unknown', response: responseObject(b) },
          });
        }
      }
    }
    if (parts.length) out.push({ role, parts });
  }
  return out;
}

let counter = 0;
const newId = () => `gem_${Date.now().toString(36)}${(counter++).toString(36)}`;

/** Gemini response → the Messages shape the loop understands. */
export function fromGeminiResponse(res: GeminiResponse, model: string): Anthropic.Message {
  const cand = res.candidates?.[0];
  const content: (StoredText | StoredToolUse)[] = [];
  for (const p of cand?.content?.parts ?? []) {
    if (p.thought) continue; // thought summaries are not shown or stored
    if (p.functionCall) {
      content.push({
        type: 'tool_use', id: p.functionCall.id || newId(), name: p.functionCall.name,
        input: p.functionCall.args ?? {}, ...(p.thoughtSignature ? { gemini_signature: p.thoughtSignature } : {}),
      });
    } else if (p.text) {
      content.push({ type: 'text', text: p.text, ...(p.thoughtSignature ? { gemini_signature: p.thoughtSignature } : {}) });
    }
  }
  let stop: Anthropic.StopReason;
  if (res.promptFeedback?.blockReason || BLOCKED.has(cand?.finishReason ?? '')) stop = 'refusal';
  else if (content.some((b) => b.type === 'tool_use')) stop = 'tool_use';
  else if (cand?.finishReason === 'MAX_TOKENS') stop = 'max_tokens';
  else stop = 'end_turn';
  return {
    id: newId(), type: 'message', role: 'assistant', model, content, stop_reason: stop, stop_sequence: null,
    usage: { input_tokens: res.usageMetadata?.promptTokenCount ?? 0, output_tokens: res.usageMetadata?.candidatesTokenCount ?? 0 },
  } as unknown as Anthropic.Message;
}

/** Builds the `generateContent` body for one assistant step. */
export function toGeminiRequest(params: Anthropic.MessageCreateParamsNonStreaming): Record<string, unknown> {
  const decls = toolDeclarations(params.tools);
  const system = systemText(params.system);
  return {
    ...(system ? { systemInstruction: { parts: [{ text: system }] } } : {}),
    contents: toGeminiContents(params.messages),
    ...(decls.length ? { tools: [{ functionDeclarations: decls }], toolConfig: { functionCallingConfig: { mode: 'AUTO' } } } : {}),
    generationConfig: { maxOutputTokens: params.max_tokens },
  };
}

/** A `ModelClient` backed by Gemini. `fetchImpl` is injectable for tests. */
export function geminiModel(apiKey: string, modelId: string, fetchImpl: FetchLike = fetch as unknown as FetchLike,
  timeoutMs = 60_000): ModelClient {
  if (!/^[a-z0-9.-]{3,60}$/.test(modelId)) throw new Error('Bad Gemini model id');
  return {
    demo: false,
    modelId,
    async create(params) {
      const res = await fetchImpl(`${GEMINI_ENDPOINT}/${modelId}:generateContent`, {
        method: 'POST',
        headers: { 'content-type': 'application/json', 'x-goog-api-key': apiKey },
        body: JSON.stringify(toGeminiRequest(params)),
        signal: AbortSignal.timeout(timeoutMs),
      });
      if (res.status === 429) throw new ModelQuotaError();
      if (!res.ok) throw new ModelHttpError(res.status);
      return fromGeminiResponse(await res.json() as GeminiResponse, modelId);
    },
  };
}
