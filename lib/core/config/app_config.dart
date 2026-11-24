import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Build-time configuration injected with `--dart-define-from-file=config/dev.json`.
///
/// NOTE: the Google Maps Platform key is a *client* key. It ships inside the app
/// binary and is therefore NOT secret — it is protected only by Google Cloud
/// application restrictions (Android package + SHA-1, iOS bundle ID) and API
/// restrictions. True secrets (e.g. the Claude API key in Phase 2) must live
/// server-side in Cloud Functions and never in this class.
class AppConfig {
  const AppConfig({
    required this.googleMapsApiKey,
    required this.osrmBaseUrl,
    this.androidCertSha1 = '',
    this.androidPackageName = 'com.example.gas_station_finder',
    this.iosBundleId = 'com.example.gasStationFinder',
  });

  factory AppConfig.fromEnvironment() => const AppConfig(
        googleMapsApiKey: String.fromEnvironment('GOOGLE_MAPS_API_KEY'),
        osrmBaseUrl: String.fromEnvironment(
          'OSRM_BASE_URL',
          defaultValue: 'https://router.project-osrm.org',
        ),
        androidCertSha1: String.fromEnvironment('ANDROID_CERT_SHA1'),
      );

  final String googleMapsApiKey;
  final String osrmBaseUrl;

  /// SHA-1 of the Android signing certificate (no colons). Sent as
  /// `X-Android-Cert` so an Android-restricted key works for Places REST calls.
  final String androidCertSha1;
  final String androidPackageName;
  final String iosBundleId;

  bool get hasGoogleMapsKey => googleMapsApiKey.isNotEmpty;
}

final appConfigProvider = Provider<AppConfig>((ref) => AppConfig.fromEnvironment());
