import 'dart:async';
import 'dart:ui' show PlatformDispatcher;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/l10n.dart';
import '../../along_route/presentation/along_route_providers.dart' show nowProvider;
import '../../garage/domain/vehicle_profile.dart';
import '../../garage/presentation/garage_providers.dart';
import '../data/local_reminder_notifier.dart';
import '../domain/care_reminder.dart';
import '../domain/care_schedule.dart';
import '../domain/reminder_notifier.dart';
import 'care_labels.dart';
import 'care_providers.dart';

/// Turns reminders into localized notices: soonest first, at most [limit].
/// Reminders of deleted vehicles are skipped (their rows are kept for Undo).
List<ScheduledCareNotice> buildCareSchedule({
  required List<VehicleProfile> vehicles,
  required List<CareReminder> reminders,
  required OdometerStats Function(String vehicleId) statsOf,
  required DateTime now,
  required AppLocalizations l,
  int limit = kMaxCareNotices,
}) {
  final byId = {for (final v in vehicles) v.id: v};
  final pending = <(CareNotice, VehicleProfile, CareReminder)>[];
  for (final r in reminders) {
    final v = byId[r.vehicleId];
    if (v == null) continue;
    final st = statsOf(v.id);
    final status = CareStatus.of(r, now: now, odometerKm: st.latestKm, kmPerDay: st.kmPerDay);
    for (final n in careNotices(r, status, now: now)) {
      pending.add((n, v, r));
    }
  }
  pending.sort((a, b) {
    final c = a.$1.when.compareTo(b.$1.when);
    return c != 0 ? c : a.$3.id.compareTo(b.$3.id);
  });
  return [
    for (final (i, (n, v, r)) in pending.take(limit).indexed)
      ScheduledCareNotice(
        id: kCareNoticeBaseId + i,
        when: n.when,
        title: l.careNoticeTitle(careTitle(r, l), v.name),
        body:
            switch (n.kind) {
              CareNoticeKind.onDay => l.careDueToday,
              CareNoticeKind.before => l.careDueInDays(
                r.notifyDaysBefore,
                careDate(n.when.add(Duration(days: r.notifyDaysBefore)), l),
              ),
            } +
            (n.estimated ? l.careNoticeEstimated : ''),
      ),
  ];
}

/// Strings for code that runs outside the widget tree: the user's choice, else the device language.
AppLocalizations l10nFor(String? preference) {
  final locale = localeFromPreference(preference) ?? PlatformDispatcher.instance.locale;
  return AppLocalizations.delegate.isSupported(locale) ? lookupAppLocalizations(locale) : kEnglish;
}

/// Every notice that should currently be scheduled.
final careScheduleProvider = Provider<AsyncValue<List<ScheduledCareNotice>>>((ref) {
  final vehicles = ref.watch(vehiclesProvider);
  final reminders = ref.watch(allCareRemindersProvider);
  final pref = ref.watch(localePreferenceProvider);
  if (pref.isLoading) return const AsyncLoading();
  return switch ((vehicles, reminders)) {
    (AsyncData(value: final vs), AsyncData(value: final rs)) => AsyncData(
      buildCareSchedule(
        vehicles: vs,
        reminders: rs,
        statsOf: (id) => ref.watch(odometerStatsProvider(id)),
        now: ref.watch(nowProvider)(),
        l: l10nFor(pref.value),
      ),
    ),
    (AsyncError(:final error, :final stackTrace), _) ||
    (_, AsyncError(:final error, :final stackTrace)) => AsyncError(error, stackTrace),
    _ => const AsyncLoading(),
  };
});

/// Kept alive by the app: re-syncs the device's notifications whenever the schedule changes.
final careSyncProvider = Provider<void>((ref) {
  final schedule = ref.watch(careScheduleProvider);
  if (schedule case AsyncData(:final value)) {
    unawaited(ref.read(reminderNotifierProvider).sync(value));
  }
});
