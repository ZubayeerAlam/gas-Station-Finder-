import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gas_station_finder/core/database/app_database.dart';
import 'package:gas_station_finder/core/error/app_failure.dart';
import 'package:gas_station_finder/core/error/result.dart';
import 'package:gas_station_finder/core/location/geo_point.dart';
import 'package:gas_station_finder/features/along_route/data/places_place_search_repository.dart';
import 'package:gas_station_finder/features/along_route/domain/along_route_models.dart';
import 'package:gas_station_finder/features/along_route/presentation/along_route_providers.dart';
import 'package:gas_station_finder/features/trips/data/drift_saved_trip_repository.dart';
import 'package:gas_station_finder/features/trips/domain/saved_trip.dart';
import 'package:gas_station_finder/features/trips/presentation/saved_trips_providers.dart';

import '../../helpers/fake_saved_trip_repository.dart';
import '../along_route/along_route_fakes.dart';

final now = DateTime(2026, 11, 27, 9);
const office = GeoPoint(latitude: 23.7925, longitude: 90.4078);

SavedTrip trip(String id, {String? placeId = 'p1', DateTime? coordsAt, DateTime? used, GeoPoint? at = office}) =>
    SavedTrip(
      id: id,
      label: 'Office $id',
      placeId: placeId,
      location: at,
      coordsSavedAt: at == null ? null : coordsAt ?? now,
      lastDistanceMeters: 8200,
      lastDurationSeconds: 1500,
      createdAt: DateTime(2026, 1, 1),
      lastUsedAt: used ?? now,
    );

