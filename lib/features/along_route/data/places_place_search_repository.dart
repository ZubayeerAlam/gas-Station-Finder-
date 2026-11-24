import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/error/app_failure.dart';
import '../../../core/error/result.dart';
import '../../../core/location/geo_point.dart';
import '../../../core/network/failure_mapper.dart';
import '../../stations/data/places_mapper.dart';
import '../../stations/data/places_remote_data_source.dart';
import '../../stations/data/stations_providers.dart';
import '../../stations/domain/entities/station.dart';
import '../domain/along_route_models.dart';
import '../domain/along_route_repositories.dart';
import '../domain/route_geometry.dart';

class PlacesPlaceSearchRepository implements PlaceSearchRepository {
  PlacesPlaceSearchRepository(this.remote, {required this.hasApiKey});

  final PlacesRemoteDataSource remote;
  final bool hasApiKey;

  static const _missingKey = ConfigFailure(
    'Google Maps API key is not configured. Run with --dart-define-from-file=config/dev.json.',
  );

  @override
  Future<Result<List<PlaceSuggestion>>> autocomplete(
    String input, {
    GeoPoint? near,
    required String sessionToken,
  }) async {
    if (!hasApiKey) return const Err(_missingKey);
    if (input.trim().length < 2) return const Ok([]);
    return guardResult(
      () async => parseSuggestions(await remote.autocomplete(input.trim(), near: near, sessionToken: sessionToken)),
    );
  }

  @override
  Future<Result<Destination>> resolve(String placeId, {required String sessionToken}) async {
    if (!hasApiKey) return const Err(_missingKey);
    return guardResult(() async => parseDestination(await remote.placeLocation(placeId, sessionToken: sessionToken)));
  }

  @override
  Future<Result<List<Station>>> stationsAlongRoute(
    List<GeoPoint> routePiece, {
    String includedType = 'gas_station',
  }) async {
    if (!hasApiKey) return const Err(_missingKey);
    return guardResult(
      () async => PlacesMapper.stationsFromSearch(
        await remote.searchAlongRoute(
          RouteGeometry.encodePolyline(routePiece),
          textQuery: includedType == 'gas_station' ? 'gas station' : 'EV charging station',
          includedType: includedType,
        ),
      ),
    );
  }

  /// `{suggestions: [{placePrediction: {placeId, text, structuredFormat}}]}`.
  /// Query predictions (no placeId) are ignored.
  static List<PlaceSuggestion> parseSuggestions(Map<String, dynamic> json) {
    final list = json['suggestions'];
    if (list == null) return const [];
    if (list is! List) throw const FormatException('suggestions is not a list');
    String? text(Object? o) => o is Map ? o['text'] as String? : null;
    return [
      for (final s in list)
        if (s case {'placePrediction': {'placeId': final String id} && final Map p})
          PlaceSuggestion(
            placeId: id,
            primaryText: text((p['structuredFormat'] as Map?)?['mainText']) ?? text(p['text']) ?? '',
            secondaryText: text((p['structuredFormat'] as Map?)?['secondaryText']),
          ),
    ];
  }

  static Destination parseDestination(Map<String, dynamic> json) {
    final loc = json['location'];
    final lat = loc is Map ? loc['latitude'] : null, lng = loc is Map ? loc['longitude'] : null;
    if (lat is! num || lng is! num) throw const FormatException('Place has no location');
    final name = (json['displayName'] as Map?)?['text'] as String?;
    return Destination(
      placeId: json['id'] as String?,
      name: name ?? json['formattedAddress'] as String? ?? 'Destination',
      address: json['formattedAddress'] as String?,
      location: GeoPoint(latitude: lat.toDouble(), longitude: lng.toDouble()),
    );
  }
}

final placeSearchRepositoryProvider = Provider<PlaceSearchRepository>(
  (ref) => PlacesPlaceSearchRepository(
    ref.watch(placesRemoteDataSourceProvider),
    hasApiKey: ref.watch(appConfigProvider).hasGoogleMapsKey,
  ),
);
