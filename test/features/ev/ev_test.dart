import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gas_station_finder/core/error/app_failure.dart';
import 'package:gas_station_finder/core/error/result.dart';
import 'package:gas_station_finder/core/location/geo_point.dart';
import 'package:gas_station_finder/core/theme/app_theme.dart';
import 'package:gas_station_finder/features/ev/data/open_charge_map_repository.dart';
import 'package:gas_station_finder/core/location/location_service.dart';
import 'package:gas_station_finder/features/ev/domain/charge_point.dart';
import 'package:gas_station_finder/features/ev/domain/charge_points_repository.dart';
import 'package:gas_station_finder/features/stations/data/stations_providers.dart';
import 'package:gas_station_finder/features/ev/presentation/ev_providers.dart';
import 'package:gas_station_finder/features/ev/presentation/widgets/charge_point_sheet.dart';
import 'package:gas_station_finder/features/ev/presentation/widgets/ev_filter_sheet.dart';
import 'package:gas_station_finder/features/ev/presentation/widgets/marker_icons.dart';
import 'package:gas_station_finder/features/garage/data/drift_garage_repository.dart';
import 'package:gas_station_finder/features/garage/domain/vehicle_profile.dart';
import 'package:gas_station_finder/features/stations/domain/entities/station.dart';
import 'package:gas_station_finder/features/stations/presentation/map_screen.dart';

import '../../helpers/fake_garage_repository.dart';
import '../along_route/along_route_fakes.dart' show CountingStations;

List<ChargePoint> fixture() =>
    OpenChargeMapRepository.parse(jsonDecode(File('test/fixtures/ocm_poi_berlin.json').readAsStringSync()));

