import 'dart:math' as math;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'geo_point.freezed.dart';

/// Platform-independent coordinate used by the domain layer
/// (keeps domain free of google_maps_flutter / geolocator types).
@freezed
abstract class GeoPoint with _$GeoPoint {
  const GeoPoint._();

  const factory GeoPoint({required double latitude, required double longitude}) = _GeoPoint;

  static const _earthRadiusMeters = 6371008.8;

  /// Great-circle (haversine) distance in meters.
  double distanceTo(GeoPoint other) {
    double rad(double d) => d * math.pi / 180;
    final dLat = rad(other.latitude - latitude);
    final dLng = rad(other.longitude - longitude);
    final a = math.pow(math.sin(dLat / 2), 2) +
        math.cos(rad(latitude)) * math.cos(rad(other.latitude)) * math.pow(math.sin(dLng / 2), 2);
    return 2 * _earthRadiusMeters * math.asin(math.min(1, math.sqrt(a)));
  }
}
