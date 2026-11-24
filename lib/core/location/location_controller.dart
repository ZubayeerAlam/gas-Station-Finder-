import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'geo_point.dart';
import 'location_service.dart';

/// Current device position. Errors are typed `LocationFailure`s.
class LocationController extends AsyncNotifier<GeoPoint> {
  @override
  Future<GeoPoint> build() async {
    final result = await ref.watch(locationServiceProvider).currentPosition();
    return result.getOrThrow();
  }

  /// Re-request permission/position (e.g. after the user changed settings).
  void relocate() => ref.invalidateSelf();
}

final locationControllerProvider =
    AsyncNotifierProvider<LocationController, GeoPoint>(LocationController.new);
