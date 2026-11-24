import 'package:gas_station_finder/core/error/app_failure.dart';
import 'package:gas_station_finder/core/error/result.dart';
import 'package:gas_station_finder/core/location/geo_point.dart';
import 'package:gas_station_finder/features/along_route/domain/along_route_models.dart';
import 'package:gas_station_finder/features/along_route/domain/along_route_repositories.dart';
import 'package:gas_station_finder/features/garage/domain/vehicle_profile.dart';
import 'package:gas_station_finder/features/route/domain/route_info.dart';
import 'package:gas_station_finder/features/stations/data/places_remote_data_source.dart';
import 'package:gas_station_finder/features/stations/domain/entities/station.dart';
import 'package:gas_station_finder/features/stations/domain/repositories/stations_repository.dart';

/// ~20 km east along latitude 52.5 (Berlin area).
final straightRoute = [for (var i = 0; i <= 30; i++) GeoPoint(latitude: 52.5, longitude: 13.0 + i * 0.01)];

const dest = Destination(name: 'Potsdam-ish', location: GeoPoint(latitude: 52.5, longitude: 13.3));

const stationA = Station(id: 'a', name: 'A', location: GeoPoint(latitude: 52.5027, longitude: 13.1)); // ~300 m off
const stationB = Station(id: 'b', name: 'B', location: GeoPoint(latitude: 52.58, longitude: 13.2)); // ~9 km off
const stationC = Station(id: 'c', name: 'C', location: GeoPoint(latitude: 52.4991, longitude: 13.25)); // ~100 m off

const car = VehicleProfile(
  id: 'car',
  name: 'Corolla',
  energyType: EnergyType.fuel,
  consumptionPer100Km: 6.5,
  capacity: 50,
  preferredFuelType: 'REGULAR_UNLEADED',
);

class FakeRoutes implements RouteRepository {
  FakeRoutes({this.error});
  final AppFailure? error;

  @override
  Future<Result<RouteInfo>> drivingRoute(GeoPoint origin, GeoPoint destination) async =>
      error != null ? Err(error!) : Ok(RouteInfo(distanceMeters: 20300, durationSeconds: 1200, points: straightRoute));
}

class FakeDetours implements DetourRepository {
  FakeDetours({this.fail = false});
  final bool fail;

  @override
  Future<Result<List<StopDetour?>>> detours(GeoPoint origin, GeoPoint destination, List<GeoPoint> stops) async => fail
      ? const Err(NetworkFailure())
      : Ok([
          for (var i = 0; i < stops.length; i++)
            StopDetour(toStationMeters: 1000.0 * (i + 1), detourMeters: 500.0 * (i + 1), detourSeconds: 30.0 * (i + 1)),
        ]);
}

class FakePlaces implements PlaceSearchRepository {
  FakePlaces({this.error, this.suggestions = const [], this.resolved = dest});
  final AppFailure? error;
  final List<PlaceSuggestion> suggestions;
  final Destination resolved;
  int calls = 0;
  final queries = <String>[];
  final sessions = <String>[];

  @override
  Future<Result<List<PlaceSuggestion>>> autocomplete(
    String input, {
    GeoPoint? near,
    required String sessionToken,
  }) async {
    queries.add(input);
    sessions.add(sessionToken);
    return Ok(suggestions);
  }

  @override
  Future<Result<Destination>> resolve(String placeId, {required String sessionToken}) async {
    sessions.add(sessionToken);
    return Ok(resolved);
  }

  @override
  Future<Result<List<Station>>> stationsAlongRoute(
    List<GeoPoint> routePiece, {
    String includedType = 'gas_station',
  }) async {
    calls++;
    return error != null ? Err(error!) : const Ok([stationA, stationB, stationC]);
  }
}

class FakeQuotes implements StationQuoteLookup {
  final requested = <String>[];

  @override
  Future<Map<String, StationQuote>> quotes(List<String> stationIds, {String? fuelType}) async {
    requested.addAll(stationIds);
    return {
      for (final id in stationIds)
        id: const StationQuote(
          price: FuelPrice(fuelType: 'DIESEL', amount: 1.70, currencyCode: 'EUR'),
          openNow: true,
        ),
    };
  }
}

class CountingStations implements StationsRepository {
  final calls = <String, int>{};

  @override
  Future<Result<List<Station>>> nearbyStations(GeoPoint center, {double radiusMeters = 5000}) async => const Ok([]);

  @override
  Future<Result<StationDetails>> stationDetails(String stationId) async {
    calls[stationId] = (calls[stationId] ?? 0) + 1;
    if (stationId == 'missing') return const Err(NotFoundFailure());
    return Ok(
      StationDetails(
        id: stationId,
        name: 'S',
        location: const GeoPoint(latitude: 0, longitude: 0),
        openNow: true,
        fuelPrices: const [
          FuelPrice(fuelType: 'DIESEL', amount: 1.65, currencyCode: 'EUR'),
          FuelPrice(fuelType: 'REGULAR_UNLEADED', amount: 1.75, currencyCode: 'EUR'),
        ],
      ),
    );
  }
}

class UnusedRemote implements PlacesRemoteDataSource {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw StateError('network must not be called');
}

/// Hand-computed plan for ranking/UI tests (car: 6.5 L/100 km, 50 L, 25 % → 37.5 L).
final widgetPlan = AlongRoutePlan(
  origin: straightRoute.first,
  destination: dest,
  route: RouteInfo(distanceMeters: 20300, durationSeconds: 1200, points: straightRoute),
  fuelType: 'REGULAR_UNLEADED',
  stops: [
    RouteStop(
      station: const Station(id: 'far', name: 'Cheap but far', location: GeoPoint(latitude: 52.55, longitude: 13.1)),
      alongMeters: 6800,
      offRouteMeters: 2900,
      detour: const StopDetour(toStationMeters: 10000, detourMeters: 6000, detourSeconds: 420),
      price: FuelPrice(
        fuelType: 'REGULAR_UNLEADED',
        amount: 1.60,
        currencyCode: 'EUR',
        updatedAt: DateTime(2026, 11, 24),
      ),
      openNow: true,
    ),
    const RouteStop(
      station: Station(id: 'near', name: 'Right on route', location: GeoPoint(latitude: 52.5, longitude: 13.2)),
      alongMeters: 13500,
      offRouteMeters: 20,
      detour: StopDetour(toStationMeters: 13500, detourMeters: 200, detourSeconds: 20),
      price: FuelPrice(fuelType: 'REGULAR_UNLEADED', amount: 1.70, currencyCode: 'EUR'),
    ),
    const RouteStop(
      station: Station(id: 'np', name: 'No price', location: GeoPoint(latitude: 52.5, longitude: 13.25)),
      alongMeters: 17000,
      offRouteMeters: 10,
      detour: StopDetour(toStationMeters: 17000, detourMeters: 100),
    ),
  ],
);
