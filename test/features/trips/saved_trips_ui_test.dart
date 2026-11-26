import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gas_station_finder/core/error/result.dart';
import 'package:gas_station_finder/core/location/geo_point.dart';
import 'package:gas_station_finder/core/location/location_service.dart';
import 'package:gas_station_finder/core/router/app_router.dart';
import 'package:gas_station_finder/core/theme/app_theme.dart';
import 'package:gas_station_finder/features/along_route/data/places_place_search_repository.dart';
import 'package:gas_station_finder/features/along_route/domain/along_route_models.dart';
import 'package:gas_station_finder/features/along_route/domain/along_route_planner.dart';
import 'package:gas_station_finder/features/along_route/presentation/along_route_providers.dart';
import 'package:gas_station_finder/features/garage/data/drift_garage_repository.dart';
import 'package:gas_station_finder/features/trips/data/drift_saved_trip_repository.dart';
import 'package:gas_station_finder/features/trips/domain/saved_trip.dart';
import 'package:gas_station_finder/l10n/app_localizations.dart';

import '../../helpers/fake_garage_repository.dart';
import '../../helpers/fake_saved_trip_repository.dart';
import '../along_route/along_route_fakes.dart';

final now = DateTime(2026, 11, 25, 9);

SavedTrip office({DateTime? coordsAt}) => SavedTrip(
  id: 't1',
  label: 'Office',
  placeId: 'p1',
  location: const GeoPoint(latitude: 52.5, longitude: 13.3),
  coordsSavedAt: coordsAt ?? now,
  lastDistanceMeters: 8200,
  lastDurationSeconds: 1500,
  createdAt: DateTime(2026, 1, 1),
  lastUsedAt: now,
);

class _Location implements LocationService {
  @override
  Future<Result<GeoPoint>> currentPosition() async => Ok(straightRoute.first);
  @override
  Future<bool> openAppSettings() async => true;
  @override
  Future<bool> openLocationSettings() async => true;
}

class _FixedPlan extends AlongRouteController {
  @override
  AlongRoutePlan? build() => widgetPlan;
}

void main() {
  Future<FakeSavedTripRepository> pump(
    WidgetTester tester,
    String location, {
    List<SavedTrip> trips = const [],
    FakePlaces? places,
    bool fixedPlan = false,
    Locale? locale,
    double textScale = 1,
  }) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
    final repo = FakeSavedTripRepository(trips);
    final p = places ?? FakePlaces();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          mapsEnabledProvider.overrideWithValue(false),
          garageRepositoryProvider.overrideWithValue(FakeGarageRepository(const [car])),
          nowProvider.overrideWithValue(() => now),
          locationServiceProvider.overrideWithValue(_Location()),
          savedTripRepositoryProvider.overrideWithValue(repo),
          placeSearchRepositoryProvider.overrideWithValue(p),
          alongRoutePlannerProvider.overrideWithValue(
            AlongRoutePlanner(routes: FakeRoutes(), detours: FakeDetours(), places: p, quotes: FakeQuotes()),
          ),
          if (fixedPlan) alongRouteControllerProvider.overrideWith(_FixedPlan.new),
        ],
        retry: (_, _) => null,
        child: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
          child: MaterialApp.router(
            theme: AppTheme.light(),
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: buildRouter(initialLocation: location),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return repo;
  }

  testWidgets('no saved trips: only the search hint', (tester) async {
    await pump(tester, AppRoutes.plan);
    expect(find.text('Saved trips'), findsNothing);
  });

  testWidgets('tap a saved trip plans it without a Places lookup', (tester) async {
    final places = FakePlaces();
    await pump(tester, AppRoutes.plan, trips: [office()], places: places);
    expect(find.text('Saved trips'), findsOneWidget);
    expect(find.textContaining('Last time:'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('savedTrip-t1')));
    await tester.pumpAndSettle();
    expect(find.text('To Office'), findsOneWidget);
    expect(places.sessions, isEmpty);
  });

  testWidgets('expired coordinates say they will be looked up again', (tester) async {
    await pump(tester, AppRoutes.plan, trips: [office(coordsAt: now.subtract(const Duration(days: 40)))]);
    expect(find.textContaining('Location will be looked up again'), findsOneWidget);
  });

  testWidgets('delete then Undo restores the trip', (tester) async {
    final repo = await pump(tester, AppRoutes.plan, trips: [office()]);
    await tester.tap(find.byTooltip('Remove saved trip'));
    await tester.pumpAndSettle();
    expect(repo.items, isEmpty);
    expect(find.byKey(const ValueKey('savedTrip-t1')), findsNothing);
    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(repo.items.single.id, 't1');
    expect(find.byKey(const ValueKey('savedTrip-t1')), findsOneWidget);
  });

  testWidgets('save dialog validates and stores the label', (tester) async {
    final repo = await pump(tester, AppRoutes.planRoute, fixedPlan: true);
    await tester.tap(find.byKey(const Key('saveTrip')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a name (up to 40 characters)'), findsOneWidget);
    expect(repo.items, isEmpty);
    await tester.enterText(find.byKey(const Key('tripLabel')), '  Gym ');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(repo.items.single.label, 'Gym');
    expect(find.text('Trip saved'), findsOneWidget);
  });

  testWidgets('Bengali at 200% text meets tap-target and contrast guidelines', (tester) async {
    await pump(tester, AppRoutes.plan, trips: [office()], locale: const Locale('bn'), textScale: 2);
    final bn = lookupAppLocalizations(const Locale('bn'));
    expect(find.text(bn.savedTripsTitle), findsOneWidget);
    expect(tester.takeException(), isNull);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
  });
}
