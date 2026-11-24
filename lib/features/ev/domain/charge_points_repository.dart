import '../../../core/error/result.dart';
import '../../../core/location/geo_point.dart';
import 'charge_point.dart';

abstract interface class ChargePointsRepository {
  Future<Result<List<ChargePoint>>> nearby(GeoPoint center, {double radiusKm = 10, int maxResults = 100});
}
