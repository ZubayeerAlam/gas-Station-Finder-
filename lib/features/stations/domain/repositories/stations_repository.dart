import '../../../../core/error/result.dart';
import '../../../../core/location/geo_point.dart';
import '../entities/station.dart';

abstract interface class StationsRepository {
  Future<Result<List<Station>>> nearbyStations(
    GeoPoint center, {
    double radiusMeters = 5000,
  });

  Future<Result<StationDetails>> stationDetails(String stationId);
}
