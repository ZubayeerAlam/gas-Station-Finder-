import '../../../core/location/geo_point.dart';
import '../../ev/domain/charge_point.dart';

/// One place in the nearby list, with its straight-line distance.
typedef Ranked<T> = ({T item, double meters});

/// How the charger list is ordered. Fuel stations are always nearest first
/// (a nearby search carries no prices to sort by).
enum ChargerSort { nearest, fastest }

/// Nearest first; ties keep the search order (stable).
List<Ranked<T>> nearestFirst<T>(Iterable<T> items, GeoPoint origin, GeoPoint Function(T) locate) {
  final ranked = [for (final i in items) (item: i, meters: origin.distanceTo(locate(i)))];
  return _stableSort(ranked, (a, b) => a.meters.compareTo(b.meters));
}

/// Chargers by [sort]. "Fastest" orders by max power (unknown power last),
/// then by distance; out-of-service chargers always go to the end.
List<Ranked<ChargePoint>> sortChargers(Iterable<ChargePoint> points, GeoPoint origin, ChargerSort sort) {
  final ranked = nearestFirst(points, origin, (p) => p.location);
  int down(ChargePoint p) => p.isOperational == false ? 1 : 0;
  return _stableSort(ranked, (a, b) {
    final byStatus = down(a.item).compareTo(down(b.item));
    if (byStatus != 0 || sort == ChargerSort.nearest) return byStatus;
    final pa = a.item.maxPowerKw ?? -1, pb = b.item.maxPowerKw ?? -1;
    return pb.compareTo(pa);
  });
}

List<E> _stableSort<E>(List<E> list, int Function(E, E) compare) {
  final indexed = [for (var i = 0; i < list.length; i++) (i, list[i])];
  indexed.sort((a, b) {
    final c = compare(a.$2, b.$2);
    return c != 0 ? c : a.$1.compareTo(b.$1);
  });
  return [for (final e in indexed) e.$2];
}
