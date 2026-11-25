import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gas_station_finder/features/along_route/presentation/along_route_providers.dart';
import 'package:gas_station_finder/features/care/data/drift_care_repository.dart';
import 'package:gas_station_finder/features/care/data/local_reminder_notifier.dart';
import 'package:gas_station_finder/features/care/domain/care_reminder.dart';
import 'package:gas_station_finder/features/care/domain/reminder_notifier.dart';
import 'package:gas_station_finder/features/care/presentation/care_notifications.dart';
import 'package:gas_station_finder/features/care/presentation/care_providers.dart';
import 'package:gas_station_finder/features/garage/data/drift_garage_repository.dart';
import 'package:gas_station_finder/features/garage/domain/vehicle_profile.dart';
import 'package:gas_station_finder/features/history/data/drift_fill_up_repository.dart';
import 'package:gas_station_finder/features/history/domain/fill_up.dart';
import 'package:gas_station_finder/l10n/l10n.dart';

import '../../helpers/fake_care_repository.dart';
import '../../helpers/fake_fill_up_repository.dart';
import '../../helpers/fake_garage_repository.dart';
import '../../helpers/fake_reminder_notifier.dart';

const car = VehicleProfile(id: 'v1', name: 'Axio', energyType: EnergyType.fuel, consumptionPer100Km: 7, capacity: 40);
final now = DateTime(2026, 11, 25, 10);
final bn = lookupAppLocalizations(const Locale('bn'));

CareReminder rem(String id, {DateTime? due, double? km, int notify = 7, String vehicle = 'v1', CareType? type}) =>
    CareReminder(
      id: id,
      vehicleId: vehicle,
      type: type ?? CareType.taxToken,
      dueDate: due,
      dueOdometerKm: km,
      notifyDaysBefore: notify,
      createdAt: DateTime(2026),
    );

OdometerStats noStats(String _) => (latestKm: null, kmPerDay: null);

void main() {
  group('buildCareSchedule', () {
    test('before + on-day notices at 09:00, soonest first, stable ids, English text', () {
      final out = buildCareSchedule(
        vehicles: [car],
        reminders: [
          rem('b', due: DateTime(2026, 12, 20), type: CareType.insurance),
          rem('a', due: DateTime(2026, 12, 7)),
        ],
        statsOf: noStats,
        now: now,
        l: kEnglish,
      );
      expect(out.map((n) => (n.id, n.when)), [
        (7000, DateTime(2026, 11, 30, 9)),
        (7001, DateTime(2026, 12, 7, 9)),
        (7002, DateTime(2026, 12, 13, 9)),
        (7003, DateTime(2026, 12, 20, 9)),
      ]);
      expect(out[0].title, 'Tax token · Axio');
      expect(out[0].body, 'Due in 7 days · 7 Dec 2026');
      expect(out[1].body, 'Due today');
      expect(out[2].title, 'Insurance · Axio');
    });

    test('skips overdue, undated, past times and deleted vehicles; notify 0 = on the day only', () {
      final out = buildCareSchedule(
        vehicles: [car],
        reminders: [
          rem('overdue', due: DateTime(2026, 11, 20)),
          rem('undated'),
          rem('soon', due: DateTime(2026, 11, 28)), // "before" would be 21 Nov: already past
          rem('zero', due: DateTime(2027, 1, 10), notify: 0),
          rem('orphan', due: DateTime(2027, 1, 1), vehicle: 'deleted'),
        ],
        statsOf: noStats,
        now: now,
        l: kEnglish,
      );
      expect(out.map((n) => n.when), [DateTime(2026, 11, 28, 9), DateTime(2027, 1, 10, 9)]);
      expect(out.map((n) => n.body), ['Due today', 'Due today']);
    });

    test('km reminders use the estimated date and say so; Bengali text', () {
      final out = buildCareSchedule(
        vehicles: [car],
        reminders: [rem('oil', km: 12300, type: CareType.oilChange, notify: 1)],
        statsOf: (_) => (latestKm: 11900, kmPerDay: 40), // 400 km left → 10 days → 5 Dec
        now: now,
        l: bn,
      );
      expect(out.map((n) => n.when), [DateTime(2026, 12, 4, 9), DateTime(2026, 12, 5, 9)]);
      expect(out.first.title, '${bn.careTypeOilChange} · Axio');
      expect(out.first.body, endsWith(bn.careNoticeEstimated));
      expect(out.last.body, bn.careDueToday + bn.careNoticeEstimated);
    });

    test('caps at the limit, keeping the soonest', () {
      final out = buildCareSchedule(
        vehicles: [car],
        reminders: [for (var i = 0; i < 40; i++) rem('r$i', due: DateTime(2027, 1, 1).add(Duration(days: i)))],
        statsOf: noStats,
        now: now,
        l: kEnglish,
      );
      expect(out, hasLength(kMaxCareNotices));
      expect(out.first.when, DateTime(2026, 12, 25, 9));
      expect(out.map((n) => n.id).toSet(), {for (var i = 0; i < kMaxCareNotices; i++) kCareNoticeBaseId + i});
      final whens = out.map((n) => n.when).toList();
      expect(whens, [...whens]..sort());
    });
  });

  test('careSyncProvider pushes the schedule to the notifier and re-syncs on change', () async {
    final care = FakeCareRepository([rem('a', due: DateTime(2026, 12, 7))]);
    final notifier = FakeReminderNotifier();
    final container = ProviderContainer(
      overrides: [
        garageRepositoryProvider.overrideWithValue(FakeGarageRepository([car])),
        fillUpRepositoryProvider.overrideWithValue(FakeFillUpRepository(const <FillUp>[])),
        careRepositoryProvider.overrideWithValue(care),
        reminderNotifierProvider.overrideWithValue(notifier),
        localePreferenceProvider.overrideWithValue(const AsyncData('bn')),
        nowProvider.overrideWithValue(() => now),
      ],
      retry: (_, _) => null,
    );
    addTearDown(container.dispose);
    container.listen(careSyncProvider, (_, _) {});
    await pumpEventQueue();
    expect(notifier.last, hasLength(2));
    expect(notifier.last.first.body, bn.careDueInDays(7, '7 ${bn.monthsShort.split(',')[11]} 2026'));

    await container.read(careControllerProvider).delete('a');
    await pumpEventQueue();
    expect(notifier.last, isEmpty);
    expect(notifier.permissionRequests, 0);
  });

  test('CareController asks for permission once, on the first reminder with a due point', () async {
    final notifier = FakeReminderNotifier();
    final container = ProviderContainer(
      overrides: [
        careRepositoryProvider.overrideWithValue(FakeCareRepository()),
        reminderNotifierProvider.overrideWithValue(notifier),
      ],
    );
    addTearDown(container.dispose);
    final c = container.read(careControllerProvider);
    await c.save(rem('undated'));
    expect(notifier.permissionRequests, 0);
    await c.save(rem('a', due: DateTime(2027)));
    await c.save(rem('b', km: 20000));
    expect(notifier.permissionRequests, 1);
  });

  test('LocalReminderNotifier never throws where the plugin is missing', () async {
    final n = LocalReminderNotifier();
    expect(await n.requestPermission(), isFalse);
    expect(await n.sync([ScheduledCareNotice(id: 7000, when: DateTime(2030), title: 't', body: 'b')]), 0);
  });
}
