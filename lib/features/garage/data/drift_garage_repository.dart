import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/error/app_failure.dart';
import '../../../core/error/result.dart';
import '../domain/garage_repository.dart';
import '../domain/vehicle_profile.dart';

class DriftGarageRepository implements GarageRepository {
  DriftGarageRepository(this._db);

  final AppDatabase _db;
  static const activeVehicleKey = 'garage.activeVehicleId';

  @override
  Stream<List<VehicleProfile>> watchVehicles() {
    final q = _db.select(_db.vehicles)..orderBy([(v) => OrderingTerm.asc(v.createdAt)]);
    return q.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Future<Result<void>> save(VehicleProfile v) => _guard(() async {
    final existing = await (_db.select(_db.vehicles)..where((t) => t.id.equals(v.id))).getSingleOrNull();
    await _db
        .into(_db.vehicles)
        .insertOnConflictUpdate(
          VehiclesCompanion.insert(
            id: v.id,
            name: v.name.trim(),
            energyType: v.energyType.index,
            consumptionPer100Km: v.consumptionPer100Km,
            capacity: v.capacity,
            preferredFuelType: Value(v.preferredFuelType),
            chargingEfficiency: Value(v.chargingEfficiency),
            secondaryFuelType: Value(v.isElectric ? null : v.secondaryFuelType),
            secondaryConsumptionPer100Km: Value(v.isElectric ? null : v.secondaryConsumptionPer100Km),
            createdAt: existing?.createdAt ?? DateTime.now(),
          ),
        );
    // First vehicle becomes active automatically.
    if (await _db.readSetting(activeVehicleKey) == null) {
      await _db.writeSetting(activeVehicleKey, v.id);
    }
  });

  @override
  Future<Result<void>> delete(String vehicleId) => _guard(() async {
    await _db.transaction(() async {
      await (_db.delete(_db.vehicles)..where((t) => t.id.equals(vehicleId))).go();
      if (await _db.readSetting(activeVehicleKey) == vehicleId) {
        final next =
            await (_db.select(_db.vehicles)
                  ..orderBy([(v) => OrderingTerm.asc(v.createdAt)])
                  ..limit(1))
                .getSingleOrNull();
        await _db.writeSetting(activeVehicleKey, next?.id);
      }
    });
  });

  @override
  Stream<String?> watchActiveVehicleId() => _db.watchSetting(activeVehicleKey);

  @override
  Future<Result<void>> setActiveVehicle(String? vehicleId) =>
      _guard(() => _db.writeSetting(activeVehicleKey, vehicleId));

  static VehicleProfile _toDomain(Vehicle r) => VehicleProfile(
    id: r.id,
    name: r.name,
    energyType: EnergyType.values[r.energyType],
    consumptionPer100Km: r.consumptionPer100Km,
    capacity: r.capacity,
    preferredFuelType: r.preferredFuelType,
    chargingEfficiency: r.chargingEfficiency,
    secondaryFuelType: r.secondaryFuelType,
    secondaryConsumptionPer100Km: r.secondaryConsumptionPer100Km,
  );

  static Future<Result<void>> _guard(Future<void> Function() body) async {
    try {
      await body();
      return const Ok(null);
    } catch (_) {
      return const Err(
        UnknownFailure('Could not save to the local garage. Please try again.', FailureCode.garageSaveFailed),
      );
    }
  }
}

final garageRepositoryProvider = Provider<GarageRepository>(
  (ref) => DriftGarageRepository(ref.watch(appDatabaseProvider)),
);
