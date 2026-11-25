import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/result.dart';
import '../../along_route/presentation/along_route_providers.dart' show nowProvider;
import '../../garage/domain/vehicle_profile.dart';
import '../../history/domain/history_analytics.dart';
import '../../history/presentation/history_providers.dart';
import '../data/drift_care_repository.dart';
import '../domain/care_reminder.dart';
import '../domain/care_schedule.dart';
import '../domain/care_schedule.dart' as schedule show markDone;

typedef OdometerStats = ({double? latestKm, double? kmPerDay});
typedef CareItem = (CareReminder, CareStatus);

final careRemindersProvider = StreamProvider.family<List<CareReminder>, String>(
  (ref, vehicleId) => ref.watch(careRepositoryProvider).watchReminders(vehicleId),
);

final allCareRemindersProvider = StreamProvider<List<CareReminder>>(
  (ref) => ref.watch(careRepositoryProvider).watchAll(),
);

/// Latest odometer + km/day from the vehicle's fill-up history.
final odometerStatsProvider = Provider.family<OdometerStats, String>(
  (ref, vehicleId) => HistoryAnalytics.odometerStats(ref.watch(fillUpsProvider(vehicleId)).value ?? const []),
);

/// The vehicle's reminders with their current status, most urgent first.
final careItemsProvider = Provider.family<AsyncValue<List<CareItem>>, String>((ref, vehicleId) {
  final now = ref.watch(nowProvider)();
  final stats = ref.watch(odometerStatsProvider(vehicleId));
  return ref
      .watch(careRemindersProvider(vehicleId))
      .whenData(
        (list) => sortByUrgency([
          for (final r in list) (r, CareStatus.of(r, now: now, odometerKm: stats.latestKm, kmPerDay: stats.kmPerDay)),
        ]),
      );
});

/// Overdue + due-soon count for the Garage badge.
final careAttentionCountProvider = Provider.family<int, String>((ref, vehicleId) {
  final items = ref.watch(careItemsProvider(vehicleId)).value ?? const <CareItem>[];
  return items.where((i) => i.$2.band == CareBand.overdue || i.$2.band == CareBand.dueSoon).length;
});

/// Write operations for the care screens (MVVM view-model).
class CareController {
  CareController(this._ref);

  final Ref _ref;
  final _random = Random();

  String newId() => 'care_${DateTime.now().microsecondsSinceEpoch}_${_random.nextInt(1 << 20)}';
  DateTime _now() => _ref.read(nowProvider)();

  Future<Result<void>> save(CareReminder r) => _ref.read(careRepositoryProvider).save(r);
  Future<Result<void>> delete(String id) => _ref.read(careRepositoryProvider).delete(id);

  /// Adds the suggested presets this vehicle doesn't have yet; returns how many.
  Future<Result<int>> addSuggested(VehicleProfile v, List<CareReminder> existing) async {
    final have = existing.map((r) => r.type).toSet();
    var added = 0;
    for (final type in suggestedCareTypes(v)) {
      if (have.contains(type)) continue;
      final result = await save(reminderFromPreset(type, id: newId(), vehicleId: v.id, now: _now()));
      if (result case Err(:final failure)) return Err(failure);
      added++;
    }
    return Ok(added);
  }

  Future<Result<CareReminder>> markDone(CareReminder r, {required DateTime doneAt, double? doneKm}) async {
    final next = schedule.markDone(r, doneAt: doneAt, doneKm: doneKm);
    return switch (await save(next)) {
      Ok() => Ok(next),
      Err(:final failure) => Err(failure),
    };
  }
}

final careControllerProvider = Provider<CareController>(CareController.new);
