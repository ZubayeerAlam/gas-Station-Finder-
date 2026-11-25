import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../error/app_failure.dart';
import '../error/result.dart';
import 'geo_point.dart';

/// Abstraction over device location so it can be faked in tests.
abstract interface class LocationService {
  Future<Result<GeoPoint>> currentPosition();
  Future<bool> openAppSettings();
  Future<bool> openLocationSettings();
}

class GeolocatorLocationService implements LocationService {
  const GeolocatorLocationService();

  @override
  Future<Result<GeoPoint>> currentPosition() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return const Err(LocationFailure(
          LocationFailureReason.serviceDisabled,
          'Location services are turned off. Turn them on to find stations near you.',
          code: FailureCode.locationServiceDisabled,
        ));
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        return const Err(LocationFailure(
          LocationFailureReason.denied,
          'FuelWise needs location permission to find stations near you.',
          code: FailureCode.locationDenied,
        ));
      }
      if (permission == LocationPermission.deniedForever) {
        return const Err(LocationFailure(
          LocationFailureReason.deniedForever,
          'Location permission is blocked. Enable it in Settings to find stations near you.',
          code: FailureCode.locationDeniedForever,
        ));
      }
      Position? p;
      try {
        p = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 15),
          ),
        );
      } catch (_) {
        // A cold GPS fix can exceed the time limit; fall back to the last
        // position the OS already knows rather than failing outright.
        p = await Geolocator.getLastKnownPosition();
      }
      if (p == null) throw StateError('No position available');
      return Ok(GeoPoint(latitude: p.latitude, longitude: p.longitude));
    } catch (_) {
      return const Err(LocationFailure(
        LocationFailureReason.unavailable,
        'Could not determine your location. Please try again.',
        code: FailureCode.locationUnavailable,
      ));
    }
  }

  @override
  Future<bool> openAppSettings() => Geolocator.openAppSettings();

  @override
  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();
}

final locationServiceProvider =
    Provider<LocationService>((ref) => const GeolocatorLocationService());
