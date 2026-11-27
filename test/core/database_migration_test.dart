import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gas_station_finder/core/database/app_database.dart';
import 'package:gas_station_finder/features/garage/data/drift_garage_repository.dart';

/// Every released schema upgrades straight to the current one and keeps the
/// user's data (each version only added tables, then v6 added two columns).
void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  const tablesAt = {
    1: ['vehicles', 'settings'],
    2: ['vehicles', 'settings', 'fill_ups'],
    3: ['vehicles', 'settings', 'fill_ups', 'place_locations'],
    4: ['vehicles', 'settings', 'fill_ups', 'place_locations', 'care_reminders'],
    5: ['vehicles', 'settings', 'fill_ups', 'place_locations', 'care_reminders', 'saved_trips'],
  };

  late Map<String, String> currentSql;

  setUpAll(() async {
    final fresh = AppDatabase(NativeDatabase.memory());
    final rows = await fresh
        .customSelect("SELECT name, sql FROM sqlite_master WHERE type = 'table' AND name NOT LIKE 'sqlite_%'")
        .get();
    currentSql = {for (final r in rows) r.read<String>('name'): r.read<String>('sql')};
    await fresh.close();
  });

  test('the current schema is version 6 with the six known tables', () {
    expect(AppDatabase(NativeDatabase.memory()).schemaVersion, 6);
    expect(currentSql.keys.toSet(), tablesAt[5]!.toSet());
  });

  for (final version in tablesAt.keys) {
    test('v$version → v6 keeps vehicles and settings, creates the rest, accepts new data', () async {
      String oldSql(String table) => table == 'vehicles'
          ? currentSql[table]!
                .replaceAll(RegExp(r',\s*"secondary_fuel_type" TEXT NULL'), '')
                .replaceAll(RegExp(r',\s*"secondary_consumption_per100_km" REAL NULL'), '')
          : currentSql[table]!;

      final db = AppDatabase(
        NativeDatabase.memory(
          setup: (raw) {
            if (raw.userVersion != 0) return;
            for (final t in tablesAt[version]!) {
              raw.execute(oldSql(t));
            }
            raw.execute(
              'INSERT INTO vehicles (id, name, energy_type, consumption_per100_km, capacity, preferred_fuel_type, '
              "charging_efficiency, created_at) VALUES ('old', 'Old car', 0, 7, 40, 'DIESEL', 1.0, 0)",
            );
            raw.execute("INSERT INTO settings (key, value) VALUES ('garage.activeVehicleId', 'old')");
            raw.userVersion = version;
          },
        ),
      );
      addTearDown(db.close);

      final repo = DriftGarageRepository(db);
      final vehicles = await repo.watchVehicles().first;
      expect(vehicles.single.name, 'Old car');
      expect(vehicles.single.isDualFuel, isFalse);
      expect(await repo.watchActiveVehicleId().first, 'old');

      final tables = await db
          .customSelect("SELECT name FROM sqlite_master WHERE type = 'table' AND name NOT LIKE 'sqlite_%'")
          .map((r) => r.read<String>('name'))
          .get();
      expect(tables.toSet(), tablesAt[5]!.toSet());
      final cols = await db.customSelect('PRAGMA table_info("vehicles")').map((r) => r.read<String>('name')).get();
      expect(cols, containsAll(['secondary_fuel_type', 'secondary_consumption_per100_km']));
      expect(await db.customSelect('PRAGMA user_version').map((r) => r.read<int>('user_version')).getSingle(), 6);

      // "Delete everything on this device" still empties every table after an upgrade.
      await db.wipeAll();
      for (final t in tablesAt[5]!) {
        final n = await db.customSelect('SELECT COUNT(*) AS n FROM "$t"').map((r) => r.read<int>('n')).getSingle();
        expect(n, 0, reason: t);
      }
    });
  }
}
