import '../../../core/location/geo_point.dart';
import '../../along_route/domain/along_route_repositories.dart';
import '../../ev/domain/charge_point.dart';
import '../../ranking/domain/ranking_models.dart';
import 'entities/station.dart';

/// One place in the nearby list, with its straight-line distance.
typedef Ranked<T> = ({T item, double meters});

/// How the charger list is ordered.
enum ChargerSort { nearest, fastest }

/// How the fuel station list is ordered. "Cheapest" uses Google prices or a
/// fresh community consensus for one fuel type, looked up separately.
enum StationSort { nearest, cheapest }

/// A nearby station with the price used for comparison (null = none).
typedef PricedStation = ({Ranked<Station> ranked, FuelPrice? price, PriceSource? source});

/// Cheapest first among stations priced in the most common currency (prices in
/// different currencies are never compared); ties go to the nearer station.
/// Stations without a comparable price follow, nearest first.
List<PricedStation> cheapestFirst(List<Ranked<Station>> nearest, Map<String, StationQuote> quotes) {
  final all = [
    for (final r in nearest) (ranked: r, price: quotes[r.item.id]?.price, source: quotes[r.item.id]?.priceSource),
  ];
  final counts = <String, int>{};
  for (final p in all) {
    if (p.price case final price?) counts[price.currencyCode] = (counts[price.currencyCode] ?? 0) + 1;
  }
  if (counts.isEmpty) return [for (final p in all) (ranked: p.ranked, price: null, source: null)];
  final currency = (counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value))).first.key;
  bool comparable(PricedStation p) => p.price?.currencyCode == currency;
  final priced = _stableSort(all.where(comparable).toList(), (a, b) => a.price!.amount.compareTo(b.price!.amount));
  return [
    ...priced,
    for (final p in all)
      if (!comparable(p)) (ranked: p.ranked, price: null, source: null),
  ];
}

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
