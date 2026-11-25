import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gas_station_finder/core/database/app_database.dart';
import 'package:gas_station_finder/core/error/app_failure.dart';
import 'package:gas_station_finder/core/error/result.dart';
import 'package:gas_station_finder/core/location/geo_point.dart';
import 'package:gas_station_finder/features/stations/data/offline_fallback_stations_repository.dart';
import 'package:gas_station_finder/features/stations/data/place_location_cache.dart';
import 'package:gas_station_finder/features/stations/domain/entities/station.dart';
import 'package:gas_station_finder/features/stations/domain/repositories/stations_repository.dart';
import 'package:gas_station_finder/features/stations/presentation/map_screen.dart';

const here = GeoPoint(latitude: 52.52, longitude: 13.405);
const near = Station(id: 'near', name: 'Aral Mitte', address: 'Street 1', location: GeoPoint(latitude: 52.521, longitude: 13.406));
const far = Station(id: 'far', name: 'Far away', location: GeoPoint(latitude: 52.60, longitude: 13.405)); // ~9 km

class _Live implements StationsRepository {
  Result<List<Station>> next = const Ok([near, far]);
  @override
  Future<Result<List<Station>>> nearbyStations(GeoPoint center, {double radiusMeters = 5000}) async => next;
  @override
  Future<Result<StationDetails>> stationDetails(String stationId) async => const Err(NetworkFailure());
}

void main() {
  late AppDatabase db;
  late PlaceLocationCache cache;
  late _Live live;
  var now = DateTime(2026, 11, 25, 12);
  late OfflineFallbackStationsRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    cache = PlaceLocationCache(db);
    live = _Live();
    now = DateTime(2026, 11, 25, 12);
    repo = OfflineFallbackStationsRepository(live, cache, clock: () => now);
  });
  tearDown(() => db.close());

  test('live results pass through and only id + position are stored', () async {
    final r = await repo.nearbyStations(here);
    expect(r.getOrThrow(), [near, far]);
    final rows = await db.select(db.placeLocations).get();
    expect(rows.map((r) => r.placeId), unorderedEquals(['near', 'far']));
    // The table has no columns for names/addresses/prices (Places policy).
    expect(db.placeLocations.$columns.map((c) => c.name), unorderedEquals(['place_id', 'lat', 'lng', 'fetched_at']));
  });

  test('offline: saved positions within the radius, nearest first, no names', () async {
    await repo.nearbyStations(here);
    live.next = const Err(NetworkFailure());
    now = now.add(const Duration(hours: 2));
    final r = (await repo.nearbyStations(here)).getOrThrow();
    expect(r.map((s) => s.id), ['near']);
    expect(r.single.name, PlaceLocationCache.offlineName);
    expect(r.single.address, isNull);
    expect(r.single.offlineSavedAt, DateTime(2026, 11, 25, 12));
  });

  test('timeouts fall back too; config / server errors do not', () async {
    await repo.nearbyStations(here);
    live.next = const Err(TimeoutFailure());
    expect((await repo.nearbyStations(here)).isOk, isTrue);
    live.next = const Err(ConfigFailure('no key'));
    expect(await repo.nearbyStations(here), isA<Err<List<Station>>>());
    live.next = const Err(ServerFailure('403', statusCode: 403));
    expect(await repo.nearbyStations(here), isA<Err<List<Station>>>());
  });

  test('coordinates are deleted after 30 days', () async {
    await repo.nearbyStations(here);
    live.next = const Err(NetworkFailure());
    now = now.add(const Duration(days: 30, minutes: 1));
    final r = await repo.nearbyStations(here);
    expect(r, isA<Err<List<Station>>>()); // nothing left → the original error
    expect(await db.select(db.placeLocations).get(), isEmpty);
  });

  test('empty cache keeps the network error', () async {
    live.next = const Err(NetworkFailure());
    expect(await repo.nearbyStations(here), isA<Err<List<Station>>>());
  });

  test('offline banner text', () {
    final saved = Station(id: 'x', name: 'Saved station', location: here, offlineSavedAt: DateTime(2026, 11, 25, 10));
    final s = fuelStatus(AsyncData([saved]), now: DateTime(2026, 11, 25, 12));
    expect(s.text, contains('Offline · 1 saved station positions (2 h ago)'));
    expect(s.icon, Icons.cloud_off_rounded);
    expect(s.showRetry, isTrue);
  });
}
