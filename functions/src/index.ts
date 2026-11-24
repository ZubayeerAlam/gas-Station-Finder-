import { initializeApp } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';
import { getMessaging } from 'firebase-admin/messaging';
import { setGlobalOptions } from 'firebase-functions/v2';
import { onDocumentCreated, onDocumentWritten } from 'firebase-functions/v2/firestore';
import * as logger from 'firebase-functions/logger';
import { processReport, refreshReliability, type Messenger } from './handlers';

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
