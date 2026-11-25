import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gas_station_finder/core/database/app_database.dart';
import 'package:gas_station_finder/core/router/app_router.dart';
import 'package:gas_station_finder/core/theme/app_theme.dart';
import 'package:gas_station_finder/features/garage/data/drift_garage_repository.dart';
import 'package:gas_station_finder/features/garage/domain/vehicle_profile.dart';
import 'package:gas_station_finder/features/history/data/drift_fill_up_repository.dart';
import 'package:gas_station_finder/features/history/domain/fill_up.dart';
import 'package:gas_station_finder/features/history/domain/history_analytics.dart';
import 'package:gas_station_finder/features/history/presentation/fill_up_form_screen.dart';
import 'package:gas_station_finder/features/history/presentation/history_screen.dart';

import '../../helpers/fake_fill_up_repository.dart';
import '../../helpers/fake_garage_repository.dart';

const car = VehicleProfile(
  id: 'car',
  name: 'Corolla',
  energyType: EnergyType.fuel,
  consumptionPer100Km: 6.5,
  capacity: 50,
);

FillUp fill(String id, DateTime date, double amount, double cost,
        {double? odo, bool full = true, String ccy = 'EUR', String vehicle = 'car'}) =>
    FillUp(
      id: id,
      vehicleId: vehicle,
      date: date,
      amount: amount,
      totalCost: cost,
      currencyCode: ccy,
      odometerKm: odo,
      isFull: full,
    );

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  group('HistoryAnalytics.consumption (full-to-full)', () {
    test('partial fills are added to the next full fill-up', () {
      final points = HistoryAnalytics.consumption([
        fill('1', DateTime(2026, 1, 1), 40, 70, odo: 10000),
        fill('2', DateTime(2026, 1, 10), 10, 18, odo: 10200, full: false),
        fill('3', DateTime(2026, 1, 20), 20, 36, odo: 10500),
      ]);
      expect(points, hasLength(1));
      final p = points.single;
      expect(p.distanceKm, 500);
      expect(p.amount, 30); // first fill excluded, partial included
      expect(p.per100Km, closeTo(6, 1e-9));
      expect(p.costPerKm, closeTo(54 / 500, 1e-9));
      expect(p.currencyCode, 'EUR');
    });

    test('no odometer / no distance → no point; mixed currency → no cost per km', () {
      expect(
        HistoryAnalytics.consumption([
          fill('1', DateTime(2026, 1, 1), 40, 70),
          fill('2', DateTime(2026, 1, 9), 40, 70),
        ]),
        isEmpty,
      );
      expect(
        HistoryAnalytics.consumption([
          fill('1', DateTime(2026, 1, 1), 40, 70, odo: 100),
          fill('2', DateTime(2026, 1, 9), 40, 70, odo: 100),
        ]),
        isEmpty,
      );
      final mixed = HistoryAnalytics.consumption([
        fill('1', DateTime(2026, 1, 1), 40, 70, odo: 0),
        fill('2', DateTime(2026, 1, 5), 10, 20, odo: 200, full: false, ccy: 'CHF'),
        fill('3', DateTime(2026, 1, 9), 20, 36, odo: 500),
      ]).single;
      expect(mixed.per100Km, closeTo(6, 1e-9));
      expect(mixed.costPerKm, isNull);
      expect(mixed.currencyCode, isNull);
    });

    test('average is distance-weighted', () {
      final points = HistoryAnalytics.consumption([
        fill('1', DateTime(2026, 1, 1), 40, 0, odo: 0),
        fill('2', DateTime(2026, 1, 2), 5, 0, odo: 100), // 5.0
        fill('3', DateTime(2026, 1, 3), 27, 0, odo: 400), // 9.0
      ]);
      expect(points.map((p) => p.per100Km), [closeTo(5, 1e-9), closeTo(9, 1e-9)]);
      expect(HistoryAnalytics.averagePer100Km(points), closeTo(32 / 400 * 100, 1e-9));
      expect(HistoryAnalytics.averagePer100Km(const []), isNull);
    });
  });

  group('HistoryAnalytics summaries', () {
    final list = [
      fill('1', DateTime(2026, 10, 3), 40, 70),
      fill('2', DateTime(2026, 11, 2), 30, 50),
      fill('3', DateTime(2026, 11, 20), 20, 30),
      fill('4', DateTime(2026, 11, 21), 10, 25, ccy: 'CHF'),
    ];

    test('monthly groups by month and currency, newest first', () {
      final m = HistoryAnalytics.monthly(list);
      expect(m.map((s) => (s.month, s.currencyCode, s.totalCost, s.count)), [
        (11, 'EUR', 80.0, 2),
        (11, 'CHF', 25.0, 1),
        (10, 'EUR', 70.0, 1),
      ]);
    });

    test('primary currency and spend by month (zero-filled)', () {
      expect(HistoryAnalytics.primaryCurrency(list), 'EUR');
      expect(HistoryAnalytics.primaryCurrency(const []), isNull);
      final spend = HistoryAnalytics.spendByMonth(list, 'EUR', now: DateTime(2026, 11, 25), months: 3);
      expect(spend.map((e) => (e.$1.month, e.$2)), [(9, 0.0), (10, 70.0), (11, 80.0)]);
    });

    test('spend window crosses the year boundary', () {
      final spend = HistoryAnalytics.spendByMonth(const [], 'EUR', now: DateTime(2027, 2, 1), months: 4);
      expect(spend.map((e) => (e.$1.year, e.$1.month)), [(2026, 11), (2026, 12), (2027, 1), (2027, 2)]);
    });
  });

  test('previousOdometer only considers readings on or before the date', () {
    final list = [
      fill('1', DateTime(2026, 1, 1), 1, 1, odo: 1000),
      fill('2', DateTime(2026, 2, 1), 1, 1, odo: 2000),
    ];
    expect(previousOdometer(list, DateTime(2026, 1, 15)), 1000);
    expect(previousOdometer(list, DateTime(2026, 3, 1)), 2000);
    expect(previousOdometer(list, DateTime(2025, 1, 1)), isNull);
  });

  group('DriftFillUpRepository', () {
    late AppDatabase db;
    late DriftFillUpRepository repo;
    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      repo = DriftFillUpRepository(db);
    });
    tearDown(() => db.close());

    test('round-trips, filters by vehicle, newest first, deletes', () async {
      final a = fill('a', DateTime(2026, 1, 1), 40, 70, odo: 100, full: false)
          .copyWith(stationName: 'Shell');
      final b = fill('b', DateTime(2026, 2, 1), 30, 50);
      final other = fill('c', DateTime(2026, 3, 1), 1, 1, vehicle: 'ev');
      for (final f in [a, b, other]) {
        expect((await repo.save(f)).isOk, isTrue);
      }
      expect(await repo.watchFillUps('car').first, [b, a]);
      await repo.delete('b');
      expect(await repo.watchFillUps('car').first, [a]);
    });

    test('fill-ups survive vehicle delete so Undo restores history', () async {
      final garage = DriftGarageRepository(db);
      await garage.save(car);
      await repo.save(fill('a', DateTime(2026, 1, 1), 40, 70));
      await garage.delete('car');
      await garage.save(car);
      expect(await repo.watchFillUps('car').first, hasLength(1));
    });
  });

  group('History UI (fake repositories via DI)', () {
    Future<FakeFillUpRepository> pumpApp(WidgetTester tester, String location,
        {List<VehicleProfile> vehicles = const [car], List<FillUp> fillUps = const []}) async {
      final repo = FakeFillUpRepository(fillUps);
      await tester.pumpWidget(ProviderScope(
        overrides: [
          garageRepositoryProvider.overrideWithValue(FakeGarageRepository(vehicles)),
          fillUpRepositoryProvider.overrideWithValue(repo),
        ],
        retry: (_, _) => null,
        child: MaterialApp.router(theme: AppTheme.light(), routerConfig: buildRouter(initialLocation: location)),
      ));
      await tester.pumpAndSettle();
      return repo;
    }

    testWidgets('no vehicle → prompt to open garage', (tester) async {
      await pumpApp(tester, AppRoutes.history, vehicles: const []);
      expect(find.text('No active vehicle'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsNothing);
    });

    testWidgets('empty history → add fill-up → shows entry', (tester) async {
      final repo = await pumpApp(tester, AppRoutes.history);
      expect(find.text('No fill-ups yet'), findsOneWidget);

      await tester.tap(find.text('Add fill-up'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('amount')), '40');
      await tester.enterText(find.byKey(const Key('cost')), '71,6');
      await tester.enterText(find.byKey(const Key('currency')), 'eur');
      await tester.pump();
      expect(find.text('Unit price: EUR 1.79/L'), findsOneWidget);
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      final saved = repo.items.single;
      expect((saved.amount, saved.totalCost, saved.currencyCode, saved.isFull), (40.0, 71.6, 'EUR', true));
      await tester.scrollUntilVisible(find.text('40 L · EUR 71.60'), 200);
      expect(find.text('40 L · EUR 71.60'), findsOneWidget);
    });

    testWidgets('form rejects bad currency and lower odometer', (tester) async {
      final repo = await pumpApp(tester, AppRoutes.fillUpNew,
          fillUps: [fill('1', DateTime(2026, 1, 1), 40, 70, odo: 12000)]);
      expect(find.widgetWithText(TextFormField, 'EUR'), findsOneWidget); // reused currency
      await tester.enterText(find.byKey(const Key('amount')), '10');
      await tester.enterText(find.byKey(const Key('cost')), '20');
      await tester.enterText(find.byKey(const Key('currency')), 'E');
      await tester.enterText(find.byKey(const Key('odometer')), '11000');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(find.text('3-letter code'), findsOneWidget);
      expect(find.text('Must be above the previous reading (12000 km)'), findsOneWidget);
      expect(repo.items, hasLength(1));
    });

    testWidgets('stats, charts and delete with undo', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.5;
      addTearDown(tester.view.reset);
      final repo = FakeFillUpRepository([
        fill('1', DateTime(2026, 9, 1), 40, 70, odo: 10000),
        fill('2', DateTime(2026, 10, 1), 30, 54, odo: 10500), // 6.0
        fill('3', DateTime(2026, 11, 1), 35, 63, odo: 11000), // 7.0
        fill('4', DateTime(2026, 11, 2), 5, 9, ccy: 'CHF', full: false),
      ]);
      await tester.pumpWidget(ProviderScope(
        overrides: [
          garageRepositoryProvider.overrideWithValue(FakeGarageRepository([car])),
          fillUpRepositoryProvider.overrideWithValue(repo),
        ],
        child: MaterialApp(theme: AppTheme.light(), home: HistoryScreen(now: DateTime(2026, 11, 25))),
      ));
      await tester.pumpAndSettle();

      expect(find.text('History · Corolla'), findsOneWidget);
      expect(find.text('EUR 63.00'), findsAtLeastNWidgets(1)); // this month (EUR only)
      expect(find.text('6.5 L/100 km'), findsOneWidget); // 65 L / 1000 km
      expect(find.text('EUR 0.117'), findsOneWidget); // 117 / 1000 km
      expect(find.textContaining('1 entry in another currency not shown'), findsOneWidget);
      expect(find.bySemanticsLabel(RegExp('Consumption trend: 6.0, 7.0')), findsOneWidget);

      await tester.scrollUntilVisible(find.text('5 L · CHF 9.00'), 200);
      await tester.tap(find.byTooltip('Delete entry').first);
      await tester.pumpAndSettle();
      expect(repo.items, hasLength(3));
      await tester.tap(find.text('Undo'));
      await tester.pumpAndSettle();
      expect(repo.items, hasLength(4));
    });
  });
}
