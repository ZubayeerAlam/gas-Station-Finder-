/**
 * FuelWise trip assistant: a Claude tool-use loop run server-side so the API
 * key never reaches the app.
 *
 * Tools are split by where their data lives:
 *  - client tools (`get_vehicle`, `plan_route_stops`) run in the app with the
 *    same Dart planner + ranking engine the UI uses, so AI answers always match
 *    the app's own ranking. The function returns them as "needs_client_tools"
 *    and the app sends the results back on the next call.
 *  - server tools (`get_community_prices`, `show_station_cards`) run here.
 *
 * The conversation lives in `assistantSessions/{id}` (server-only, append-only),
 * so the client can never rewrite history or inject assistant turns.
 */
import type Anthropic from '@anthropic-ai/sdk';
import { FieldValue, Timestamp, type Firestore } from 'firebase-admin/firestore';

/** Claude Haiku 5.5 — ID verified against the installed @anthropic-ai/sdk 1.14 model list. */
export const ASSISTANT_MODEL = 'claude-haiku-5-5';
/** Chat replies are short by design; also a cost cap per model call. */
export const MAX_TOKENS = 4096;
export const MAX_MODEL_CALLS_PER_REQUEST = 6;
export const MAX_USER_TURNS_PER_SESSION = 20;
export const MAX_TEXT_CHARS = 1000;
export const MAX_TOOL_RESULT_CHARS = 16_000;
export const MAX_CARDS = 5;
export const RATE_LIMIT_PER_HOUR = 20;
export const RATE_LIMIT_PER_DAY = 100;

export const CLIENT_TOOLS = ['get_vehicle', 'plan_route_stops'] as const;
export const SERVER_TOOLS = ['get_community_prices', 'show_station_cards'] as const;
const ALLOWED_TOOLS = new Set<string>([...CLIENT_TOOLS, ...SERVER_TOOLS]);

/** Minimal model surface so tests and the emulator demo can swap the real client. */
export interface ModelClient {
  readonly demo: boolean;
  create(params: Anthropic.MessageCreateParamsNonStreaming): Promise<Anthropic.Message>;
}

export const SYSTEM_PROMPT = `You are the FuelWise trip assistant inside a fuel and EV-charging app.
Help the driver decide where to refuel or charge, using the tools. Every station, price, detour,
cost and reliability figure you mention must come from a tool result in this conversation; if a
value is missing, say it is unknown. Prices are only Google or community reports — never estimate one.
The app's ranking is a calculation, and "best value" is a heuristic; say so if you recommend by it.
When you recommend stations, call show_station_cards with their ids (best first) so the app can
show them as cards. Keep replies short (under 120 words) and answer in the user's language
(English or Bengali). If a request is not about driving, fuel, charging or trip costs, say briefly
that you can only help with those.`;

export const TOOLS: Anthropic.Tool[] = [
  {
    name: 'get_vehicle',
    description: "Returns the user's active vehicle from their garage (energy type, consumption, " +
      'tank or battery size, preferred fuel), or null if they have none.',
    strict: true,
    input_schema: { type: 'object', properties: {}, required: [], additionalProperties: false },
  },
  {
    name: 'plan_route_stops',
    description: 'Plans a driving route from the current location to a destination and ranks fuel or ' +
      'charging stops along it with the app\'s cost engine. Returns the route, the ranked stations ' +
      '(id, name, price and its source, detour, total trip cost, savings, reliability, open status) and caveats.',
    strict: true,
    input_schema: {
      type: 'object',
      properties: {
        destination: { type: 'string', description: 'Destination as the user said it, e.g. "Potsdam Hbf".' },
        strategy: {
          type: 'string',
          enum: ['cheapest_total', 'shortest_detour', 'best_value'],
          description: 'cheapest_total = lowest purchase + detour cost (default); best_value = heuristic balance.',
        },
      },
      required: ['destination', 'strategy'],
      additionalProperties: false,
    },
  },
  {
    name: 'get_community_prices',
    description: 'Community-reported consensus prices for up to 10 station ids, with report count, ' +
      'confidence and age. Only fresh prices (under 72 h) are returned.',
    strict: true,
    input_schema: {
      type: 'object',
      properties: { station_ids: { type: 'array', items: { type: 'string' } } },
      required: ['station_ids'],
      additionalProperties: false,
    },
  },
  {
    name: 'show_station_cards',
    description: 'Shows stations from plan_route_stops as tappable cards in the app, best first. ' +
      'Only ids returned by plan_route_stops in this conversation are accepted.',
    strict: true,
    input_schema: {
      type: 'object',
      properties: { station_ids: { type: 'array', items: { type: 'string' } } },
      required: ['station_ids'],
      additionalProperties: false,
    },
  },
];

