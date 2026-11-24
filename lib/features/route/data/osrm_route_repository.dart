import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/error/app_failure.dart';
import '../../../core/error/result.dart';
import '../../../core/location/geo_point.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/failure_mapper.dart';
import '../domain/route_info.dart';

/// Driving routes from an OSRM server (HTTPS). The public demo server has no
/// SLA; for production point `OSRM_BASE_URL` at a self-hosted instance.
class OsrmRouteRepository implements RouteRepository {
  OsrmRouteRepository(this._dio);

  final Dio _dio;

  @override
  Future<Result<RouteInfo>> drivingRoute(GeoPoint origin, GeoPoint destination) {
    return guardResult(() async {
      final coords = '${origin.longitude},${origin.latitude};'
          '${destination.longitude},${destination.latitude}';
      final response = await _dio.get<Map<String, dynamic>>(
        '/route/v1/driving/$coords',
        queryParameters: {'overview': 'full', 'geometries': 'geojson'},
      );
      return parseOsrmRoute(response.data ?? const {});
    });
  }

  /// Parses an OSRM `/route` response. OSRM GeoJSON coordinates are
  /// `[longitude, latitude]`.
  static RouteInfo parseOsrmRoute(Map<String, dynamic> json) {
    final routes = json['routes'];
    if (json['code'] != 'Ok' || routes is! List || routes.isEmpty) {
      throw const NotFoundFailure('No driving route found to this station.');
    }
    final route = routes.first as Map<String, dynamic>;
    final coords = (route['geometry'] as Map<String, dynamic>?)?['coordinates'];
    final points = <GeoPoint>[
      if (coords is List)
        for (final c in coords)
          if (c is List && c.length >= 2)
            GeoPoint(latitude: (c[1] as num).toDouble(), longitude: (c[0] as num).toDouble()),
    ];
    if (points.length < 2) throw const FormatException('Route geometry missing');
    return RouteInfo(
      distanceMeters: (route['distance'] as num?)?.toDouble() ?? 0,
      durationSeconds: (route['duration'] as num?)?.toDouble() ?? 0,
      points: points,
    );
  }
}

final routeRepositoryProvider = Provider<RouteRepository>((ref) {
  final dio = buildDio(baseUrl: ref.watch(appConfigProvider).osrmBaseUrl);
  ref.onDispose(dio.close);
  return OsrmRouteRepository(dio);
});
