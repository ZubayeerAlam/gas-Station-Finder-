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
