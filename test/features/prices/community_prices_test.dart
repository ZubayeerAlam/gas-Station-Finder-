import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseException, Timestamp;
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gas_station_finder/features/prices/domain/community_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gas_station_finder/core/config/app_config.dart';
import 'package:gas_station_finder/core/error/app_failure.dart';
import 'package:gas_station_finder/core/firebase/firebase_bootstrap.dart';
import 'package:gas_station_finder/core/error/result.dart';
import 'package:gas_station_finder/core/location/geo_point.dart';
import 'package:gas_station_finder/core/location/location_service.dart';
import 'package:gas_station_finder/core/theme/app_theme.dart';
import 'package:gas_station_finder/features/along_route/domain/along_route_repositories.dart';
import 'package:gas_station_finder/features/along_route/presentation/along_route_providers.dart';
import 'package:gas_station_finder/features/garage/data/drift_garage_repository.dart';
import 'package:gas_station_finder/features/garage/domain/vehicle_profile.dart';
import 'package:gas_station_finder/features/prices/data/community_quote_lookup.dart';
import 'package:gas_station_finder/features/prices/data/firestore_community_repository.dart';
import 'package:gas_station_finder/features/prices/data/unavailable_community_repository.dart';
import 'package:gas_station_finder/features/prices/domain/community_models.dart';
import 'package:gas_station_finder/features/prices/presentation/alerts_screen.dart';
import 'package:gas_station_finder/features/prices/presentation/community_providers.dart';
import 'package:gas_station_finder/features/prices/presentation/community_section.dart';
import 'package:gas_station_finder/features/prices/presentation/report_price_screen.dart';
import 'package:gas_station_finder/features/ranking/domain/ranking_models.dart';
import 'package:gas_station_finder/features/stations/domain/entities/station.dart';

import '../../helpers/fake_community_repository.dart';
import '../../helpers/fake_garage_repository.dart';

final now = DateTime.utc(2026, 11, 25, 12);
const berlin = GeoPoint(latitude: 52.52, longitude: 13.405);
const station = Station(id: 's1', name: 'Aral Mitte', location: berlin, address: 'Main St 1');

CommunityPrice cp({String fuel = 'DIESEL', double price = 1.659, int reports = 3, Duration age = const Duration(hours: 2)}) =>
    CommunityPrice(
      fuelType: fuel,
      price: price,
      currencyCode: 'EUR',
      reportCount: reports,
      confidence: 0.8,
      lastReportAt: now.subtract(age),
      expiresAt: now.subtract(age).add(const Duration(hours: 72)),
    );

const diesel = VehicleProfile(
  id: 'v',
  name: 'Golf',
  energyType: EnergyType.fuel,
  consumptionPer100Km: 5.5,
  capacity: 50,
  preferredFuelType: 'DIESEL',
);

class _Location implements LocationService {
  @override
  Future<Result<GeoPoint>> currentPosition() async => const Ok(berlin);
  @override
  Future<bool> openAppSettings() async => true;
  @override
  Future<bool> openLocationSettings() async => true;
}

class _Google implements StationQuoteLookup {
  _Google(this.result);
  final Map<String, StationQuote> result;
  @override
  Future<Map<String, StationQuote>> quotes(List<String> stationIds, {String? fuelType}) async => result;
}

