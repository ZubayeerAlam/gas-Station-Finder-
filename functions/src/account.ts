import type { Firestore } from 'firebase-admin/firestore';

/** What was removed, returned to the app so it can tell the user. */
export interface DeletionSummary {
  priceReports: number;
  votes: number;
  priceFlags: number;
  alertRules: number;
  assistantSessions: number;
}

/**
 * Deletes everything in Firestore that is linked to [uid]:
 *  - their price reports (they carry uid, position and time),
 *  - their open/closed votes (stations recorded in users/{uid}.votedStations),
 *  - their "wrong price" flags (stations recorded in users/{uid}.flaggedStations),
 *  - users/{uid} with alert rules, messaging token and trust stats,
 *  - alert cooldown log entries, assistant conversations and quota.
 *
 * Station aggregates (consensus price, history, reliability) hold no user id
 * and stay; they expire on their own TTL. Reliability is recomputed by the
 * verification trigger when the votes are deleted.
 */
export async function deleteUserData(db: Firestore, uid: string): Promise<DeletionSummary> {
  if (!uid) throw new Error('uid required');
  const userRef = db.collection('users').doc(uid);
  const [reports, user, rules, alertLog, sessions] = await Promise.all([
    db.collection('priceReports').where('uid', '==', uid).get(),
    userRef.get(),
    userRef.collection('alertRules').get(),
    db.collection('alertLog').where('uid', '==', uid).get(),
    db.collection('assistantSessions').where('uid', '==', uid).get(),
  ]);
  const voted = (user.get('votedStations') as string[] | undefined) ?? [];
  const flagged = (user.get('flaggedStations') as string[] | undefined) ?? [];

  const writer = db.bulkWriter();
  for (const d of [...reports.docs, ...alertLog.docs, ...sessions.docs]) void writer.delete(d.ref);
  const votes = await Promise.all(voted.map((s) => db.doc(`stations/${s}/verifications/${uid}`).get()));
  for (const v of votes) if (v.exists) void writer.delete(v.ref);
  const flags = (await Promise.all(flagged.map((s) =>
    db.collection(`stations/${s}/priceFlags`).where('uid', '==', uid).get()))).flatMap((q) => q.docs);
  for (const f of flags) void writer.delete(f.ref);
  void writer.delete(db.collection('assistantQuota').doc(uid));
  await writer.close();
  // users/{uid} last, with every subcollection (alertRules, private/messaging).
  await db.recursiveDelete(userRef);

  return {
    priceReports: reports.size,
    votes: votes.filter((v) => v.exists).length,
    priceFlags: flags.length,
    alertRules: rules.size,
    assistantSessions: sessions.size,
  };
}
