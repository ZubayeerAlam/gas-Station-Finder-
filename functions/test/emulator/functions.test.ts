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

test('EV charger working / not working votes are counted with no station document', async () => {
  const at = Timestamp.now();
  await db.doc('stations/ocm:4242/verifications/w1').set({ open: true, at });
  await db.doc('stations/ocm:4242/verifications/b1').set({ open: false, at });
  await db.doc('stations/ocm:4242/verifications/b2').set({ open: false, at });
  const s = await waitFor(async () => {
    const d = (await db.doc('stations/ocm:4242').get()).data();
    return d?.openVotes === 1 && d.closedVotes === 2 ? d : undefined;
  });
  assert.equal(s.outOfStockVotes, 0);
  const user = await waitFor(async () => {
    const d = (await db.doc('users/b2').get()).data();
    return d?.votedStations?.includes('ocm:4242') ? d : undefined;
  });
  assert.ok(user);
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

test('deleteMyData callable: removes only the caller\'s data and account', async () => {
  const fnUrl = 'http://127.0.0.1:5001/demo-fuelwise/europe-west1/deleteMyData';
  const call = (token?: string) => fetch(fnUrl, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', ...(token ? { Authorization: `Bearer ${token}` } : {}) },
    body: JSON.stringify({ data: {} }),
  }).then(async (r) => (await r.json()) as { result?: any; error?: { status: string } });

  assert.equal((await call()).error?.status, 'UNAUTHENTICATED');

  const signUp = await fetch(`http://${process.env.FIREBASE_AUTH_EMULATOR_HOST}/identitytoolkit.googleapis.com/v1/accounts:signUp?key=fake`,
    { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ returnSecureToken: true }) });
  const { idToken, localId: me } = await signUp.json() as { idToken: string; localId: string };
  const other = 'someone-else';

  // Mine: a report, a vote, an alert rule, a messaging token, an assistant session + quota, an alert log entry.
  await report('del-mine', me, 1.75, { stationId: 'stDel' });
  await report('del-other', other, 1.76, { stationId: 'stDel' });
  await db.doc(`stations/stDel/verifications/${me}`).set({ open: true, at: Timestamp.now() });
  await db.doc(`stations/stDel/verifications/${other}`).set({ open: true, at: Timestamp.now() });
  await waitFor(async () => {
    const voted = (await db.doc(`users/${me}`).get()).get('votedStations') as string[] | undefined;
    return voted?.includes('stDel') ? true : undefined;
  });
  await db.doc(`stations/stDel/priceFlags/DIESEL_${me}`).set({ uid: me, fuelType: 'DIESEL', at: Timestamp.now() });
  await db.doc(`stations/stDel/priceFlags/DIESEL_${other}`).set({ uid: other, fuelType: 'DIESEL', at: Timestamp.now() });
  await waitFor(async () => {
    const flagged = (await db.doc(`users/${me}`).get()).get('flaggedStations') as string[] | undefined;
    return flagged?.includes('stDel') ? true : undefined;
  });
  await db.doc(`users/${me}/alertRules/r1`).set({ uid: me, fuelType: 'DIESEL', currency: 'EUR', maxPrice: 1.5,
    lat: 52.5, lng: 13.4, radiusKm: 10, enabled: true });
  await db.doc(`users/${me}/private/messaging`).set({ token: 't', updatedAt: Timestamp.now() });
  await db.doc(`users/${other}/alertRules/r2`).set({ uid: other, fuelType: 'DIESEL', currency: 'EUR', maxPrice: 1.5,
    lat: 52.5, lng: 13.4, radiusKm: 10, enabled: true });
  await db.doc('assistantSessions/s-mine').set({ uid: me, messagesJson: '[]' });
  await db.doc('assistantSessions/s-other').set({ uid: other, messagesJson: '[]' });
  await db.doc(`assistantQuota/${me}`).set({ count: 1 });
  await db.doc(`alertLog/${me}_r1_stDel`).set({ uid: me, ruleId: 'r1' });

  const res = await call(idToken);
  assert.deepEqual(res.result, { priceReports: 1, votes: 1, priceFlags: 1, alertRules: 1, assistantSessions: 1 });

  const gone = await Promise.all([
    db.doc('priceReports/del-mine').get(), db.doc(`stations/stDel/verifications/${me}`).get(),
    db.doc(`users/${me}`).get(), db.doc(`users/${me}/alertRules/r1`).get(), db.doc(`users/${me}/private/messaging`).get(),
    db.doc('assistantSessions/s-mine').get(), db.doc(`assistantQuota/${me}`).get(), db.doc(`alertLog/${me}_r1_stDel`).get(),
    db.doc(`stations/stDel/priceFlags/DIESEL_${me}`).get(),
  ]);
  assert.deepEqual(gone.map((d) => d.exists), gone.map(() => false));

  const kept = await Promise.all([
    db.doc('priceReports/del-other').get(), db.doc(`stations/stDel/verifications/${other}`).get(),
    db.doc(`users/${other}/alertRules/r2`).get(), db.doc('assistantSessions/s-other').get(),
    db.doc('stations/stDel/prices/DIESEL').get(), db.doc(`stations/stDel/priceFlags/DIESEL_${other}`).get(),
  ]);
  assert.deepEqual(kept.map((d) => d.exists), kept.map(() => true));

  // Reliability recomputed without my vote (trigger on the vote delete).
  await waitFor(async () => ((await db.doc('stations/stDel').get()).get('openVotes') === 1 ? true : undefined));

  // The anonymous account is gone: its token no longer works.
  const lookup = await fetch(`http://${process.env.FIREBASE_AUTH_EMULATOR_HOST}/identitytoolkit.googleapis.com/v1/accounts:lookup?key=fake`,
    { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ idToken }) });
  assert.notEqual(lookup.status, 200);

  // Idempotent: a second call (fresh account, nothing stored) succeeds with zero counts.
  const again = await fetch(`http://${process.env.FIREBASE_AUTH_EMULATOR_HOST}/identitytoolkit.googleapis.com/v1/accounts:signUp?key=fake`,
    { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ returnSecureToken: true }) });
  const empty = await call((await again.json() as { idToken: string }).idToken);
  assert.deepEqual(empty.result, { priceReports: 0, votes: 0, priceFlags: 0, alertRules: 0, assistantSessions: 0 });
});

test('three "wrong price" flags dispute the price; a new report clears it', async () => {
  const st = 'stFlag';
  await report('fl-a', 'r1', 1.7, { stationId: st });
  const flag = (uid: string) =>
    db.doc(`stations/${st}/priceFlags/DIESEL_${uid}`).set({ uid, fuelType: 'DIESEL', at: Timestamp.now() });
  const price = () => db.doc(`stations/${st}/prices/DIESEL`).get();

  await flag('f1');
  await flag('f2');
  await waitFor(async () => ((await price()).get('flagCount') === 2 ? true : undefined));
  assert.equal((await price()).get('disputed'), false);
  await flag('f2'); // same user again: still 2
  await flag('f3');
  await waitFor(async () => ((await price()).get('disputed') === true ? true : undefined));
  assert.equal((await price()).get('flagCount'), 3);

  // A fresh report replaces the consensus: older flags no longer count.
  await new Promise((r) => setTimeout(r, 20));
  await report('fl-b', 'r2', 1.72, { stationId: st });
  const after = (await price()).data()!;
  assert.equal(after.disputed ?? false, false);
  assert.equal(after.flagCount ?? 0, 0);
});
