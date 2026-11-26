import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/location/geo_point.dart';
import '../../../core/location/location_controller.dart';
import '../data/osrm_route_repository.dart';
import '../domain/route_info.dart';

/// Active driving routes (null when none): the fastest plus up to two
/// alternatives, and which one is selected. Origin is the current location.
class RouteController extends AsyncNotifier<RoutePlan?> {
  /// Synchronous so the initial state is `AsyncData(null)`, not a loading
  /// flash (which briefly showed "Calculating route…" on app start).
  @override
  FutureOr<RoutePlan?> build() => null;

  Future<void> routeTo(GeoPoint destination) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final origin = await ref.read(locationControllerProvider.future);
      final result = await ref.read(routeAlternativesRepositoryProvider).drivingRoutes(origin, destination);
      return RoutePlan(result.getOrThrow());
    });
  }

  /// Picks another of the shown routes; ignored while loading or with no plan.
  void select(int index) {
    if (state case AsyncData(:final value?)) state = AsyncData(value.select(index));
  }

  void clear() => state = const AsyncData(null);
}

final routeControllerProvider =
    AsyncNotifierProvider<RouteController, RoutePlan?>(RouteController.new);
