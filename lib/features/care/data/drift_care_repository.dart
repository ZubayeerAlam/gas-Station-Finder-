import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/error/app_failure.dart';
import '../../../core/error/result.dart';
import '../domain/care_reminder.dart';
import '../domain/care_repository.dart';

class DriftCareRepository implements CareRepository {
  DriftCareRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<List<CareReminder>> watchReminders(String vehicleId) {
    final q = _db.select(_db.careReminders)
      ..where((t) => t.vehicleId.equals(vehicleId))
      ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]);
    return q.watch().map((rows) => rows.map(_toDomain).nonNulls.toList());
  }

  @override
  Stream<List<CareReminder>> watchAll() {
    final q = _db.select(_db.careReminders)..orderBy([(t) => OrderingTerm.asc(t.createdAt)]);
    return q.watch().map((rows) => rows.map(_toDomain).nonNulls.toList());
  }

  @override
  Future<Result<void>> save(CareReminder r) => _guard(() => _db.into(_db.careReminders).insertOnConflictUpdate(
        CareRemindersCompanion.insert(
          id: r.id,
          vehicleId: r.vehicleId,
          type: r.type.name,
          title: Value(r.title?.trim().isEmpty ?? true ? null : r.title!.trim()),
          dueDate: Value(r.dueDate),
          dueOdometerKm: Value(r.dueOdometerKm),
          repeatMonths: Value(r.repeatMonths),
          repeatKm: Value(r.repeatKm),
          lastDoneAt: Value(r.lastDoneAt),
          lastDoneKm: Value(r.lastDoneKm),
          notifyDaysBefore: Value(r.notifyDaysBefore),
          note: Value(r.note?.trim().isEmpty ?? true ? null : r.note!.trim()),
          createdAt: r.createdAt,
        ),
      ));

  @override
  Future<Result<void>> delete(String reminderId) =>
      _guard(() => (_db.delete(_db.careReminders)..where((t) => t.id.equals(reminderId))).go());

  /// Unknown types (from a newer app version) are skipped, never crash.
  static CareReminder? _toDomain(CareReminderRow r) {
    final type = CareType.values.asNameMap()[r.type];
    if (type == null) return null;
    return CareReminder(
      id: r.id,
      vehicleId: r.vehicleId,
      type: type,
      title: r.title,
      dueDate: r.dueDate,
      dueOdometerKm: r.dueOdometerKm,
      repeatMonths: r.repeatMonths,
      repeatKm: r.repeatKm,
      lastDoneAt: r.lastDoneAt,
      lastDoneKm: r.lastDoneKm,
      notifyDaysBefore: r.notifyDaysBefore < 0 ? 0 : r.notifyDaysBefore,
      note: r.note,
      createdAt: r.createdAt,
    );
  }

  static Future<Result<void>> _guard(Future<void> Function() body) async {
    try {
      await body();
      return const Ok(null);
    } catch (_) {
      return const Err(UnknownFailure('Could not save the reminder. Please try again.', FailureCode.careSaveFailed));
    }
  }
}

final careRepositoryProvider = Provider<CareRepository>(
  (ref) => DriftCareRepository(ref.watch(appDatabaseProvider)),
);
