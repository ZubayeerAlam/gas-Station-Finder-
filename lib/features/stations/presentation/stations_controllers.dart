import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/location/location_controller.dart';
import '../../along_route/domain/along_route_repositories.dart';
import '../../prices/data/community_quote_lookup.dart';
import '../data/stations_providers.dart';
import '../domain/entities/station.dart';

/// Stations near the current location. Recomputes when location changes.
final nearbyStationsProvider = FutureProvider<List<Station>>((ref) async {
  final center = await ref.watch(locationControllerProvider.future);
  final result = await ref.watch(stationsRepositoryProvider).nearbyStations(center);
  return result.getOrThrow();
});

/// Details for one station, fetched lazily when its sheet opens.
final stationDetailsProvider = FutureProvider.autoDispose.family<StationDetails, String>((ref, stationId) async {
  final result = await ref.watch(stationsRepositoryProvider).stationDetails(stationId);
  return result.getOrThrow();
});

/// Prices for the nearby list's "Cheapest" sort: Google price or a fresh
/// community consensus for one fuel. Only watched while that sort is chosen,
/// so the default list makes no extra requests. Key: comma-joined station ids.
final nearbyQuotesProvider = FutureProvider.autoDispose.family<Map<String, StationQuote>, ({String ids, String fuel})>(
  (ref, q) => ref.watch(stationQuoteLookupProvider).quotes(q.ids.split(','), fuelType: q.fuel),
);
