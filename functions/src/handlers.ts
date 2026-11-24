import { FieldValue, Timestamp, type Firestore } from 'firebase-admin/firestore';
import {
  ALERT_COOLDOWN_HOURS, PRICE_TTL_HOURS, VOTE_TTL_DAYS, alertMatches, consensus, dayKey, rateLimitReason,
  reliability, trustScore, type AlertRule, type Report,
} from './pricing';

const HOUR = 3_600_000;
/** A report counts as "corroborated" (raises trust) within 3 % of consensus with ≥ 2 reports. */
export const CORROBORATION_RATIO = 0.03;

export interface Messenger {
  send(token: string, title: string, body: string, data: Record<string, string>): Promise<void>;
}

interface ReportDoc {
  uid: string;
  stationId: string;
  stationName?: string;
  stationLat: number;
  stationLng: number;
  fuelType: string;
  price: number;
  currency: string;
  reportedAt: Timestamp;
  status?: string;
}

export type ReportOutcome =
  | { status: 'rejected'; reason: string }
  | { status: 'accepted' | 'pending'; consensusPrice: number; alertsSent: number };

/**
 * Handles one new price report: rate limit → consensus over fresh reports →
 * aggregate + daily history → reporter trust → station reliability → alerts.
 * Idempotent: a report that already has a status is ignored.
 */
export async function processReport(db: Firestore, reportId: string, messenger: Messenger, nowMs = Date.now()):
  Promise<ReportOutcome | null> {
  const ref = db.collection('priceReports').doc(reportId);
  const snap = await ref.get();
  const r = snap.data() as ReportDoc | undefined;
  if (!r || r.status) return null;
  const reportedAtMs = r.reportedAt.toMillis();

  // 1. Rate limit (other reports by the same user in the last hour).
  const recent = await db.collection('priceReports')
    .where('uid', '==', r.uid)
    .where('reportedAt', '>=', Timestamp.fromMillis(reportedAtMs - HOUR))
    .get();
  const reason = rateLimitReason(
    recent.docs.filter((d) => d.id !== reportId && d.get('status') !== 'rejected').map((d) => ({
      stationId: d.get('stationId'), fuelType: d.get('fuelType'), reportedAtMs: (d.get('reportedAt') as Timestamp).toMillis(),
    })),
    { stationId: r.stationId, fuelType: r.fuelType, reportedAtMs },
  );
  if (reason) {
    await ref.update({ status: 'rejected', reason, processedAt: FieldValue.serverTimestamp() });
    return { status: 'rejected', reason };
  }

  // 2. Consensus over fresh, non-rejected reports for this station + fuel.
  const fresh = await db.collection('priceReports')
    .where('stationId', '==', r.stationId)
    .where('fuelType', '==', r.fuelType)
    .where('reportedAt', '>=', Timestamp.fromMillis(nowMs - PRICE_TTL_HOURS * HOUR))
    .get();
  const docs = fresh.docs.filter((d) => d.id === reportId || d.get('status') !== 'rejected');
  const uids = [...new Set(docs.map((d) => d.get('uid') as string))];
  const userSnaps = uids.length ? await db.getAll(...uids.map((u) => db.collection('users').doc(u))) : [];
  const trustOf = new Map(userSnaps.map((s) => [s.id, (s.get('trust') as number | undefined) ?? 0.5]));
  const reports: Report[] = docs.map((d) => ({
    id: d.id, uid: d.get('uid'), price: d.get('price'), currency: d.get('currency'),
    reportedAtMs: (d.get('reportedAt') as Timestamp).toMillis(), trust: trustOf.get(d.get('uid')) ?? 0.5,
  }));
  const c = consensus(reports, nowMs);
  if (!c) return null;

  const isOutlier = c.outlierIds.includes(reportId);
  const otherCurrency = !c.usedIds.includes(reportId) && !isOutlier;
  const corroborated = !isOutlier && !otherCurrency && c.reportCount >= 2 &&
    Math.abs(r.price - c.price) / c.price <= CORROBORATION_RATIO;

  const stationRef = db.collection('stations').doc(r.stationId);
  const batch = db.batch();
  batch.set(stationRef.collection('prices').doc(r.fuelType), {
    fuelType: r.fuelType,
    price: c.price,
    currency: c.currency,
    reportCount: c.reportCount,
    confidence: c.confidence,
    lastReportAt: Timestamp.fromMillis(c.lastReportAtMs),
    expiresAt: Timestamp.fromMillis(c.expiresAtMs),
    updatedAt: FieldValue.serverTimestamp(),
    source: 'community',
  });
  batch.set(stationRef, {
    ...(r.stationName ? { name: r.stationName } : {}),
    lat: r.stationLat,
    lng: r.stationLng,
    lastPriceAt: Timestamp.fromMillis(c.lastReportAtMs),
  }, { merge: true });
  batch.update(ref, {
    status: isOutlier ? 'rejected' : otherCurrency ? 'pending' : 'accepted',
    ...(isOutlier ? { reason: 'outlier' } : otherCurrency ? { reason: 'minority_currency' } : {}),
    processedAt: FieldValue.serverTimestamp(),
  });
  // Trust: outliers count against the reporter; corroborated reports for them.
  if (isOutlier || corroborated) {
    batch.set(db.collection('users').doc(r.uid), {
      accepted: FieldValue.increment(corroborated ? 1 : 0),
      rejected: FieldValue.increment(isOutlier ? 1 : 0),
    }, { merge: true });
  }
  await batch.commit();
  if (isOutlier || corroborated) await refreshTrust(db, r.uid);

  // 3. Daily history (consensus samples per UTC day).
  const day = dayKey(nowMs);
  const histRef = stationRef.collection('priceHistory').doc(`${r.fuelType}_${day}`);
  await db.runTransaction(async (tx) => {
    const h = await tx.get(histRef);
    const prev = h.exists ? h.data()! : null;
    const sameCurrency = !prev || prev.currency === c.currency;
    tx.set(histRef, {
      fuelType: r.fuelType,
      day,
      currency: c.currency,
      close: c.price,
      min: prev && sameCurrency ? Math.min(prev.min, c.price) : c.price,
      max: prev && sameCurrency ? Math.max(prev.max, c.price) : c.price,
      samples: (prev && sameCurrency ? prev.samples : 0) + 1,
    });
  });

  await refreshReliability(db, r.stationId, nowMs);

  // 4. Alerts (only for accepted consensus changes).
  const alertsSent = isOutlier ? 0 : await sendAlerts(db, messenger, {
    stationId: r.stationId, stationName: r.stationName, fuelType: r.fuelType, currency: c.currency, price: c.price,
    lat: r.stationLat, lng: r.stationLng,
  }, nowMs);

  return { status: isOutlier ? 'rejected' as const : otherCurrency ? 'pending' : 'accepted', consensusPrice: c.price, alertsSent } as ReportOutcome;
}

