import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/error/app_failure.dart';
import '../../../core/error/result.dart';
import '../../../core/location/geo_point.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/failure_mapper.dart';
import '../../along_route/domain/along_route_models.dart';
import '../../along_route/domain/along_route_repositories.dart';
import '../domain/route_info.dart';

/// Driving routes from an OSRM server (HTTPS). The public demo server has no
/// SLA; for production point `OSRM_BASE_URL` at a self-hosted instance.
class OsrmRouteRepository implements RouteRepository, DetourRepository {
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

  /// One `/table` request: coordinates `[origin, destination, s1..sn]`,
  /// sources `[origin, s1..sn]`, destinations `[destination, s1..sn]`.
  @override
  Future<Result<List<StopDetour?>>> detours(GeoPoint origin, GeoPoint destination, List<GeoPoint> stops) {
    return guardResult(() async {
      if (stops.isEmpty) return const <StopDetour?>[];
      final all = [origin, destination, ...stops];
      final coords = all.map((p) => '${p.longitude},${p.latitude}').join(';');
      final stopIdx = [for (var i = 0; i < stops.length; i++) i + 2];
      final response = await _dio.get<Map<String, dynamic>>(
        '/table/v1/driving/$coords',
        queryParameters: {
          'sources': [0, ...stopIdx].join(';'),
          'destinations': [1, ...stopIdx].join(';'),
          'annotations': 'distance,duration',
        },
      );
      return parseOsrmDetours(response.data ?? const {}, stops.length);
    });
  }

  /// Rows = sources `[origin, s1..sn]`, columns = destinations
  /// `[destination, s1..sn]`. detour_i = d(origin,s_i) + d(s_i,dest) − d(origin,dest).
  static List<StopDetour?> parseOsrmDetours(Map<String, dynamic> json, int stopCount) {
    if (json['code'] != 'Ok') throw const NotFoundFailure('Could not compute detours.');
    final dist = json['distances'], dur = json['durations'];
    if (dist is! List || dist.length != stopCount + 1) throw const FormatException('Bad table size');
    double? at(Object? m, int r, int c) {
      if (m is! List || r >= m.length) return null;
      final row = m[r];
      return row is List && c < row.length && row[c] is num ? (row[c] as num).toDouble() : null;
    }

    final direct = at(dist, 0, 0);
    final directT = at(dur, 0, 0);
    if (direct == null) throw const NotFoundFailure('No route to the destination.');
    return [
      for (var i = 1; i <= stopCount; i++)
        if ((at(dist, 0, i), at(dist, i, 0)) case (final toS?, final fromS?))
          StopDetour(
            toStationMeters: toS,
            toStationSeconds: at(dur, 0, i),
            detourMeters: (toS + fromS - direct).clamp(0, double.infinity).toDouble(),
            detourSeconds: switch ((at(dur, 0, i), at(dur, i, 0), directT)) {
              (final a?, final b?, final c?) => (a + b - c).clamp(0, double.infinity).toDouble(),
              _ => null,
            },
          )
        else
          null,
    ];
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

final osrmRepositoryProvider = Provider<OsrmRouteRepository>((ref) {
  final dio = buildDio(baseUrl: ref.watch(appConfigProvider).osrmBaseUrl);
  ref.onDispose(dio.close);
  return OsrmRouteRepository(dio);
});

final routeRepositoryProvider = Provider<RouteRepository>((ref) => ref.watch(osrmRepositoryProvider));

final detourRepositoryProvider = Provider<DetourRepository>((ref) => ref.watch(osrmRepositoryProvider));
