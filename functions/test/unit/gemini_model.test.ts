import { test } from 'node:test';
import assert from 'node:assert/strict';
import type Anthropic from '@anthropic-ai/sdk';
import { ModelQuotaError, SYSTEM_PROMPT, TOOLS } from '../../src/assistant';
import {
  fromGeminiResponse, geminiModel, GEMINI_ENDPOINT, ModelHttpError, toGeminiContents, toGeminiRequest, toGeminiSchema,
  type FetchLike,
} from '../../src/gemini_model';

const params = (messages: Anthropic.MessageParam[]): Anthropic.MessageCreateParamsNonStreaming =>
  ({ model: 'x', max_tokens: 4096, system: SYSTEM_PROMPT, tools: TOOLS, messages });

test('schemas drop additionalProperties at every level', () => {
  const out = JSON.stringify(TOOLS.map((t) => toGeminiSchema(t.input_schema)));
  assert.ok(!out.includes('additionalProperties'));
  assert.deepEqual(toGeminiSchema({ type: 'object', additionalProperties: false, properties: { a: { type: 'string' } } }),
    { type: 'object', properties: { a: { type: 'string' } } });
});

test('request has system, all tools, AUTO mode and the token cap', () => {
  const body = toGeminiRequest(params([{ role: 'user', content: 'hi' }])) as any;
  assert.equal(body.systemInstruction.parts[0].text, SYSTEM_PROMPT);
  const decls = body.tools[0].functionDeclarations;
  assert.deepEqual(decls.map((d: any) => d.name), TOOLS.map((t) => t.name));
  assert.equal(decls[0].parameters, undefined, 'no-argument tool sends no parameters');
  assert.deepEqual(decls[1].parameters.required, ['destination', 'strategy']);
  assert.equal(body.toolConfig.functionCallingConfig.mode, 'AUTO');
  assert.equal(body.generationConfig.maxOutputTokens, 4096);
  assert.deepEqual(body.contents, [{ role: 'user', parts: [{ text: 'hi' }] }]);
});

test('history: tool calls keep id + signature, results get the tool name and an object', () => {
  const contents = toGeminiContents([
    { role: 'user', content: 'to Potsdam' },
    { role: 'assistant', content: [
      { type: 'thinking', thinking: 'old provider', signature: 's' } as any,
      { type: 'tool_use', id: 'c1', name: 'plan_route_stops', input: { destination: 'Potsdam' }, gemini_signature: 'SIG' } as any,
    ] },
    { role: 'user', content: [
      { type: 'tool_result', tool_use_id: 'c1', content: '{"stations":[]}' },
    ] },
    { role: 'assistant', content: [{ type: 'tool_use', id: 'c2', name: 'get_vehicle', input: {} }] },
    { role: 'user', content: [{ type: 'tool_result', tool_use_id: 'c2', content: '"nope"', is_error: true }] },
  ]);
  assert.deepEqual(contents[1], { role: 'model', parts: [
    { functionCall: { id: 'c1', name: 'plan_route_stops', args: { destination: 'Potsdam' } }, thoughtSignature: 'SIG' },
  ] });
  assert.deepEqual(contents[2].parts[0].functionResponse, { id: 'c1', name: 'plan_route_stops', response: { stations: [] } });
  assert.deepEqual(contents[4].parts[0].functionResponse!.response, { error: { result: 'nope' } });
});

test('response mapping: function calls, text, stop reasons, thoughts hidden', () => {
  const call = fromGeminiResponse({ candidates: [{ finishReason: 'STOP', content: { parts: [
    { thought: true, text: 'thinking…' },
    { functionCall: { name: 'get_vehicle', args: {} }, thoughtSignature: 'S1' },
  ] } }] }, 'm');
  assert.equal(call.stop_reason, 'tool_use');
  assert.equal(call.content.length, 1);
  const u = call.content[0] as any;
  assert.equal(u.type, 'tool_use'); assert.equal(u.name, 'get_vehicle'); assert.equal(u.gemini_signature, 'S1');
  assert.match(u.id, /^gem_/);

  const done = fromGeminiResponse({ candidates: [{ finishReason: 'STOP', content: { parts: [{ text: 'Hi' }] } }] }, 'm');
  assert.equal(done.stop_reason, 'end_turn');
  assert.equal((done.content[0] as Anthropic.TextBlock).text, 'Hi');
  assert.equal(fromGeminiResponse({ candidates: [{ finishReason: 'MAX_TOKENS', content: { parts: [{ text: 'p' }] } }] }, 'm')
    .stop_reason, 'max_tokens');
  assert.equal(fromGeminiResponse({ candidates: [{ finishReason: 'SAFETY' }] }, 'm').stop_reason, 'refusal');
  assert.equal(fromGeminiResponse({ promptFeedback: { blockReason: 'OTHER' } }, 'm').stop_reason, 'refusal');
});

function fakeFetch(status: number, body: unknown) {
  const calls: { url: string; headers: Record<string, string>; body: string }[] = [];
  const f: FetchLike = async (url, init) => {
    calls.push({ url, headers: init.headers, body: init.body });
    return { ok: status < 400, status, json: async () => body };
  };
  return { f, calls };
}

test('client: key only in the header, model id in the path', async () => {
  const { f, calls } = fakeFetch(200, { candidates: [{ finishReason: 'STOP', content: { parts: [{ text: 'ok' }] } }] });
  const m = geminiModel('TEST_KEY', 'gemini-3.8-flash', f);
  const r = await m.create(params([{ role: 'user', content: 'hi' }]));
  assert.equal((r.content[0] as Anthropic.TextBlock).text, 'ok');
  assert.equal(calls[0].url, `${GEMINI_ENDPOINT}/gemini-3.8-flash:generateContent`);
  assert.ok(!calls[0].url.includes('TEST_KEY'));
  assert.equal(calls[0].headers['x-goog-api-key'], 'TEST_KEY');
  assert.ok(!calls[0].body.includes('TEST_KEY'));
  assert.equal(m.modelId, 'gemini-3.8-flash');
});

test('client: 429 is a quota error, other failures carry only the status', async () => {
  await assert.rejects(geminiModel('k', 'gemini-3.8-flash', fakeFetch(429, {}).f).create(params([])),
    (e) => e instanceof ModelQuotaError);
  await assert.rejects(geminiModel('k', 'gemini-3.8-flash', fakeFetch(503, { error: 'secret detail' }).f).create(params([])),
    (e) => e instanceof ModelHttpError && e.status === 503 && !e.message.includes('secret'));
  assert.throws(() => geminiModel('k', '../evil?x=1', fakeFetch(200, {}).f));
});
