import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../stations/data/stations_providers.dart';
import '../../stations/domain/entities/station.dart';
import '../../stations/domain/repositories/stations_repository.dart';
import '../domain/along_route_repositories.dart';

/// Prices + open status from Place Details (`fuelOptions`, `currentOpeningHours`).
/// Only real Google data; stations without a matching fuel price get none.
/// Results are cached in memory for [ttl] to avoid repeat Enterprise calls.
class PlacesQuoteLookup implements StationQuoteLookup {
  PlacesQuoteLookup(this.stations, {this.ttl = const Duration(minutes: 10), DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final StationsRepository stations;
  final Duration ttl;
  final DateTime Function() _clock;
  final _cache = <String, (DateTime, StationDetails)>{};

  @override
  Future<Map<String, StationQuote>> quotes(List<String> stationIds, {String? fuelType}) async {
    final details = await Future.wait(stationIds.map(_details));
    return {
      for (var i = 0; i < stationIds.length; i++)
        if (details[i] case final d?) stationIds[i]: StationQuote(price: pickPrice(d, fuelType), openNow: d.openNow),
    };
  }

  Future<StationDetails?> _details(String id) async {
    final hit = _cache[id];
    if (hit != null && _clock().difference(hit.$1) < ttl) return hit.$2;
    final result = await stations.stationDetails(id);
    final d = result.isOk ? result.getOrThrow() : null;
    if (d != null) _cache[id] = (_clock(), d);
    return d;
  }

  /// Exact fuel-type match only — e.g. a Premium price is never used for Regular.
  static FuelPrice? pickPrice(StationDetails d, String? fuelType) {
    if (fuelType == null) return null;
    for (final p in d.fuelPrices) {
      if (p.fuelType == fuelType) return p;
    }
    return null;
  }
}

final stationQuoteLookupProvider = Provider<StationQuoteLookup>(
  (ref) => PlacesQuoteLookup(ref.watch(stationsRepositoryProvider)),
);
