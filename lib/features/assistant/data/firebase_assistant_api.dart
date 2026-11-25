import 'package:cloud_functions/cloud_functions.dart' hide Result;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../../core/error/app_failure.dart';
import '../../../core/error/result.dart';
import '../domain/assistant_models.dart';

/// Calls the `assistantChat` callable. The Claude API key lives only on the
/// server; the app sends the user's text and tool results, nothing else.
class FirebaseAssistantApi implements AssistantApi {
  FirebaseAssistantApi(this._functions, this._auth);

  final FirebaseFunctions _functions;
  final FirebaseAuth _auth;

  @override
  bool get isAvailable => true;

  @override
  Future<Result<AssistantTurn>> sendMessage(String? sessionId, String text) =>
      _call({'sessionId': ?sessionId, 'text': text});

  @override
  Future<Result<AssistantTurn>> sendToolResults(String sessionId, List<ToolOutput> results) =>
      _call({'sessionId': sessionId, 'toolResults': [for (final r in results) r.toMap()]});

  /// Signs in anonymously, replacing a stored user whose token can no longer
  /// be refreshed (deleted/disabled user, or a reset auth emulator).
  Future<void> _ensureSignedIn() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await user.getIdToken();
        return;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'network-request-failed') rethrow;
        await _auth.signOut();
      }
    }
    await _auth.signInAnonymously();
  }

  Future<Result<AssistantTurn>> _call(Map<String, Object?> data) async {
    try {
      await _ensureSignedIn();
      final res = await _functions
          .httpsCallable('assistantChat', options: HttpsCallableOptions(timeout: const Duration(seconds: 130)))
          .call<Object?>(data);
      return Ok(AssistantTurn.fromMap(deepStringKeys(res.data) as Map<String, Object?>));
    } on FirebaseFunctionsException catch (e) {
      debugPrint('assistantChat failed: ${e.code} ${e.message}');
      return Err(mapFunctionsError(e.code, e.message));
    } on FirebaseAuthException catch (e) {
      return Err(e.code == 'network-request-failed' ? const NetworkFailure() : const ServerFailure('Could not sign in.'));
    } on FormatException {
      return const Err(UnknownFailure());
    }
  }
}

/// Callable error code → [AppFailure]. Server messages for user-facing codes
/// are written for users (see functions/src/assistant.ts).
AppFailure mapFunctionsError(String code, String? message) => switch (code) {
      'deadline-exceeded' => const TimeoutFailure(),
      'unavailable' when message == null => const NetworkFailure(),
      'invalid-argument' || 'resource-exhausted' || 'failed-precondition' || 'not-found' || 'unavailable' ||
      'unauthenticated' =>
        ServerFailure(message ?? 'The assistant could not answer.'),
      _ => const ServerFailure('The assistant could not answer. Please try again.'),
    };
