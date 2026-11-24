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

/// Fill-ups / charging sessions (history). Kept when a vehicle is deleted so
/// "Undo" restores the full history.
@DataClassName('FillUpRow')
class FillUps extends Table {
  TextColumn get id => text()();
  TextColumn get vehicleId => text()();
  DateTimeColumn get date => dateTime()();
  RealColumn get amount => real()();
  RealColumn get totalCost => real()();
  TextColumn get currencyCode => text().withLength(min: 1, max: 8)();
  RealColumn get odometerKm => real().nullable()();
  BoolColumn get isFull => boolean().withDefault(const Constant(true))();
  TextColumn get stationName => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Vehicles, Settings, FillUps])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// On-device database (`fuelwise.sqlite` in app documents).
  factory AppDatabase.onDevice() => AppDatabase(driftDatabase(name: 'fuelwise'));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) await m.createTable(fillUps);
        },
      );

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
