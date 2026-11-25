import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gas_station_finder/core/router/app_router.dart';
import 'package:gas_station_finder/core/theme/app_theme.dart';
import 'package:gas_station_finder/features/along_route/presentation/along_route_providers.dart';
import 'package:gas_station_finder/features/care/data/drift_care_repository.dart';
import 'package:gas_station_finder/features/care/data/local_reminder_notifier.dart';
import 'package:gas_station_finder/features/care/domain/care_reminder.dart';
import 'package:gas_station_finder/features/garage/data/drift_garage_repository.dart';
import 'package:gas_station_finder/features/garage/domain/vehicle_profile.dart';
import 'package:gas_station_finder/features/history/data/drift_fill_up_repository.dart';
import 'package:gas_station_finder/features/history/domain/fill_up.dart';
import 'package:gas_station_finder/l10n/l10n.dart';

import '../../helpers/fake_care_repository.dart';
import '../../helpers/fake_fill_up_repository.dart';
import '../../helpers/fake_garage_repository.dart';
import '../../helpers/fake_reminder_notifier.dart';

late FakeReminderNotifier notifier;

const car = VehicleProfile(
  id: 'v1',
  name: 'Axio',
  energyType: EnergyType.fuel,
  consumptionPer100Km: 7,
  capacity: 40,
  preferredFuelType: 'REGULAR_UNLEADED',
);

final now = DateTime(2026, 11, 25, 10);

FillUp fill(String id, DateTime date, double odo) => FillUp(
  id: id,
  vehicleId: car.id,
  date: date,
  amount: 30,
  totalCost: 3000,
  currencyCode: 'BDT',
  odometerKm: odo,
  isFull: true,
);

CareReminder oil() => CareReminder(
  id: 'oil',
  vehicleId: car.id,
  type: CareType.oilChange,
  dueDate: DateTime(2026, 11, 20),
  repeatMonths: 6,
  repeatKm: 5000,
  createdAt: DateTime(2026, 1, 1),
);

CareReminder tax() => CareReminder(
  id: 'tax',
  vehicleId: car.id,
  type: CareType.taxToken,
  dueDate: DateTime(2027, 3, 1),
  repeatMonths: 12,
  createdAt: DateTime(2026, 1, 1),
);

