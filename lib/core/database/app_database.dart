import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'app_database.g.dart';

/// Saved vehicles (My Garage). Values are metric (see `VehicleProfile`).
class Vehicles extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 60)();

  /// `EnergyType.index`.
  IntColumn get energyType => integer()();
  RealColumn get consumptionPer100Km => real()();
  RealColumn get capacity => real()();
  TextColumn get preferredFuelType => text().nullable()();
  RealColumn get chargingEfficiency => real().withDefault(const Constant(1.0))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Small key/value store for app settings (active vehicle, preferences).
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

@DriftDatabase(tables: [Vehicles, Settings])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// On-device database (`fuelwise.sqlite` in app documents).
  factory AppDatabase.onDevice() => AppDatabase(driftDatabase(name: 'fuelwise'));

  @override
  int get schemaVersion => 1;

  // ---- settings helpers ----
  Stream<String?> watchSetting(String key) =>
      (select(settings)..where((s) => s.key.equals(key))).watchSingleOrNull().map((r) => r?.value);

  Future<String?> readSetting(String key) =>
      (select(settings)..where((s) => s.key.equals(key))).getSingleOrNull().then((r) => r?.value);

  Future<void> writeSetting(String key, String? value) async {
    if (value == null) {
      await (delete(settings)..where((s) => s.key.equals(key))).go();
    } else {
      await into(settings).insertOnConflictUpdate(SettingsCompanion.insert(key: key, value: value));
    }
  }
}

/// Overridden in tests with an in-memory database.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase.onDevice();
  ref.onDispose(db.close);
  return db;
});
