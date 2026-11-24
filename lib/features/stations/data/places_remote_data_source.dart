import 'package:dio/dio.dart';

import '../../../core/location/geo_point.dart';
import '../../../core/network/dio_client.dart';

/// Google Places API (New) REST client.
///
/// Field masks are deliberately split by billing tier:
/// * Nearby search requests only id/name/location/address (Pro SKU), because
///   it runs on every map refresh.
/// * Details (on tap) additionally requests rating, hours, phone, fuel prices
///   and EV options (Enterprise SKU) for a single place.
class PlacesRemoteDataSource {
  PlacesRemoteDataSource(this._dio);

  final Dio _dio;

  static const searchFieldMask =
      'places.id,places.displayName,places.location,places.shortFormattedAddress';

  static const detailsFieldMask = 'id,displayName,location,formattedAddress,'
      'internationalPhoneNumber,nationalPhoneNumber,rating,userRatingCount,'
      'currentOpeningHours.openNow,currentOpeningHours.weekdayDescriptions,'
      'regularOpeningHours.weekdayDescriptions,fuelOptions,evChargeOptions,googleMapsUri';

  Future<Map<String, dynamic>> searchNearby(
    GeoPoint center, {
    required double radiusMeters,
    List<String> includedTypes = const ['gas_station'],
    int maxResults = 20,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/places:searchNearby',
      data: {
        'includedTypes': includedTypes,
        'maxResultCount': maxResults,
        'rankPreference': 'DISTANCE',
        'locationRestriction': {
          'circle': {
            'center': {'latitude': center.latitude, 'longitude': center.longitude},
            'radius': radiusMeters,
          },
        },
      },
      options: Options(
        headers: {'X-Goog-FieldMask': searchFieldMask},
        extra: {kIdempotentExtra: true},
      ),
    );
    return response.data ?? const {};
  }

  Future<Map<String, dynamic>> placeDetails(String placeId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/places/${Uri.encodeComponent(placeId)}',
      options: Options(headers: {'X-Goog-FieldMask': detailsFieldMask}),
    );
    final data = response.data;
    if (data == null) throw const FormatException('Empty details response');
    return data;
  }
}
