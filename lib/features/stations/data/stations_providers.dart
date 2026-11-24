import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/dio_client.dart';
import '../domain/repositories/stations_repository.dart';
import 'places_remote_data_source.dart';
import 'places_stations_repository.dart';

/// Headers required by Places API (New). The app-identity headers let a key
/// restricted to the FuelWise Android/iOS app be used from REST calls.
@visibleForTesting
Map<String, String> placesHeaders(AppConfig config, TargetPlatform platform) {
  return {
    'X-Goog-Api-Key': config.googleMapsApiKey,
    if (platform == TargetPlatform.android) ...{
      'X-Android-Package': config.androidPackageName,
      if (config.androidCertSha1.isNotEmpty) 'X-Android-Cert': config.androidCertSha1,
    },
    if (platform == TargetPlatform.iOS) 'X-Ios-Bundle-Identifier': config.iosBundleId,
  };
}

final placesRemoteDataSourceProvider = Provider<PlacesRemoteDataSource>((ref) {
  final config = ref.watch(appConfigProvider);
  final dio = buildDio(
    baseUrl: 'https://places.googleapis.com/v1',
    headers: placesHeaders(config, defaultTargetPlatform),
  );
  ref.onDispose(dio.close);
  return PlacesRemoteDataSource(dio);
});

final stationsRepositoryProvider = Provider<StationsRepository>((ref) {
  return PlacesStationsRepository(
    ref.watch(placesRemoteDataSourceProvider),
    hasApiKey: ref.watch(appConfigProvider).hasGoogleMapsKey,
  );
});