// ---------- request / response contract ----------

export interface ClientToolResult { toolUseId: string; output: unknown; isError?: boolean }
export interface AssistantRequest { sessionId?: string; text?: string; toolResults?: ClientToolResult[] }
export interface ClientToolCall { id: string; name: string; input: unknown }
export interface AssistantResponse {
  sessionId: string;
  status: 'done' | 'needs_client_tools';
  reply?: string;
  cards: string[];
  clientToolCalls?: ClientToolCall[];
  demo: boolean;
}

/** Thrown for user-facing problems; mapped to HttpsError by index.ts. */
export class AssistantError extends Error {
  constructor(readonly code: 'invalid-argument' | 'not-found' | 'resource-exhausted' | 'failed-precondition' | 'unavailable',
    message: string) { super(message); }
}

interface PendingTurn {
  /** tool_use ids the client must answer, in order. */
  clientIds: string[];
  /** Results of server tools from the same assistant turn (sent together with the client's). */
  serverResults: Anthropic.ToolResultBlockParam[];
  /** Order of every tool_use in that turn, so results go back in the same order. */
  order: string[];
}

interface SessionDoc {
  uid: string;
  messagesJson: string;
  pendingJson: string | null;
  knownStationIds: string[];
  cards: string[];
  userTurns: number;
}

/** Validates the raw callable payload (never trust the client). */
export function parseRequest(data: unknown): AssistantRequest {
  if (typeof data !== 'object' || data === null) throw new AssistantError('invalid-argument', 'Bad request.');
  const d = data as Record<string, unknown>;
  const sessionId = d.sessionId;
  if (sessionId !== undefined && (typeof sessionId !== 'string' || !/^[A-Za-z0-9]{10,40}$/.test(sessionId))) {
    throw new AssistantError('invalid-argument', 'Bad session id.');
  }
  const hasText = d.text !== undefined, hasResults = d.toolResults !== undefined;
  if (hasText === hasResults) throw new AssistantError('invalid-argument', 'Send either a message or tool results.');
  if (hasText) {
    if (typeof d.text !== 'string') throw new AssistantError('invalid-argument', 'Message must be text.');
    const text = d.text.trim();
    if (!text) throw new AssistantError('invalid-argument', 'Message is empty.');
    if (text.length > MAX_TEXT_CHARS) throw new AssistantError('invalid-argument', `Message is longer than ${MAX_TEXT_CHARS} characters.`);
    return { sessionId: sessionId as string | undefined, text };
  }
  if (!sessionId) throw new AssistantError('invalid-argument', 'Tool results need a session.');
  if (!Array.isArray(d.toolResults) || d.toolResults.length === 0 || d.toolResults.length > 4) {
    throw new AssistantError('invalid-argument', 'Bad tool results.');
  }
  const toolResults = d.toolResults.map((r): ClientToolResult => {
    const x = r as Record<string, unknown>;
    if (typeof x?.toolUseId !== 'string') throw new AssistantError('invalid-argument', 'Bad tool result.');
    const size = JSON.stringify(x.output ?? null).length;
    if (size > MAX_TOOL_RESULT_CHARS) throw new AssistantError('invalid-argument', 'Tool result too large.');
    return { toolUseId: x.toolUseId, output: x.output ?? null, isError: x.isError === true };
  });
  return { sessionId: sessionId as string, toolResults };
}

// ---------- rate limiting ----------

/** Fixed hour + day windows per user, counted only for new user messages. */
export async function consumeQuota(db: Firestore, uid: string, nowMs: number): Promise<void> {
  const ref = db.collection('assistantQuota').doc(uid);
  const hour = Math.floor(nowMs / 3_600_000), day = Math.floor(nowMs / 86_400_000);
  await db.runTransaction(async (tx) => {
    const s = await tx.get(ref);
    const hourCount = s.get('hour') === hour ? (s.get('hourCount') as number) : 0;
    const dayCount = s.get('day') === day ? (s.get('dayCount') as number) : 0;
    if (hourCount >= RATE_LIMIT_PER_HOUR || dayCount >= RATE_LIMIT_PER_DAY) {
      throw new AssistantError('resource-exhausted', 'You have reached the assistant limit for now. Please try again later.');
    }
    tx.set(ref, { hour, hourCount: hourCount + 1, day, dayCount: dayCount + 1 });
  });
}

