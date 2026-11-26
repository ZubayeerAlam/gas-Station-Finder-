import 'package:cloud_functions/cloud_functions.dart' hide Result;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/error/result.dart';
import '../../../core/firebase/firebase_bootstrap.dart';
import '../data/drift_local_data_store.dart';
import '../data/firebase_community_account.dart';
import '../domain/account_data.dart';

final communityAccountProvider = Provider<CommunityAccount>((ref) {
  if (!ref.watch(firebaseStatusProvider).ready) return const UnavailableCommunityAccount();
  return FirebaseCommunityAccount(FirebaseFunctions.instanceFor(region: kFunctionsRegion), FirebaseAuth.instance);
});

final localDataStoreProvider = Provider<LocalDataStore>((ref) => DriftLocalDataStore(ref.watch(appDatabaseProvider)));

/// View-model for the Privacy & data screen.
class AccountController {
  AccountController(this._ref);

  final Ref _ref;

  Future<Result<CommunityDeletionSummary>> deleteOnlineData() => _ref.read(communityAccountProvider).deleteMyData();

  Future<Result<void>> deleteDeviceData() => _ref.read(localDataStoreProvider).wipe();
}

final accountControllerProvider = Provider<AccountController>(AccountController.new);
