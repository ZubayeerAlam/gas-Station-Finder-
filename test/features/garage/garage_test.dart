import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gas_station_finder/core/database/app_database.dart';
import 'package:gas_station_finder/core/router/app_router.dart';
import 'package:gas_station_finder/core/theme/app_theme.dart';
import 'package:gas_station_finder/features/garage/data/drift_garage_repository.dart';
import 'package:gas_station_finder/features/garage/domain/consumption_unit.dart';
import 'package:gas_station_finder/features/garage/domain/vehicle_profile.dart';
import 'package:gas_station_finder/features/garage/presentation/vehicle_form_screen.dart';

import '../../helpers/fake_garage_repository.dart';

AppDatabase memoryDb() => AppDatabase(NativeDatabase.memory());

const corolla = VehicleProfile(
  id: 'a',
  name: 'Corolla',
  energyType: EnergyType.fuel,
  consumptionPer100Km: 6.5,
  capacity: 50,
  preferredFuelType: 'REGULAR_UNLEADED',
);
const model3 = VehicleProfile(
  id: 'b',
  name: 'Model 3',
  energyType: EnergyType.electric,
  consumptionPer100Km: 15,
  capacity: 60,
  chargingEfficiency: 0.9,
);

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  group('DriftGarageRepository', () {
    late AppDatabase db;
    late DriftGarageRepository repo;
    setUp(() {
      db = memoryDb();
      repo = DriftGarageRepository(db);
    });
    tearDown(() => db.close());

    test('save round-trips all fields and first vehicle becomes active', () async {
      expect((await repo.save(model3)).isOk, isTrue);
      expect(await repo.watchVehicles().first, [model3]);
      expect(await repo.watchActiveVehicleId().first, 'b');
    });

    test('second vehicle does not steal active; update keeps order', () async {
      await repo.save(corolla);
      await Future<void>.delayed(const Duration(milliseconds: 2));
      await repo.save(model3);
      await repo.save(corolla.copyWith(name: 'Corolla Hybrid', consumptionPer100Km: 4.5));
      final list = await repo.watchVehicles().first;
      expect(list.map((v) => v.name), ['Corolla Hybrid', 'Model 3']);
      expect(list.first.consumptionPer100Km, 4.5);
      expect(await repo.watchActiveVehicleId().first, 'a');
    });

    test('deleting the active vehicle activates the next one, then none', () async {
      await repo.save(corolla);
      await Future<void>.delayed(const Duration(milliseconds: 2));
      await repo.save(model3);
      await repo.delete('a');
      expect(await repo.watchActiveVehicleId().first, 'b');
      await repo.delete('b');
      expect(await repo.watchActiveVehicleId().first, isNull);
      expect(await repo.watchVehicles().first, isEmpty);
    });

    test('setActiveVehicle switches selection', () async {
      await repo.save(corolla);
      await repo.save(model3);
      await repo.setActiveVehicle('b');
      expect(await repo.watchActiveVehicleId().first, 'b');
    });
  });

  group('ConsumptionUnit', () {
    test('every unit round-trips', () {
      for (final u in ConsumptionUnit.values) {
        expect(u.fromPer100Km(u.toPer100Km(7.3)), closeTo(7.3, 1e-9), reason: u.label);
      }
    });

    test('known conversions', () {
      expect(ConsumptionUnit.kmPerLitre.toPer100Km(12.5), closeTo(8, 1e-9));
      expect(ConsumptionUnit.whPerKm.toPer100Km(150), closeTo(15, 1e-9));
      expect(ConsumptionUnit.whPerKm.fromPer100Km(15), closeTo(150, 1e-9));
    });

    test('units are grouped by energy type', () {
      expect(ConsumptionUnit.forType(EnergyType.fuel), hasLength(4));
      expect(ConsumptionUnit.forType(EnergyType.electric), hasLength(3));
    });
  });

  test('parsePositive accepts comma decimals and rejects junk', () {
    expect(parsePositive('6,5'), 6.5);
    expect(parsePositive(' 12 '), 12);
    expect(parsePositive('0'), isNull);
    expect(parsePositive('-3'), isNull);
    expect(parsePositive('abc'), isNull);
  });

  group('Garage UI (fake repository via DI)', () {
    Future<FakeGarageRepository> pumpApp(WidgetTester tester, String location,
        [List<VehicleProfile> initial = const []]) async {
      final repo = FakeGarageRepository(initial);
      await tester.pumpWidget(ProviderScope(
        overrides: [garageRepositoryProvider.overrideWithValue(repo)],
        retry: (_, _) => null,
        child: MaterialApp.router(theme: AppTheme.light(), routerConfig: buildRouter(initialLocation: location)),
      ));
      await tester.pumpAndSettle();
      return repo;
    }

    testWidgets('empty garage → add a vehicle in km/L → saved as L/100 km and active', (tester) async {
      final repo = await pumpApp(tester, AppRoutes.garage);
      expect(find.text('No vehicles yet'), findsOneWidget);

      await tester.tap(find.text('Add vehicle').first);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).first, 'Axio');
      await tester.tap(find.text('L/100 km'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('km/L').last);
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('consumption')), '12,5');
      await tester.enterText(find.byKey(const Key('capacity')), '40');
      await tester.tap(find.text('Save vehicle'));
      await tester.pumpAndSettle();

      expect(repo.vehicles.single.consumptionPer100Km, closeTo(8, 1e-9));
      expect(find.text('Axio'), findsOneWidget);
      expect(find.textContaining('8.0 L/100 km'), findsOneWidget);
      expect(find.textContaining('Full tank range ≈ 500 km'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    });

    testWidgets('switching the unit converts the entered value', (tester) async {
      await pumpApp(tester, AppRoutes.vehicleNew);
      await tester.enterText(find.byKey(const Key('consumption')), '8');
      await tester.tap(find.text('L/100 km'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('km/L').last);
      await tester.pumpAndSettle();
      expect(find.widgetWithText(TextFormField, '12.5'), findsOneWidget);
    });

    testWidgets('validation blocks empty/invalid input', (tester) async {
      final repo = await pumpApp(tester, AppRoutes.vehicleNew);
      await tester.enterText(find.byKey(const Key('consumption')), '0');
      await tester.tap(find.text('Save vehicle'));
      await tester.pumpAndSettle();
      expect(find.text('Enter a name'), findsOneWidget);
      expect(find.text('Enter a positive number'), findsNWidgets(2));
      expect(repo.vehicles, isEmpty);
    });

    testWidgets('EV form saves efficiency as a fraction; deep-linked form returns to garage', (tester) async {
      final repo = await pumpApp(tester, AppRoutes.vehicleNew);
      await tester.enterText(find.byType(TextFormField).first, 'Leaf');
      await tester.tap(find.text('Electric'));
      await tester.pumpAndSettle();
      expect(find.text('kWh/100 km'), findsOneWidget);
      await tester.enterText(find.byKey(const Key('consumption')), '17');
      await tester.enterText(find.byKey(const Key('capacity')), '39');
      await tester.enterText(find.byKey(const Key('efficiency')), '90');
      await tester.tap(find.text('Save vehicle'));
      await tester.pumpAndSettle();

      final saved = repo.vehicles.single;
      expect(saved.energyType, EnergyType.electric);
      expect(saved.chargingEfficiency, closeTo(0.9, 1e-9));
      expect(saved.preferredFuelType, isNull);
      expect(find.text('My Garage'), findsOneWidget);
    });

    testWidgets('tap selects active vehicle; delete with confirm + undo', (tester) async {
      final repo = await pumpApp(tester, AppRoutes.garage, [corolla, model3]);
      await tester.tap(find.text('Model 3'));
      await tester.pumpAndSettle();
      expect(repo.activeId, 'b');

      await tester.tap(find.byTooltip('Vehicle options').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete').last);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
      await tester.pumpAndSettle();
      expect(repo.vehicles.map((v) => v.id), ['a']);
      expect(repo.activeId, 'a');

      await tester.tap(find.text('Undo'));
      await tester.pumpAndSettle();
      expect(repo.vehicles.map((v) => v.id), containsAll(['a', 'b']));
    });
  });
}