// ---------- server tools ----------

function validIds(input: unknown): string[] | null {
  const ids = (input as { station_ids?: unknown })?.station_ids;
  if (!Array.isArray(ids) || ids.some((x) => typeof x !== 'string' || x.length === 0 || x.length > 200)) return null;
  return [...new Set(ids as string[])];
}

async function communityPrices(db: Firestore, input: unknown, nowMs: number): Promise<unknown> {
  const ids = validIds(input);
  if (!ids) throw new Error('station_ids must be a list of ids');
  const out: Record<string, unknown[]> = {};
  for (const id of ids.slice(0, 10)) {
    const snap = await db.collection('stations').doc(id).collection('prices').get();
    out[id] = snap.docs
      .filter((d) => ((d.get('expiresAt') as Timestamp | undefined)?.toMillis() ?? 0) > nowMs)
      .map((d) => ({
        fuel_type: d.get('fuelType'),
        price: d.get('price'),
        currency: d.get('currency'),
        report_count: d.get('reportCount'),
        confidence: d.get('confidence'),
        last_report_at: (d.get('lastReportAt') as Timestamp).toDate().toISOString(),
      }));
  }
  return { prices: out, note: 'Community consensus; stations without fresh reports have an empty list.' };
}

/** Station ids the client's plan_route_stops returned (the only ids cards may show). */
export function stationIdsFromPlan(output: unknown): string[] {
  const stations = (output as { stations?: unknown })?.stations;
  if (!Array.isArray(stations)) return [];
  return stations.map((s) => (s as { id?: unknown })?.id).filter((x): x is string => typeof x === 'string');
}

// ---------- the loop ----------

function textOf(content: Anthropic.ContentBlock[]): string {
  return content.filter((b): b is Anthropic.TextBlock => b.type === 'text').map((b) => b.text).join('\n').trim();
}

function result(id: string, content: unknown, isError = false): Anthropic.ToolResultBlockParam {
  return { type: 'tool_result', tool_use_id: id, content: JSON.stringify(content), ...(isError ? { is_error: true } : {}) };
}

/**
 * One callable request: append the user's message (or the client's tool
 * results), then call Claude until it answers or needs client tools.
 */