void main() {
  Future<FakeCareRepository> pump(
    WidgetTester tester, {
    List<CareReminder> reminders = const [],
    Locale? locale,
    double textScale = 1,
  }) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
    final care = FakeCareRepository(reminders);
    notifier = FakeReminderNotifier();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          garageRepositoryProvider.overrideWithValue(FakeGarageRepository([car])),
          fillUpRepositoryProvider.overrideWithValue(
            FakeFillUpRepository([
              fill('f1', DateTime(2026, 10, 26), 11000),
              fill('f2', DateTime(2026, 11, 25), 11900),
            ]),
          ),
          careRepositoryProvider.overrideWithValue(care),
          reminderNotifierProvider.overrideWithValue(notifier),
          nowProvider.overrideWithValue(() => now),
        ],
        retry: (_, _) => null,
        child: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
          child: MaterialApp.router(
            theme: AppTheme.light(),
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: buildRouter(initialLocation: AppRoutes.garage),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return care;
  }

  Future<void> openCareFromMenu(
    WidgetTester tester, {
    String options = 'Vehicle options',
    String menu = 'Care & reminders',
  }) async {
    await tester.tap(find.byTooltip(options));
    await tester.pumpAndSettle();
    await tester.tap(find.text(menu));
    await tester.pumpAndSettle();
  }

  testWidgets('garage menu → empty care screen → add suggested reminders', (tester) async {
    final care = await pump(tester);
    expect(find.byKey(const ValueKey('careChip-v1')), findsNothing);
    await openCareFromMenu(tester);

    expect(find.text('Care · Axio'), findsOneWidget);
    expect(find.text('No reminders yet'), findsOneWidget);
    await tester.tap(find.text('Add suggested reminders'));
    await tester.pumpAndSettle();

    // Petrol car: tax, insurance, fitness, oil change, tyre rotation (no CNG retest).
    expect(care.items.map((r) => r.type), [
      CareType.taxToken,
      CareType.insurance,
      CareType.fitness,
      CareType.oilChange,
      CareType.tyreRotation,
    ]);
    expect(find.text('5 reminders added — set their dates'), findsOneWidget);
    expect(notifier.permissionRequests, 0, reason: 'undated presets never prompt');
    expect(find.text('Needs a date'), findsOneWidget);
    expect(find.textContaining('Odometer 11900 km'), findsOneWidget);
  });

  testWidgets('garage chip shows overdue count; mark done rolls the reminder forward', (tester) async {
    final care = await pump(tester, reminders: [oil(), tax()]);
    final chip = find.byKey(const ValueKey('careChip-v1'));
    expect(chip, findsOneWidget);
    expect(find.text('1 reminder needs attention'), findsOneWidget);

    await tester.tap(chip);
    await tester.pumpAndSettle();
    expect(find.text('Overdue'), findsOneWidget);
    expect(find.text('Overdue by 5 days'), findsOneWidget);
    expect(find.text('Upcoming'), findsOneWidget);

    await tester.tap(find.byTooltip('Reminder options').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mark done').last);
    await tester.pumpAndSettle();
    // Odometer prefilled from history.
    expect(find.widgetWithText(TextFormField, '11900'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Mark done'));
    await tester.pumpAndSettle();

    final done = care.items.firstWhere((r) => r.id == 'oil');
    expect(done.dueDate, DateTime(2027, 5, 25));
    expect(done.dueOdometerKm, 16900);
    expect(done.lastDoneKm, 11900);
    expect(find.textContaining('Marked as done · next'), findsOneWidget);
    expect(find.text('Overdue'), findsNothing);
  });

  testWidgets('delete with undo restores the reminder', (tester) async {
    final care = await pump(tester, reminders: [tax()]);
    await openCareFromMenu(tester);
    await tester.tap(find.byTooltip('Reminder options'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete').last);
    await tester.pumpAndSettle();
    expect(care.items, isEmpty);
    expect(find.text('No reminders yet'), findsOneWidget);
    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(care.items.single.id, 'tax');
    expect(find.text('Tax token'), findsOneWidget);
  });

  testWidgets('form validation, then a custom km reminder is saved', (tester) async {
    final care = await pump(tester);
    await openCareFromMenu(tester);
    await tester.tap(find.text('Add reminder'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<CareType>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Custom').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save reminder'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a name'), findsOneWidget);
    expect(find.text('Set a due date or a due odometer'), findsOneWidget);
    expect(care.items, isEmpty);

    await tester.enterText(find.byKey(const Key('careTitle')), 'Brake pads');
    await tester.enterText(find.byKey(const Key('careDueKm')), '12500');
    await tester.enterText(find.byKey(const Key('careRepeatMonths')), '0');
    await tester.tap(find.text('Save reminder'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a whole number'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('careRepeatMonths')), '');
    await tester.tap(find.text('Save reminder'));
    await tester.pumpAndSettle();
    final r = care.items.single;
    expect(
      (r.type, r.title, r.dueOdometerKm, r.dueDate, r.repeatMonths),
      (CareType.custom, 'Brake pads', 12500, null, null),
    );
    expect(find.text('Brake pads'), findsOneWidget);
    expect(notifier.permissionRequests, 1, reason: 'first dated save asks once');
    expect(find.textContaining('In 600 km'), findsOneWidget);
  });

  testWidgets('new oil change takes the preset repeat interval', (tester) async {
    await pump(tester);
    await openCareFromMenu(tester);
    await tester.tap(find.text('Add reminder'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextFormField, '12'), findsOneWidget); // tax token: 12 months
    await tester.tap(find.byType(DropdownButtonFormField<CareType>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Oil change').last);
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextFormField, '6'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, '5000'), findsOneWidget);
  });

  testWidgets('Bengali care screen at 200 % text is accessible', (tester) async {
    final handle = tester.ensureSemantics();
    await pump(tester, reminders: [oil(), tax()], locale: const Locale('bn'), textScale: 2);
    final bn = lookupAppLocalizations(const Locale('bn'));
    expect(find.text(bn.careAttention(1)), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('careChip-v1')));
    await tester.pumpAndSettle();
    expect(find.text(bn.careTitle('Axio')), findsOneWidget);
    expect(find.text(bn.careBandOverdue), findsOneWidget);
    expect(find.text(bn.careOverdueDays(5)), findsOneWidget);
    expect(tester.takeException(), isNull);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));

    await tester.tap(
      find.byTooltip(bn.careAddReminder).hitTestable().evaluate().isEmpty
          ? find.text(bn.careAddReminder)
          : find.byTooltip(bn.careAddReminder),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    handle.dispose();
  });
}
