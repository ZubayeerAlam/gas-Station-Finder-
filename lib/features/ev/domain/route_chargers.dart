import 'dart:math' as math;

import '../../../core/error/app_failure.dart';
import '../../../core/error/result.dart';
import '../../../core/location/geo_point.dart';
import '../../along_route/domain/route_geometry.dart';
import 'charge_point.dart';
import 'charge_points_repository.dart';

/// A charger near a route, with where it lies relative to the route.
class RouteCharger {
  const RouteCharger({required this.point, required this.alongMeters, required this.offRouteMeters});

  final ChargePoint point;

  /// Distance from the route start to the closest point on the route.
  final double alongMeters;

  /// Straight-line distance from the route (not a driving detour).
  final double offRouteMeters;
}

class RouteChargersResult {
  const RouteChargersResult({required this.chargers, required this.queries, this.partial = false});

  /// Inside the corridor, ordered along the route.
  final List<RouteCharger> chargers;

  /// Number of radius searches made.
  final int queries;

  /// Some searches failed, so part of the route may be missing chargers.
  final bool partial;
}

/// One radius search around a route point.
class RouteSearchCircle {
  const RouteSearchCircle(this.center, this.radiusKm);
  final GeoPoint center;
  final double radiusKm;
}

/// Finds chargers along a route with the provider's plain radius search
/// (`nearby`), so no route-specific API is assumed: evenly spaced circles that
/// together cover the corridor, then an exact corridor filter by projection.
class RouteChargerFinder {
  RouteChargerFinder(this.repository);

  final ChargePointsRepository repository;

  /// Default corridor half-width, the same 5 km as fuel stations along a route.
  static const defaultCorridorMeters = 5000.0;

  /// Upper bound on searches per route (keeps request volume polite).
  static const defaultMaxQueries = 8;

  /// Preferred spacing between circle centres.
  static const preferredSpacingMeters = 20000.0;

  /// Circles covering a corridor of [corridorMeters] either side of [line].
  /// With spacing s, a circle of radius √((s/2)² + c²) covers the corridor
  /// between its neighbours' midpoints (plus a 5 % margin).
  static List<RouteSearchCircle> circles(
    List<GeoPoint> line, {
    double corridorMeters = defaultCorridorMeters,
    int maxQueries = defaultMaxQueries,
  }) {
    if (line.isEmpty) return const [];
    final cum = RouteGeometry.cumulative(line);
    final length = cum.last;
    final n = math.max(1, math.min(maxQueries, (length / preferredSpacingMeters).ceil() + 1));
    if (n == 1) {
      return [RouteSearchCircle(_pointAt(line, cum, length / 2), (length / 2 + corridorMeters) / 1000)];
    }
    final spacing = length / (n - 1);
    // +5 %: the exact bound leaves hairline gaps at circle midpoints once the
    // route's planar geometry meets the provider's great-circle distances.
    final radius = math.sqrt(math.pow(spacing / 2, 2) + corridorMeters * corridorMeters) * 1.05;
    return [for (var i = 0; i < n; i++) RouteSearchCircle(_pointAt(line, cum, spacing * i), radius / 1000)];
  }

  static GeoPoint _pointAt(List<GeoPoint> line, List<double> cum, double meters) {
    if (line.length == 1 || meters <= 0) return line.first;
    for (var i = 1; i < line.length; i++) {
      if (cum[i] >= meters) {
        final seg = cum[i] - cum[i - 1];
        final t = seg == 0 ? 0.0 : (meters - cum[i - 1]) / seg;
        final a = line[i - 1], b = line[i];
        return GeoPoint(
          latitude: a.latitude + (b.latitude - a.latitude) * t,
          longitude: a.longitude + (b.longitude - a.longitude) * t,
        );
      }
    }
    return line.last;
  }

  Future<Result<RouteChargersResult>> find(
    List<GeoPoint> line, {
    double corridorMeters = defaultCorridorMeters,
    int maxQueries = defaultMaxQueries,
    int maxResultsPerQuery = 100,
  }) async {
    final cs = circles(line, corridorMeters: corridorMeters, maxQueries: maxQueries);
    if (cs.isEmpty) return const Ok(RouteChargersResult(chargers: [], queries: 0));
    final results = await Future.wait([
      for (final c in cs) repository.nearby(c.center, radiusKm: c.radiusKm, maxResults: maxResultsPerQuery),
    ]);
    AppFailure? firstFailure;
    final byId = <String, ChargePoint>{};
    for (final r in results) {
      switch (r) {
        case Ok(:final value):
          for (final p in value) {
            byId.putIfAbsent(p.id, () => p);
          }
        case Err(:final failure):
          firstFailure ??= failure;
      }
    }
    final failures = results.whereType<Err<List<ChargePoint>>>().length;
    if (failures == results.length) return Err(firstFailure!);
    final cum = RouteGeometry.cumulative(line);
    final inside = <RouteCharger>[];
    for (final p in byId.values) {
      final proj = RouteGeometry.project(p.location, line, cum);
      if (proj.offRouteMeters <= corridorMeters) {
        inside.add(RouteCharger(point: p, alongMeters: proj.alongMeters, offRouteMeters: proj.offRouteMeters));
      }
    }
    inside.sort((a, b) => a.alongMeters.compareTo(b.alongMeters));
    return Ok(RouteChargersResult(chargers: inside, queries: cs.length, partial: failures > 0));
  }
}
