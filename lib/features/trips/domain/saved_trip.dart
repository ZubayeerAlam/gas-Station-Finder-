import '../../../core/error/result.dart';
import '../../../core/location/geo_point.dart';
import '../../along_route/domain/along_route_models.dart';

/// Google Places terms: place IDs may be stored indefinitely, coordinates for
/// at most 30 consecutive days, other place content (names, addresses) not at
/// all. A saved trip therefore keeps only the user's own label, the place ID,
/// and coordinates until they expire.
const kSavedCoordsMaxAge = Duration(days: 30);

const kMaxSavedTrips = 20;
const kMaxTripLabelLength = 40;

/// A destination the user saved under their own name ("Home", "Office").
class SavedTrip {
  const SavedTrip({
    required this.id,
    required this.label,
    required this.createdAt,
    required this.lastUsedAt,
    this.placeId,
    this.location,
    this.coordsSavedAt,
    this.lastDistanceMeters,
    this.lastDurationSeconds,
  });

  final String id;

  /// Typed by the user, never copied from Places.
  final String label;
  final String? placeId;
  final GeoPoint? location;
  final DateTime? coordsSavedAt;

  /// Last planned route (FuelWise's own OSRM result, not Places content).
  final double? lastDistanceMeters;
  final double? lastDurationSeconds;
  final DateTime createdAt;
  final DateTime lastUsedAt;

  /// Coordinates are present and younger than [kSavedCoordsMaxAge].
  bool coordsUsable(DateTime now) =>
      location != null && coordsSavedAt != null && now.difference(coordsSavedAt!) < kSavedCoordsMaxAge;

  /// Can still be planned at all (fresh coordinates or a place ID to look up).
  bool canPlan(DateTime now) => coordsUsable(now) || placeId != null;

  SavedTrip copyWith({
    String? label,
    GeoPoint? location,
    DateTime? coordsSavedAt,
    double? lastDistanceMeters,
    double? lastDurationSeconds,
    DateTime? lastUsedAt,
    bool clearCoords = false,
  }) => SavedTrip(
    id: id,
    label: label ?? this.label,
    placeId: placeId,
    location: clearCoords ? null : location ?? this.location,
    coordsSavedAt: clearCoords ? null : coordsSavedAt ?? this.coordsSavedAt,
    lastDistanceMeters: lastDistanceMeters ?? this.lastDistanceMeters,
    lastDurationSeconds: lastDurationSeconds ?? this.lastDurationSeconds,
    createdAt: createdAt,
    lastUsedAt: lastUsedAt ?? this.lastUsedAt,
  );
}

/// Trims and validates a label; null when it is not acceptable.
String? normalizeTripLabel(String raw) {
  final t = raw.trim().replaceAll(RegExp(r'\s+'), ' ');
  if (t.isEmpty || t.length > kMaxTripLabelLength) return null;
  return t;
}

/// Builds a trip to save from a planned destination.
SavedTrip tripFromPlan({
  required String id,
  required String label,
  required Destination destination,
  required double distanceMeters,
  required double durationSeconds,
  required DateTime now,
}) => SavedTrip(
  id: id,
  label: label,
  placeId: destination.placeId,
  location: destination.location,
  coordsSavedAt: now,
  lastDistanceMeters: distanceMeters,
  lastDurationSeconds: durationSeconds,
  createdAt: now,
  lastUsedAt: now,
);

abstract interface class SavedTripRepository {
  /// Most recently used first.
  Stream<List<SavedTrip>> watchAll();

  /// Inserts or replaces. A trip with the same place ID replaces the older
  /// one; beyond [kMaxSavedTrips] the least recently used are dropped.
  Future<Result<void>> save(SavedTrip trip);
  Future<Result<void>> delete(String id);

  /// Removes coordinates older than [kSavedCoordsMaxAge] (policy).
  Future<Result<void>> purgeExpiredCoords(DateTime now);
}
