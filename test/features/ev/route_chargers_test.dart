import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gas_station_finder/core/error/app_failure.dart';
import 'package:gas_station_finder/core/error/result.dart';
import 'package:gas_station_finder/core/location/geo_point.dart';
import 'package:gas_station_finder/core/location/location_service.dart';
import 'package:gas_station_finder/core/router/app_router.dart';
import 'package:gas_station_finder/core/theme/app_theme.dart';
import 'package:gas_station_finder/features/along_route/domain/along_route_models.dart';
import 'package:gas_station_finder/features/along_route/domain/route_geometry.dart';
import 'package:gas_station_finder/features/along_route/presentation/along_route_providers.dart';
import 'package:gas_station_finder/features/ev/data/open_charge_map_repository.dart';
import 'package:gas_station_finder/features/ev/domain/charge_point.dart';
import 'package:gas_station_finder/features/ev/domain/charge_points_repository.dart';
import 'package:gas_station_finder/features/ev/domain/route_chargers.dart';
import 'package:gas_station_finder/features/garage/data/drift_garage_repository.dart';
import 'package:gas_station_finder/features/history/data/drift_fill_up_repository.dart';
import 'package:gas_station_finder/features/garage/domain/vehicle_profile.dart';
import 'package:gas_station_finder/l10n/app_localizations.dart';

import '../../helpers/fake_fill_up_repository.dart';
import '../../helpers/fake_garage_repository.dart';
import '../along_route/along_route_fakes.dart';

/// Answers each radius search with the fixtures inside that circle, so the
/// test exercises the real coverage + corridor logic.
class _CircleChargers implements ChargePointsRepository {
  _CircleChargers(this.all, {this.failFirst = 0, this.failAll = false});

  final List<ChargePoint> all;
  final int failFirst;
  final bool failAll;
  final calls = <(GeoPoint, double)>[];

  @override
  Future<Result<List<ChargePoint>>> nearby(GeoPoint center, {double radiusKm = 10, int maxResults = 100}) async {
    calls.add((center, radiusKm));
    if (failAll || calls.length <= failFirst) {
      return const Err(NetworkFailure());
    }
    return Ok([
      for (final p in all)
        if (p.location.distanceTo(center) <= radiusKm * 1000) p,
    ]);
  }
}

ChargePoint cp(String id, double lat, double lng, {double? kw, bool? ok}) => ChargePoint(
  id: 'ocm:$id',
  name: 'Charger $id',
  location: GeoPoint(latitude: lat, longitude: lng),
  connectors: [ChargeConnector(type: 'CCS2', powerKw: kw)],
  isOperational: ok,
);

// straightRoute: ~20 km east along latitude 52.5.
final near1 = cp('1', 52.503, 13.25, kw: 60, ok: true); // ~330 m off, ~17 km along
final near2 = cp('2', 52.47, 13.05, kw: 22, ok: false); // ~3.3 km off, ~3.4 km along
final far = cp('3', 52.56, 13.15); // ~6.7 km off → outside the corridor

const ev = VehicleProfile(
  id: 'ev',
  name: 'Atto 3',
  energyType: EnergyType.electric,
  consumptionPer100Km: 16,
  capacity: 60,
);

class _Location implements LocationService {
  @override
  Future<Result<GeoPoint>> currentPosition() async => Ok(straightRoute.first);
  @override
  Future<bool> openAppSettings() async => true;
  @override
  Future<bool> openLocationSettings() async => true;
}

class _FixedPlan extends AlongRouteController {
  _FixedPlan(this.fixed);
  final AlongRoutePlan fixed;
  @override
  AlongRoutePlan? build() => fixed;
}

