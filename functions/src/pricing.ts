/**
 * Pure crowdsourced-price logic (no Firebase imports) so it is unit-testable
 * and identical in the emulator and production.
 */

export const FUEL_TYPES = [
  'REGULAR_UNLEADED', 'MIDGRADE', 'PREMIUM', 'DIESEL', 'DIESEL_PLUS', 'LPG', 'METHANE', 'E85', 'E10', 'EV_KWH',
] as const;
export type FuelType = (typeof FUEL_TYPES)[number];

export const PRICE_TTL_HOURS = 72; // reports older than this are ignored
export const HALF_LIFE_HOURS = 12; // recency weight halves every 12 h
export const OUTLIER_RATIO = 0.15; // > 15 % from the others' median = outlier
export const MIN_PRICE = 0.01;
export const MAX_PRICE = 1000; // per unit; generous for weak currencies

export interface Report {
  id: string;
  uid: string;
  price: number;
  currency: string;
  reportedAtMs: number;
  /** Reporter trust 0..1 at aggregation time. */
  trust: number;
}

export interface Consensus {
  price: number;
  currency: string;
  /** Reports that contributed (inside TTL, majority currency, not outliers). */
  usedIds: string[];
  outlierIds: string[];
  reportCount: number;
  /** 0..1 — grows with total weight, shrinks with disagreement. */
  confidence: number;
  lastReportAtMs: number;
  expiresAtMs: number;
}

const HOUR = 3_600_000;

export function recencyWeight(ageMs: number): number {
  return Math.pow(0.5, Math.max(0, ageMs) / (HALF_LIFE_HOURS * HOUR));
}

/** Weighted median (lower median on ties). Weights must be > 0. */
export function weightedMedian(values: { v: number; w: number }[]): number {
  if (values.length === 0) throw new Error('empty');
  const sorted = [...values].sort((a, b) => a.v - b.v);
  const total = sorted.reduce((s, x) => s + x.w, 0);
  let acc = 0;
  for (const x of sorted) {
    acc += x.w;
    if (acc >= total / 2) return x.v;
  }
  return sorted[sorted.length - 1].v;
}

function median(values: number[]): number {
  return weightedMedian(values.map((v) => ({ v, w: 1 })));
}

/**
 * Consensus price for one station + fuel type.
 * 1. drop reports older than the TTL;
 * 2. keep the currency with the most reports (others are never converted);
 * 3. leave-one-out outlier test against the median of the *other* reports
 *    (only when ≥ 3 reports, so two users cannot veto each other);
 * 4. weighted median with weight = trust × recency.
 */
export function consensus(reports: Report[], nowMs: number): Consensus | null {
  const fresh = reports.filter((r) => nowMs - r.reportedAtMs <= PRICE_TTL_HOURS * HOUR && r.price > 0);
  if (fresh.length === 0) return null;

  const byCurrency = new Map<string, Report[]>();
  for (const r of fresh) byCurrency.set(r.currency, [...(byCurrency.get(r.currency) ?? []), r]);
  const [currency, group] = [...byCurrency.entries()].sort(
    (a, b) => b[1].length - a[1].length || latest(b[1]) - latest(a[1]),
  )[0];

  const outlierIds: string[] = [];
  let used = group;
  if (group.length >= 3) {
    used = group.filter((r) => {
      const others = median(group.filter((o) => o !== r).map((o) => o.price));
      const isOutlier = Math.abs(r.price - others) / others > OUTLIER_RATIO;
      if (isOutlier) outlierIds.push(r.id);
      return !isOutlier;
    });
  }
  if (used.length === 0) return null;

  const weighted = used.map((r) => ({ v: r.price, w: Math.max(1e-6, r.trust) * recencyWeight(nowMs - r.reportedAtMs) }));
  const price = weightedMedian(weighted);
  const totalWeight = weighted.reduce((s, x) => s + x.w, 0);
  const spread = used.length < 2 ? 0 : used.reduce((s, r) => s + Math.abs(r.price - price), 0) / used.length / price;
  const confidence = clamp01((1 - Math.exp(-totalWeight)) * (1 - Math.min(1, spread / OUTLIER_RATIO)));
  const last = latest(used);
  return {
    price: round(price, 4),
    currency,
    usedIds: used.map((r) => r.id),
    outlierIds,
    reportCount: used.length,
    confidence: round(confidence, 3),
    lastReportAtMs: last,
    expiresAtMs: last + PRICE_TTL_HOURS * HOUR,
  };
}

/** Laplace-smoothed trust: (accepted + 1) / (accepted + rejected + 2). New users = 0.5. */
export function trustScore(accepted: number, rejected: number): number {
  return round((accepted + 1) / (accepted + rejected + 2), 4);
}

export interface VerificationVote {
  open?: boolean;
  fuelAvailable?: boolean;
  atMs: number;
}

export interface Reliability {
  /** 0..1 or null when nothing is known. */
  score: number | null;
  openVotes: number;
  closedVotes: number;
  outOfStockVotes: number;
  components: { freshness?: number; agreement?: number };
}

export const VOTE_TTL_DAYS = 30;

