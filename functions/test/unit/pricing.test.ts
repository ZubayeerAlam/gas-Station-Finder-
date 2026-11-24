import { test } from 'node:test';
import assert from 'node:assert/strict';
import {
  alertMatches, consensus, dayKey, distanceKm, rateLimitReason, recencyWeight, reliability, trustScore, weightedMedian,
  type AlertRule, type Report,
} from '../../src/pricing';

const H = 3_600_000;
const now = Date.UTC(2026, 10, 25, 12);
const r = (id: string, price: number, ageH = 0, trust = 0.5, currency = 'EUR'): Report =>
  ({ id, uid: `u-${id}`, price, currency, reportedAtMs: now - ageH * H, trust });

test('recency weight halves every 12 h', () => {
  assert.equal(recencyWeight(0), 1);
  assert.ok(Math.abs(recencyWeight(12 * H) - 0.5) < 1e-12);
});

test('weighted median', () => {
  assert.equal(weightedMedian([{ v: 1, w: 1 }, { v: 2, w: 1 }, { v: 3, w: 1 }]), 2);
  assert.equal(weightedMedian([{ v: 1, w: 5 }, { v: 2, w: 1 }, { v: 3, w: 1 }]), 1);
});

test('single report → its price, low confidence', () => {
  const c = consensus([r('a', 1.799)], now)!;
  assert.equal(c.price, 1.799);
  assert.equal(c.reportCount, 1);
  assert.ok(c.confidence > 0 && c.confidence < 0.5);
  assert.equal(c.expiresAtMs, now + 72 * H);
});

test('outlier is excluded and reported', () => {
  const c = consensus([r('a', 1.79), r('b', 1.8), r('c', 1.81), r('d', 2.5)], now)!;
  assert.deepEqual(c.outlierIds, ['d']);
  assert.equal(c.price, 1.8);
  assert.equal(c.reportCount, 3);
});

test('two disagreeing reports cannot veto each other', () => {
  const c = consensus([r('a', 1.5), r('b', 2.0)], now)!;
  assert.deepEqual(c.outlierIds, []);
  assert.equal(c.reportCount, 2);
  assert.ok(c.confidence < 0.2, `confidence ${c.confidence}`);
});

test('expired reports ignored; nothing fresh → null', () => {
  assert.equal(consensus([r('old', 1.7, 73)], now), null);
  const c = consensus([r('old', 9.9, 80), r('new', 1.7, 1)], now)!;
  assert.equal(c.price, 1.7);
});

test('majority currency wins, never converted', () => {
  const c = consensus([r('a', 1.7), r('b', 1.71), r('c', 1.9, 0, 0.5, 'CHF')], now)!;
  assert.equal(c.currency, 'EUR');
  assert.deepEqual(c.usedIds.sort(), ['a', 'b']);
});

test('trusted and recent reports dominate', () => {
  const c = consensus([r('old-low-trust', 1.6, 20, 0.2), r('fresh-trusted', 1.75, 0, 0.9)], now)!;
  assert.equal(c.price, 1.75);
});

test('trust score is Laplace-smoothed', () => {
  assert.equal(trustScore(0, 0), 0.5);
  assert.equal(trustScore(8, 0), 0.9);
  assert.equal(trustScore(0, 3), 0.2);
});

test('reliability uses only known components', () => {
  assert.equal(reliability([], null, now).score, null);
  const fresh = reliability([], now, now);
  assert.equal(fresh.score, 1);
  const votes = [{ open: true, atMs: now }, { open: true, atMs: now }, { open: false, atMs: now }, { open: false, atMs: now - 40 * 24 * H }];
  const rel = reliability(votes, null, now);
  assert.equal(rel.openVotes, 2);
  assert.equal(rel.closedVotes, 1); // 40-day-old vote expired
  assert.equal(rel.score, 0.667);
});

test('rate limits', () => {
  const base = { stationId: 's', fuelType: 'DIESEL', reportedAtMs: now };
  assert.equal(rateLimitReason([], base), null);
  assert.equal(rateLimitReason([{ ...base, reportedAtMs: now - 5 * 60_000 }], base), 'duplicate_report');
  assert.equal(rateLimitReason([{ ...base, reportedAtMs: now - 11 * 60_000 }], base), null);
  const many = Array.from({ length: 10 }, (_, i) => ({ stationId: `x${i}`, fuelType: 'DIESEL', reportedAtMs: now - i * 60_000 }));
  assert.equal(rateLimitReason(many, base), 'too_many_reports');
});

test('alert matching: fuel, currency, threshold, radius or station', () => {
  const rule: AlertRule = { id: 'r', uid: 'u', fuelType: 'DIESEL', currency: 'EUR', maxPrice: 1.7, lat: 52.52, lng: 13.405, radiusKm: 5, enabled: true };
  const p = { stationId: 's', fuelType: 'DIESEL', currency: 'EUR', price: 1.69, lat: 52.53, lng: 13.41 };
  assert.ok(alertMatches(rule, p));
  assert.ok(!alertMatches(rule, { ...p, price: 1.71 }));
  assert.ok(!alertMatches(rule, { ...p, currency: 'CHF' }));
  assert.ok(!alertMatches(rule, { ...p, lat: 52.7 })); // ~20 km away
  assert.ok(!alertMatches({ ...rule, enabled: false }, p));
  assert.ok(alertMatches({ ...rule, stationId: 's', radiusKm: 0 }, { ...p, lat: 60 }));
});

test('helpers', () => {
  assert.equal(dayKey(now), '2026-11-25');
  assert.ok(Math.abs(distanceKm(52.52, 13.405, 52.4, 13.06) - 26.8) < 1);
});
