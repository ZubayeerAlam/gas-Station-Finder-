import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gas_station_finder/core/database/app_database.dart';
import 'package:gas_station_finder/core/error/app_failure.dart';
import 'package:gas_station_finder/core/error/result.dart';
import 'package:gas_station_finder/features/care/data/drift_care_repository.dart';
import 'package:gas_station_finder/features/care/domain/care_reminder.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  final reminder = CareReminder(
    id: 'r1',
    vehicleId: 'car',
    type: CareType.oilChange,
    title: '  ',
    dueDate: DateTime(2027, 5, 25),
    dueOdometerKm: 19800,
    repeatMonths: 6,
    repeatKm: 5000,
    lastDoneAt: DateTime(2026, 11, 25),
    lastDoneKm: 14800,
    notifyDaysBefore: 3,
    note: ' Shell Helix ',
    createdAt: DateTime(2026, 11, 1),
  );

  group('DriftCareRepository', () {
    late AppDatabase db;
    late DriftCareRepository repo;
    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      repo = DriftCareRepository(db);
    });
    tearDown(() => db.close());

    test('round-trips every field; blank text becomes null', () async {
      expect((await repo.save(reminder)).isOk, isTrue);
      final saved = (await repo.watchReminders('car').first).single;
      expect(saved, reminder.copyWith(title: null, note: 'Shell Helix'));
    });

    test('per-vehicle list, update in place, delete', () async {
      await repo.save(reminder);
      await repo.save(reminder.copyWith(id: 'r2', vehicleId: 'other'));
      expect(await repo.watchReminders('car').first, hasLength(1));
      expect(await repo.watchAll().first, hasLength(2));
      await repo.save(reminder.copyWith(dueOdometerKm: 20000));
      expect((await repo.watchReminders('car').first).single.dueOdometerKm, 20000);
      await repo.delete('r1');
      expect(await repo.watchReminders('car').first, isEmpty);
    });

    test('unknown stored types are skipped instead of crashing', () async {
      await repo.save(reminder);
      await (db.update(
        db.careReminders,
      )..where((t) => t.id.equals('r1'))).write(const CareRemindersCompanion(type: Value('fromTheFuture')));
      expect(await repo.watchAll().first, isEmpty);
    });

    test('failures map to a translated care failure', () async {
      await db.customStatement('DROP TABLE care_reminders'); // simulate a broken database
      final result = await repo.save(reminder);
      expect(result, isA<Err<void>>());
      expect((result as Err<void>).failure.code, FailureCode.careSaveFailed);
    });
  });

  test('upgrading a v3 database adds care_reminders and keeps existing data', () async {
    // Capture the v3 tables' SQL from a fresh database, minus the new table.
    final fresh = AppDatabase(NativeDatabase.memory());
    final rows = await fresh
        .customSelect(
          "SELECT sql FROM sqlite_master WHERE type = 'table' AND name NOT LIKE 'sqlite_%' "
          "AND name != 'care_reminders'",
        )
        .get();
    final v3Sql = rows.map((r) => r.read<String>('sql')).toList();
    await fresh.close();
    expect(v3Sql, hasLength(4));

    final db = AppDatabase(
      NativeDatabase.memory(
        setup: (raw) {
          if (raw.userVersion != 0) return;
          for (final sql in v3Sql) {
            raw.execute(sql);
          }
          raw.execute("INSERT INTO settings (key, value) VALUES ('locale', 'bn')");
          raw.userVersion = 3;
        },
      ),
    );
    addTearDown(db.close);

    expect(await db.readSetting('locale'), 'bn');
    final repo = DriftCareRepository(db);
    expect((await repo.save(reminder)).isOk, isTrue);
    expect(await repo.watchAll().first, hasLength(1));
    expect(await db.customSelect('PRAGMA user_version').map((r) => r.read<int>('user_version')).getSingle(), 4);
  });
}