/**
 * Station reliability: mean of the components we actually have
 * - freshness of the latest price report: exp(−age / 72 h)
 * - agreement of open/closed votes in the last 30 days: majority share
 * Unknown stays null — never defaulted to "reliable".
 */
export function reliability(votes: VerificationVote[], lastPriceAtMs: number | null, nowMs: number): Reliability {
  const recent = votes.filter((v) => nowMs - v.atMs <= VOTE_TTL_DAYS * 24 * HOUR);
  const openVotes = recent.filter((v) => v.open === true).length;
  const closedVotes = recent.filter((v) => v.open === false).length;
  const outOfStockVotes = recent.filter((v) => v.fuelAvailable === false).length;
  const components: Reliability['components'] = {};
  if (lastPriceAtMs != null) components.freshness = round(Math.exp(-(nowMs - lastPriceAtMs) / (PRICE_TTL_HOURS * HOUR)), 3);
  if (openVotes + closedVotes > 0) components.agreement = round(Math.max(openVotes, closedVotes) / (openVotes + closedVotes), 3);
  const parts = Object.values(components);
  return {
    score: parts.length === 0 ? null : round(parts.reduce((s, x) => s + x, 0) / parts.length, 3),
    openVotes,
    closedVotes,
    outOfStockVotes,
    components,
  };
}

/** Rate limits (enforced by the report trigger). */
export const MAX_REPORTS_PER_HOUR = 10;
export const MIN_MINUTES_SAME_STATION_FUEL = 10;

export function rateLimitReason(
  recentByUser: { reportedAtMs: number; stationId: string; fuelType: string }[],
  report: { stationId: string; fuelType: string; reportedAtMs: number },
): string | null {
  const lastHour = recentByUser.filter((r) => report.reportedAtMs - r.reportedAtMs < HOUR);
  if (lastHour.length >= MAX_REPORTS_PER_HOUR) return 'too_many_reports';
  const sameKey = recentByUser.some(
    (r) =>
      r.stationId === report.stationId &&
      r.fuelType === report.fuelType &&
      report.reportedAtMs - r.reportedAtMs < MIN_MINUTES_SAME_STATION_FUEL * 60_000,
  );
  return sameKey ? 'duplicate_report' : null;
}

/** Day bucket key (UTC) for price history: 2026-11-25. */
export function dayKey(ms: number): string {
  return new Date(ms).toISOString().slice(0, 10);
}

export function distanceKm(aLat: number, aLng: number, bLat: number, bLng: number): number {
  const rad = (d: number) => (d * Math.PI) / 180;
  const dLat = rad(bLat - aLat), dLng = rad(bLng - aLng);
  const h = Math.sin(dLat / 2) ** 2 + Math.cos(rad(aLat)) * Math.cos(rad(bLat)) * Math.sin(dLng / 2) ** 2;
  return 2 * 6371.0088 * Math.asin(Math.min(1, Math.sqrt(h)));
}

export interface AlertRule {
  id: string;
  uid: string;
  fuelType: string;
  currency: string;
  maxPrice: number;
  lat: number;
  lng: number;
  radiusKm: number;
  enabled: boolean;
  /** Optional: only this station. */
  stationId?: string;
}

export const ALERT_COOLDOWN_HOURS = 12;

/** Should [rule] fire for a new consensus price at a station? (duplicates handled by caller via cooldown). */
export function alertMatches(
  rule: AlertRule,
  price: { stationId: string; fuelType: string; currency: string; price: number; lat: number; lng: number },
): boolean {
  if (!rule.enabled || rule.fuelType !== price.fuelType || rule.currency !== price.currency) return false;
  if (price.price > rule.maxPrice) return false;
  if (rule.stationId) return rule.stationId === price.stationId;
  return distanceKm(rule.lat, rule.lng, price.lat, price.lng) <= rule.radiusKm;
}

function latest(rs: Report[]): number {
  return Math.max(...rs.map((r) => r.reportedAtMs));
}
function clamp01(x: number): number {
  return Math.min(1, Math.max(0, x));
}
function round(x: number, d: number): number {
  const f = 10 ** d;
  return Math.round(x * f) / f;
}

// ---------- "wrong price" flags (moderation) ----------

/** Distinct users needed to mark a consensus price as disputed. */
export const DISPUTE_MIN_FLAGS = 3;

export interface PriceFlag {
  uid: string;
  atMs: number;
}

export interface DisputeState {
  /** Distinct users who flagged the *current* consensus. */
  flagCount: number;
  disputed: boolean;
}

/**
 * Only flags newer than the latest report that shaped the consensus count:
 * a new report replaces the price, so older flags no longer apply. Flags older
 * than the price TTL never count. One flag per user.
 */
export function disputeState(flags: PriceFlag[], lastReportAtMs: number, nowMs: number): DisputeState {
  const minMs = Math.max(lastReportAtMs, nowMs - PRICE_TTL_HOURS * 3_600_000);
  const users = new Set(flags.filter((f) => f.atMs > minMs && f.atMs <= nowMs + 60_000).map((f) => f.uid));
  return { flagCount: users.size, disputed: users.size >= DISPUTE_MIN_FLAGS };
}
