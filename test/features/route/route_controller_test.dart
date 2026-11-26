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

class _Routes implements RouteAlternativesRepository {
  _Routes(this.result);
  final Result<List<RouteInfo>> result;
  GeoPoint? origin;

  @override
  Future<Result<List<RouteInfo>>> drivingRoutes(GeoPoint origin, GeoPoint destination) async {
    this.origin = origin;
    return result;
  }
}

ProviderContainer _container(_Routes routes) {
  final c = ProviderContainer(
    overrides: [
      locationServiceProvider.overrideWithValue(_Location()),
      routeAlternativesRepositoryProvider.overrideWithValue(routes),
    ],
    retry: (_, _) => null,
  );
  addTearDown(c.dispose);
  return c;
}

void main() {
  const route = RouteInfo(distanceMeters: 1500, durationSeconds: 240, points: [_here, _there]);
  const slower = RouteInfo(distanceMeters: 1400, durationSeconds: 420, points: [_here, _there]);

  test('initial state is data(null), never loading', () {
    final c = _container(_Routes(const Ok([route])));
    final state = c.read(routeControllerProvider);
    expect(state, isA<AsyncData<RoutePlan?>>());
    expect(state.value, isNull);
  });

  test('routeTo uses current location as origin and exposes the route', () async {
    final routes = _Routes(const Ok([route]));
    final c = _container(routes);
    c.listen(routeControllerProvider, (_, _) {});
    await c.read(routeControllerProvider.notifier).routeTo(_there);
    expect(routes.origin, _here);
    final plan = c.read(routeControllerProvider).value!;
    expect(plan.selected, route);
    expect(plan.hasAlternatives, isFalse);
  });

  test('alternatives: fastest selected first, select switches, bad index ignored', () async {
    final c = _container(_Routes(const Ok([route, slower])));
    c.listen(routeControllerProvider, (_, _) {});
    final notifier = c.read(routeControllerProvider.notifier);
    notifier.select(1); // no plan yet: ignored
    expect(c.read(routeControllerProvider).value, isNull);
    await notifier.routeTo(_there);
    final first = c.read(routeControllerProvider).value!;
    expect((first.selectedIndex, first.hasAlternatives), (0, true));
    expect(first.differenceFromFastest(1), (meters: -100.0, seconds: 180.0));
    notifier.select(1);
    expect(c.read(routeControllerProvider).value!.selected, slower);
    expect(identical(c.read(routeControllerProvider).value!.routes, first.routes), isTrue, reason: 'camera keeps position');
    notifier.select(7);
    expect(c.read(routeControllerProvider).value!.selectedIndex, 1);
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
