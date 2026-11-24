import '../../../core/error/result.dart';
import '../../../core/location/geo_point.dart';
import '../../ranking/domain/ranking_models.dart';
import '../../stations/domain/entities/station.dart';
import 'along_route_models.dart';

/// Place search used by trip planning (Places API New).
abstract interface class PlaceSearchRepository {
  /// Destination suggestions. [sessionToken] groups autocomplete + the final
  /// details call into one billing session.
  Future<Result<List<PlaceSuggestion>>> autocomplete(String input, {GeoPoint? near, required String sessionToken});

  Future<Result<Destination>> resolve(String placeId, {required String sessionToken});

  /// Stations along one piece of a route (Text Search "search along route").
  Future<Result<List<Station>>> stationsAlongRoute(List<GeoPoint> routePiece, {String includedType = 'gas_station'});
}

/// Driving detours for candidate stops, in one routing request.
abstract interface class DetourRepository {
  /// One entry per stop, in order. Null entries = unroutable stop.
  Future<Result<List<StopDetour?>>> detours(GeoPoint origin, GeoPoint destination, List<GeoPoint> stops);
}

/// Price + open status for a station (from a real source, never estimated).
class StationQuote {
  const StationQuote({this.price, this.openNow, this.priceSource, this.reliability});

  final FuelPrice? price;
  final bool? openNow;

  /// Where [price] came from (null when there is no price).
  final PriceSource? priceSource;

  /// 0..1 community data-reliability score; null = unknown.
  final double? reliability;
}

abstract interface class StationQuoteLookup {
  /// [fuelType] = Places fuel code to price; null = no price wanted (EV).
  Future<Map<String, StationQuote>> quotes(List<String> stationIds, {String? fuelType});
}
