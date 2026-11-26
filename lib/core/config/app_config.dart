import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Build-time configuration injected with `--dart-define-from-file=config/dev.json`.
///
/// NOTE: the Google Maps Platform key is a *client* key. It ships inside the app
/// binary and is therefore NOT secret — it is protected only by Google Cloud
/// application restrictions (Android package + SHA-1, iOS bundle ID) and API
/// restrictions. True secrets (e.g. the Gemini API key for the assistant) must live
/// server-side in Cloud Functions and never in this class.
class AppConfig {
  const AppConfig({
    required this.googleMapsApiKey,
    required this.osrmBaseUrl,
    this.androidCertSha1 = '',
    this.openChargeMapApiKey = '',
    this.androidPackageName = 'com.fuelwise.app',
    this.iosBundleId = 'com.fuelwise.app',
    this.firebaseModeName = 'off',
    this.firebaseEmulatorHost = 'localhost',
    this.firebaseProjectId = '',
    this.firebaseApiKey = '',
    this.firebaseAppId = '',
    this.firebaseSenderId = '',
  });

  factory AppConfig.fromEnvironment() => const AppConfig(
        googleMapsApiKey: String.fromEnvironment('GOOGLE_MAPS_API_KEY'),
        osrmBaseUrl: String.fromEnvironment(
          'OSRM_BASE_URL',
          defaultValue: 'https://router.project-osrm.org',
        ),
        androidCertSha1: String.fromEnvironment('ANDROID_CERT_SHA1'),
        openChargeMapApiKey: String.fromEnvironment('OCM_API_KEY'),
        firebaseModeName: String.fromEnvironment('FIREBASE_MODE', defaultValue: 'off'),
        firebaseEmulatorHost: String.fromEnvironment('FIREBASE_EMULATOR_HOST', defaultValue: 'localhost'),
        firebaseProjectId: String.fromEnvironment('FIREBASE_PROJECT_ID'),
        firebaseApiKey: String.fromEnvironment('FIREBASE_API_KEY'),
        firebaseAppId: String.fromEnvironment('FIREBASE_APP_ID'),
        firebaseSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID'),
      );

  final String googleMapsApiKey;
  final String osrmBaseUrl;

  /// SHA-1 of the Android signing certificate (no colons). Sent as
  /// `X-Android-Cert` so an Android-restricted key works for Places REST calls.
  final String androidCertSha1;
  final String androidPackageName;
  final String iosBundleId;

  /// Open Charge Map key (free, per-app; also a client key, not a secret).
  final String openChargeMapApiKey;

  /// Community backend: `off` (default), `emulator` (local Emulator Suite,
  /// project `demo-fuelwise`) or `project` (a real Firebase project whose
  /// client options are passed as dart-defines — never committed).
  final String firebaseModeName;
  FirebaseMode get firebaseMode => FirebaseMode.parse(firebaseModeName);

  /// Emulator host: `localhost` for the iOS Simulator, `10.0.2.2` for the
  /// Android emulator, the Mac's LAN IP for a physical device.
  final String firebaseEmulatorHost;
  final String firebaseProjectId;
  final String firebaseApiKey;
  final String firebaseAppId;
  final String firebaseSenderId;

  bool get hasGoogleMapsKey => googleMapsApiKey.isNotEmpty;
  bool get hasOpenChargeMapKey => openChargeMapApiKey.isNotEmpty;
}

final appConfigProvider = Provider<AppConfig>((ref) => AppConfig.fromEnvironment());

enum FirebaseMode {
  off,
  emulator,
  project;

  static FirebaseMode parse(String v) => switch (v.trim().toLowerCase()) {
        'emulator' => emulator,
        'project' => project,
        _ => off,
      };
}
