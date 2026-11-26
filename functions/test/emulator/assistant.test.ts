import { after, before, beforeEach, test } from 'node:test';
import assert from 'node:assert/strict';
import type Anthropic from '@anthropic-ai/sdk';
import { deleteApp, initializeApp, type App } from 'firebase-admin/app';
import { getFirestore, Timestamp, type Firestore } from 'firebase-admin/firestore';
import {
  AssistantError, ModelQuotaError, RATE_LIMIT_PER_HOUR, runAssistant, type ModelClient,
} from '../../src/assistant';

// The loop against the Firestore emulator with a scripted fake Claude. No
// network calls to Anthropic are made by these tests.
let app: App;
let db: Firestore;

before(async () => {
  assert.ok(process.env.FIRESTORE_EMULATOR_HOST, 'must run against the emulator');
  app = initializeApp({ projectId: 'demo-fuelwise' }, 'assistant');
  db = getFirestore(app);
});
beforeEach(async () => {
  await fetch(`http://${process.env.FIRESTORE_EMULATOR_HOST}/emulator/v1/projects/demo-fuelwise/databases/(default)/documents`,
    { method: 'DELETE' });
});
after(async () => deleteApp(app));

type Block = Record<string, unknown>;
const msg = (content: Block[], stop: string) =>
  ({ id: 'm', type: 'message', role: 'assistant', model: 'x', content, stop_reason: stop, stop_sequence: null,
    usage: { input_tokens: 1, output_tokens: 1 } }) as unknown as Anthropic.Message;
const text = (t: string) => ({ type: 'text', text: t, citations: null });
const use = (id: string, name: string, input: unknown) => ({ type: 'tool_use', id, name, input });

/** Replays scripted responses and records every request it got. */
function fake(...script: Anthropic.Message[]): ModelClient & { calls: Anthropic.MessageCreateParamsNonStreaming[] } {
  const calls: Anthropic.MessageCreateParamsNonStreaming[] = [];
  return {
    demo: false, modelId: 'fake-model', calls,
    async create(p) {
      calls.push(structuredClone(p));
      const next = script.shift();
      if (!next) throw new Error('script exhausted');
      return next;
    },
  };
}

const PLAN = { stations: [{ id: 'st1', name: 'Aral' }, { id: 'st2', name: 'Shell' }] };

test('full turn: client tool round-trip, server tool, cards from known ids only', async () => {
  await db.doc('stations/st1/prices/DIESEL').set({
    fuelType: 'DIESEL', price: 1.7, currency: 'EUR', reportCount: 3, confidence: 0.9,
    lastReportAt: Timestamp.now(), expiresAt: Timestamp.fromMillis(Date.now() + 3_600_000),
  });
  await db.doc('stations/st2/prices/DIESEL').set({
    fuelType: 'DIESEL', price: 1.6, currency: 'EUR', reportCount: 1, confidence: 0.5,
    lastReportAt: Timestamp.now(), expiresAt: Timestamp.fromMillis(Date.now() - 1),
  });
  const thinking = { type: 'thinking', thinking: 'plan first', signature: 'sig' };
  const m = fake(
    msg([thinking, use('t1', 'get_vehicle', {}), use('t2', 'plan_route_stops', { destination: 'Potsdam', strategy: 'cheapest_total' })], 'tool_use'),
    msg([use('t3', 'get_community_prices', { station_ids: ['st1', 'st2'] })], 'tool_use'),
    msg([use('t4', 'show_station_cards', { station_ids: ['st1', 'evil', 'st2'] })], 'tool_use'),
    msg([text('Aral is cheapest overall.')], 'end_turn'),
  );

  const r1 = await runAssistant(db, 'u1', { text: 'Fuel on the way to Potsdam?' }, m);
  assert.equal(r1.status, 'needs_client_tools');
  assert.deepEqual(r1.clientToolCalls!.map((c) => c.name), ['get_vehicle', 'plan_route_stops']);

  // Wrong ids are refused and nothing changes.
  await assert.rejects(runAssistant(db, 'u1', { sessionId: r1.sessionId, toolResults: [{ toolUseId: 't1', output: null }] }, m),
    (e: AssistantError) => e.code === 'invalid-argument');
  // Another user cannot continue the session.
  await assert.rejects(runAssistant(db, 'u2', { sessionId: r1.sessionId, toolResults: [] }, m),
    (e: AssistantError) => e.code === 'not-found');

  const r2 = await runAssistant(db, 'u1', {
    sessionId: r1.sessionId,
    toolResults: [{ toolUseId: 't2', output: PLAN }, { toolUseId: 't1', output: { energy: 'diesel' } }],
  }, m);
  assert.equal(r2.status, 'done');
  assert.equal(r2.reply, 'Aral is cheapest overall.');
  assert.deepEqual(r2.cards, ['st1', 'st2']);

  // Request 2: results in the original tool_use order, after the unchanged assistant turn (thinking kept).
  const req2 = m.calls[1].messages;
  assert.deepEqual((req2[1].content as unknown as Block[])[0], thinking);
  const results = req2[2].content as Anthropic.ToolResultBlockParam[];
  assert.deepEqual(results.map((r) => r.tool_use_id), ['t1', 't2']);
  // Request 3: only the fresh community price is returned.
  const prices = JSON.parse((m.calls[2].messages[4].content as Anthropic.ToolResultBlockParam[])[0].content as string);
  assert.equal(prices.prices.st1.length, 1);
  assert.equal(prices.prices.st2.length, 0);
  // Request 4: the unknown id was rejected back to the model.
  const shown = JSON.parse((m.calls[3].messages[6].content as Anthropic.ToolResultBlockParam[])[0].content as string);
  assert.deepEqual(shown.rejected, ['evil']);
  // Every call used the verified model, strict tools and a token cap.
  for (const c of m.calls) {
    assert.equal(c.model, 'fake-model'); // the client's own model id is sent
    assert.equal(c.max_tokens, 4096);
  }
  // History is append-only: each request extends the previous one.
  for (let i = 1; i < m.calls.length; i++) {
    assert.deepEqual(m.calls[i].messages.slice(0, m.calls[i - 1].messages.length), m.calls[i - 1].messages);
  }
});

