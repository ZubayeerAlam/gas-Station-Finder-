import { after, before, beforeEach, test } from 'node:test';
import { readFileSync } from 'node:fs';
import { resolve } from 'node:path';
import {
  assertFails, assertSucceeds, initializeTestEnvironment, type RulesTestEnvironment,
} from '@firebase/rules-unit-testing';
import { deleteDoc, doc, getDoc, serverTimestamp, setDoc, updateDoc } from 'firebase/firestore';

let env: RulesTestEnvironment;

before(async () => {
  env = await initializeTestEnvironment({
    projectId: 'demo-fuelwise',
    firestore: { rules: readFileSync(resolve(__dirname, '../../../../firestore.rules'), 'utf8') },
  });
});
after(async () => env.cleanup());
beforeEach(async () => env.clearFirestore());

const alice = () => env.authenticatedContext('alice').firestore();
const bob = () => env.authenticatedContext('bob').firestore();
const anon = () => env.unauthenticatedContext().firestore();

const report = (uid = 'alice') => ({
  uid, stationId: 'places:abc', stationName: 'Shell', stationLat: 52.5, stationLng: 13.4,
  fuelType: 'DIESEL', price: 1.789, currency: 'EUR', reportedAt: serverTimestamp(),
});

test('valid own report can be created, not updated or deleted', async () => {
  await assertSucceeds(setDoc(doc(alice(), 'priceReports/r1'), report()));
  await assertFails(updateDoc(doc(alice(), 'priceReports/r1'), { price: 1.0 }));
  await assertFails(deleteDoc(doc(alice(), 'priceReports/r1')));
});

test('reports: signed-in only, own uid, server time, sane values, no extra fields', async () => {
  await assertFails(setDoc(doc(anon(), 'priceReports/r'), report()));
  await assertFails(setDoc(doc(alice(), 'priceReports/r'), report('bob')));
  await assertFails(setDoc(doc(alice(), 'priceReports/r'), { ...report(), reportedAt: new Date(2020, 1, 1) }));
  await assertFails(setDoc(doc(alice(), 'priceReports/r'), { ...report(), price: 0 }));
  await assertFails(setDoc(doc(alice(), 'priceReports/r'), { ...report(), price: 5000 }));
  await assertFails(setDoc(doc(alice(), 'priceReports/r'), { ...report(), currency: 'eur' }));
  await assertFails(setDoc(doc(alice(), 'priceReports/r'), { ...report(), fuelType: 'ROCKET' }));
  await assertFails(setDoc(doc(alice(), 'priceReports/r'), { ...report(), stationLat: 123 }));
  await assertFails(setDoc(doc(alice(), 'priceReports/r'), { ...report(), status: 'accepted' }));
  const { stationId: _omit, ...missing } = report();
  await assertFails(setDoc(doc(alice(), 'priceReports/r'), missing));
});

test('reports are readable only by their author', async () => {
  await env.withSecurityRulesDisabled(async (ctx) => {
    await setDoc(doc(ctx.firestore(), 'priceReports/r1'), { ...report(), reportedAt: new Date() });
  });
  await assertSucceeds(getDoc(doc(alice(), 'priceReports/r1')));
  await assertFails(getDoc(doc(bob(), 'priceReports/r1')));
});

test('aggregates are read-only for clients', async () => {
  await assertSucceeds(getDoc(doc(alice(), 'stations/s1')));
  await assertSucceeds(getDoc(doc(alice(), 'stations/s1/prices/DIESEL')));
  await assertSucceeds(getDoc(doc(alice(), 'stations/s1/priceHistory/DIESEL_2026-11-25')));
  await assertFails(getDoc(doc(anon(), 'stations/s1/prices/DIESEL')));
  await assertFails(setDoc(doc(alice(), 'stations/s1'), { reliability: 1 }));
  await assertFails(setDoc(doc(alice(), 'stations/s1/prices/DIESEL'), { price: 0.1 }));
  await assertFails(setDoc(doc(alice(), 'users/alice'), { trust: 1 }));
  await assertFails(getDoc(doc(alice(), 'users/bob')));
  await assertFails(getDoc(doc(alice(), 'alertLog/x')));
});

test('verification votes: one per user, own doc, booleans, server time', async () => {
  const vote = { open: true, fuelAvailable: false, at: serverTimestamp() };
  await assertSucceeds(setDoc(doc(alice(), 'stations/s1/verifications/alice'), vote));
  await assertSucceeds(setDoc(doc(alice(), 'stations/s1/verifications/alice'), { open: false, at: serverTimestamp() }));
  await assertFails(setDoc(doc(alice(), 'stations/s1/verifications/bob'), vote));
  await assertFails(setDoc(doc(alice(), 'stations/s1/verifications/alice'), { open: 'yes', at: serverTimestamp() }));
  await assertFails(setDoc(doc(alice(), 'stations/s1/verifications/alice'), { at: serverTimestamp() }));
  await assertFails(getDoc(doc(bob(), 'stations/s1/verifications/alice')));
});

