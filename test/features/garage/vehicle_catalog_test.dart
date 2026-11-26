import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gas_station_finder/core/router/app_router.dart';
import 'package:gas_station_finder/core/theme/app_theme.dart';
import 'package:gas_station_finder/features/garage/data/drift_garage_repository.dart';
import 'package:gas_station_finder/features/garage/domain/vehicle_catalog.dart';
import 'package:gas_station_finder/features/garage/domain/vehicle_profile.dart';
import 'package:gas_station_finder/features/garage/presentation/vehicle_form_screen.dart';
import 'package:gas_station_finder/l10n/app_localizations.dart';

import '../../helpers/fake_garage_repository.dart';

void main() {
  group('catalog data', () {
    test('every entry is usable as a vehicle and names are unique', () {
      final names = <String>{};
      for (final v in kVehicleCatalog) {
        expect(names.add(v.name), isTrue, reason: 'duplicate ${v.name}');
        expect(v.capacity, greaterThan(0));
        expect(v.consumptionPer100Km, greaterThan(0));
        if (v.kind == CatalogKind.electric) {
          expect(v.fuelType, isNull);
          expect(v.energyType, EnergyType.electric);
        } else {
          expect(kFuelTypeChoices, contains(v.fuelType));
        }
        // Builds without tripping VehicleProfile's assertions.
        VehicleProfile(
          id: 'x',
          name: v.name,
          energyType: v.energyType,
          consumptionPer100Km: v.consumptionPer100Km,
          capacity: v.capacity,
          preferredFuelType: v.fuelType,
        );
      }
    });

    test('plausible ranges per kind (guards against unit mix-ups)', () {
      for (final v in kVehicleCatalog) {
        final (cap, cons) = switch (v.kind) {
          CatalogKind.car => ((30.0, 90.0), (3.0, 15.0)),
          CatalogKind.motorbike => ((8.0, 20.0), (1.5, 4.0)),
          CatalogKind.electric => ((30.0, 110.0), (10.0, 25.0)),
        };
        expect(v.capacity, inInclusiveRange(cap.$1, cap.$2), reason: v.name);
        expect(v.consumptionPer100Km, inInclusiveRange(cons.$1, cons.$2), reason: v.name);
      }
    });

    test('search: every word must match, any order, any case', () {
      expect(searchCatalog('').length, kVehicleCatalog.length);
      expect(searchCatalog('axio').single.name, 'Toyota Axio');
      expect(searchCatalog('hybrid honda').map((v) => v.model), containsAll(['Vezel Hybrid', 'Grace Hybrid']));
      expect(searchCatalog('  PULSAR  ').single.make, 'Bajaj');
      expect(searchCatalog('tesla'), isEmpty);
    });
  });

  group('vehicle form picker', () {
    Future<FakeGarageRepository> pump(WidgetTester tester, {Locale? locale, double textScale = 1}) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.5;
      addTearDown(tester.view.reset);
      final repo = FakeGarageRepository();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [garageRepositoryProvider.overrideWithValue(repo)],
          retry: (_, _) => null,
          child: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
            child: MaterialApp.router(
              theme: AppTheme.light(),
              locale: locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              routerConfig: buildRouter(initialLocation: AppRoutes.vehicleNew),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      return repo;
    }

    testWidgets('pick a diesel car: fields filled, note shown, saved as edited', (tester) async {
      final repo = await pump(tester);
      await tester.tap(find.byKey(const Key('pickCommonVehicle')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('catalogSearch')), 'hiace');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Toyota Hiace (diesel)'));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('catalogNote')), findsOneWidget);
      expect(find.widgetWithText(TextFormField, '70'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, '10.5'), findsOneWidget);
      await tester.enterText(find.byKey(const Key('consumption')), '11');
      await tester.tap(find.text('Save vehicle'));
      await tester.pumpAndSettle();

      final v = repo.vehicles.single;
      expect(
        (v.name, v.capacity, v.consumptionPer100Km, v.preferredFuelType),
        ('Toyota Hiace (diesel)', 70, 11, 'DIESEL'),
      );
    });

    testWidgets('pick an EV switches the form to electric', (tester) async {
      final repo = await pump(tester);
      await tester.tap(find.byKey(const Key('pickCommonVehicle')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('catalogSearch')), 'dolphin');
      await tester.pumpAndSettle();
      await tester.tap(find.text('BYD Dolphin'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('efficiency')), findsOneWidget);
      await tester.enterText(find.byKey(const Key('efficiency')), '90');
      await tester.tap(find.text('Save vehicle'));
      await tester.pumpAndSettle();
      expect(repo.vehicles.single.energyType, EnergyType.electric);
      expect(repo.vehicles.single.capacity, 44.9);
    });

    testWidgets('no match message', (tester) async {
      await pump(tester);
      await tester.tap(find.byKey(const Key('pickCommonVehicle')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('catalogSearch')), 'zzz');
      await tester.pumpAndSettle();
      expect(find.textContaining('No match'), findsOneWidget);
    });

    testWidgets('Bengali at 200% text: sheet meets guidelines', (tester) async {
      await pump(tester, locale: const Locale('bn'), textScale: 2);
      final bn = lookupAppLocalizations(const Locale('bn'));
      await tester.tap(find.text(bn.pickCommonVehicle));
      await tester.pumpAndSettle();
      expect(find.text(bn.catalogCars), findsOneWidget);
      expect(tester.takeException(), isNull);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
    });
  });
}
