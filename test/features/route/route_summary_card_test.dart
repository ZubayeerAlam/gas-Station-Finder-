import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gas_station_finder/core/location/geo_point.dart';
import 'package:gas_station_finder/core/theme/app_theme.dart';
import 'package:gas_station_finder/features/garage/domain/vehicle_profile.dart';
import 'package:gas_station_finder/features/history/domain/fill_up.dart';
import 'package:gas_station_finder/features/route/domain/route_energy.dart';
import 'package:gas_station_finder/features/route/domain/route_info.dart';
import 'package:gas_station_finder/features/route/presentation/route_summary_card.dart';
import 'package:gas_station_finder/l10n/app_localizations.dart';

const a = GeoPoint(latitude: 23.8, longitude: 90.4);
const b = GeoPoint(latitude: 23.7, longitude: 90.4);
RouteInfo route(double m, double s) => RouteInfo(distanceMeters: m, durationSeconds: s, points: const [a, b]);

Future<void> pump(
  WidgetTester tester,
  RoutePlan? plan, {
  bool loading = false,
  ValueChanged<int>? onSelect,
  Locale locale = const Locale('en'),
  double scale = 1,
  RouteEnergyEstimate Function(double)? estimateFor,
}) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 2.75;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light(),
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, c) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
        child: c!,
      ),
      home: Scaffold(
        body: Align(
          alignment: Alignment.bottomCenter,
          child: RouteSummaryCard(
            plan: plan,
            loading: loading,
            onSelect: onSelect ?? (_) {},
            onClear: () {},
            estimateFor: estimateFor,
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  final plan = RoutePlan([route(12300, 1500), route(11800, 1740), route(14000, 1520)]);

  testWidgets('single route: no chips', (tester) async {
    await pump(tester, RoutePlan([route(2400, 300)]));
    expect(find.text('2.4 km · 5 min'), findsOneWidget);
    expect(find.byType(ChoiceChip), findsNothing);
  });

  testWidgets('loading shows calculating', (tester) async {
    await pump(tester, null, loading: true);
    expect(find.text('Calculating route…'), findsOneWidget);
  });

  testWidgets('alternatives: labels relative to fastest, tap selects', (tester) async {
    int? picked;
    await pump(tester, plan, onSelect: (i) => picked = i);
    expect(find.text('12 km · 25 min'), findsOneWidget);
    expect(find.text('Fastest · 12 km'), findsOneWidget);
    expect(find.text('+4 min · 12 km'), findsOneWidget);
    expect(find.text('Similar time · 14 km'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('routeOption-1')));
    expect(picked, 1);
  });

  testWidgets('selected alternative is shown in the headline', (tester) async {
    await pump(tester, plan.select(1));
    expect(find.text('12 km · 29 min'), findsOneWidget);
    expect(tester.widget<ChoiceChip>(find.byKey(const ValueKey('routeOption-1'))).selected, isTrue);
  });

  testWidgets('Bengali at 200 % text is accessible', (tester) async {
    final handle = tester.ensureSemantics();
    await pump(tester, plan, locale: const Locale('bn'), scale: 2);
    expect(find.text('দ্রুততম · 12 km'), findsOneWidget);
    expect(find.text('+4 মিনিট · 12 km'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    handle.dispose();
  });

  group('fuel estimate', () {
    const axio = VehicleProfile(
      id: 'v',
      name: 'Axio',
      energyType: EnergyType.fuel,
      consumptionPer100Km: 6.5,
      capacity: 42,
    );
    const ev = VehicleProfile(
      id: 'e',
      name: 'Dolphin',
      energyType: EnergyType.electric,
      consumptionPer100Km: 14.5,
      capacity: 44.9,
      chargingEfficiency: 0.9,
    );
    final fill = FillUp(
      id: 'f',
      vehicleId: 'v',
      date: DateTime(2026, 11, 20),
      amount: 40,
      totalCost: 5000,
      currencyCode: 'BDT',
    );

    test('litres from consumption; cost at the last fill-up unit price; no price → no cost', () {
      final e = estimateRouteEnergy(20000, axio, lastFillUp: fill);
      expect(e.units, closeTo(1.3, 1e-9));
      expect(e.cost, closeTo(162.5, 1e-9)); // 1.3 L × BDT 125
      expect((e.unit, e.currencyCode), ('L', 'BDT'));
      final none = estimateRouteEnergy(20000, axio);
      expect((none.cost, none.currencyCode), (null, null));
    });

    test('EV: kWh to buy includes charging losses', () {
      expect(estimateRouteEnergy(10000, ev).units, closeTo(1.45 / 0.9, 1e-9));
    });

    testWidgets('card shows the selected route\'s litres and cost, updates on switch', (tester) async {
      await pump(tester, plan, estimateFor: (m) => estimateRouteEnergy(m, axio, lastFillUp: fill));
      expect(find.text('≈ 0.8 L · ≈ BDT 99.94 at your last fill-up price'), findsOneWidget); // 12.3 km
      await pump(tester, plan.select(2), estimateFor: (m) => estimateRouteEnergy(m, axio, lastFillUp: fill));
      expect(find.text('≈ 0.9 L · ≈ BDT 113.75 at your last fill-up price'), findsOneWidget); // 14 km
    });

    testWidgets('no fill-up yet: litres only; no vehicle: no line', (tester) async {
      await pump(tester, plan, estimateFor: (m) => estimateRouteEnergy(m, axio));
      expect(find.text('≈ 0.8 L for this route'), findsOneWidget);
      await pump(tester, plan);
      expect(find.byKey(const Key('routeEstimate')), findsNothing);
    });
  });
}