export async function runAssistant(
  db: Firestore, uid: string, req: AssistantRequest, model: ModelClient, nowMs = Date.now(),
): Promise<AssistantResponse> {
  const sessions = db.collection('assistantSessions');
  let ref = req.sessionId ? sessions.doc(req.sessionId) : sessions.doc();
  let s: SessionDoc;
  if (req.sessionId) {
    const snap = await ref.get();
    if (!snap.exists || snap.get('uid') !== uid) throw new AssistantError('not-found', 'Conversation not found.');
    s = snap.data() as SessionDoc;
  } else {
    s = { uid, messagesJson: '[]', pendingJson: null, knownStationIds: [], cards: [], userTurns: 0 };
  }
  const messages = JSON.parse(s.messagesJson) as Anthropic.MessageParam[];
  const pending = s.pendingJson ? (JSON.parse(s.pendingJson) as PendingTurn) : null;
  const known = new Set(s.knownStationIds);
  let cards: string[] = [];

  if (req.text !== undefined) {
    if (pending) throw new AssistantError('failed-precondition', 'Waiting for the app to finish the previous step.');
    if (s.userTurns >= MAX_USER_TURNS_PER_SESSION) {
      throw new AssistantError('failed-precondition', 'This conversation is full. Please start a new one.');
    }
    await consumeQuota(db, uid, nowMs);
    messages.push({ role: 'user', content: req.text });
    s.userTurns++;
  } else {
    // Tool results must answer exactly the pending client tool calls.
    if (!pending) throw new AssistantError('failed-precondition', 'No tool call is waiting for results.');
    const got = new Map(req.toolResults!.map((r) => [r.toolUseId, r]));
    if (got.size !== pending.clientIds.length || pending.clientIds.some((id) => !got.has(id))) {
      throw new AssistantError('invalid-argument', 'Tool results do not match the pending tool calls.');
    }
    const byId = new Map(pending.serverResults.map((r) => [r.tool_use_id, r]));
    for (const id of pending.clientIds) {
      const r = got.get(id)!;
      byId.set(id, result(id, r.output, r.isError));
      for (const sid of stationIdsFromPlan(r.output)) known.add(sid);
    }
    messages.push({ role: 'user', content: pending.order.map((id) => byId.get(id)!) });
  }

  let reply: string | undefined;
  let newPending: PendingTurn | null = null;
  for (let call = 0; call < MAX_MODEL_CALLS_PER_REQUEST && reply === undefined && !newPending; call++) {
    let res: Anthropic.Message;
    try {
      res = await model.create({
        model: ASSISTANT_MODEL,
        max_tokens: MAX_TOKENS,
        system: SYSTEM_PROMPT,
        tools: TOOLS,
        messages,
        output_config: { effort: 'medium' },
        cache_control: { type: 'ephemeral' },
      });
    } catch {
      // Nothing was appended for this call, so the session stays consistent.
      throw new AssistantError('unavailable', 'The assistant is unavailable right now. Please try again.');
    }
    // Append the full content (thinking blocks included) unchanged: history is append-only.
    messages.push({ role: 'assistant', content: res.content });

    switch (res.stop_reason) {
      case 'refusal':
        reply = "Sorry, I can't help with that. I can help with fuel, charging and trip costs.";
        break;
      case 'max_tokens':
        reply = (textOf(res.content) + '\n\n(Reply cut short.)').trim();
        break;
      case 'pause_turn':
        continue;
      case 'tool_use': {
        const uses = res.content.filter((b): b is Anthropic.ToolUseBlock => b.type === 'tool_use');
        const serverResults: Anthropic.ToolResultBlockParam[] = [];
        const clientCalls: ClientToolCall[] = [];
        for (const u of uses) {
          if (!ALLOWED_TOOLS.has(u.name)) {
            serverResults.push(result(u.id, { error: `Unknown tool ${u.name}` }, true));
          } else if ((CLIENT_TOOLS as readonly string[]).includes(u.name)) {
            clientCalls.push({ id: u.id, name: u.name, input: u.input });
          } else if (u.name === 'get_community_prices') {
            try {
              serverResults.push(result(u.id, await communityPrices(db, u.input, nowMs)));
            } catch (e) {
              serverResults.push(result(u.id, { error: (e as Error).message }, true));
            }
          } else {
            const ids = validIds(u.input) ?? [];
            const shown = ids.filter((id) => known.has(id)).slice(0, MAX_CARDS);
            const rejected = ids.filter((id) => !known.has(id));
            cards = shown;
            serverResults.push(result(u.id, {
              shown,
              ...(rejected.length ? { rejected, reason: 'Only ids returned by plan_route_stops can be shown.' } : {}),
            }));
          }
        }
        const order = uses.map((u) => u.id);
        if (clientCalls.length) {
          newPending = { clientIds: clientCalls.map((c) => c.id), serverResults, order };
          await save();
          return { sessionId: ref.id, status: 'needs_client_tools', clientToolCalls: clientCalls, cards, demo: model.demo };
        }
        messages.push({ role: 'user', content: order.map((id) => serverResults.find((r) => r.tool_use_id === id)!) });
        break;
      }
      default: // end_turn, stop_sequence
        reply = textOf(res.content) || '…';
    }
  }
  if (reply === undefined) reply = 'Sorry, that took too many steps. Please try a simpler question.';
  await save();
  return { sessionId: ref.id, status: 'done', reply, cards, demo: model.demo };

  async function save(): Promise<void> {
    const json = JSON.stringify(messages);
    if (json.length > 800_000) throw new AssistantError('failed-precondition', 'This conversation is full. Please start a new one.');
    await ref.set({
      uid,
      messagesJson: json,
      pendingJson: newPending ? JSON.stringify(newPending) : null,
      knownStationIds: [...known].slice(-200),
      cards,
      userTurns: s.userTurns,
      model: ASSISTANT_MODEL,
      updatedAt: FieldValue.serverTimestamp(),
      ...(req.sessionId ? {} : { createdAt: FieldValue.serverTimestamp() }),
    }, { merge: true });
    ref = sessions.doc(ref.id);
  }
}