test('unknown tools are answered with an error, not executed', async () => {
  const m = fake(msg([use('x1', 'delete_everything', {})], 'tool_use'), msg([text('ok')], 'end_turn'));
  const r = await runAssistant(db, 'u1', { text: 'hi' }, m);
  assert.equal(r.status, 'done');
  const res = (m.calls[1].messages[2].content as Anthropic.ToolResultBlockParam[])[0];
  assert.equal(res.is_error, true);
});

test('refusal and max_tokens are handled', async () => {
  const r1 = await runAssistant(db, 'u1', { text: 'bad' }, fake(msg([], 'refusal')));
  assert.match(r1.reply!, /can't help/);
  const r2 = await runAssistant(db, 'u1', { text: 'long' }, fake(msg([text('partial')], 'max_tokens')));
  assert.match(r2.reply!, /partial[\s\S]*cut short/);
});

test('model failure leaves the session consistent', async () => {
  const failing: ModelClient = { demo: false, modelId: 'fake-model', async create() { throw new Error('timeout'); } };
  await assert.rejects(runAssistant(db, 'u1', { text: 'hi' }, failing), (e: AssistantError) => e.code === 'unavailable');
});

test('provider quota exhausted: resource-exhausted, session unchanged, no paid fallback', async () => {
  const quota: ModelClient = { demo: false, modelId: 'fake-model', async create() { throw new ModelQuotaError(); } };
  await assert.rejects(runAssistant(db, 'u1', { text: 'hi' }, quota),
    (e: AssistantError) => e.code === 'resource-exhausted' && /free daily limit/.test(e.message));
});

test('message must not arrive while client tools are pending', async () => {
  const m = fake(msg([use('t1', 'get_vehicle', {})], 'tool_use'));
  const r = await runAssistant(db, 'u1', { text: 'hi' }, m);
  await assert.rejects(runAssistant(db, 'u1', { sessionId: r.sessionId, text: 'again' }, m),
    (e: AssistantError) => e.code === 'failed-precondition');
});

test('too many tool steps stops the loop', async () => {
  const loop = Array.from({ length: 10 }, (_, i) => msg([use(`p${i}`, 'get_community_prices', { station_ids: [] })], 'tool_use'));
  const m = fake(...loop);
  const r = await runAssistant(db, 'u1', { text: 'hi' }, m);
  assert.equal(m.calls.length, 6);
  assert.match(r.reply!, /too many steps/);
});

test('per-user hourly rate limit', async () => {
  const now = Date.UTC(2026, 10, 25, 10, 30);
  const ok = () => fake(msg([text('ok')], 'end_turn'));
  for (let i = 0; i < RATE_LIMIT_PER_HOUR; i++) await runAssistant(db, 'u9', { text: 'hi' }, ok(), now);
  await assert.rejects(runAssistant(db, 'u9', { text: 'hi' }, ok(), now), (e: AssistantError) => e.code === 'resource-exhausted');
  // A different user is unaffected, and the next hour resets.
  await runAssistant(db, 'u8', { text: 'hi' }, ok(), now);
  await runAssistant(db, 'u9', { text: 'hi' }, ok(), now + 3_600_000);
});