async function refreshTrust(db: Firestore, uid: string): Promise<void> {
  const ref = db.collection('users').doc(uid);
  const s = await ref.get();
  await ref.set({ trust: trustScore(s.get('accepted') ?? 0, s.get('rejected') ?? 0) }, { merge: true });
}

/** Recomputes votes + reliability for a station. */
export async function refreshReliability(db: Firestore, stationId: string, nowMs = Date.now()): Promise<void> {
  const stationRef = db.collection('stations').doc(stationId);
  const [station, votes] = await Promise.all([
    stationRef.get(),
    stationRef.collection('verifications')
      .where('at', '>=', Timestamp.fromMillis(nowMs - VOTE_TTL_DAYS * 24 * HOUR)).get(),
  ]);
  const rel = reliability(
    votes.docs.map((d) => ({ open: d.get('open'), fuelAvailable: d.get('fuelAvailable'), atMs: (d.get('at') as Timestamp).toMillis() })),
    station.get('lastPriceAt') ? (station.get('lastPriceAt') as Timestamp).toMillis() : null,
    nowMs,
  );
  await stationRef.set({
    reliability: rel.score,
    openVotes: rel.openVotes,
    closedVotes: rel.closedVotes,
    outOfStockVotes: rel.outOfStockVotes,
    reliabilityUpdatedAt: FieldValue.serverTimestamp(),
  }, { merge: true });
}

async function sendAlerts(
  db: Firestore,
  messenger: Messenger,
  p: { stationId: string; stationName?: string; fuelType: string; currency: string; price: number; lat: number; lng: number },
  nowMs: number,
): Promise<number> {
  const rules = await db.collectionGroup('alertRules')
    .where('fuelType', '==', p.fuelType)
    .where('currency', '==', p.currency)
    .where('enabled', '==', true)
    .where('maxPrice', '>=', p.price)
    .get();
  let sent = 0;
  for (const d of rules.docs) {
    const rule = { id: d.id, ...(d.data() as Omit<AlertRule, 'id'>) };
    if (!alertMatches(rule, p)) continue;
    // Duplicate prevention: one notification per rule + station per cooldown window.
    const logRef = db.collection('alertLog').doc(`${rule.uid}_${rule.id}_${p.stationId}`);
    const claimed = await db.runTransaction(async (tx) => {
      const log = await tx.get(logRef);
      const last = log.exists ? (log.get('sentAt') as Timestamp).toMillis() : 0;
      if (nowMs - last < ALERT_COOLDOWN_HOURS * HOUR) return false;
      tx.set(logRef, { sentAt: Timestamp.fromMillis(nowMs), price: p.price, currency: p.currency, ruleId: rule.id, uid: rule.uid });
      return true;
    });
    if (!claimed) continue;
    const token = (await db.doc(`users/${rule.uid}/private/messaging`).get()).get('token') as string | undefined;
    if (!token) continue;
    await messenger.send(
      token,
      `${p.fuelType.replace(/_/g, ' ')} at ${p.currency} ${p.price.toFixed(3)}`,
      `${p.stationName ?? 'A station'} is at or below your alert price (${p.currency} ${rule.maxPrice}).`,
      { stationId: p.stationId, fuelType: p.fuelType, price: String(p.price), currency: p.currency },
    );
    sent++;
  }
  return sent;
}
