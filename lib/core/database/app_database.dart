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
  // v6: dual-fuel vehicles.
  TextColumn get secondaryFuelType => text().nullable()();
  RealColumn get secondaryConsumptionPer100Km => real().nullable()();
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

/// Offline cache of nearby-search results. Google's Places policies allow
/// storing place IDs indefinitely and latitude/longitude for at most 30
/// consecutive days — so ONLY those are kept (no names, addresses, prices).
@DataClassName('PlaceLocationRow')
class PlaceLocations extends Table {
  TextColumn get placeId => text()();
  RealColumn get lat => real()();
  RealColumn get lng => real()();
  DateTimeColumn get fetchedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {placeId};
}

/// Vehicle-care reminders (document expiry, service intervals). Like
/// fill-ups, rows outlive a deleted vehicle so "Undo" restores them.
@DataClassName('CareReminderRow')
class CareReminders extends Table {
  TextColumn get id => text()();
  TextColumn get vehicleId => text()();

  /// `CareType.name` (stable across enum reordering).
  TextColumn get type => text()();
  TextColumn get title => text().nullable()();
  DateTimeColumn get dueDate => dateTime().nullable()();
  RealColumn get dueOdometerKm => real().nullable()();
  IntColumn get repeatMonths => integer().nullable()();
  RealColumn get repeatKm => real().nullable()();
  DateTimeColumn get lastDoneAt => dateTime().nullable()();
  RealColumn get lastDoneKm => real().nullable()();
  IntColumn get notifyDaysBefore => integer().withDefault(const Constant(7))();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Trips the user saved under their own label. Only the place ID is kept
/// long-term; coordinates are dropped after 30 days (Google Places terms).
@DataClassName('SavedTripRow')
class SavedTrips extends Table {
  TextColumn get id => text()();
  TextColumn get label => text().withLength(min: 1, max: 40)();
  TextColumn get placeId => text().nullable()();
  RealColumn get lat => real().nullable()();
  RealColumn get lng => real().nullable()();
  DateTimeColumn get coordsSavedAt => dateTime().nullable()();
  RealColumn get lastDistanceMeters => real().nullable()();
  RealColumn get lastDurationSeconds => real().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastUsedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Vehicles, Settings, FillUps, PlaceLocations, CareReminders, SavedTrips])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// On-device database (`fuelwise.sqlite` in app documents).
  factory AppDatabase.onDevice() => AppDatabase(driftDatabase(name: 'fuelwise'));

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) await m.createTable(fillUps);
      if (from < 3) await m.createTable(placeLocations);
      if (from < 4) await m.createTable(careReminders);
      if (from < 5) await m.createTable(savedTrips);
      if (from < 6) {
        await _addColumnIfMissing(m, vehicles, vehicles.secondaryFuelType);
        await _addColumnIfMissing(m, vehicles, vehicles.secondaryConsumptionPer100Km);
      }
    },
  );

  /// Adds [column] unless the table already has it, so an upgrade never fails
  /// on a database that was created with the newer table definition.
  Future<void> _addColumnIfMissing(Migrator m, TableInfo table, GeneratedColumn column) async {
    final existing = await customSelect('PRAGMA table_info("${table.actualTableName}")').get();
    if (existing.any((r) => r.read<String>('name') == column.name)) return;
    await m.addColumn(table, column);
  }

  /// Erases every row the app keeps on the device ("delete my data").
  Future<void> wipeAll() => transaction(() async {
    for (final table in allTables) {
      await delete(table).go();
    }
  });

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
