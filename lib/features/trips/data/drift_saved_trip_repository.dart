import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/error/app_failure.dart';
import '../../../core/error/result.dart';
import '../../../core/location/geo_point.dart';
import '../domain/saved_trip.dart';

class DriftSavedTripRepository implements SavedTripRepository {
  DriftSavedTripRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<List<SavedTrip>> watchAll() {
    final q = _db.select(_db.savedTrips)..orderBy([(t) => OrderingTerm.desc(t.lastUsedAt)]);
    return q.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Future<Result<void>> save(SavedTrip t) => _guard(
    () => _db.transaction(() async {
      if (t.placeId != null) {
        await (_db.delete(_db.savedTrips)..where((r) => r.placeId.equals(t.placeId!) & r.id.isNotValue(t.id))).go();
      }
      await _db
          .into(_db.savedTrips)
          .insertOnConflictUpdate(
            SavedTripsCompanion.insert(
              id: t.id,
              label: t.label,
              placeId: Value(t.placeId),
              lat: Value(t.location?.latitude),
              lng: Value(t.location?.longitude),
              coordsSavedAt: Value(t.location == null ? null : t.coordsSavedAt),
              lastDistanceMeters: Value(t.lastDistanceMeters),
              lastDurationSeconds: Value(t.lastDurationSeconds),
              createdAt: t.createdAt,
              lastUsedAt: t.lastUsedAt,
            ),
          );
      final extra = await (_db.select(_db.savedTrips)
            ..orderBy([(r) => OrderingTerm.desc(r.lastUsedAt)])
            ..limit(1000, offset: kMaxSavedTrips))
          .get();
      if (extra.isNotEmpty) {
        await (_db.delete(_db.savedTrips)..where((r) => r.id.isIn(extra.map((e) => e.id)))).go();
      }
    }),
  );

  @override
  Future<Result<void>> delete(String id) => _guard(() => (_db.delete(_db.savedTrips)..where((t) => t.id.equals(id))).go());

  @override
  Future<Result<void>> purgeExpiredCoords(DateTime now) => _guard(
    () => (_db.update(_db.savedTrips)..where((t) => t.coordsSavedAt.isSmallerOrEqualValue(now.subtract(kSavedCoordsMaxAge))))
        .write(const SavedTripsCompanion(lat: Value(null), lng: Value(null), coordsSavedAt: Value(null))),
  );

  static SavedTrip _toDomain(SavedTripRow r) => SavedTrip(
    id: r.id,
    label: r.label,
    placeId: r.placeId,
    location: r.lat != null && r.lng != null ? GeoPoint(latitude: r.lat!, longitude: r.lng!) : null,
    coordsSavedAt: r.lat != null && r.lng != null ? r.coordsSavedAt : null,
    lastDistanceMeters: r.lastDistanceMeters,
    lastDurationSeconds: r.lastDurationSeconds,
    createdAt: r.createdAt,
    lastUsedAt: r.lastUsedAt,
  );

  static Future<Result<void>> _guard(Future<void> Function() body) async {
    try {
      await body();
      return const Ok(null);
    } catch (_) {
      return const Err(UnknownFailure('Could not save the trip. Please try again.', FailureCode.tripSaveFailed));
    }
  }
}

final savedTripRepositoryProvider = Provider<SavedTripRepository>(
  (ref) => DriftSavedTripRepository(ref.watch(appDatabaseProvider)),
);
