import { test } from 'node:test';
import assert from 'node:assert/strict';
import { AssistantError, MAX_TEXT_CHARS, parseRequest, stationIdsFromPlan, TOOLS } from '../../src/assistant';
import { demoDestination } from '../../src/demo_model';

const code = (fn: () => unknown) => {
  try { fn(); } catch (e) { return (e as AssistantError).code; }
  return 'ok';
};

test('parseRequest accepts a message and trims it', () => {
  assert.deepEqual(parseRequest({ text: '  hi  ' }), { sessionId: undefined, text: 'hi' });
  assert.deepEqual(parseRequest({ sessionId: 'abcdefghij12', text: 'x' }).sessionId, 'abcdefghij12');
});

test('parseRequest rejects bad input', () => {
  assert.equal(code(() => parseRequest(null)), 'invalid-argument');
  assert.equal(code(() => parseRequest({})), 'invalid-argument');
  assert.equal(code(() => parseRequest({ text: '   ' })), 'invalid-argument');
  assert.equal(code(() => parseRequest({ text: 'x'.repeat(MAX_TEXT_CHARS + 1) })), 'invalid-argument');
  assert.equal(code(() => parseRequest({ text: 5 })), 'invalid-argument');
  assert.equal(code(() => parseRequest({ sessionId: '../x', text: 'a' })), 'invalid-argument');
  // both or neither of text / toolResults
  assert.equal(code(() => parseRequest({ sessionId: 'abcdefghij12', text: 'a', toolResults: [] })), 'invalid-argument');
  // tool results need a session and a sane size
  assert.equal(code(() => parseRequest({ toolResults: [{ toolUseId: 'a', output: 1 }] })), 'invalid-argument');
  assert.equal(code(() => parseRequest({ sessionId: 'abcdefghij12', toolResults: [{ toolUseId: 'a', output: 'x'.repeat(20_000) }] })),
    'invalid-argument');
  assert.equal(code(() => parseRequest({ sessionId: 'abcdefghij12', toolResults: [{ output: 1 }] })), 'invalid-argument');
});

test('parseRequest keeps tool results', () => {
  const r = parseRequest({ sessionId: 'abcdefghij12', toolResults: [{ toolUseId: 't1', output: { a: 1 }, isError: true }] });
  assert.deepEqual(r.toolResults, [{ toolUseId: 't1', output: { a: 1 }, isError: true }]);
});

test('tools are strict with closed schemas', () => {
  assert.deepEqual(TOOLS.map((t) => t.name), ['get_vehicle', 'plan_route_stops', 'get_community_prices', 'show_station_cards']);
  for (const t of TOOLS) {
    assert.equal(t.strict, true);
    assert.equal((t.input_schema as { additionalProperties?: boolean }).additionalProperties, false);
  }
});

test('stationIdsFromPlan reads only string ids', () => {
  assert.deepEqual(stationIdsFromPlan({ stations: [{ id: 'a' }, { id: 2 }, {}, { id: 'b' }] }), ['a', 'b']);
  assert.deepEqual(stationIdsFromPlan(null), []);
  assert.deepEqual(stationIdsFromPlan({ stations: 'x' }), []);
});

test('demo model destination parsing', () => {
  assert.equal(demoDestination('Where should I fill up on my way to Potsdam Hbf?'), 'Potsdam Hbf');
  assert.equal(demoDestination('hello'), null);
});