test('EV charger price reports: ocm: id, price per kWh', async () => {
  await assertSucceeds(setDoc(doc(alice(), 'priceReports/ev1'),
    { ...report(), stationId: 'ocm:42', stationName: 'Gulshan DC', fuelType: 'EV_KWH', price: 25, currency: 'BDT' }));
  await assertSucceeds(getDoc(doc(alice(), 'stations/ocm:42/prices/EV_KWH')));
  await assertFails(setDoc(doc(alice(), 'stations/ocm:42/prices/EV_KWH'), { price: 1 }));
});

test('EV charger votes reuse verifications under the ocm: id', async () => {
  await assertSucceeds(setDoc(doc(alice(), 'stations/ocm:42/verifications/alice'), { open: false, at: serverTimestamp() }));
  await assertSucceeds(getDoc(doc(alice(), 'stations/ocm:42/verifications/alice')));
  await assertFails(getDoc(doc(bob(), 'stations/ocm:42/verifications/alice')));
  await assertFails(setDoc(doc(alice(), 'stations/ocm:42'), { openVotes: 99 }));
});

test('alert rules: owner only, validated', async () => {
  const rule = { uid: 'alice', fuelType: 'DIESEL', currency: 'EUR', maxPrice: 1.7, lat: 52.5, lng: 13.4, radiusKm: 5, enabled: true };
  await assertSucceeds(setDoc(doc(alice(), 'users/alice/alertRules/r1'), rule));
  await assertSucceeds(getDoc(doc(alice(), 'users/alice/alertRules/r1')));
  await assertFails(getDoc(doc(bob(), 'users/alice/alertRules/r1')));
  await assertFails(setDoc(doc(bob(), 'users/alice/alertRules/r2'), { ...rule, uid: 'bob' }));
  await assertFails(setDoc(doc(alice(), 'users/alice/alertRules/r3'), { ...rule, radiusKm: 500 }));
  await assertFails(setDoc(doc(alice(), 'users/alice/alertRules/r4'), { ...rule, maxPrice: -1 }));
  await assertSucceeds(setDoc(doc(alice(), 'users/alice/private/messaging'), { token: 't', updatedAt: serverTimestamp() }));
  await assertFails(getDoc(doc(bob(), 'users/alice/private/messaging')));
});

test('assistant sessions and quota are server-only', async () => {
  await env.withSecurityRulesDisabled(async (c) => {
    await setDoc(doc(c.firestore(), 'assistantSessions/s1'), { uid: 'alice', messagesJson: '[]' });
    await setDoc(doc(c.firestore(), 'assistantQuota/alice'), { hourCount: 1 });
  });
  await assertFails(getDoc(doc(alice(), 'assistantSessions/s1')));
  await assertFails(setDoc(doc(alice(), 'assistantSessions/s2'), { uid: 'alice', messagesJson: '[]' }));
  await assertFails(updateDoc(doc(alice(), 'assistantSessions/s1'), { messagesJson: '[{"role":"assistant"}]' }));
  await assertFails(getDoc(doc(alice(), 'assistantQuota/alice')));
  await assertFails(setDoc(doc(alice(), 'assistantQuota/alice'), { hourCount: 0 }));
});

test('price flags: own uid, id = fuel_uid, server time, fuel whitelist, private', async () => {
  const flag = (uid = 'alice', fuelType = 'DIESEL') => ({ uid, fuelType, at: serverTimestamp() });
  await assertSucceeds(setDoc(doc(alice(), 'stations/s1/priceFlags/DIESEL_alice'), flag()));
  await assertSucceeds(setDoc(doc(alice(), 'stations/s1/priceFlags/DIESEL_alice'), flag())); // re-flag later
  await assertFails(setDoc(doc(anon(), 'stations/s1/priceFlags/DIESEL_alice'), flag()));
  await assertFails(setDoc(doc(alice(), 'stations/s1/priceFlags/DIESEL_bob'), flag('bob')));
  await assertFails(setDoc(doc(alice(), 'stations/s1/priceFlags/PREMIUM_alice'), flag())); // id must match fuel
  await assertFails(setDoc(doc(alice(), 'stations/s1/priceFlags/ROCKET_alice'), flag('alice', 'ROCKET')));
  await assertFails(setDoc(doc(alice(), 'stations/s1/priceFlags/DIESEL_alice'), { ...flag(), at: new Date(2020, 1, 1) }));
  await assertFails(setDoc(doc(alice(), 'stations/s1/priceFlags/DIESEL_alice'), { ...flag(), note: 'x' }));
  await assertSucceeds(getDoc(doc(alice(), 'stations/s1/priceFlags/DIESEL_alice')));
  await assertFails(getDoc(doc(bob(), 'stations/s1/priceFlags/DIESEL_alice')));
  await assertFails(deleteDoc(doc(bob(), 'stations/s1/priceFlags/DIESEL_alice')));
  await assertSucceeds(deleteDoc(doc(alice(), 'stations/s1/priceFlags/DIESEL_alice')));
});