void main() {
  group('Firestore mapping', () {
    test('community price parses Timestamps and rejects incomplete docs', () {
      final p = parseCommunityPrice({
        'fuelType': 'DIESEL',
        'price': 1.659,
        'currency': 'EUR',
        'reportCount': 4,
        'confidence': 1.7, // clamped
        'lastReportAt': Timestamp.fromDate(now),
        'expiresAt': Timestamp.fromDate(now.add(const Duration(hours: 72))),
      })!;
      expect(p.price, 1.659);
      expect(p.reportCount, 4);
      expect(p.confidence, 1.0);
      expect(p.lastReportAt.isAtSameMomentAs(now), isTrue);
      expect(parseCommunityPrice({'fuelType': 'DIESEL', 'price': 1.6, 'currency': 'EUR'}), isNull);
      expect(parseCommunityPrice({'fuelType': 'DIESEL', 'price': 'x', 'currency': 'EUR', 'lastReportAt': now, 'expiresAt': now}),
          isNull);
    });

    test('history day + reliability defaults', () {
      final h = parseHistoryDay({'day': '2026-11-24', 'fuelType': 'DIESEL', 'currency': 'EUR', 'close': 1.7})!;
      expect(h.day, DateTime.utc(2026, 11, 24));
      expect((h.min, h.max, h.samples), (1.7, 1.7, 1));
      expect(parseHistoryDay({'day': 'nope', 'fuelType': 'DIESEL', 'currency': 'EUR', 'close': 1.7}), isNull);

      final r = parseReliability({'reliability': null, 'openVotes': 2});
      expect(r.score, isNull, reason: 'unknown must stay unknown');
      expect((r.openVotes, r.closedVotes), (2, 0));
      expect(reliabilityLabel(null), 'Not enough community data');
      expect(reliabilityLabel(0.9), contains('confirmed'));
      expect(reliabilityLabel(0.3), contains('old or disagree'));
    });

    test('alert rule round-trips and only writes keys the rules allow', () {
      const rule = PriceAlertRule(
        id: 'a1', fuelType: 'DIESEL', currencyCode: 'EUR', maxPrice: 1.6, center: berlin, radiusKm: 10, //
      );
      final map = alertRuleToMap(rule, 'u1');
      const allowed = {
        'fuelType', 'currency', 'maxPrice', 'lat', 'lng', 'radiusKm', 'enabled', 'stationId', 'stationName', 'uid', //
      };
      expect(allowed.containsAll(map.keys), isTrue);
      expect(map['uid'], 'u1');
      expect(map.containsKey('stationId'), isFalse);
      expect(parseAlertRule('a1', map), rule);
    });

    test('dayKey is UTC', () {
      expect(dayKey(DateTime.utc(2026, 11, 25, 23, 30)), '2026-11-25');
    });

    test('Firebase errors map to user-facing failures', () {
      expect(mapFirebaseError(FirebaseException(plugin: 'cloud_firestore', code: 'permission-denied')),
          isA<ServerFailure>());
      expect(mapFirebaseError(FirebaseException(plugin: 'cloud_firestore', code: 'unavailable')), isA<NetworkFailure>());
      expect(mapFirebaseError(FirebaseAuthException(code: 'operation-not-allowed')), isA<ConfigFailure>());
      expect(mapFirebaseError(StateError('boom')), isA<UnknownFailure>());
    });
  });

  group('validation + defaults', () {
    test('report price bounds mirror the security rules', () {
      expect(validateReportPrice('1,659'), isNull);
      expect(validateReportPrice('0'), isNotNull);
      expect(validateReportPrice('1000.5'), isNotNull);
      expect(validateReportPrice(''), isNotNull);
    });

    test('server verdicts become plain messages', () {
      expect(reportStatusMessage('accepted', null), startsWith('Thanks'));
      expect(reportStatusMessage('rejected', 'outlier'), contains('far from other'));
      expect(reportStatusMessage(null, null), contains('checked'));
    });

    test('default fuel follows the vehicle; currency is never guessed', () {
      expect(defaultReportFuel(null), 'REGULAR_UNLEADED');
      expect(defaultReportFuel(diesel), 'DIESEL');
      expect(defaultReportFuel(diesel.copyWith(energyType: EnergyType.electric)), 'EV_KWH');
      expect(defaultReportFuel(diesel.copyWith(preferredFuelType: 'SP95_E10')), 'REGULAR_UNLEADED');
      expect(defaultReportCurrency(null, null), '');
      expect(defaultReportCurrency(null, [cp()]), 'EUR');
    });

    test('FIREBASE_MODE parsing defaults to off', () {
      expect(FirebaseMode.parse('emulator'), FirebaseMode.emulator);
      expect(FirebaseMode.parse(' Project '), FirebaseMode.project);
      expect(FirebaseMode.parse(''), FirebaseMode.off);
      expect(const AppConfig(googleMapsApiKey: '', osrmBaseUrl: '').firebaseMode, FirebaseMode.off);
    });
  });

  test('Firebase option format guards (native iOS SDK aborts on bad values)', () {
    expect(isPlausibleFirebaseApiKey(kEmulatorPlaceholderApiKey), isTrue);
    expect(isPlausibleFirebaseApiKey('demo-key'), isFalse);
    expect(isPlausibleFirebaseAppId('1:123456789012:ios:0000000000000000'), isTrue);
    expect(isPlausibleFirebaseAppId('my-app'), isFalse);
  });

  group('CombinedQuoteLookup', () {
    const googlePrice = FuelPrice(fuelType: 'DIESEL', amount: 1.7, currencyCode: 'EUR');

    test('Google price wins; community only fills gaps', () {
      final q = CombinedQuoteLookup.merge(
        const StationQuote(price: googlePrice, openNow: true, priceSource: PriceSource.google),
        [cp(price: 1.5)],
        const StationReliability(score: 0.8),
        'DIESEL',
        now,
      )!;
      expect(q.price!.amount, 1.7);
      expect(q.priceSource, PriceSource.google);
      expect(q.reliability, 0.8);
      expect(q.openNow, isTrue);

      final filled = CombinedQuoteLookup.merge(const StationQuote(openNow: false), [cp()], null, 'DIESEL', now)!;
      expect(filled.price!.amount, 1.659);
      expect(filled.priceSource, PriceSource.community);
      expect(filled.price!.updatedAt, now.subtract(const Duration(hours: 2)));
    });

    test('stale or other-fuel community prices are never used', () {
      final stale = CombinedQuoteLookup.merge(null, [cp(age: const Duration(hours: 80))], null, 'DIESEL', now);
      expect(stale, isNull);
      final other = CombinedQuoteLookup.merge(null, [cp(fuel: 'PREMIUM')], null, 'DIESEL', now);
      expect(other, isNull);
    });

    test('end to end with a repository; unavailable backend = Google only', () async {
      final google = _Google({'s2': const StationQuote(price: googlePrice, priceSource: PriceSource.google)});
      final repo = FakeCommunityRepository(
        prices: {'s1': [cp()]},
        reliability: {'s1': const StationReliability(score: 0.6)},
      );
      final combined = CombinedQuoteLookup(google, repo, clock: () => now);
      final q = await combined.quotes(['s1', 's2', 's3'], fuelType: 'DIESEL');
      expect(q.keys, unorderedEquals(['s1', 's2']));
      expect(q['s1']!.priceSource, PriceSource.community);
      expect(q['s1']!.reliability, 0.6);

      final off = CombinedQuoteLookup(google, const UnavailableCommunityRepository(), clock: () => now);
      expect((await off.quotes(['s1', 's2'], fuelType: 'DIESEL')).keys, ['s2']);
    });

    test('EV planning (no fuel type) uses the per-kWh community price', () async {
      final repo = FakeCommunityRepository(prices: {'c1': [cp(fuel: 'EV_KWH', price: 0.49)]});
      final q = await CombinedQuoteLookup(_Google({}), repo, clock: () => now).quotes(['c1']);
      expect(q['c1']!.price!.amount, 0.49);
    });
  });

  group('UI', () {
    late FakeCommunityRepository repo;

    Future<void> pump(WidgetTester tester, Widget child, {CommunityRepository? backend}) async {
      tester.view.physicalSize = const Size(1200, 2400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(ProviderScope(
        retry: (_, _) => null,
        overrides: [
          communityRepositoryProvider.overrideWithValue(backend ?? repo),
          nowProvider.overrideWithValue(() => now),
          garageRepositoryProvider.overrideWithValue(FakeGarageRepository([diesel])),
          locationServiceProvider.overrideWithValue(_Location()),
        ],
        child: MaterialApp(theme: AppTheme.light(), home: child),
      ));
      await tester.pumpAndSettle();
    }

    testWidgets('community prices, history toggle (7 → 30 days) and votes', (tester) async {
      repo = FakeCommunityRepository(
        prices: {'s1': [cp(), cp(fuel: 'PREMIUM', price: 1.899, reports: 1, age: const Duration(hours: 90))]},
        reliability: {'s1': const StationReliability(score: 0.82, openVotes: 3, closedVotes: 1)},
        history: [
          PriceHistoryDay(day: DateTime.utc(2026, 11, 23), fuelType: 'DIESEL', currencyCode: 'EUR', close: 1.70, min: 1.68, max: 1.72, samples: 3),
          PriceHistoryDay(day: DateTime.utc(2026, 11, 25), fuelType: 'DIESEL', currencyCode: 'EUR', close: 1.66, min: 1.65, max: 1.69, samples: 2),
        ],
      );
      await pump(tester, const Scaffold(body: SingleChildScrollView(child: CommunitySection(station: station))));

      expect(find.text('EUR 1.659'), findsOneWidget);
      expect(find.textContaining('3 reports'), findsOneWidget);
      expect(find.textContaining('outdated'), findsOneWidget, reason: 'expired price is flagged, not hidden');
      expect(find.text('Recently confirmed by the community'), findsOneWidget);
      expect(find.text('82%'), findsOneWidget);
      expect(find.textContaining('3 said open · 1 said closed'), findsOneWidget);
      expect(find.textContaining('not an official check'), findsOneWidget);

      await tester.tap(find.text('Diesel'));
      await tester.pumpAndSettle();
      expect(find.byType(LineChart), findsOneWidget);
      expect(repo.historyRequests.last.days, 7);
      await tester.tap(find.text('30 days'));
      await tester.pumpAndSettle();
      expect(repo.historyRequests.last, (stationId: 's1', fuelType: 'DIESEL', days: 30));

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(repo.votes['s1'], const StationVote(open: true));
      await tester.tap(find.text('Out of fuel'));
      await tester.pumpAndSettle();
      expect(repo.votes['s1'], const StationVote(open: true, fuelAvailable: false));
      expect(find.text('Thanks for confirming!'), findsOneWidget);
    });

    testWidgets('vote failure shows the failure message', (tester) async {
      repo = FakeCommunityRepository(failWrites: const NetworkFailure());
      await pump(tester, const Scaffold(body: SingleChildScrollView(child: CommunitySection(station: station))));
      expect(find.textContaining('No community reports yet'), findsOneWidget);
      expect(find.text('Not enough community data'), findsOneWidget);
      await tester.tap(find.text('Closed'));
      await tester.pumpAndSettle();
      expect(find.textContaining('No internet connection'), findsOneWidget);
    });

    testWidgets('backend off → hint, no report button', (tester) async {
      repo = FakeCommunityRepository();
      await pump(
        tester,
        const Scaffold(body: CommunitySection(station: station)),
        backend: const UnavailableCommunityRepository(),
      );
      expect(find.text('Community prices are turned off in this build.'), findsOneWidget);
      expect(find.text('Report price'), findsNothing);
    });

    testWidgets('report price: validates, submits draft, shows server verdict', (tester) async {
      repo = FakeCommunityRepository(prices: {'s1': [cp()]});
      await pump(tester, const ReportPriceScreen(station: station));

      expect(find.text('Diesel'), findsOneWidget, reason: 'fuel defaults to the active vehicle');
      expect(tester.widget<EditableText>(find.descendant(of: find.byKey(const Key('currency')), matching: find.byType(EditableText))).controller.text, 'EUR', reason: 'currency from existing prices');
      await tester.tap(find.text('Send report'));
      await tester.pumpAndSettle();
      expect(find.text('Enter a price'), findsOneWidget);
      expect(repo.reports, isEmpty);

      await tester.enterText(find.byKey(const Key('price')), '1,649');
      await tester.tap(find.text('Send report'));
      await tester.pumpAndSettle();
      final d = repo.reports.single;
      expect((d.stationId, d.fuelType, d.price, d.currencyCode), ('s1', 'DIESEL', 1.649, 'EUR'));
      expect(d.stationLocation, berlin);
      expect(find.textContaining('Thanks! Your price'), findsOneWidget);
    });

    testWidgets('report price: outlier verdict is explained', (tester) async {
      repo = FakeCommunityRepository(verdict: (status: 'rejected', reason: 'outlier'));
      await pump(tester, const ReportPriceScreen(station: station));
      await tester.enterText(find.byKey(const Key('price')), '2.5');
      await tester.enterText(find.byKey(const Key('currency')), 'eur');
      await tester.tap(find.text('Send report'));
      await tester.pumpAndSettle();
      expect(repo.reports.single.currencyCode, 'EUR');
      expect(find.textContaining('far from other recent reports'), findsOneWidget);
    });

    testWidgets('alerts: create around current location, pause, delete', (tester) async {
      repo = FakeCommunityRepository();
      await pump(tester, const AlertsScreen());
      expect(find.text('No price alerts yet'), findsOneWidget);

      await tester.tap(find.text('New alert'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('maxPrice')), '1.6');
      await tester.enterText(find.byKey(const Key('alertCurrency')), 'EUR');
      await tester.tap(find.text('Save alert'));
      await tester.pumpAndSettle();

      final rule = repo.rules.single;
      expect((rule.fuelType, rule.maxPrice, rule.currencyCode, rule.radiusKm), ('DIESEL', 1.6, 'EUR', 10.0));
      expect(rule.center, berlin);
      expect(find.text('Diesel ≤ EUR 1.60'), findsOneWidget);
      expect(find.textContaining('Push notifications are not enabled'), findsOneWidget);

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(repo.rules.single.enabled, isFalse);
      await tester.tap(find.byTooltip('Delete alert'));
      await tester.pumpAndSettle();
      expect(repo.rules, isEmpty);
    });

    testWidgets('alerts: backend off → explanation, no create button', (tester) async {
      repo = FakeCommunityRepository();
      await pump(
        tester,
        const AlertsScreen(),
        backend: const UnavailableCommunityRepository(),
      );
      expect(find.text('Alerts are not available'), findsOneWidget);
      expect(find.text('New alert'), findsNothing);
    });
  });

  test('UnavailableCommunityRepository never fakes data', () async {
    const r = UnavailableCommunityRepository('off');
    expect(await r.watchPrices('x').first, isEmpty);
    final res = await r.submitReport(const PriceReportDraft(
      stationId: 'x', stationLocation: berlin, fuelType: 'DIESEL', price: 1, currencyCode: 'EUR', //
    ));
    expect(res, isA<Err<String>>());
    expect((res as Err).failure, isA<ConfigFailure>());
  });

}
