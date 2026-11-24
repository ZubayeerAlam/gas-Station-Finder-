import '../../../core/error/app_failure.dart';
import '../../../core/error/result.dart';
import '../../../core/location/geo_point.dart';
import '../../route/domain/route_info.dart';
import '../../stations/domain/entities/station.dart';
import 'along_route_models.dart';
import 'along_route_repositories.dart';
import 'route_geometry.dart';

/// Finds stations along a driving route and measures the real detour of each.
///
/// 1. Route origin → destination (OSRM).
/// 2. Split long routes into pieces (≤ [segmentMeters], max [maxSegments]),
///    simplify each and run a Places "search along route" per piece, so
///    results cover the whole trip, not just its start.
/// 3. Deduplicate, drop anything farther than [maxOffRouteMeters] from the
///    line, sort by position along the route.
/// 4. Detours for the [maxDetourStops] closest-to-route stations in one OSRM
///    table request. If routing fails, fall back to a straight-line estimate
///    (2 × off-route distance) and mark the plan as approximate.
/// 5. Prices/opening for the [maxQuotedStops] smallest detours (cost control).
class AlongRoutePlanner {
  AlongRoutePlanner({
    required this.routes,
    required this.detours,
    required this.places,
    required this.quotes,
    this.maxOffRouteMeters = 5000,
    this.segmentMeters = 150000,
    this.maxSegments = 4,
    this.maxDetourStops = 25,
    this.maxQuotedStops = 8,
    this.simplifyToleranceMeters = 30,
  });

  final RouteRepository routes;
  final DetourRepository detours;
  final PlaceSearchRepository places;
  final StationQuoteLookup quotes;
  final double maxOffRouteMeters;
  final double segmentMeters;
  final int maxSegments;
  final int maxDetourStops;
  final int maxQuotedStops;
  final double simplifyToleranceMeters;

  Future<Result<AlongRoutePlan>> plan({
    required GeoPoint origin,
    required Destination destination,
    String? fuelType,
    String includedType = 'gas_station',
  }) async {
    final routeResult = await routes.drivingRoute(origin, destination.location);
    if (routeResult case Err(:final failure)) return Err(failure);
    final route = routeResult.getOrThrow();

    // 2. Search per route piece.
    // Piece size ≥ length/maxSegments + longest edge ⇒ at most maxSegments pieces.
    var longestEdge = 0.0;
    for (var i = 1; i < route.points.length; i++) {
      final d = route.points[i - 1].distanceTo(route.points[i]);
      if (d > longestEdge) longestEdge = d;
    }
    final evenSplit = RouteGeometry.length(route.points) / maxSegments + longestEdge;
    final pieces = RouteGeometry.split(route.points, evenSplit > segmentMeters ? evenSplit : segmentMeters);
    final searches = await Future.wait([
      for (final p in pieces)
        places.stationsAlongRoute(RouteGeometry.simplify(p, simplifyToleranceMeters), includedType: includedType),
    ]);
    final found = <String, Station>{};
    AppFailure? firstError;
    for (final r in searches) {
      switch (r) {
        case Ok(:final value):
          for (final s in value) {
            found.putIfAbsent(s.id, () => s);
          }
        case Err(:final failure):
          firstError ??= failure;
      }
    }
    if (found.isEmpty && firstError != null) return Err(firstError);

    // 3. Corridor filter.
    final cum = RouteGeometry.cumulative(route.points);
    var stops = <RouteStop>[
      for (final s in found.values)
        if (RouteGeometry.project(s.location, route.points, cum) case final p
            when p.offRouteMeters <= maxOffRouteMeters)
          RouteStop(station: s, alongMeters: p.alongMeters, offRouteMeters: p.offRouteMeters),
    ];

    // 4. Detours for the closest-to-route candidates.
    stops.sort((a, b) => a.offRouteMeters.compareTo(b.offRouteMeters));
    final skipped = stops.length > maxDetourStops ? stops.length - maxDetourStops : 0;
    stops = stops.take(maxDetourStops).toList();
    var approximate = false;
    if (stops.isNotEmpty) {
      final detourResult = await detours.detours(origin, destination.location, [
        for (final s in stops) s.station.location,
      ]);
      switch (detourResult) {
        case Ok(:final value) when value.length == stops.length:
          stops = [for (var i = 0; i < stops.length; i++) stops[i].copyWith(detour: value[i])];
        default:
          approximate = true;
          stops = [
            for (final s in stops)
              s.copyWith(
                detour: StopDetour(
                  toStationMeters: s.alongMeters + s.offRouteMeters,
                  detourMeters: 2 * s.offRouteMeters,
                ),
              ),
          ];
      }
    }
    // Unroutable stops (null detour) are dropped — we cannot cost them.
    stops = stops.where((s) => s.detour != null).toList();

    // 5. Quotes for the smallest detours.
    final byDetour = [...stops]..sort((a, b) => a.detour!.detourMeters.compareTo(b.detour!.detourMeters));
    final quoteIds = [for (final s in byDetour.take(maxQuotedStops)) s.station.id];
    if (quoteIds.isNotEmpty) {
      final quoted = await quotes.quotes(quoteIds, fuelType: fuelType);
      stops = [
        for (final s in stops)
          if (quoted[s.station.id] case final q?) s.copyWith(price: q.price, openNow: q.openNow) else s,
      ];
    }

    stops.sort((a, b) => a.alongMeters.compareTo(b.alongMeters));
    return Ok(
      AlongRoutePlan(
        origin: origin,
        destination: destination,
        route: route,
        stops: stops,
        fuelType: fuelType,
        detoursApproximate: approximate,
        skippedForDetour: skipped,
      ),
    );
  }
}