void main() {
  group('Open Charge Map parsing', () {
    test('maps fields, skips invalid and duplicate entries', () {
      final points = fixture();
      expect(points.map((p) => p.id), ['ocm:101', 'ocm:102', 'ocm:103']);
      final hbf = points.first;
      expect(hbf.name, 'Hauptbahnhof Nord');
      expect(hbf.address, 'Europaplatz 1, Berlin, 10557');
      expect(hbf.operatorName, 'Allego');
      expect(hbf.usageCost, '0,59 €/kWh');
      expect(hbf.isOperational, isTrue);
      expect(hbf.numberOfPoints, 3);
      expect(hbf.lastVerified, DateTime.utc(2026, 11, 20, 9));
      expect(
        hbf.connectors.first,
        const ChargeConnector(type: 'CCS (Type 2)', powerKw: 150, quantity: 2, isDc: true, isOperational: true),
      );
      expect(hbf.connectors.last.isDc, isFalse);
      expect(hbf.maxPowerKw, 150);
      expect(hbf.isFast, isTrue);
    });

    test('unknown connector types and status stay unknown', () {
      final kit = fixture()[2];
      expect(kit.isOperational, isNull);
      expect(kit.connectors.single.type, 'Connector 999');
      expect(kit.maxPowerKw, isNull);
      expect(chargeMarkerLabel(kit), 'EV');
      expect(() => OpenChargeMapRepository.parse({'error': 'x'}), throwsFormatException);
    });

    test('missing key → ConfigFailure, no request sent', () async {
      final dio = Dio()..interceptors.add(InterceptorsWrapper(onRequest: (o, h) => fail('no request expected')));
      final r = await OpenChargeMapRepository(dio, hasApiKey: false).nearby(const GeoPoint(latitude: 0, longitude: 0));
      expect((r as Err).failure, isA<ConfigFailure>());
    });

    test('sends documented query parameters', () async {
      late RequestOptions sent;
      final dio = Dio(BaseOptions(baseUrl: 'https://api.openchargemap.io/v3'))
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (o, h) {
              sent = o;
              h.resolve(Response(requestOptions: o, statusCode: 200, data: const []));
            },
          ),
        );
      final r = await OpenChargeMapRepository(
        dio,
        hasApiKey: true,
      ).nearby(const GeoPoint(latitude: 52.52, longitude: 13.4), radiusKm: 5);
      expect(r.getOrThrow(), isEmpty);
      expect(sent.path, '/poi');
      expect(sent.queryParameters, containsPair('distance', 5.0));
      expect(sent.queryParameters, containsPair('distanceunit', 'KM'));
      expect(sent.queryParameters, containsPair('compact', false));
    });
  });

  group('EvFilter', () {
    final points = fixture();
    test('power, connector and operational filters', () {
      expect(const EvFilter().apply(points), hasLength(3));
      expect(const EvFilter(minPowerKw: 50).apply(points).map((p) => p.id), ['ocm:101']);
      expect(const EvFilter(minPowerKw: 11).apply(points).map((p) => p.id), ['ocm:101', 'ocm:102']);
      expect(const EvFilter(connectorTypes: {'Type 2 (Socket Only)'}).apply(points).map((p) => p.id), [
        'ocm:101',
        'ocm:102',
      ]);
      // Combined: needs ONE connector that is both Type 2 and ≥ 50 kW → none.
      expect(const EvFilter(connectorTypes: {'Type 2 (Socket Only)'}, minPowerKw: 50).apply(points), isEmpty);
      expect(const EvFilter(operationalOnly: true).apply(points).map((p) => p.id), ['ocm:101']);
      expect(const EvFilter().isActive, isFalse);
    });

    test('labels and connector list', () {
      expect(chargeMarkerLabel(points[1]), '11 kW');
      expect(
        chargeMarkerLabel(
          const ChargePoint(
            id: 'x',
            name: 'x',
            location: GeoPoint(latitude: 0, longitude: 0),
            connectors: [ChargeConnector(type: 'Schuko', powerKw: 3.7)],
          ),
        ),
        '3.7 kW',
      );
      expect(connectorTypesOf(points), ['CCS (Type 2)', 'Connector 999', 'Type 2 (Socket Only)']);
      expect(powerStepLabel(0), 'Any');
      expect(powerStepLabel(50), '≥ 50 kW');
    });

    test('status banner text', () {
      expect(evStatus(AsyncData(points), filtered: false).text, '3 chargers nearby');
      expect(evStatus(const AsyncData([]), filtered: true).text, 'No chargers match your filters.');
      final noKey = evStatus(AsyncError(const ConfigFailure('no key'), StackTrace.empty), filtered: false);
      expect((noKey.text, noKey.showRetry), ('no key', false));
      expect(evStatus(AsyncError(const NetworkFailure(), StackTrace.empty), filtered: false).showRetry, isTrue);
    });
  });

  group('map mode', () {
    const ev = VehicleProfile(
      id: 'e',
      name: 'Leaf',
      energyType: EnergyType.electric,
      consumptionPer100Km: 17,
      capacity: 39,
    );
    test('defaults to the active vehicle type and can be switched', () async {
      final container = ProviderContainer(
        overrides: [
          garageRepositoryProvider.overrideWithValue(FakeGarageRepository([ev])),
        ],
      );
      addTearDown(container.dispose);
      container.listen(mapModeProvider, (_, _) {});
      expect(container.read(mapModeProvider), MapMode.fuel); // vehicle stream not loaded yet
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(container.read(mapModeProvider), MapMode.ev);
      container.read(mapModeProvider.notifier).set(MapMode.fuel);
      expect(container.read(mapModeProvider), MapMode.fuel);
    });
  });

  group('widgets', () {
    testWidgets('pill marker icons render to PNG and are cached', (tester) async {
      final icons = PillMarkerIcons();
      await tester.runAsync(() async {
        final a = await icons.get('150 kW', background: Colors.teal, foreground: Colors.white, dpr: 3);
        final b = await icons.get('150 kW', background: Colors.teal, foreground: Colors.white, dpr: 3);
        expect(identical(a, b), isTrue);
        final json = a.toJson() as List;
        expect(json.first, 'bytes');
        final png = (json[1] as Map)['byteData'] as List<int>;
        expect(png.sublist(1, 4), 'PNG'.codeUnits);
      });
    });


    testWidgets('charge point sheet shows connectors, cost caveat and attribution', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: ChargePointSheet(point: fixture().first, onDirections: () {}, now: DateTime.utc(2026, 11, 25, 9)),
          ),
        ),
      );
      expect(find.text('Operational'), findsOneWidget);
      expect(find.text('Up to 150 kW · fast'), findsOneWidget);
      expect(find.text('150 kW · DC · ×2'), findsOneWidget);
      expect(find.text('22 kW · AC · ×1'), findsOneWidget);
      expect(find.textContaining('not verified by FuelWise'), findsOneWidget);
      expect(find.textContaining('Last verified 5 d ago'), findsOneWidget);
      await tester.scrollUntilVisible(find.text(kOcmAttribution), 100);
      expect(find.text(kOcmAttribution), findsOneWidget);
    });

    testWidgets('unknown status and missing cost are said plainly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChargePointSheet(point: fixture()[2], onDirections: () {}),
          ),
        ),
      );
      expect(find.text('Status unknown'), findsOneWidget);
      expect(find.textContaining('No cost information reported'), findsOneWidget);
    });

    testWidgets('filter sheet updates the shared filter', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(body: EvFilterSheet(availableConnectors: connectorTypesOf(fixture()))),
          ),
        ),
      );
      for (final label in ['≥ 50 kW', 'CCS (Type 2)', 'Only operational']) {
        await tester.tap(find.text(label));
        await tester.pumpAndSettle();
      }
      expect(
        container.read(evFilterProvider),
        const EvFilter(minPowerKw: 50, connectorTypes: {'CCS (Type 2)'}, operationalOnly: true),
      );
      await tester.tap(find.text('Reset'));
      await tester.pumpAndSettle();
      expect(container.read(evFilterProvider), const EvFilter());
    });
  });

  testWidgets('map: switching to EV loads chargers once, fuel search is not repeated', (tester) async {
    final chargers = _FakeChargers();
    final stations = _NearbyCounter();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          garageRepositoryProvider.overrideWithValue(FakeGarageRepository()),
          locationServiceProvider.overrideWithValue(_Here()),
          chargePointsRepositoryProvider.overrideWithValue(chargers),
          stationsRepositoryProvider.overrideWithValue(stations),
        ],
        child: MaterialApp(theme: AppTheme.light(), home: const MapScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('No fuel stations within 5 km.'), findsOneWidget);
    expect(chargers.calls, 0);

    await tester.tap(find.text('EV'));
    await tester.pumpAndSettle();
    expect(find.text('3 chargers nearby'), findsOneWidget);
    expect(find.text(kOcmAttribution), findsOneWidget);
    expect(chargers.calls, 1);
    expect(stations.nearbyCalls, 1);

    await tester.tap(find.byTooltip('Charger filters'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('≥ 50 kW'));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(10, 10)); // dismiss sheet
    await tester.pumpAndSettle();
    expect(find.text('1 charger nearby (filtered)'), findsOneWidget);
    expect(chargers.calls, 1); // filtering is local
  });
}

class _Here implements LocationService {
  @override
  Future<Result<GeoPoint>> currentPosition() async => const Ok(GeoPoint(latitude: 52.52, longitude: 13.4));
  @override
  Future<bool> openAppSettings() async => true;
  @override
  Future<bool> openLocationSettings() async => true;
}

class _FakeChargers implements ChargePointsRepository {
  int calls = 0;
  @override
  Future<Result<List<ChargePoint>>> nearby(GeoPoint center, {double radiusKm = 10, int maxResults = 100}) async {
    calls++;
    return Ok(fixture());
  }
}

class _NearbyCounter extends CountingStations {
  int nearbyCalls = 0;
  @override
  Future<Result<List<Station>>> nearbyStations(GeoPoint center, {double radiusMeters = 5000}) {
    nearbyCalls++;
    return super.nearbyStations(center, radiusMeters: radiusMeters);
  }
}
