import 'package:cloud_functions/cloud_functions.dart' hide Result;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../../core/error/app_failure.dart';
import '../../../core/error/result.dart';
import '../domain/account_data.dart';

const _failed = ServerFailure('Could not delete your online data.', code: FailureCode.dataDeletionFailed);

/// Calls the `deleteMyData` callable (functions/src/account.ts).
class FirebaseCommunityAccount implements CommunityAccount {
  FirebaseCommunityAccount(this._functions, this._auth);

  final FirebaseFunctions _functions;
  final FirebaseAuth _auth;

  @override
  bool get isAvailable => true;

  @override
  Future<Result<CommunityDeletionSummary>> deleteMyData() async {
    final user = _auth.currentUser;
    // Never signed in on this device → nothing online is linked to it. Signing in
    // now would only create a new, empty account.
    if (user == null) return const Ok(CommunityDeletionSummary.none);
    try {
      await user.getIdToken();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') return const Err(NetworkFailure());
      // Token can't be refreshed: the account no longer exists server-side.
      await _auth.signOut();
      return const Ok(CommunityDeletionSummary.none);
    }
    try {
      final res = await _functions
          .httpsCallable('deleteMyData', options: HttpsCallableOptions(timeout: const Duration(seconds: 120)))
          .call<Object?>(const <String, Object?>{});
      await _auth.signOut();
      final data = res.data;
      return Ok(data is Map ? CommunityDeletionSummary.fromMap(data) : CommunityDeletionSummary.none);
    } on FirebaseFunctionsException catch (e) {
      debugPrint('deleteMyData failed: ${e.code}');
      return Err(e.code == 'unavailable' || e.code == 'deadline-exceeded' ? const NetworkFailure() : _failed);
    } on FirebaseAuthException catch (e) {
      return Err(e.code == 'network-request-failed' ? const NetworkFailure() : _failed);
    }
  }
}

/// Community features not configured: nothing is stored online.
class UnavailableCommunityAccount implements CommunityAccount {
  const UnavailableCommunityAccount();

  @override
  bool get isAvailable => false;

  @override
  Future<Result<CommunityDeletionSummary>> deleteMyData() async => const Ok(CommunityDeletionSummary.none);
}
