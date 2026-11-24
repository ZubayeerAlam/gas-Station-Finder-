import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/error/app_failure.dart';
import '../../../core/error/result.dart';
import '../domain/fill_up.dart';
import '../domain/fill_up_repository.dart';

class DriftFillUpRepository implements FillUpRepository {
  DriftFillUpRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<List<FillUp>> watchFillUps(String vehicleId) {
    final q = _db.select(_db.fillUps)
      ..where((f) => f.vehicleId.equals(vehicleId))
      ..orderBy([(f) => OrderingTerm.desc(f.date)]);
    return q.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Future<Result<void>> save(FillUp f) => _guard(() => _db.into(_db.fillUps).insertOnConflictUpdate(
        FillUpsCompanion.insert(
          id: f.id,
          vehicleId: f.vehicleId,
          date: f.date,
          amount: f.amount,
          totalCost: f.totalCost,
          currencyCode: f.currencyCode,
          odometerKm: Value(f.odometerKm),
          isFull: Value(f.isFull),
          stationName: Value(f.stationName),
        ),
      ));

  @override
  Future<Result<void>> delete(String fillUpId) =>
      _guard(() => (_db.delete(_db.fillUps)..where((f) => f.id.equals(fillUpId))).go());

  static FillUp _toDomain(FillUpRow r) => FillUp(
        id: r.id,
        vehicleId: r.vehicleId,
        date: r.date,
        amount: r.amount,
        totalCost: r.totalCost,
        currencyCode: r.currencyCode,
        odometerKm: r.odometerKm,
        isFull: r.isFull,
        stationName: r.stationName,
      );

  static Future<Result<void>> _guard(Future<Object?> Function() body) async {
    try {
      await body();
      return const Ok(null);
    } catch (_) {
      return const Err(UnknownFailure('Could not update your history. Please try again.'));
    }
  }
}

final fillUpRepositoryProvider = Provider<FillUpRepository>(
  (ref) => DriftFillUpRepository(ref.watch(appDatabaseProvider)),
);
