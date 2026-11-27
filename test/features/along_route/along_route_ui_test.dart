import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
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
import 'package:gas_station_finder/features/history/data/drift_fill_up_repository.dart';
import 'package:gas_station_finder/features/garage/domain/vehicle_profile.dart';

import '../../helpers/fake_fill_up_repository.dart';
import '../../helpers/fake_garage_repository.dart';
import 'along_route_fakes.dart';

class _Location implements LocationService {
  @override
  Future<Result<GeoPoint>> currentPosition() async => Ok(straightRoute.first);
  @override
  Future<bool> openAppSettings() async => true;
  @override
  Future<bool> openLocationSettings() async => true;
}

class _FixedPlan extends AlongRouteController {
  _FixedPlan(this.fixed);
  final AlongRoutePlan fixed;
  @override
  AlongRoutePlan? build() => fixed;
}

void main() {
  Future<void> pump(
    WidgetTester tester,
    String location,
    List<Override> overrides, {
    List<VehicleProfile> vehicles = const [car],
  }) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          mapsEnabledProvider.overrideWithValue(false),
          garageRepositoryProvider.overrideWithValue(FakeGarageRepository(vehicles)),
          fillUpRepositoryProvider.overrideWithValue(FakeFillUpRepository()),
          locationServiceProvider.overrideWithValue(_Location()),
          nowProvider.overrideWithValue(() => DateTime(2026, 11, 25)),
          ...overrides,
        ],
        retry: (_, _) => null,
        child: MaterialApp.router(
          theme: AppTheme.light(),
          routerConfig: buildRouter(initialLocation: location),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('ranked by total cost; strategy switch reorders; explanation expands', (tester) async {
    await pump(tester, AppRoutes.planRoute, [alongRouteControllerProvider.overrideWith(() => _FixedPlan(widgetPlan))]);

    expect(find.text('To Potsdam-ish'), findsOneWidget);
    expect(find.textContaining('3 stations on the way'), findsOneWidget);
    expect(find.text('Comparing Regular prices'), findsOneWidget);
    expect(find.text('EUR 60.62'), findsOneWidget);
    expect(find.text('EUR 63.77'), findsOneWidget);
    expect(find.text('Without a comparable price (1)'), findsOneWidget);
    double y(String name) => tester.getTopLeft(find.text(name)).dy;
    expect(y('Cheap but far'), lessThan(y('Right on route')));

    await tester.tap(find.text('Least detour').first); // segmented button (badge chip also says it)
    await tester.pumpAndSettle();
    expect(y('Right on route'), lessThan(y('Cheap but far')));

    await tester.tap(find.text('Cheap but far'));
    await tester.pumpAndSettle();
    expect(find.text('Total EUR 60.62 · saves EUR 3.15 vs the nearest station'), findsOneWidget);
  });

  testWidgets('fill level slider changes purchase size', (tester) async {
    await pump(tester, AppRoutes.planRoute, [alongRouteControllerProvider.overrideWith(() => _FixedPlan(widgetPlan))]);
    expect(find.textContaining('tank now 25% → full (37.5 L)'), findsOneWidget);
    final container = ProviderScope.containerOf(tester.element(find.byType(Slider)));
    container.read(fillLevelProvider.notifier).set(0.5);
    await tester.pumpAndSettle();
    expect(find.textContaining('tank now 50% → full (25 L)'), findsOneWidget);
    expect(find.text('EUR 40.62'), findsOneWidget); // (25 + 0.39) × 1.60
  });

  testWidgets('no vehicle → unit price comparison and prompt', (tester) async {
    await pump(tester, AppRoutes.planRoute, [
      alongRouteControllerProvider.overrideWith(() => _FixedPlan(widgetPlan)),
    ], vehicles: const []);
    expect(find.text('Comparing price per litre only'), findsOneWidget);
    expect(find.text('EUR 1.60/L'), findsOneWidget);
  });

  testWidgets('search → pick suggestion → plan is computed and shown', (tester) async {
    final places = FakePlaces(
      suggestions: const [PlaceSuggestion(placeId: 'p1', primaryText: 'Potsdam-ish', secondaryText: 'Germany')],
    );
    final planner = AlongRoutePlanner(
      routes: FakeRoutes(),
      detours: FakeDetours(),
      places: places,
      quotes: FakeQuotes(),
    );
    await pump(tester, AppRoutes.map, [
      placeSearchRepositoryProvider.overrideWithValue(places),
      alongRoutePlannerProvider.overrideWithValue(planner),
    ]);

    await tester.tap(find.text('Plan trip'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('destination')), 'P');
    await tester.enterText(find.byKey(const Key('destination')), 'Pot');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    expect(places.queries, ['Pot']); // debounced: one request
    await tester.tap(find.text('Germany'));
    await tester.pumpAndSettle();

    expect(places.sessions.toSet(), hasLength(1)); // autocomplete + details share a session
    expect(find.text('To Potsdam-ish'), findsOneWidget);
    expect(find.textContaining('2 stations on the way'), findsOneWidget);
    expect(find.text('C'), findsOneWidget);
  });

  testWidgets('trip line: fuel for the route and whether the tank reaches the destination', (tester) async {
    await pump(tester, AppRoutes.planRoute, [alongRouteControllerProvider.overrideWith(() => _FixedPlan(widgetPlan))]);
    // 20.3 km at 6.5 L/100 km ≈ 1.3 L; no fill-up in History → no price guessed.
    expect(find.text('≈ 1.3 L for this route'), findsOneWidget);
    // 25 % of 50 L = 192 km range → arrives with 25 % − 2.6 % ≈ 22 %.
    expect(find.text('Reaches the destination with about 22% left.'), findsOneWidget);

    await tester.drag(find.byType(Slider), const Offset(-1000, 0));
    await tester.pumpAndSettle();
    // Empty tank: range 0 m, the whole 20 km route is the shortfall.
    expect(
      find.text('Range at this level is about 0 m, about 20 km short of the destination: stop on the way.'),
      findsOneWidget,
    );
  });
}