void main() {
  group('circles', () {
    test('cover the whole corridor, capped at maxQueries', () {
      final line = [for (var i = 0; i <= 300; i++) GeoPoint(latitude: 23.8, longitude: 90.0 + i * 0.01)]; // ~305 km
      final cs = RouteChargerFinder.circles(line);
      expect(cs, hasLength(RouteChargerFinder.defaultMaxQueries));
      expect(cs.first.center, line.first);
      expect(cs.last.center.distanceTo(line.last), lessThan(1));
      // Every point 5 km either side of the route is inside some circle.
      for (var i = 0; i <= 300; i += 5) {
        for (final dLat in [-0.0449, 0.0449]) {
          final p = GeoPoint(latitude: 23.8 + dLat, longitude: 90.0 + i * 0.01);
          expect(cs.any((c) => c.center.distanceTo(p) <= c.radiusKm * 1000), isTrue, reason: 'gap at $i');
        }
      }
    });

    test('short route → one circle; spacing near 20 km on medium routes; empty line → none', () {
      final short = [straightRoute.first, straightRoute[5]];
      expect(RouteChargerFinder.circles(short), hasLength(2));
      expect(RouteChargerFinder.circles([straightRoute.first]), hasLength(1));
      expect(RouteChargerFinder.circles(const []), isEmpty);
      final cs = RouteChargerFinder.circles(straightRoute);
      expect(cs, hasLength((RouteGeometry.length(straightRoute) / 20000).ceil() + 1));
    });
  });

  group('find', () {
    test('keeps chargers inside 5 km, de-duplicated and ordered along the route', () async {
      final repo = _CircleChargers([near1, near2, far]);
      final r = (await RouteChargerFinder(repo).find(straightRoute)) as Ok<RouteChargersResult>;
      expect(r.value.chargers.map((c) => c.point.id), ['ocm:2', 'ocm:1']);
      expect(r.value.partial, isFalse);
      expect(r.value.queries, repo.calls.length);
      expect(r.value.chargers.first.offRouteMeters, closeTo(3340, 100));
      expect(r.value.chargers.last.alongMeters, closeTo(16950, 200));
    });

    test('some searches fail → partial results; all fail → the failure', () async {
      final partial = (await RouteChargerFinder(
        _CircleChargers([near1, near2], failFirst: 1),
      ).find(straightRoute)) as Ok<RouteChargersResult>;
      expect(partial.value.partial, isTrue);
      expect(partial.value.chargers.map((c) => c.point.id), contains('ocm:1'));

      final all = await RouteChargerFinder(_CircleChargers([near1], failAll: true)).find(straightRoute);
      expect((all as Err).failure.code, FailureCode.network);
    });

    test('empty route makes no request', () async {
      final repo = _CircleChargers([near1]);
      final r = (await RouteChargerFinder(repo).find(const [])) as Ok<RouteChargersResult>;
      expect(r.value.chargers, isEmpty);
      expect(repo.calls, isEmpty);
    });
  });

  group('along-route screen', () {
    Future<_CircleChargers> pump(
      WidgetTester tester, {
      VehicleProfile vehicle = ev,
      ChargePointsRepository? repo,
      Locale locale = const Locale('en'),
      double textScale = 1,
    }) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.5;
      addTearDown(tester.view.reset);
      final chargers = _CircleChargers([near1, near2, far]);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            mapsEnabledProvider.overrideWithValue(false),
            garageRepositoryProvider.overrideWithValue(FakeGarageRepository([vehicle])),
            fillUpRepositoryProvider.overrideWithValue(FakeFillUpRepository()),
            locationServiceProvider.overrideWithValue(_Location()),
            nowProvider.overrideWithValue(() => DateTime(2026, 11, 25)),
            alongRouteControllerProvider.overrideWith(() => _FixedPlan(widgetPlan.copyWith(fuelType: null))),
            chargePointsRepositoryProvider.overrideWithValue(repo ?? chargers),
          ],
          retry: (_, _) => null,
          child: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
            child: MaterialApp.router(
              theme: AppTheme.light(),
              locale: locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              routerConfig: buildRouter(initialLocation: AppRoutes.planRoute),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      return chargers;
    }

    Future<void> scrollTo(WidgetTester tester, Finder f) async {
      await tester.dragUntilVisible(f, find.byType(ListView).first, const Offset(0, -300));
      await tester.pumpAndSettle();
    }

    testWidgets('EV trip lists chargers on the route with position, power and status', (tester) async {
      await pump(tester);
      await scrollTo(tester, find.byKey(const ValueKey('routeCharger-ocm:1')));
      expect(find.text('Chargers on this route'), findsOneWidget);
      expect(find.text('Charger 2'), findsOneWidget);
      expect(find.text('Charger 3'), findsNothing);
      expect(find.textContaining('up to 60 kW · Operational'), findsOneWidget);
      expect(find.textContaining('up to 22 kW · Not operational'), findsOneWidget);
      expect(find.textContaining('off the route'), findsNWidgets(2));
      double y(String t) => tester.getTopLeft(find.text(t)).dy;
      expect(y('Charger 2'), lessThan(y('Charger 1')));
    });

    testWidgets('fuel vehicle: no section and no charger requests', (tester) async {
      final repo = await pump(tester, vehicle: car);
      expect(find.byKey(const Key('routeChargers')), findsNothing);
      expect(repo.calls, isEmpty);
    });

    testWidgets('missing OCM key → explained, not an empty list', (tester) async {
      await pump(tester, repo: _Failing(const ConfigFailure('no key', code: FailureCode.missingOcmKey)));
      await scrollTo(tester, find.byKey(const Key('routeChargersError')));
      expect(find.byKey(const Key('routeChargersNone')), findsNothing);
    });

    testWidgets('Bengali at 200 % text: charger list meets guidelines', (tester) async {
      final handle = tester.ensureSemantics();
      await pump(tester, locale: const Locale('bn'), textScale: 2);
      final bn = lookupAppLocalizations(const Locale('bn'));
      await scrollTo(tester, find.byKey(const ValueKey('routeCharger-ocm:1')));
      expect(find.text(bn.routeChargersTitle), findsOneWidget);
      expect(tester.takeException(), isNull);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      handle.dispose();
    });
  });
}

class _Failing implements ChargePointsRepository {
  _Failing(this.failure);
  final AppFailure failure;
  @override
  Future<Result<List<ChargePoint>>> nearby(GeoPoint center, {double radiusKm = 10, int maxResults = 100}) async =>
      Err(failure);
}
