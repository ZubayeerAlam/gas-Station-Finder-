import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gas_station_finder/core/database/app_database.dart';
import 'package:gas_station_finder/core/router/app_router.dart';
import 'package:gas_station_finder/core/theme/app_theme.dart';
import 'package:gas_station_finder/features/care/data/drift_care_repository.dart';
import 'package:gas_station_finder/features/garage/data/drift_garage_repository.dart';
import 'package:gas_station_finder/features/garage/domain/fuel_comparison.dart';
import 'package:gas_station_finder/features/garage/domain/vehicle_profile.dart';
import 'package:gas_station_finder/features/history/data/drift_fill_up_repository.dart';
import 'package:gas_station_finder/features/history/domain/fill_up.dart';
import 'package:gas_station_finder/l10n/app_localizations.dart';

import '../../helpers/fake_care_repository.dart';
import '../../helpers/fake_fill_up_repository.dart';
import '../../helpers/fake_garage_repository.dart';

// Petrol 10 L/100 km (10 km/L) or CNG 8 m³/100 km (12.5 km/m³).
const axio = VehicleProfile(
  id: 'axio',
  name: 'Axio',
  energyType: EnergyType.fuel,
  consumptionPer100Km: 10,
  capacity: 42,
  preferredFuelType: 'REGULAR_UNLEADED',
  secondaryFuelType: 'METHANE',
  secondaryConsumptionPer100Km: 8,
);

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  group('compareFuels', () {
    test('cost per 100 km, cheaper fuel, saving and share', () {
      final c = compareFuels(axio, primaryPrice: 130, secondaryPrice: 43)!;
      expect(c.primary.unit, 'L');
      expect(c.secondary.unit, 'm³');
      expect(c.primary.kmPerUnit, 10);
      expect(c.secondary.kmPerUnit, 12.5);
      expect(c.primary.costPer100Km, 1300);
      expect(c.secondary.costPer100Km, 344);
      expect(c.secondary.costPerKm, closeTo(3.44, 1e-9));
      expect(identical(c.cheaper, c.secondary), isTrue);
      expect(c.savingPer100Km, 956);
      expect(c.savingFor(1500), closeTo(14340, 1e-6));
      expect(c.savingShare, closeTo(956 / 1300, 1e-9));
    });

    test('missing or invalid price → incomplete, nothing guessed', () {
      for (final p in [null, 0.0, -5.0, double.nan, double.infinity]) {
        final c = compareFuels(axio, primaryPrice: 130, secondaryPrice: p)!;
        expect(c.isComplete, isFalse);
        expect(c.cheaper, isNull);
        expect(c.savingPer100Km, isNull);
        expect(c.savingFor(100), isNull);
        expect(c.savingShare, isNull);
      }
    });

    test('equal cost → no winner, zero saving', () {
      final c = compareFuels(axio, primaryPrice: 80, secondaryPrice: 100)!;
      expect(c.cheaper, isNull);
      expect(c.savingPer100Km, 0);
    });

    test('primary can be the cheaper one', () {
      final c = compareFuels(axio, primaryPrice: 30, secondaryPrice: 100)!;
      expect(identical(c.cheaper, c.primary), isTrue);
    });

    test('single-fuel and electric vehicles are not compared', () {
      expect(compareFuels(axio.copyWith(secondaryFuelType: null), primaryPrice: 1, secondaryPrice: 1), isNull);
      expect(compareFuels(axio.copyWith(secondaryConsumptionPer100Km: null)), isNull);
      expect(axio.copyWith(energyType: EnergyType.electric).isDualFuel, isFalse);
      expect(purchaseUnitForFuel('DIESEL'), 'L');
      expect(purchaseUnitForFuel(null), 'L');
    });

    test('secondary consumption must be positive', () {
      expect(() => axio.copyWith(secondaryConsumptionPer100Km: 0), throwsA(isA<AssertionError>()));
    });
  });

  group('storage', () {
    test('dual-fuel fields round-trip; EVs never keep a second fuel', () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final repo = DriftGarageRepository(db);
      await repo.save(axio);
      await repo.save(axio.copyWith(id: 'ev', energyType: EnergyType.electric, preferredFuelType: null));
      final list = await repo.watchVehicles().first;
      expect(list.first, axio);
      expect(list.last.secondaryFuelType, isNull);
      expect(list.last.secondaryConsumptionPer100Km, isNull);
    });

    test('upgrading a v5 database adds the dual-fuel columns and keeps vehicles', () async {
      final fresh = AppDatabase(NativeDatabase.memory());
      final rows = await fresh
          .customSelect("SELECT name, sql FROM sqlite_master WHERE type = 'table' AND name NOT LIKE 'sqlite_%'")
          .get();
      await fresh.close();
      final v5Sql = [
        for (final r in rows)
          r.read<String>('name') == 'vehicles'
              // The v5 vehicles table: the current one minus the two new columns.
              ? r
                    .read<String>('sql')
                    .replaceAll(RegExp(r',\s*"secondary_fuel_type" TEXT NULL'), '')
                    .replaceAll(RegExp(r',\s*"secondary_consumption_per100_km" REAL NULL'), '')
              : r.read<String>('sql'),
      ];
      expect(v5Sql.firstWhere((s) => s.contains('"vehicles"')), isNot(contains('secondary')));

      final db = AppDatabase(
        NativeDatabase.memory(
          setup: (raw) {
            if (raw.userVersion != 0) return;
            for (final sql in v5Sql) {
              raw.execute(sql);
            }
            raw.execute(
              'INSERT INTO vehicles (id, name, energy_type, consumption_per100_km, capacity, preferred_fuel_type, '
              "charging_efficiency, created_at) VALUES ('old', 'Old car', 0, 7, 40, 'DIESEL', 1.0, 0)",
            );
            raw.userVersion = 5;
          },
        ),
      );
      addTearDown(db.close);
      final repo = DriftGarageRepository(db);
      final before = await repo.watchVehicles().first;
      expect(before.single.name, 'Old car');
      expect(before.single.isDualFuel, isFalse);
      expect((await repo.save(axio)).isOk, isTrue);
      expect((await repo.watchVehicles().first).last, axio);
      expect(await db.customSelect('PRAGMA user_version').map((r) => r.read<int>('user_version')).getSingle(), 6);
    });
  });

  group('UI', () {
    Future<FakeGarageRepository> pump(
      WidgetTester tester,
      String location, {
      List<VehicleProfile> vehicles = const [],
      List<FillUp> fillUps = const [],
      Locale locale = const Locale('en'),
      double textScale = 1,
    }) async {
      final repo = FakeGarageRepository(vehicles);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            garageRepositoryProvider.overrideWithValue(repo),
            fillUpRepositoryProvider.overrideWithValue(FakeFillUpRepository(fillUps)),
            careRepositoryProvider.overrideWithValue(FakeCareRepository()),
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

    testWidgets('form saves a second fuel as per-100 km from km per m³', (tester) async {
      final repo = await pump(tester, AppRoutes.vehicleNew);
      await tester.enterText(find.byType(TextFormField).first, 'Axio');
      await tester.enterText(find.byKey(const Key('consumption')), '10');
      await tester.enterText(find.byKey(const Key('capacity')), '42');
      expect(find.byKey(const Key('secondKmPerUnit')), findsNothing);
      await tester.dragUntilVisible(find.text('No second fuel'), find.byType(ListView), const Offset(0, -200));
      await tester.pumpAndSettle();
      await tester.tap(find.text('No second fuel'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('CNG / Methane').last);
      await tester.pumpAndSettle();
      await tester.dragUntilVisible(
        find.byKey(const Key('secondKmPerUnit')),
        find.byType(ListView),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();
      expect(find.text('km/m³'), findsOneWidget);
      // Saving without the distance is blocked.
      await tester.tap(find.text('Save vehicle'));
      await tester.pumpAndSettle();
      expect(repo.vehicles, isEmpty);
      await tester.enterText(find.byKey(const Key('secondKmPerUnit')), '12,5');
      await tester.tap(find.text('Save vehicle'));
      await tester.pumpAndSettle();
      final v = repo.vehicles.single;
      expect(v.secondaryFuelType, 'METHANE');
      expect(v.secondaryConsumptionPer100Km, closeTo(8, 1e-9));
      expect(find.textContaining('Regular + CNG / Methane'), findsOneWidget);
    });

    testWidgets('compare sheet: prices → cheaper fuel and monthly saving from odometer history', (tester) async {
      await pump(
        tester,
        AppRoutes.garage,
        vehicles: [axio],
        fillUps: [
          FillUp(
            id: 'f1',
            vehicleId: 'axio',
            date: DateTime(2026, 10, 1),
            amount: 30,
            totalCost: 3900,
            currencyCode: 'BDT',
            odometerKm: 10000,
          ),
          FillUp(
            id: 'f2',
            vehicleId: 'axio',
            date: DateTime(2026, 10, 31),
            amount: 30,
            totalCost: 3900,
            currencyCode: 'BDT',
            odometerKm: 11500,
          ),
        ],
      );
      await tester.tap(find.byTooltip('Vehicle options'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Compare fuel costs'));
      await tester.pumpAndSettle();
      expect(find.text('Enter both prices to compare.'), findsOneWidget);
      await tester.enterText(find.byKey(const Key('primaryPrice')), '130');
      await tester.enterText(find.byKey(const Key('secondaryPrice')), '43');
      await tester.pump();
      expect(find.textContaining('BDT 1300.00 per 100 km'), findsOneWidget);
      expect(find.textContaining('BDT 344.00 per 100 km'), findsOneWidget);
      expect(find.text('CNG / Methane is cheaper by BDT 956.00 per 100 km (74% less).'), findsOneWidget);
      // 1500 km in 30 days → 1500 km a month → 956 × 15.
      expect(find.byKey(const Key('fuelCompareMonthly')), findsOneWidget);
      expect(find.textContaining('BDT 14340.00'), findsOneWidget);
    });

    testWidgets('compare menu only for dual-fuel vehicles; no history → hint', (tester) async {
      await pump(tester, AppRoutes.garage, vehicles: [axio.copyWith(id: 'single', secondaryFuelType: null)]);
      await tester.tap(find.byTooltip('Vehicle options'));
      await tester.pumpAndSettle();
      expect(find.text('Compare fuel costs'), findsNothing);
    });

    testWidgets('Bengali at 200 % text: compare sheet meets guidelines', (tester) async {
      final handle = tester.ensureSemantics();
      await pump(tester, AppRoutes.garage, vehicles: [axio], locale: const Locale('bn'), textScale: 2);
      final bn = lookupAppLocalizations(const Locale('bn'));
      await tester.tap(find.byTooltip(bn.vehicleOptions));
      await tester.pumpAndSettle();
      await tester.tap(find.text(bn.compareFuelsMenu));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('primaryPrice')), '130');
      await tester.enterText(find.byKey(const Key('secondaryPrice')), '43');
      await tester.pump();
      expect(find.text(bn.fuelSavingNoHistory), findsOneWidget);
      expect(tester.takeException(), isNull);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      handle.dispose();
    });
  });
}
