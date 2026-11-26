import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_failure.dart';
import '../../../core/error/result.dart';
import '../../along_route/data/places_place_search_repository.dart';
import '../../along_route/domain/along_route_models.dart';
import '../../along_route/presentation/along_route_providers.dart';
import '../../along_route/presentation/destination_search_screen.dart' show newSessionToken;
import '../data/drift_saved_trip_repository.dart';
import '../domain/saved_trip.dart';

/// Saved trips, most recently used first. Expired coordinates are purged once
/// when this is first read (Google Places 30-day limit).
final savedTripsProvider = StreamProvider<List<SavedTrip>>((ref) async* {
  final repo = ref.watch(savedTripRepositoryProvider);
  await repo.purgeExpiredCoords(ref.read(nowProvider)());
  yield* repo.watchAll();
});

class SavedTripsController {
  SavedTripsController(this._ref);

  final Ref _ref;
  final _random = Random();

  DateTime get _now => _ref.read(nowProvider)();

  String newId() => 'trip_${DateTime.now().microsecondsSinceEpoch}_${_random.nextInt(1 << 20)}';

  /// Saves the currently planned trip under [label].
  Future<Result<void>> saveCurrent(String label) async {
    final name = normalizeTripLabel(label);
    final plan = _ref.read(alongRouteControllerProvider).value;
    if (name == null || plan == null) {
      return const Err(UnknownFailure('Could not save the trip.', FailureCode.tripSaveFailed));
    }
    return _ref
        .read(savedTripRepositoryProvider)
        .save(
          tripFromPlan(
            id: newId(),
            label: name,
            destination: plan.destination,
            distanceMeters: plan.route.distanceMeters,
            durationSeconds: plan.route.durationSeconds,
            now: _now,
          ),
        );
  }

  /// Where to plan to for [trip]: stored coordinates while still allowed,
  /// otherwise a fresh Place Details lookup by place ID (one billed call).
  Future<Result<Destination>> destinationFor(SavedTrip trip) async {
    final now = _now;
    final repo = _ref.read(savedTripRepositoryProvider);
    if (trip.coordsUsable(now)) {
      await repo.save(trip.copyWith(lastUsedAt: now));
      return Ok(Destination(name: trip.label, location: trip.location!, placeId: trip.placeId));
    }
    if (trip.placeId == null) {
      return const Err(NotFoundFailure('This saved place has expired.', FailureCode.tripLocationExpired));
    }
    final resolved = await _ref
        .read(placeSearchRepositoryProvider)
        .resolve(trip.placeId!, sessionToken: newSessionToken());
    if (resolved case Ok(:final value)) {
      await repo.save(trip.copyWith(location: value.location, coordsSavedAt: now, lastUsedAt: now));
      return Ok(Destination(name: trip.label, location: value.location, placeId: trip.placeId));
    }
    return resolved;
  }

  Future<Result<void>> delete(String id) => _ref.read(savedTripRepositoryProvider).delete(id);

  Future<Result<void>> restore(SavedTrip trip) => _ref.read(savedTripRepositoryProvider).save(trip);
}

final savedTripsControllerProvider = Provider<SavedTripsController>(SavedTripsController.new);
