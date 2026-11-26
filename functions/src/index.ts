import { initializeApp } from 'firebase-admin/app';
import { getAuth } from 'firebase-admin/auth';
import { FieldValue, getFirestore } from 'firebase-admin/firestore';
import { getMessaging } from 'firebase-admin/messaging';
import { setGlobalOptions } from 'firebase-functions/v2';
import { onDocumentCreated, onDocumentWritten } from 'firebase-functions/v2/firestore';
import { HttpsError, onCall } from 'firebase-functions/v2/https';
import { defineSecret, defineString } from 'firebase-functions/params';
import * as logger from 'firebase-functions/logger';
import { processReport, refreshReliability, type Messenger } from './handlers';
import { AssistantError, DEFAULT_GEMINI_MODEL, parseRequest, runAssistant, type ModelClient } from './assistant';
import { geminiModel } from './gemini_model';
import { demoModel } from './demo_model';
import { deleteUserData } from './account';

initializeApp();
// Cost control: a single small instance per function is plenty for this load.
setGlobalOptions({ region: 'europe-west1', maxInstances: 5, memory: '256MiB' });

const isEmulator = process.env.FUNCTIONS_EMULATOR === 'true';

/** FCM in production; in the emulator FCM is not available, so log instead. */
const messenger: Messenger = isEmulator
  ? { async send(_token, title, body, data) { logger.info('[emulator] alert', { title, body, data }); } }
  : {
      async send(token, title, body, data) {
        await getMessaging().send({ token, notification: { title, body }, data });
      },
    };

export const onPriceReportCreated = onDocumentCreated('priceReports/{reportId}', async (event) => {
  const outcome = await processReport(getFirestore(), event.params.reportId, messenger);
  logger.info('price report processed', { reportId: event.params.reportId, outcome });
});

export const onVerificationWritten = onDocumentWritten('stations/{stationId}/verifications/{uid}', async (event) => {
  const db = getFirestore();
  // Remember where the user voted so "delete my data" can find the (uid-less) vote docs.
  if (event.data?.after.exists) {
    await db.collection('users').doc(event.params.uid)
      .set({ votedStations: FieldValue.arrayUnion(event.params.stationId) }, { merge: true });
  }
  await refreshReliability(db, event.params.stationId);
});

// ---------- account ----------

/** Deletes the caller's community data and their (anonymous) account. Idempotent. */
export const deleteMyData = onCall({ timeoutSeconds: 120, maxInstances: 5 }, async (request) => {
  const uid = request.auth?.uid;
  if (!uid) throw new HttpsError('unauthenticated', 'Sign in first.');
  try {
    const summary = await deleteUserData(getFirestore(), uid);
    try {
      await getAuth().deleteUser(uid);
    } catch (e) {
      if ((e as { code?: string }).code !== 'auth/user-not-found') throw e;
    }
    logger.info('user data deleted', { summary }); // counts only, never the uid
    return summary;
  } catch (e) {
    logger.error('data deletion failed', { error: (e as Error).message });
    throw new HttpsError('internal', 'Could not delete your data. Please try again.');
  }
});

// ---------- AI trip assistant ----------

/**
 * Provider: Gemini API (free tier preferred). The key is server-side only:
 * Secret Manager in production, functions/.secret.local in the emulator.
 * The model id is a plain parameter (functions/.env or the deploy prompt),
 * so it can change without code changes. To use Claude instead, bind
 * ANTHROPIC_API_KEY and return `claudeModel(key)` from claude_model.ts.
 */
const geminiKey = defineSecret('GEMINI_API_KEY');
const geminiModelId = defineString('GEMINI_MODEL', { default: DEFAULT_GEMINI_MODEL });

let live: ModelClient | undefined;
function model(): ModelClient {
  let key = '';
  try { key = geminiKey.value(); } catch { key = ''; }
  if (!key) {
    // Only the emulator may fall back to the clearly labelled offline demo.
    if (isEmulator) return demoModel;
    throw new HttpsError('failed-precondition', 'The assistant is not configured.');
  }
  if (!live) {
    const inner = geminiModel(key, geminiModelId.value());
    live = {
      demo: false,
      modelId: inner.modelId,
      async create(params) {
        try {
          return await inner.create(params);
        } catch (e) {
          // Log the error class/status only, never the request body or key.
          logger.warn('model call failed', { error: (e as Error).name, status: (e as { status?: number }).status });
          throw e;
        }
      },
    };
  }
  return live;
}

export const assistantChat = onCall(
  { secrets: [geminiKey], timeoutSeconds: 120, maxInstances: 5 },
  async (request) => {
    const uid = request.auth?.uid;
    if (!uid) throw new HttpsError('unauthenticated', 'Sign in to use the assistant.');
    try {
      return await runAssistant(getFirestore(), uid, parseRequest(request.data), model());
    } catch (e) {
      if (e instanceof AssistantError) throw new HttpsError(e.code, e.message);
      if (e instanceof HttpsError) throw e;
      logger.error('assistant failed', { error: (e as Error).message });
      throw new HttpsError('internal', 'Something went wrong. Please try again.');
    }
  },
);
