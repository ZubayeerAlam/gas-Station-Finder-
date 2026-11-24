import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/location/location_controller.dart';
import '../data/stations_providers.dart';
import '../domain/entities/station.dart';

/// Stations near the current location. Recomputes when location changes.
final nearbyStationsProvider = FutureProvider<List<Station>>((ref) async {
  final center = await ref.watch(locationControllerProvider.future);
  final result = await ref.watch(stationsRepositoryProvider).nearbyStations(center);
  return result.getOrThrow();
});

/// Details for one station, fetched lazily when its sheet opens.
final stationDetailsProvider =
    FutureProvider.autoDispose.family<StationDetails, String>((ref, stationId) async {
  final result = await ref.watch(stationsRepositoryProvider).stationDetails(stationId);
  return result.getOrThrow();
});
