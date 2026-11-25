import { initializeApp } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';
import { getMessaging } from 'firebase-admin/messaging';
import { setGlobalOptions } from 'firebase-functions/v2';
import { onDocumentCreated, onDocumentWritten } from 'firebase-functions/v2/firestore';
import { HttpsError, onCall } from 'firebase-functions/v2/https';
import { defineSecret } from 'firebase-functions/params';
import Anthropic from '@anthropic-ai/sdk';
import * as logger from 'firebase-functions/logger';
import { processReport, refreshReliability, type Messenger } from './handlers';
import { AssistantError, parseRequest, runAssistant, type ModelClient } from './assistant';
import { demoModel } from './demo_model';

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
  await refreshReliability(getFirestore(), event.params.stationId);
});

// ---------- AI trip assistant ----------

/** Server-side only (Secret Manager in production, functions/.secret.local in the emulator). */
const anthropicKey = defineSecret('ANTHROPIC_API_KEY');

let claude: ModelClient | undefined;
function model(): ModelClient {
  let key = '';
  try { key = anthropicKey.value(); } catch { key = ''; }
  if (!key) {
    // Only the emulator may fall back to the clearly labelled offline demo.
    if (isEmulator) return demoModel;
    throw new HttpsError('failed-precondition', 'The assistant is not configured.');
  }
  if (!claude) {
    const client = new Anthropic({ apiKey: key, timeout: 60_000, maxRetries: 1 });
    claude = {
      demo: false,
      async create(params) {
        try {
          return await client.messages.create(params);
        } catch (e) {
          // Log the class/status only — never the request body or key.
          const status = e instanceof Anthropic.APIError ? e.status : undefined;
          logger.warn('claude call failed', { error: (e as Error).name, status });
          throw e;
        }
      },
    };
  }
  return claude;
}

export const assistantChat = onCall(
  { secrets: [anthropicKey], timeoutSeconds: 120, maxInstances: 5 },
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
