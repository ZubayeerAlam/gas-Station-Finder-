import '../../../core/error/app_failure.dart';
import '../../../core/error/result.dart';
import '../../../core/location/geo_point.dart';
import '../domain/entities/station.dart';
import '../domain/repositories/stations_repository.dart';
import 'place_location_cache.dart';

/// Live search first; when the network is down, the saved station positions
/// (no names/prices — see [PlaceLocationCache]) so the map is not empty.
class OfflineFallbackStationsRepository implements StationsRepository {
  OfflineFallbackStationsRepository(this._live, this._cache, {DateTime Function()? clock})
      : _now = clock ?? DateTime.now;

  final StationsRepository _live;
  final PlaceLocationCache _cache;
  final DateTime Function() _now;

  static bool isConnectivity(AppFailure f) => f is NetworkFailure || f is TimeoutFailure;

  @override
  Future<Result<List<Station>>> nearbyStations(GeoPoint center, {double radiusMeters = 5000}) async {
    final live = await _live.nearbyStations(center, radiusMeters: radiusMeters);
    switch (live) {
      case Ok(:final value):
        try {
          await _cache.save(value, _now());
        } catch (_) {
          // Cache trouble must never hide live results.
        }
        return live;
      case Err(:final failure) when isConnectivity(failure):
        try {
          final saved = await _cache.near(center, radiusMeters, _now());
          return saved.isEmpty ? live : Ok(saved);
        } catch (_) {
          return live;
        }
      case Err():
        return live;
    }
  }

  @override
  Future<Result<StationDetails>> stationDetails(String stationId) => _live.stationDetails(stationId);
}
