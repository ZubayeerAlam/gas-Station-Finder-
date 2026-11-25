import '../../../core/error/app_failure.dart';
import '../../../core/error/result.dart';
import '../../../core/location/geo_point.dart';
import '../../../core/network/failure_mapper.dart';
import '../domain/entities/station.dart';
import '../domain/repositories/stations_repository.dart';
import 'places_mapper.dart';
import 'places_remote_data_source.dart';

class PlacesStationsRepository implements StationsRepository {
  PlacesStationsRepository(this._remote, {required bool hasApiKey}) : _hasApiKey = hasApiKey; // ignore: prefer_initializing_formals

  final PlacesRemoteDataSource _remote;
  final bool _hasApiKey;

  static const _missingKey = ConfigFailure(
    'Google Maps API key is not configured. Run with --dart-define-from-file=config/dev.json.',
    code: FailureCode.missingGoogleKey,
  );

  @override
  Future<Result<List<Station>>> nearbyStations(
    GeoPoint center, {
    double radiusMeters = 5000,
  }) async {
    if (!_hasApiKey) return const Err(_missingKey);
    return guardResult(() async {
      final json = await _remote.searchNearby(center, radiusMeters: radiusMeters);
      return PlacesMapper.stationsFromSearch(json);
    });
  }

  @override
  Future<Result<StationDetails>> stationDetails(String stationId) async {
    if (!_hasApiKey) return const Err(_missingKey);
    return guardResult(() async {
      final json = await _remote.placeDetails(stationId);
      return PlacesMapper.detailsFromJson(json);
    });
  }
}
