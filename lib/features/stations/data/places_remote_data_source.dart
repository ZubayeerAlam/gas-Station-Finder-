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

  static const destinationFieldMask = 'id,displayName,formattedAddress,location';

  /// Text Search (New) restricted to places along an encoded route polyline.
  Future<Map<String, dynamic>> searchAlongRoute(
    String encodedPolyline, {
    required String textQuery,
    required String includedType,
    int pageSize = 20,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/places:searchText',
      data: {
        'textQuery': textQuery,
        'includedType': includedType,
        'strictTypeFiltering': true,
        'pageSize': pageSize,
        'searchAlongRouteParameters': {
          'polyline': {'encodedPolyline': encodedPolyline},
        },
      },
      options: Options(
        headers: {'X-Goog-FieldMask': searchFieldMask},
        extra: {kIdempotentExtra: true},
      ),
    );
    return response.data ?? const {};
  }

  /// Autocomplete (New). Biased (not restricted) towards [near].
  Future<Map<String, dynamic>> autocomplete(String input, {GeoPoint? near, required String sessionToken}) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/places:autocomplete',
      data: {
        'input': input,
        'sessionToken': sessionToken,
        if (near != null)
          'locationBias': {
            'circle': {
              'center': {'latitude': near.latitude, 'longitude': near.longitude},
              'radius': 50000.0,
            },
          },
      },
      options: Options(extra: {kIdempotentExtra: true}),
    );
    return response.data ?? const {};
  }

  /// Minimal details (Essentials fields) to turn a suggestion into a destination.
  Future<Map<String, dynamic>> placeLocation(String placeId, {required String sessionToken}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/places/${Uri.encodeComponent(placeId)}',
      queryParameters: {'sessionToken': sessionToken},
      options: Options(headers: {'X-Goog-FieldMask': destinationFieldMask}),
    );
    final data = response.data;
    if (data == null) throw const FormatException('Empty place response');
    return data;
  }
}
