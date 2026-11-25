import { after, before, test } from 'node:test';
import assert from 'node:assert/strict';
import { deleteApp, initializeApp, type App } from 'firebase-admin/app';
import { getFirestore, Timestamp, type Firestore } from 'firebase-admin/firestore';

// Runs inside `firebase emulators:exec` (FIRESTORE_EMULATOR_HOST is set) with
// the functions emulator executing the real triggers from lib/src/index.js.
let app: App;
let db: Firestore;

before(async () => {
  assert.ok(process.env.FIRESTORE_EMULATOR_HOST, 'must run against the emulator');
  app = initializeApp({ projectId: 'demo-fuelwise' }, 'it');
  db = getFirestore(app);
  await fetch(`http://${process.env.FIRESTORE_EMULATOR_HOST}/emulator/v1/projects/demo-fuelwise/databases/(default)/documents`,
    { method: 'DELETE' });
});
after(async () => deleteApp(app));

async function waitFor<T>(fn: () => Promise<T | undefined>, timeoutMs = 20_000): Promise<T> {
  const start = Date.now();
  for (;;) {
    const v = await fn();
    if (v !== undefined) return v;
    if (Date.now() - start > timeoutMs) throw new Error('timed out waiting for trigger');
    await new Promise((r) => setTimeout(r, 200));
  }
}

async function report(id: string, uid: string, price: number, extra: Record<string, unknown> = {}) {
  await db.doc(`priceReports/${id}`).set({
    uid, stationId: 'st1', stationName: 'Test Station', stationLat: 52.52, stationLng: 13.405,
    fuelType: 'DIESEL', price, currency: 'EUR', reportedAt: Timestamp.now(), ...extra,
  });
  return waitFor(async () => {
    const s = await db.doc(`priceReports/${id}`).get();
    return s.get('status') ? s.data() : undefined;
  });
}

test('consensus, outlier rejection, trust and history', async () => {
  assert.equal((await report('a', 'u1', 1.8)).status, 'accepted');
  assert.equal((await report('b', 'u2', 1.81)).status, 'accepted');
  assert.equal((await report('c', 'u3', 1.79)).status, 'accepted');
  const price = (await db.doc('stations/st1/prices/DIESEL').get()).data()!;
  assert.equal(price.price, 1.8);
  assert.equal(price.currency, 'EUR');
  assert.equal(price.reportCount, 3);
  assert.equal(price.source, 'community');

  const outlier = await report('d', 'u4', 2.5);
  assert.equal(outlier.status, 'rejected');
  assert.equal(outlier.reason, 'outlier');
  const u4 = (await db.doc('users/u4').get()).data()!;
  assert.equal(u4.rejected, 1);
  assert.equal(u4.trust, 0.3333);
  // corroborated reporters gained trust
  assert.equal((await db.doc('users/u3').get()).get('trust'), 0.6667);

  const hist = await db.collection('stations/st1/priceHistory').get();
  assert.equal(hist.size, 1);
  assert.equal(hist.docs[0].get('close'), 1.8);
  const station = (await db.doc('stations/st1').get()).data()!;
  assert.equal(station.name, 'Test Station');
  assert.ok(station.reliability > 0.9, 'fresh price → high freshness');
});

test('rate limit rejects a duplicate report from the same user', async () => {
  const dup = await report('e', 'u1', 1.8);
  assert.equal(dup.status, 'rejected');
  assert.equal(dup.reason, 'duplicate_report');
});

test('verification votes update station reliability', async () => {
  const at = Timestamp.now();
  await db.doc('stations/st2').set({ name: 'Votes only', lat: 1, lng: 1 });
  await db.doc('stations/st2/verifications/v1').set({ open: true, at });
  await db.doc('stations/st2/verifications/v2').set({ open: true, at });
  await db.doc('stations/st2/verifications/v3').set({ open: false, fuelAvailable: false, at });
  const s = await waitFor(async () => {
    const d = (await db.doc('stations/st2').get()).data();
    return d?.openVotes === 2 && d.closedVotes === 1 ? d : undefined;
  });
  assert.equal(s.reliability, 0.667);
  assert.equal(s.outOfStockVotes, 1);
});

test('price alert fires once per cooldown and respects threshold', async () => {
  await db.doc('users/fan/private/messaging').set({ token: 'emulator-token', updatedAt: Timestamp.now() });
  await db.doc('users/fan/alertRules/cheap').set({
    uid: 'fan', fuelType: 'PREMIUM', currency: 'EUR', maxPrice: 1.9, lat: 52.52, lng: 13.41, radiusKm: 5, enabled: true,
  });
  await db.doc('users/fan/alertRules/too-low').set({
    uid: 'fan', fuelType: 'PREMIUM', currency: 'EUR', maxPrice: 1.5, lat: 52.52, lng: 13.41, radiusKm: 5, enabled: true,
  });
  await report('p1', 'x1', 1.85, { fuelType: 'PREMIUM' });
  const log = await waitFor(async () => {
    const d = await db.doc('alertLog/fan_cheap_st1').get();
    return d.exists ? d.data() : undefined;
  });
  assert.equal(log.price, 1.85);
  assert.equal((await db.doc('alertLog/fan_too-low_st1').get()).exists, false);

  await report('p2', 'x2', 1.86, { fuelType: 'PREMIUM' });
  const again = (await db.doc('alertLog/fan_cheap_st1').get()).data()!;
  assert.deepEqual(again.sentAt, log.sentAt, 'cooldown prevents a duplicate notification');
});

// The deployed-shape callable, through the functions + auth emulators. With no
// ANTHROPIC_API_KEY configured the emulator uses the labelled offline demo model.
test('assistantChat callable: auth required, demo protocol round-trip', async () => {
  const fnUrl = 'http://127.0.0.1:5001/demo-fuelwise/europe-west1/assistantChat';
  const call = (data: unknown, token?: string) => fetch(fnUrl, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', ...(token ? { Authorization: `Bearer ${token}` } : {}) },
    body: JSON.stringify({ data }),
  }).then(async (r) => ({ status: r.status, body: await r.json() as { result?: any; error?: { status: string } } }));

  const noAuth = await call({ text: 'hi' });
  assert.equal(noAuth.body.error?.status, 'UNAUTHENTICATED');

  const signUp = await fetch(`http://${process.env.FIREBASE_AUTH_EMULATOR_HOST}/identitytoolkit.googleapis.com/v1/accounts:signUp?key=fake`,
    { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ returnSecureToken: true }) });
  const { idToken } = await signUp.json() as { idToken: string };

  const bad = await call({ text: '' }, idToken);
  assert.equal(bad.body.error?.status, 'INVALID_ARGUMENT');

  const r1 = (await call({ text: 'Where should I fill up on my way to Potsdam?' }, idToken)).body.result;
  assert.equal(r1.demo, true);
  assert.equal(r1.status, 'needs_client_tools');
  assert.equal(r1.clientToolCalls[0].name, 'plan_route_stops');
  assert.equal(r1.clientToolCalls[0].input.destination, 'Potsdam');

  const plan = { stations: [{ id: 'sA', name: 'Aral', total_cost: '€61.20', detour: '0.4 km' }, { id: 'sB', name: 'Shell' }] };
  const r2 = (await call({ sessionId: r1.sessionId, toolResults: [{ toolUseId: r1.clientToolCalls[0].id, output: plan }] }, idToken)).body.result;
  assert.equal(r2.status, 'done');
  assert.deepEqual(r2.cards, ['sA', 'sB']);
  assert.equal(r2.demo, true);
  assert.match(r2.reply, /Aral/);
});
