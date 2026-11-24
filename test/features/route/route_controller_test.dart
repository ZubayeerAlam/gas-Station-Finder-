import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gas_station_finder/core/error/app_failure.dart';
import 'package:gas_station_finder/core/error/result.dart';
import 'package:gas_station_finder/core/location/geo_point.dart';
import 'package:gas_station_finder/core/location/location_service.dart';
import 'package:gas_station_finder/features/route/data/osrm_route_repository.dart';
import 'package:gas_station_finder/features/route/domain/route_info.dart';
import 'package:gas_station_finder/features/route/presentation/route_controller.dart';

const _here = GeoPoint(latitude: 52.52, longitude: 13.405);
const _there = GeoPoint(latitude: 52.51, longitude: 13.41);

class _Location implements LocationService {
  @override
  Future<Result<GeoPoint>> currentPosition() async => const Ok(_here);
  @override
  Future<bool> openAppSettings() async => true;
  @override
  Future<bool> openLocationSettings() async => true;
}

class _Routes implements RouteRepository {
  _Routes(this.result);
  final Result<RouteInfo> result;
  GeoPoint? origin;

  @override
  Future<Result<RouteInfo>> drivingRoute(GeoPoint origin, GeoPoint destination) async {
    this.origin = origin;
    return result;
  }
}

ProviderContainer _container(_Routes routes) {
  final c = ProviderContainer(
    overrides: [
      locationServiceProvider.overrideWithValue(_Location()),
      routeRepositoryProvider.overrideWithValue(routes),
    ],
    retry: (_, _) => null,
  );
  addTearDown(c.dispose);
  return c;
}

void main() {
  const route = RouteInfo(distanceMeters: 1500, durationSeconds: 240, points: [_here, _there]);

  test('initial state is data(null), never loading', () {
    final c = _container(_Routes(const Ok(route)));
    final state = c.read(routeControllerProvider);
    expect(state, isA<AsyncData<RouteInfo?>>());
    expect(state.value, isNull);
  });

  test('routeTo uses current location as origin and exposes the route', () async {
    final routes = _Routes(const Ok(route));
    final c = _container(routes);
    c.listen(routeControllerProvider, (_, _) {});
    await c.read(routeControllerProvider.notifier).routeTo(_there);
    expect(routes.origin, _here);
    expect(c.read(routeControllerProvider).value, route);
  });

  test('routeTo failure surfaces typed error; clear resets', () async {
    final c = _container(_Routes(const Err(NotFoundFailure('No route'))));
    c.listen(routeControllerProvider, (_, _) {});
    await c.read(routeControllerProvider.notifier).routeTo(_there);
    expect(c.read(routeControllerProvider).error, isA<NotFoundFailure>());
    c.read(routeControllerProvider.notifier).clear();
    expect(c.read(routeControllerProvider).value, isNull);
  });
}
