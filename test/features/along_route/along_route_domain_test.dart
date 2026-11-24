import 'package:flutter_test/flutter_test.dart';
import 'package:gas_station_finder/core/error/app_failure.dart';
import 'package:gas_station_finder/core/error/result.dart';
import 'package:gas_station_finder/core/location/geo_point.dart';
import 'package:gas_station_finder/features/along_route/data/places_place_search_repository.dart';
import 'package:gas_station_finder/features/along_route/data/places_quote_lookup.dart';
import 'package:gas_station_finder/features/along_route/domain/along_route_models.dart';
import 'package:gas_station_finder/features/along_route/domain/along_route_planner.dart';
import 'package:gas_station_finder/features/along_route/domain/route_geometry.dart';
import 'package:gas_station_finder/features/along_route/presentation/along_route_providers.dart';
import 'package:gas_station_finder/features/along_route/presentation/ranking_explanation.dart';
import 'package:gas_station_finder/features/garage/domain/vehicle_profile.dart';
import 'package:gas_station_finder/features/ranking/domain/ranking_models.dart';
import 'package:gas_station_finder/features/ranking/domain/trip_cost_engine.dart';
import 'package:gas_station_finder/features/route/data/osrm_route_repository.dart';

import 'along_route_fakes.dart';

void main() {
  group('RouteGeometry', () {
    test('project gives off-route and along distances', () {
      final p = RouteGeometry.project(const GeoPoint(latitude: 52.5027, longitude: 13.1), straightRoute);
      expect(p.offRouteMeters, closeTo(300, 3));
      expect(
        p.alongMeters,
        closeTo(
          const GeoPoint(latitude: 52.5, longitude: 13.0).distanceTo(const GeoPoint(latitude: 52.5, longitude: 13.1)),
          5,
        ),
      );
    });

    test('simplify drops collinear points but keeps corners', () {
      expect(RouteGeometry.simplify(straightRoute, 10), [straightRoute.first, straightRoute.last]);
      const corner = [
        GeoPoint(latitude: 0, longitude: 0),
        GeoPoint(latitude: 0, longitude: 0.01),
        GeoPoint(latitude: 0.01, longitude: 0.01),
      ];
      expect(RouteGeometry.simplify(corner, 10), corner);
    });

    test('split keeps pieces under the limit and connected', () {
      final pieces = RouteGeometry.split(straightRoute, 5000);
      expect(pieces.length, greaterThanOrEqualTo(4));
      for (final p in pieces) {
        expect(RouteGeometry.length(p), lessThanOrEqualTo(5000));
      }
      for (var i = 1; i < pieces.length; i++) {
        expect(pieces[i].first, pieces[i - 1].last);
      }
      expect(pieces.first.first, straightRoute.first);
      expect(pieces.last.last, straightRoute.last);
    });

    test('encodePolyline matches Google reference example', () {
      expect(
        RouteGeometry.encodePolyline(const [
          GeoPoint(latitude: 38.5, longitude: -120.2),
          GeoPoint(latitude: 40.7, longitude: -120.95),
          GeoPoint(latitude: 43.252, longitude: -126.453),
        ]),
        '_p~iF~ps|U_ulLnnqC_mqNvxq`@',
      );
    });
  });

  group('OSRM table → detours', () {
    // Real response shape from router.project-osrm.org (Berlin, 2 stops).
    final live = {
      'code': 'Ok',
      'distances': [
        [1937.5, 2393.7, 1533.8],
        [1540.1, 0, 3491.3],
        [3983.9, 4244.4, 0],
      ],
      'durations': [
        [300.0, 360.0, 200.0],
        [250.0, 0, 400.0],
        [500.0, 520.0, 0],
      ],
    };

    test('detour = to + from − direct, clamped at 0', () {
      final d = OsrmRouteRepository.parseOsrmDetours(live, 2);
      expect(d[0]!.toStationMeters, 2393.7);
      expect(d[0]!.detourMeters, closeTo(2393.7 + 1540.1 - 1937.5, 1e-9));
      expect(d[0]!.detourSeconds, closeTo(360 + 250 - 300, 1e-9));
      expect(d[1]!.detourMeters, closeTo(1533.8 + 3983.9 - 1937.5, 1e-9));
    });

    test('unroutable stop → null entry; error code throws', () {
      final withNull = {
        'code': 'Ok',
        'distances': [
          [1000.0, null],
          [null, 0],
        ],
      };
      expect(OsrmRouteRepository.parseOsrmDetours(withNull, 1), [null]);
      expect(() => OsrmRouteRepository.parseOsrmDetours({'code': 'NoTable'}, 1), throwsA(isA<NotFoundFailure>()));
    });
  });

  group('Places parsing', () {
    test('autocomplete suggestions (query predictions ignored)', () {
      final s = PlacesPlaceSearchRepository.parseSuggestions({
        'suggestions': [
          {
            'placePrediction': {
              'placeId': 'p1',
              'text': {'text': 'Hamburg, Germany'},
              'structuredFormat': {
                'mainText': {'text': 'Hamburg'},
                'secondaryText': {'text': 'Germany'},
              },
            },
          },
          {
            'queryPrediction': {
              'text': {'text': 'hamburger'},
            },
          },
          {
            'placePrediction': {
              'placeId': 'p2',
              'text': {'text': 'Hamm'},
            },
          },
        ],
      });
      expect(s, const [
        PlaceSuggestion(placeId: 'p1', primaryText: 'Hamburg', secondaryText: 'Germany'),
        PlaceSuggestion(placeId: 'p2', primaryText: 'Hamm'),
      ]);
      expect(PlacesPlaceSearchRepository.parseSuggestions(const {}), isEmpty);
    });

    test('destination needs a location', () {
      final d = PlacesPlaceSearchRepository.parseDestination({
        'id': 'p1',
        'displayName': {'text': 'Hamburg'},
        'formattedAddress': 'Hamburg, Germany',
        'location': {'latitude': 53.55, 'longitude': 9.99},
      });
      expect(d.location, const GeoPoint(latitude: 53.55, longitude: 9.99));
      expect(d.name, 'Hamburg');
      expect(() => PlacesPlaceSearchRepository.parseDestination({'id': 'x'}), throwsFormatException);
    });

    test('missing key → ConfigFailure without network', () async {
      final repo = PlacesPlaceSearchRepository(UnusedRemote(), hasApiKey: false);
      expect((await repo.autocomplete('Ham', sessionToken: 't')), isA<Err<List<PlaceSuggestion>>>());
    });
  });

  group('PlacesQuoteLookup', () {
    test('exact fuel match only, open status, cached', () async {
      final stations = CountingStations();
      final lookup = PlacesQuoteLookup(stations);
      final q = await lookup.quotes(['s1', 'missing'], fuelType: 'DIESEL');
      expect(q['s1']!.price!.amount, 1.65);
      expect(q['s1']!.openNow, isTrue);
      expect(q.containsKey('missing'), isFalse);
      expect((await lookup.quotes(['s1'], fuelType: 'PREMIUM'))['s1']!.price, isNull);
      expect(stations.calls['s1'], 1); // second call served from cache
    });
  });

  group('AlongRoutePlanner', () {
    test('dedups, filters corridor, routes detours, quotes smallest detours', () async {
      final places = FakePlaces();
      final quotes = FakeQuotes();
      final planner = AlongRoutePlanner(
        routes: FakeRoutes(),
        detours: FakeDetours(),
        places: places,
        quotes: quotes,
        segmentMeters: 5000,
        maxSegments: 3,
        maxQuotedStops: 1,
      );
      final plan = (await planner.plan(
        origin: straightRoute.first,
        destination: dest,
        fuelType: 'DIESEL',
      )).getOrThrow();

      expect(places.calls, inInclusiveRange(1, 3)); // bounded by maxSegments
      expect(plan.stops.map((s) => s.station.id), ['a', 'c']); // b is 9 km off route; sorted along route
      final c = plan.stops.last;
      expect(c.detour!.detourMeters, 500); // closest to route got the first table slot
      expect(c.price!.amount, 1.70); // only the smallest detour was quoted
      expect(plan.stops.first.price, isNull);
      expect(quotes.requested, ['c']);
      expect(plan.fuelType, 'DIESEL');
      expect(plan.detoursApproximate, isFalse);
    });

    test('routing table failure → straight-line estimate, flagged', () async {
      final planner = AlongRoutePlanner(
        routes: FakeRoutes(),
        detours: FakeDetours(fail: true),
        places: FakePlaces(),
        quotes: FakeQuotes(),
      );
      final plan = (await planner.plan(origin: straightRoute.first, destination: dest)).getOrThrow();
      expect(plan.detoursApproximate, isTrue);
      final a = plan.stops.firstWhere((s) => s.station.id == 'a');
      expect(a.detour!.detourMeters, closeTo(2 * a.offRouteMeters, 1e-9));
    });

    test('search error with no results → Err; route error → Err', () async {
      final noPlaces = AlongRoutePlanner(
        routes: FakeRoutes(),
        detours: FakeDetours(),
        places: FakePlaces(error: const ServerFailure('denied', statusCode: 403)),
        quotes: FakeQuotes(),
      );
      expect(await noPlaces.plan(origin: straightRoute.first, destination: dest), isA<Err<AlongRoutePlan>>());
      final noRoute = AlongRoutePlanner(
        routes: FakeRoutes(error: const NotFoundFailure()),
        detours: FakeDetours(),
        places: FakePlaces(),
        quotes: FakeQuotes(),
      );
      expect(await noRoute.plan(origin: straightRoute.first, destination: dest), isA<Err<AlongRoutePlan>>());
    });
  });

  group('ranking explanation', () {
    test('total cost lines are computed, savings vs nearest shown', () {
      final result = const TripCostEngine().rank(
        offers: offersFromPlan(widgetPlan),
        vehicle: car,
        fill: const FillToLevel(currentLevel: 0.25),
        now: DateTime(2026, 11, 25),
      );
      expect(result.ranked.map((r) => r.offer.name), ['Cheap but far', 'Right on route']);
      expect(result.unpriced.single.offer.name, 'No price');
      final lines = explainRanking(result.ranked.first, mode: result.mode, unit: 'L', now: DateTime(2026, 11, 25));
      expect(lines[0], 'Buy 37.5 L × EUR 1.60 = EUR 60.00');
      expect(lines[1], 'Detour 6.0 km uses 0.39 L = EUR 0.62');
      expect(lines[2], 'Total EUR 60.62 · saves EUR 3.15 vs the nearest station');
      expect(lines[3], startsWith('Price source: Google'));
    });

    test('unit price mode asks for a vehicle; detour text', () {
      final r = const TripCostEngine().rank(offers: offersFromPlan(widgetPlan));
      expect(r.mode, CostMode.unitPriceOnly);
      expect(explainRanking(r.ranked.first, mode: r.mode, unit: 'L').first, contains('Add a vehicle'));
      expect(detourText(const StationOffer(stationId: 'x', name: 'x', detourMeters: 20)), 'on route');
      expect(
        detourText(const StationOffer(stationId: 'x', name: 'x', detourMeters: 2000, detourSeconds: 180)),
        '+2.0 km · +3 min',
      );
    });

    test('search target follows the vehicle', () {
      expect(searchTargetFor(null), (includedType: 'gas_station', fuelType: 'REGULAR_UNLEADED'));
      expect(searchTargetFor(car.copyWith(preferredFuelType: 'DIESEL')).fuelType, 'DIESEL');
      expect(
        searchTargetFor(
          const VehicleProfile(
            id: 'e',
            name: 'EV',
            energyType: EnergyType.electric,
            consumptionPer100Km: 15,
            capacity: 60,
          ),
        ),
        (includedType: 'electric_vehicle_charging_station', fuelType: null),
      );
    });
  });
}
