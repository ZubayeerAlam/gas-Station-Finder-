import 'dart:math' as math;

import '../../../core/location/geo_point.dart';

/// Where a point lies relative to a route polyline.
class RouteProjection {
  const RouteProjection({required this.offRouteMeters, required this.alongMeters});

  /// Shortest distance from the point to the route line.
  final double offRouteMeters;

  /// Distance from the route start to the closest point on the route.
  final double alongMeters;
}

/// Pure polyline helpers (no I/O). Distances use a local equirectangular
/// projection per segment — accurate to well under 1 % for segment lengths
/// of a few km, which is what OSRM geometries contain.
abstract final class RouteGeometry {
  static const _r = 6371008.8;

  /// (x, y) in meters of [p] relative to [origin].
  static (double, double) _local(GeoPoint origin, GeoPoint p) {
    final k = math.pi / 180 * _r;
    return (
      (p.longitude - origin.longitude) * k * math.cos(origin.latitude * math.pi / 180),
      (p.latitude - origin.latitude) * k,
    );
  }

  /// Returns (distance from p to segment ab, t in 0..1 along ab).
  static (double, double) _toSegment(GeoPoint p, GeoPoint a, GeoPoint b) {
    final (bx, by) = _local(a, b);
    final (px, py) = _local(a, p);
    final len2 = bx * bx + by * by;
    final t = len2 == 0 ? 0.0 : ((px * bx + py * by) / len2).clamp(0.0, 1.0);
    final dx = px - t * bx, dy = py - t * by;
    return (math.sqrt(dx * dx + dy * dy), t);
  }

  /// Cumulative distance (meters) at each vertex; first is 0.
  static List<double> cumulative(List<GeoPoint> line) {
    final out = List<double>.filled(line.length, 0);
    for (var i = 1; i < line.length; i++) {
      out[i] = out[i - 1] + line[i - 1].distanceTo(line[i]);
    }
    return out;
  }

  static double length(List<GeoPoint> line) => line.isEmpty ? 0 : cumulative(line).last;

  static RouteProjection project(GeoPoint p, List<GeoPoint> line, [List<double>? cum]) {
    if (line.isEmpty) throw ArgumentError('empty route');
    if (line.length == 1) return RouteProjection(offRouteMeters: p.distanceTo(line.first), alongMeters: 0);
    final c = cum ?? cumulative(line);
    var best = double.infinity, along = 0.0;
    for (var i = 0; i < line.length - 1; i++) {
      final (d, t) = _toSegment(p, line[i], line[i + 1]);
      if (d < best) {
        best = d;
        along = c[i] + t * (c[i + 1] - c[i]);
      }
    }
    return RouteProjection(offRouteMeters: best, alongMeters: along);
  }

  /// Douglas–Peucker simplification with a tolerance in meters. Keeps the
  /// first and last point. Iterative (no recursion depth issues).
  static List<GeoPoint> simplify(List<GeoPoint> line, double toleranceMeters) {
    if (line.length < 3) return [...line];
    final keep = List<bool>.filled(line.length, false)
      ..[0] = true
      ..[line.length - 1] = true;
    final stack = <(int, int)>[(0, line.length - 1)];
    while (stack.isNotEmpty) {
      final (s, e) = stack.removeLast();
      var maxD = 0.0, idx = -1;
      for (var i = s + 1; i < e; i++) {
        final (d, _) = _toSegment(line[i], line[s], line[e]);
        if (d > maxD) {
          maxD = d;
          idx = i;
        }
      }
      if (idx != -1 && maxD > toleranceMeters) {
        keep[idx] = true;
        stack
          ..add((s, idx))
          ..add((idx, e));
      }
    }
    return [
      for (var i = 0; i < line.length; i++)
        if (keep[i]) line[i],
    ];
  }

  /// Splits the line into consecutive pieces of at most [maxMeters] each
  /// (pieces share their boundary vertex). Used to search long routes in
  /// several requests so stations are spread along the whole trip.
  static List<List<GeoPoint>> split(List<GeoPoint> line, double maxMeters) {
    if (line.length < 2) return [line];
    final pieces = <List<GeoPoint>>[];
    var current = <GeoPoint>[line.first];
    var acc = 0.0;
    for (var i = 1; i < line.length; i++) {
      final d = line[i - 1].distanceTo(line[i]);
      if (acc + d > maxMeters && current.length >= 2) {
        pieces.add(current);
        current = [line[i - 1]];
        acc = 0;
      }
      current.add(line[i]);
      acc += d;
    }
    if (current.length >= 2) pieces.add(current);
    return pieces;
  }

  /// Google encoded polyline (precision 1e5), as used by Places/Routes APIs.
  static String encodePolyline(List<GeoPoint> line) {
    final out = StringBuffer();
    var prevLat = 0, prevLng = 0;
    void enc(int v) {
      var x = v < 0 ? ~(v << 1) : v << 1;
      while (x >= 0x20) {
        out.writeCharCode((0x20 | (x & 0x1f)) + 63);
        x >>= 5;
      }
      out.writeCharCode(x + 63);
    }

    for (final p in line) {
      final lat = (p.latitude * 1e5).round(), lng = (p.longitude * 1e5).round();
      enc(lat - prevLat);
      enc(lng - prevLng);
      prevLat = lat;
      prevLng = lng;
    }
    return out.toString();
  }
}
