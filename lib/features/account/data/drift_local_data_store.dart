import 'package:flutter/foundation.dart';

import '../../../core/database/app_database.dart';
import '../../../core/error/app_failure.dart';
import '../../../core/error/result.dart';
import '../domain/account_data.dart';

/// Wipes the drift database. Open streams (garage, history, care…) update at
/// once, and the care-notification sync then cancels every scheduled reminder.
class DriftLocalDataStore implements LocalDataStore {
  DriftLocalDataStore(this._db);

  final AppDatabase _db;

  @override
  Future<Result<void>> wipe() async {
    try {
      await _db.wipeAll();
      return const Ok(null);
    } catch (e) {
      debugPrint('Local wipe failed: $e');
      return const Err(UnknownFailure());
    }
  }
}
