import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/location/geo_point.dart';
import '../../../core/location/location_controller.dart';
import '../data/osrm_route_repository.dart';
import '../domain/route_info.dart';

/// Active driving route (null when none). Origin is the current location.
class RouteController extends AsyncNotifier<RouteInfo?> {
  @override
  Future<RouteInfo?> build() async => null;

  Future<void> routeTo(GeoPoint destination) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final origin = await ref.read(locationControllerProvider.future);
      final result = await ref.read(routeRepositoryProvider).drivingRoute(origin, destination);
      return result.getOrThrow();
    });
  }

  void clear() => state = const AsyncData(null);
}

final routeControllerProvider =
    AsyncNotifierProvider<RouteController, RouteInfo?>(RouteController.new);
