import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/error/result.dart';
import '../../../core/location/geo_point.dart';

part 'route_info.freezed.dart';

@freezed
abstract class RouteInfo with _$RouteInfo {
  const RouteInfo._();

  const factory RouteInfo({
    required double distanceMeters,
    required double durationSeconds,
    required List<GeoPoint> points,
  }) = _RouteInfo;

  double get distanceKm => distanceMeters / 1000;
  Duration get duration => Duration(seconds: durationSeconds.round());
}

abstract interface class RouteRepository {
  Future<Result<RouteInfo>> drivingRoute(GeoPoint origin, GeoPoint destination);
}

/// Up to [kMaxRouteAlternatives] driving routes, fastest first.
abstract interface class RouteAlternativesRepository {
  Future<Result<List<RouteInfo>>> drivingRoutes(GeoPoint origin, GeoPoint destination);
}

const kMaxRouteAlternatives = 3;

/// The routes shown on the map and which one the user picked.
class RoutePlan {
  const RoutePlan(this.routes, {this.selectedIndex = 0})
    : assert(routes.length > 0),
      assert(selectedIndex >= 0 && selectedIndex < routes.length);

  final List<RouteInfo> routes;
  final int selectedIndex;

  RouteInfo get selected => routes[selectedIndex];
  bool get hasAlternatives => routes.length > 1;

  RoutePlan select(int index) => index < 0 || index >= routes.length ? this : RoutePlan(routes, selectedIndex: index);

  /// Extra time/distance of route [i] vs the fastest (index 0).
  ({double meters, double seconds}) differenceFromFastest(int i) => (
    meters: routes[i].distanceMeters - routes.first.distanceMeters,
    seconds: routes[i].durationSeconds - routes.first.durationSeconds,
  );
}
