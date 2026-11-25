import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/location/geo_point.dart';
import '../domain/entities/station.dart';

/// Stores only what Google's Places policies allow: place id (indefinitely)
/// and coordinates (≤ [maxAge], then deleted). Names, addresses, hours and
/// prices are never written to disk.
class PlaceLocationCache {
  PlaceLocationCache(this._db, {this.maxAge = const Duration(days: 30)});

  final AppDatabase _db;
  final Duration maxAge;

  static const offlineName = 'Saved station';

  Future<void> save(List<Station> stations, DateTime now) async {
    await _db.batch((b) {
      for (final s in stations) {
        b.insert(
          _db.placeLocations,
          PlaceLocationsCompanion.insert(
            placeId: s.id,
            lat: s.location.latitude,
            lng: s.location.longitude,
            fetchedAt: now,
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
    await purge(now);
  }

  /// Deletes coordinates older than [maxAge].
  Future<int> purge(DateTime now) =>
      (_db.delete(_db.placeLocations)..where((r) => r.fetchedAt.isSmallerThanValue(now.subtract(maxAge)))).go();

  /// Saved stations within [radiusMeters] of [center], nearest first.
  Future<List<Station>> near(GeoPoint center, double radiusMeters, DateTime now) async {
    await purge(now);
    final rows = await _db.select(_db.placeLocations).get();
    final out = [
      for (final r in rows)
        if (GeoPoint(latitude: r.lat, longitude: r.lng) case final p when center.distanceTo(p) <= radiusMeters)
          Station(id: r.placeId, name: offlineName, location: p, offlineSavedAt: r.fetchedAt),
    ]..sort((a, b) => center.distanceTo(a.location).compareTo(center.distanceTo(b.location)));
    return out;
  }
}
