import 'package:flutter_test/flutter_test.dart';
import 'package:gas_station_finder/features/care/domain/care_reminder.dart';
import 'package:gas_station_finder/features/care/domain/care_schedule.dart';
import 'package:gas_station_finder/features/garage/domain/vehicle_profile.dart';
import 'package:gas_station_finder/features/history/domain/fill_up.dart';
import 'package:gas_station_finder/features/history/domain/history_analytics.dart';

final now = DateTime(2026, 11, 25, 14, 30);

CareReminder r({
  CareType type = CareType.insurance,
  DateTime? due,
  double? dueKm,
  int? months,
  double? km,
  int notify = 7,
  DateTime? lastDoneAt,
  double? lastDoneKm,
  DateTime? created,
}) => CareReminder(
  id: 'r',
  vehicleId: 'car',
  type: type,
  dueDate: due,
  dueOdometerKm: dueKm,
  repeatMonths: months,
  repeatKm: km,
  notifyDaysBefore: notify,
  lastDoneAt: lastDoneAt,
  lastDoneKm: lastDoneKm,
  createdAt: created ?? DateTime(2026, 1, 1),
);

void main() {
  group('CareStatus by date', () {
    test('bands: upcoming, due soon at the notice boundary, due today, overdue', () {
      expect(CareStatus.of(r(due: DateTime(2026, 12, 10)), now: now).band, CareBand.upcoming);
      final soon = CareStatus.of(r(due: DateTime(2026, 12, 2)), now: now);
      expect((soon.band, soon.daysLeft), (CareBand.dueSoon, 7));
      expect(CareStatus.of(r(due: DateTime(2026, 12, 3)), now: now).band, CareBand.upcoming);
      final today = CareStatus.of(r(due: DateTime(2026, 11, 25)), now: now);
      expect((today.band, today.daysLeft), (CareBand.dueSoon, 0));
      final late = CareStatus.of(r(due: DateTime(2026, 11, 22)), now: now);
      expect((late.band, late.daysLeft), (CareBand.overdue, -3));
    });

    test('calendar days are not shifted by the time of day', () {
      final s = CareStatus.of(r(due: DateTime(2026, 11, 26, 0, 1)), now: DateTime(2026, 11, 25, 23, 59));
      expect(s.daysLeft, 1);
    });

    test('progress uses the last done date (or creation) as start', () {
      final s = CareStatus.of(
        r(due: DateTime(2026, 12, 25), lastDoneAt: DateTime(2025, 12, 25)),
        now: DateTime(2026, 6, 25),
      );
      expect(s.progress, closeTo(0.5, 0.01));
    });
  });

  group('CareStatus by km', () {
    test('without an odometer reading the reminder needs setup', () {
      expect(CareStatus.of(r(dueKm: 15000), now: now).band, CareBand.needsSetup);
    });

    test('km left, due soon within 500 km, overdue when reached', () {
      expect(CareStatus.of(r(dueKm: 15000), now: now, odometerKm: 13000).band, CareBand.upcoming);
      final soon = CareStatus.of(r(dueKm: 15000), now: now, odometerKm: 14600);
      expect((soon.band, soon.kmLeft), (CareBand.dueSoon, 400));
      expect(CareStatus.of(r(dueKm: 15000), now: now, odometerKm: 15000).band, CareBand.overdue);
    });

    test('estimated date from km/day, marked as estimate', () {
      final s = CareStatus.of(r(dueKm: 15000), now: now, odometerKm: 13000, kmPerDay: 40);
      expect(s.effectiveDueDate, DateTime(2027, 1, 14)); // 2000 km / 40 = 50 days
      expect(s.dateEstimated, isTrue);
    });

    test('estimate within the notice period makes it due soon', () {
      expect(CareStatus.of(r(dueKm: 15000), now: now, odometerKm: 14000, kmPerDay: 200).band, CareBand.dueSoon);
    });

    test('both: whichever comes first', () {
      final dateFirst = CareStatus.of(
        r(due: DateTime(2026, 12, 20), dueKm: 15000),
        now: now,
        odometerKm: 13000,
        kmPerDay: 40,
      );
      expect((dateFirst.effectiveDueDate, dateFirst.dateEstimated), (DateTime(2026, 12, 20), false));
      final kmFirst = CareStatus.of(
        r(due: DateTime(2027, 6, 1), dueKm: 15000),
        now: now,
        odometerKm: 14900,
        kmPerDay: 50,
      );
      expect((kmFirst.band, kmFirst.dateEstimated), (CareBand.dueSoon, true));
      expect(
        CareStatus.of(r(due: DateTime(2027, 6, 1), dueKm: 15000), now: now, odometerKm: 15100).band,
        CareBand.overdue,
      );
    });

    test('km progress from the last service', () {
      final s = CareStatus.of(r(dueKm: 15000, km: 5000), now: now, odometerKm: 12500);
      expect(s.progress, closeTo(0.5, 0.001));
    });
  });

  test('not set up / one-off done', () {
    expect(CareStatus.of(r(), now: now).band, CareBand.needsSetup);
    expect(CareStatus.of(r(lastDoneAt: DateTime(2026, 11, 1)), now: now).band, CareBand.done);
  });

  group('markDone', () {
    test('repeating by months and km rolls forward from the done point', () {
      final next = markDone(
        r(due: DateTime(2026, 11, 30), dueKm: 15000, months: 6, km: 5000),
        doneAt: DateTime(2026, 11, 25, 18),
        doneKm: 14800,
      );
      expect(next.dueDate, DateTime(2027, 5, 25));
      expect(next.dueOdometerKm, 19800);
      expect(next.lastDoneAt, DateTime(2026, 11, 25, 18));
      expect(next.lastDoneKm, 14800);
    });

    test('km repeat without an odometer leaves km unset; one-off clears the due', () {
      final noKm = markDone(r(dueKm: 15000, km: 5000), doneAt: now);
      expect((noKm.dueOdometerKm, noKm.dueDate), (null, null));
      final oneOff = markDone(r(due: DateTime(2026, 11, 30)), doneAt: now);
      expect(oneOff.hasDue, isFalse);
      expect(CareStatus.of(oneOff, now: now).band, CareBand.done);
    });

    test('month arithmetic clamps to the end of the month', () {
      expect(addMonths(DateTime(2026, 1, 31), 1), DateTime(2026, 2, 28));
      expect(addMonths(DateTime(2027, 12, 31), 2), DateTime(2028, 2, 29));
      expect(addMonths(DateTime(2026, 11, 25), 60), DateTime(2031, 11, 25));
    });
  });

  group('presets', () {
    const car = VehicleProfile(id: 'c', name: 'Car', energyType: EnergyType.fuel, consumptionPer100Km: 7, capacity: 45);
    test('CNG retest only for CNG, no oil change for EVs', () {
      expect(suggestedCareTypes(car), isNot(contains(CareType.cngRetest)));
      expect(suggestedCareTypes(car), contains(CareType.oilChange));
      expect(suggestedCareTypes(car.copyWith(preferredFuelType: 'METHANE')), contains(CareType.cngRetest));
      final ev = car.copyWith(energyType: EnergyType.electric);
      expect(suggestedCareTypes(ev), isNot(contains(CareType.oilChange)));
      expect(suggestedCareTypes(ev), contains(CareType.tyreRotation));
    });

    test('preset reminder carries the default interval and is not set up yet', () {
      final oil = reminderFromPreset(CareType.oilChange, id: 'x', vehicleId: 'c', now: now);
      expect((oil.repeatMonths, oil.repeatKm, oil.hasDue), (6, 5000, false));
      expect(reminderFromPreset(CareType.cngRetest, id: 'y', vehicleId: 'c', now: now).repeatMonths, 60);
    });
  });

  group('notices', () {
    test('N days before and on the day at 09:00; past ones dropped', () {
      final rem = r(due: DateTime(2026, 12, 10));
      final n = careNotices(rem, CareStatus.of(rem, now: now), now: now);
      expect(n.map((e) => (e.when, e.kind)), [
        (DateTime(2026, 12, 3, 9), CareNoticeKind.before),
        (DateTime(2026, 12, 10, 9), CareNoticeKind.onDay),
      ]);
      final soon = r(due: DateTime(2026, 11, 28));
      expect(careNotices(soon, CareStatus.of(soon, now: now), now: now).map((e) => e.kind), [CareNoticeKind.onDay]);
    });

    test('none when overdue, done or not set up; estimate flag carried', () {
      final late = r(due: DateTime(2026, 11, 1));
      expect(careNotices(late, CareStatus.of(late, now: now), now: now), isEmpty);
      expect(careNotices(r(), CareStatus.of(r(), now: now), now: now), isEmpty);
      final km = r(dueKm: 15000, notify: 0);
      final n = careNotices(km, CareStatus.of(km, now: now, odometerKm: 13000, kmPerDay: 40), now: now);
      expect(n.single.estimated, isTrue);
      expect(n.single.when, DateTime(2027, 1, 14, 9));
    });
  });

  test('sort: overdue, due soon, upcoming by date, then needs setup', () {
    CareReminder mk(String id, {DateTime? due}) => r(due: due).copyWith(id: id);
    final items = [
      mk('setup'),
      mk('later', due: DateTime(2027, 3, 1)),
      mk('late', due: DateTime(2026, 11, 1)),
      mk('soon', due: DateTime(2026, 11, 27)),
      mk('next', due: DateTime(2027, 1, 1)),
    ].map((x) => (x, CareStatus.of(x, now: now))).toList();
    expect(sortByUrgency(items).map((e) => e.$1.id), ['late', 'soon', 'next', 'later', 'setup']);
  });

  group('odometerStats', () {
    FillUp f(DateTime d, double? odo) =>
        FillUp(id: '$d', vehicleId: 'c', date: d, amount: 30, totalCost: 50, currencyCode: 'BDT', odometerKm: odo);

    test('latest = highest reading; km/day between first and last dated readings', () {
      final s = HistoryAnalytics.odometerStats([
        f(DateTime(2026, 11, 21), 12400),
        f(DateTime(2026, 11, 1), 12000),
        f(DateTime(2026, 11, 11), null),
      ]);
      expect(s.latestKm, 12400);
      expect(s.kmPerDay, closeTo(20, 0.001));
    });

    test('one reading: latest only; none: nothing', () {
      expect(HistoryAnalytics.odometerStats([f(DateTime(2026, 11, 1), 900)]), (latestKm: 900.0, kmPerDay: null));
      expect(HistoryAnalytics.odometerStats([f(DateTime(2026, 11, 1), null)]), (latestKm: null, kmPerDay: null));
    });
  });
}
