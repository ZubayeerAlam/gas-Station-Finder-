import 'dart:async';

import 'package:gas_station_finder/core/error/result.dart';
import 'package:gas_station_finder/features/trips/domain/saved_trip.dart';

class FakeSavedTripRepository implements SavedTripRepository {
  FakeSavedTripRepository([List<SavedTrip> initial = const []]) : items = [...initial];

  final List<SavedTrip> items;
  final _changes = StreamController<void>.broadcast();
  int purges = 0;

  List<SavedTrip> get _sorted => [...items]..sort((a, b) => b.lastUsedAt.compareTo(a.lastUsedAt));

  @override
  Stream<List<SavedTrip>> watchAll() => Stream.multi((c) {
    c.add(_sorted);
    final sub = _changes.stream.listen((_) => c.add(_sorted));
    c.onCancel = sub.cancel;
  });

  @override
  Future<Result<void>> save(SavedTrip trip) async {
    items.removeWhere((t) => t.id == trip.id || (trip.placeId != null && t.placeId == trip.placeId));
    items.add(trip);
    _changes.add(null);
    return const Ok(null);
  }

  @override
  Future<Result<void>> delete(String id) async {
    items.removeWhere((t) => t.id == id);
    _changes.add(null);
    return const Ok(null);
  }

  @override
  Future<Result<void>> purgeExpiredCoords(DateTime now) async {
    purges++;
    return const Ok(null);
  }
}
