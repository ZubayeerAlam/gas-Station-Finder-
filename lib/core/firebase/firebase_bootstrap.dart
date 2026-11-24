import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';

/// Result of Firebase start-up. [ready] = community features can be used.
class FirebaseStatus {
  const FirebaseStatus(this.mode, {this.ready = false, this.problem});

  final FirebaseMode mode;
  final bool ready;

  /// Why it is not ready (shown to developers / in settings), never a secret.
  final String? problem;

  static const off = FirebaseStatus(FirebaseMode.off, problem: 'Firebase is not configured (FIREBASE_MODE=off).');
}

/// Emulator project id. The `demo-` prefix makes the Emulator Suite refuse
/// to talk to any real Google service, so nothing can be billed.
const kDemoProjectId = 'demo-fuelwise';

/// Format-valid placeholder (not a real key): the native iOS SDK aborts the
/// whole app — uncatchable from Dart — unless the API key is 39 characters
/// and starts with `A`. The emulator never checks it.
const kEmulatorPlaceholderApiKey = 'A00000000000000000000000000000000000000';

/// Native SDK format checks, done in Dart first so a bad config disables
/// community features instead of crashing the app.
bool isPlausibleFirebaseApiKey(String key) => key.length == 39 && key.startsWith('A');
bool isPlausibleFirebaseAppId(String id) => RegExp(r'^\d+:\d+:(ios|android|web):[0-9a-f]+$').hasMatch(id);

abstract final class FirebaseBootstrap {
  static Future<FirebaseStatus> init(AppConfig c) async {
    try {
      switch (c.firebaseMode) {
        case FirebaseMode.off:
          return FirebaseStatus.off;
        case FirebaseMode.emulator:
          // Placeholder options are fine: the emulator ignores them.
          await Firebase.initializeApp(
            options: const FirebaseOptions(
              apiKey: kEmulatorPlaceholderApiKey,
              appId: '1:123456789012:ios:0000000000000000',
              messagingSenderId: '123456789012',
              projectId: kDemoProjectId,
            ),
          );
          final host = c.firebaseEmulatorHost;
          FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
          await FirebaseAuth.instance.useAuthEmulator(host, 9099);
          return const FirebaseStatus(FirebaseMode.emulator, ready: true);
        case FirebaseMode.project:
          if ([c.firebaseProjectId, c.firebaseApiKey, c.firebaseAppId, c.firebaseSenderId].any((v) => v.isEmpty)) {
            return const FirebaseStatus(FirebaseMode.project,
                problem: 'FIREBASE_MODE=project needs FIREBASE_PROJECT_ID, _API_KEY, _APP_ID and _MESSAGING_SENDER_ID.');
          }
          if (!isPlausibleFirebaseApiKey(c.firebaseApiKey) || !isPlausibleFirebaseAppId(c.firebaseAppId)) {
            return const FirebaseStatus(FirebaseMode.project,
                problem: 'FIREBASE_API_KEY / FIREBASE_APP_ID do not look like Firebase client values.');
          }
          await Firebase.initializeApp(
            options: FirebaseOptions(
              apiKey: c.firebaseApiKey,
              appId: c.firebaseAppId,
              messagingSenderId: c.firebaseSenderId,
              projectId: c.firebaseProjectId,
            ),
          );
          return const FirebaseStatus(FirebaseMode.project, ready: true);
      }
    } catch (e) {
      debugPrint('Firebase init failed: ${e.runtimeType}');
      return FirebaseStatus(c.firebaseMode, problem: 'Firebase could not start (${e.runtimeType}).');
    }
  }
}

/// Overridden in `main()` with the real start-up result.
final firebaseStatusProvider = Provider<FirebaseStatus>((_) => FirebaseStatus.off);