void main() {
  group('domain', () {
    test('coordinates usable for under 30 days', () {
      final t = trip('a', coordsAt: now.subtract(const Duration(days: 29, hours: 23)));
      expect(t.coordsUsable(now), isTrue);
      expect(trip('a', coordsAt: now.subtract(const Duration(days: 30))).coordsUsable(now), isFalse);
      expect(trip('a', at: null).coordsUsable(now), isFalse);
    });

    test('canPlan needs fresh coords or a place id', () {
      final old = now.subtract(const Duration(days: 40));
      expect(trip('a', coordsAt: old).canPlan(now), isTrue);
      expect(trip('a', coordsAt: old, placeId: null).canPlan(now), isFalse);
    });

    test('labels are trimmed, collapsed and limited', () {
      expect(normalizeTripLabel('  Home   sweet  '), 'Home sweet');
      expect(normalizeTripLabel('   '), isNull);
      expect(normalizeTripLabel('x' * 41), isNull);
      expect(normalizeTripLabel('বাসা'), 'বাসা');
    });

    test('tripFromPlan keeps only label, place id, coords and our route numbers', () {
      final t = tripFromPlan(
        id: 'n',
        label: 'Office',
        destination: const Destination(
          name: 'Google name',
          location: office,
          placeId: 'pid',
          address: 'Google address',
        ),
        distanceMeters: 8000,
        durationSeconds: 1200,
        now: now,
      );
      expect(
        (t.label, t.placeId, t.location, t.coordsSavedAt, t.lastDistanceMeters),
        ('Office', 'pid', office, now, 8000),
      );
    });
  });

  group('drift repository', () {
    late AppDatabase db;
    late DriftSavedTripRepository repo;
    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      repo = DriftSavedTripRepository(db);
    });
    tearDown(() => db.close());

    test('round-trip, most recently used first, delete', () async {
      await repo.save(trip('a', placeId: 'pa', used: DateTime(2026, 11, 1)));
      await repo.save(trip('b', placeId: 'pb', used: DateTime(2026, 11, 20)));
      final all = await repo.watchAll().first;
      expect(all.map((t) => t.id), ['b', 'a']);
      expect(all.first.location, office);
      expect(all.first.label, 'Office b');
      await repo.delete('b');
      expect((await repo.watchAll().first).map((t) => t.id), ['a']);
    });

    test('same place id replaces the older entry', () async {
      await repo.save(trip('a', placeId: 'same'));
      await repo.save(trip('b', placeId: 'same'));
      expect((await repo.watchAll().first).map((t) => t.id), ['b']);
    });

    test('keeps only the 20 most recently used', () async {
      for (var i = 0; i < kMaxSavedTrips + 3; i++) {
        await repo.save(
          trip(
            't$i',
            placeId: 'p$i',
            used: DateTime(2026, 1, 1).add(Duration(days: i)),
          ),
        );
      }
      final all = await repo.watchAll().first;
      expect(all, hasLength(kMaxSavedTrips));
      expect(all.last.id, 't3');
    });

    test('purge drops expired coordinates but keeps the trip and place id', () async {
      await repo.save(trip('old', placeId: 'po', coordsAt: now.subtract(const Duration(days: 31))));
      await repo.save(trip('new', placeId: 'pn', coordsAt: now.subtract(const Duration(days: 2))));
      await repo.purgeExpiredCoords(now);
      final byId = {for (final t in await repo.watchAll().first) t.id: t};
      expect(byId['old']!.location, isNull);
      expect(byId['old']!.coordsSavedAt, isNull);
      expect(byId['old']!.placeId, 'po');
      expect(byId['new']!.location, office);
    });

    test('wipeAll (delete device data) also clears saved trips', () async {
      await repo.save(trip('a'));
      await db.wipeAll();
      expect(await repo.watchAll().first, isEmpty);
    });
  });

  test('upgrading a v4 database adds saved_trips and keeps existing data', () async {
    final fresh = AppDatabase(NativeDatabase.memory());
    final rows = await fresh
        .customSelect(
          "SELECT sql FROM sqlite_master WHERE type = 'table' AND name NOT LIKE 'sqlite_%' AND name != 'saved_trips'",
        )
        .get();
    final v4Sql = rows.map((r) => r.read<String>('sql')).toList();
    await fresh.close();
    expect(v4Sql, hasLength(5));

    final db = AppDatabase(
      NativeDatabase.memory(
        setup: (raw) {
          if (raw.userVersion != 0) return;
          for (final sql in v4Sql) {
            raw.execute(sql);
          }
          raw.execute("INSERT INTO settings (key, value) VALUES ('locale', 'bn')");
          raw.userVersion = 4;
        },
      ),
    );
    addTearDown(db.close);
    expect(await db.readSetting('locale'), 'bn');
    final repo = DriftSavedTripRepository(db);
    expect((await repo.save(trip('a'))).isOk, isTrue);
    expect(await repo.watchAll().first, hasLength(1));
    expect(await db.customSelect('PRAGMA user_version').map((r) => r.read<int>('user_version')).getSingle(), 6);
  });

  group('controller', () {
    ProviderContainer container(FakeSavedTripRepository repo, FakePlaces places, {AlongRoutePlan? plan}) {
      final c = ProviderContainer(
        overrides: [
          savedTripRepositoryProvider.overrideWithValue(repo),
          placeSearchRepositoryProvider.overrideWithValue(places),
          nowProvider.overrideWithValue(() => now),
          if (plan != null) alongRouteControllerProvider.overrideWith(() => _Fixed(plan)),
        ],
      );
      addTearDown(c.dispose);
      return c;
    }

    test('fresh coordinates: no Places call, label used as name, marked used', () async {
      final repo = FakeSavedTripRepository([trip('a', used: DateTime(2026, 1, 1))]);
      final places = FakePlaces();
      final c = container(repo, places);
      final r = await c.read(savedTripsControllerProvider).destinationFor(repo.items.single);
      final d = (r as Ok<Destination>).value;
      expect((d.name, d.location, d.placeId), ('Office a', office, 'p1'));
      expect(places.sessions, isEmpty);
      expect(repo.items.single.lastUsedAt, now);
    });

    test('expired coordinates: one Place Details lookup by id, coords refreshed', () async {
      final repo = FakeSavedTripRepository([trip('a', coordsAt: now.subtract(const Duration(days: 45)))]);
      final places = FakePlaces();
      final c = container(repo, places);
      final r = await c.read(savedTripsControllerProvider).destinationFor(repo.items.single);
      expect((r as Ok<Destination>).value.location, dest.location);
      expect(r.value.name, 'Office a', reason: 'Places name is not shown or stored');
      expect(places.sessions, hasLength(1));
      expect((repo.items.single.location, repo.items.single.coordsSavedAt), (dest.location, now));
    });

    test('expired and no place id: typed error', () async {
      final repo = FakeSavedTripRepository([
        trip('a', placeId: null, coordsAt: now.subtract(const Duration(days: 45))),
      ]);
      final c = container(repo, FakePlaces());
      final r = await c.read(savedTripsControllerProvider).destinationFor(repo.items.single);
      expect((r as Err).failure.code, FailureCode.tripLocationExpired);
    });

    test('saveCurrent stores the planned trip under the user label', () async {
      final repo = FakeSavedTripRepository();
      final c = container(repo, FakePlaces(), plan: widgetPlan);
      expect((await c.read(savedTripsControllerProvider).saveCurrent('  Office ')).isOk, isTrue);
      final saved = repo.items.single;
      expect(
        (saved.label, saved.location, saved.lastDistanceMeters),
        ('Office', widgetPlan.destination.location, widgetPlan.route.distanceMeters),
      );
      expect((await c.read(savedTripsControllerProvider).saveCurrent('   ')).isOk, isFalse);
    });

    test('provider purges expired coordinates on first read', () async {
      final repo = FakeSavedTripRepository([trip('a')]);
      final c = container(repo, FakePlaces());
      final sub = c.listen(savedTripsProvider, (_, _) {});
      addTearDown(sub.close);
      expect(await c.read(savedTripsProvider.future), hasLength(1));
      expect(repo.purges, 1);
    });
  });
}

class _Fixed extends AlongRouteController {
  _Fixed(this._plan);
  final AlongRoutePlan _plan;
  @override
  AlongRoutePlan? build() => _plan;
}
