import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gas_station_finder/core/database/app_database.dart';
import 'package:gas_station_finder/core/error/app_failure.dart';
import 'package:gas_station_finder/core/error/result.dart';
import 'package:gas_station_finder/core/router/app_router.dart';
import 'package:gas_station_finder/core/theme/app_theme.dart';
import 'package:gas_station_finder/features/account/data/drift_local_data_store.dart';
import 'package:gas_station_finder/features/account/domain/account_data.dart';
import 'package:gas_station_finder/features/account/presentation/account_providers.dart';
import 'package:gas_station_finder/features/along_route/presentation/along_route_providers.dart';
import 'package:gas_station_finder/features/care/data/drift_care_repository.dart';
import 'package:gas_station_finder/features/care/data/local_reminder_notifier.dart';
import 'package:gas_station_finder/features/care/domain/care_reminder.dart';
import 'package:gas_station_finder/features/care/presentation/care_notifications.dart';
import 'package:gas_station_finder/features/garage/data/drift_garage_repository.dart';
import 'package:gas_station_finder/features/garage/domain/vehicle_profile.dart';
import 'package:gas_station_finder/features/history/data/drift_fill_up_repository.dart';
import 'package:gas_station_finder/features/history/domain/fill_up.dart';
import 'package:gas_station_finder/l10n/l10n.dart';

import '../../helpers/fake_care_repository.dart';
import '../../helpers/fake_fill_up_repository.dart';
import '../../helpers/fake_garage_repository.dart';
import '../../helpers/fake_reminder_notifier.dart';

const car = VehicleProfile(id: 'v1', name: 'Axio', energyType: EnergyType.fuel, consumptionPer100Km: 7, capacity: 40);

CareReminder tax() => CareReminder(
  id: 'tax',
  vehicleId: 'v1',
  type: CareType.taxToken,
  dueDate: DateTime(2027, 3, 1),
  createdAt: DateTime(2026),
);

class FakeLocalStore implements LocalDataStore {
  int wipes = 0;
  bool fail = false;

  @override
  Future<Result<void>> wipe() async {
    wipes++;
    return fail ? const Err(UnknownFailure()) : const Ok(null);
  }
}

class FakeCommunityAccount implements CommunityAccount {
  FakeCommunityAccount({this.isAvailable = true, this.result = const Ok(CommunityDeletionSummary.none)});

  @override
  final bool isAvailable;
  Result<CommunityDeletionSummary> result;
  int calls = 0;

  @override
  Future<Result<CommunityDeletionSummary>> deleteMyData() async {
    calls++;
    return result;
  }
}

void main() {
  group('local wipe', () {
    late AppDatabase db;
    setUp(() => db = AppDatabase(NativeDatabase.memory()));
    tearDown(() => db.close());

    test('wipeAll empties every table', () async {
      await DriftGarageRepository(db).save(car);
      await DriftFillUpRepository(db)
          .save(FillUp(id: 'f', vehicleId: 'v1', date: DateTime(2026), amount: 1, totalCost: 1, currencyCode: 'BDT'));
      await DriftCareRepository(db).save(tax());
      await db.writeSetting('locale', 'bn');
      for (final t in db.allTables) {
        if (t.actualTableName == 'place_locations') continue; // filled by the station cache, not needed here
        expect(await db.select(t).get(), isNotEmpty, reason: t.actualTableName);
      }

      expect(await DriftLocalDataStore(db).wipe(), isA<Ok<void>>());
      for (final t in db.allTables) {
        expect(await db.select(t).get(), isEmpty, reason: t.actualTableName);
      }
      expect(await db.readSetting('locale'), isNull);
    });

    test('wiping the device also clears scheduled care notifications', () async {
      final notifier = FakeReminderNotifier();
      final container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          reminderNotifierProvider.overrideWithValue(notifier),
          nowProvider.overrideWithValue(() => DateTime(2026, 11, 27, 10)),
        ],
        retry: (_, _) => null,
      );
      addTearDown(container.dispose);
      await DriftGarageRepository(db).save(car);
      await DriftCareRepository(db).save(tax());
      container.listen(careSyncProvider, (_, _) {});
      for (var i = 0; i < 20 && notifier.last.isEmpty; i++) {
        await pumpEventQueue();
      }
      expect(notifier.last, hasLength(2));

      await container.read(accountControllerProvider).deleteDeviceData();
      for (var i = 0; i < 20 && notifier.last.isNotEmpty; i++) {
        await pumpEventQueue();
      }
      expect(notifier.last, isEmpty);
    });

    test('summary parses counts and totals them', () {
      final s = CommunityDeletionSummary.fromMap({
        'priceReports': 2,
        'votes': 1,
        'alertRules': 0,
        'assistantSessions': 3,
      });
      expect(s.total, 6);
      expect(CommunityDeletionSummary.fromMap(const {}).total, 0);
    });
  });

  group('Privacy screen', () {
    Future<void> pump(
      WidgetTester tester, {
      required FakeLocalStore local,
      required FakeCommunityAccount online,
      Locale? locale,
      double textScale = 1,
    }) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.5;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            reminderNotifierProvider.overrideWithValue(FakeReminderNotifier()),
            fillUpRepositoryProvider.overrideWithValue(FakeFillUpRepository()),
            localePreferenceStoreProvider.overrideWithValue(_NoLocaleStore()),
            garageRepositoryProvider.overrideWithValue(FakeGarageRepository([car])),
            careRepositoryProvider.overrideWithValue(FakeCareRepository()),
            localDataStoreProvider.overrideWithValue(local),
            communityAccountProvider.overrideWithValue(online),
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
      await tester.tap(find.byTooltip(locale == null ? 'Privacy & data' : lookupAppLocalizations(locale).privacyTitle));
      await tester.pumpAndSettle();
    }

    testWidgets('device data: cancel does nothing, confirm wipes', (tester) async {
      final local = FakeLocalStore();
      await pump(tester, local: local, online: FakeCommunityAccount());
      expect(find.text('On this device'), findsOneWidget);

      await tester.tap(find.byKey(const Key('deleteDeviceData')));
      await tester.pumpAndSettle();
      expect(find.text('Delete all data on this device?'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(local.wipes, 0);

      await tester.tap(find.byKey(const Key('deleteDeviceData')));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
      await tester.pumpAndSettle();
      expect(local.wipes, 1);
      expect(find.text('Data on this device deleted'), findsOneWidget);
    });

    testWidgets('online data: success count, then a failure message', (tester) async {
      final online = FakeCommunityAccount(result: const Ok(CommunityDeletionSummary(priceReports: 2, votes: 1)));
      await pump(tester, local: FakeLocalStore(), online: online);

      Future<void> deleteOnline() async {
        await tester.tap(find.byKey(const Key('deleteOnlineData')));
        await tester.pumpAndSettle();
        expect(find.text('Delete your online data?'), findsOneWidget);
        await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
        await tester.pumpAndSettle();
      }

      await deleteOnline();
      expect(online.calls, 1);
      expect(find.text('3 items deleted online'), findsOneWidget);

      ScaffoldMessenger.of(tester.element(find.byType(Scaffold).last)).removeCurrentSnackBar();
      online.result = const Err(ServerFailure('x', code: FailureCode.dataDeletionFailed));
      await deleteOnline();
      expect(find.text('Could not delete your online data. Check your connection and try again.'), findsOneWidget);
    });

    testWidgets('community off: says nothing is online, no delete button', (tester) async {
      await pump(tester, local: FakeLocalStore(), online: FakeCommunityAccount(isAvailable: false));
      expect(find.text('Community features are off in this build, so nothing is stored online.'), findsOneWidget);
      expect(find.byKey(const Key('deleteOnlineData')), findsNothing);
    });

    testWidgets('Bengali at 200 % text is accessible', (tester) async {
      final handle = tester.ensureSemantics();
      const bnLocale = Locale('bn');
      final bn = lookupAppLocalizations(bnLocale);
      await pump(tester, local: FakeLocalStore(), online: FakeCommunityAccount(), locale: bnLocale, textScale: 2);
      expect(find.text(bn.privacyTitle), findsWidgets);
      expect(find.text(bn.privacyDeleteDevice), findsOneWidget);
      expect(tester.takeException(), isNull);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      handle.dispose();
    });
  });
}

class _NoLocaleStore implements LocalePreferenceStore {
  @override
  Stream<String?> watch() => Stream.value(null);

  @override
  Future<void> save(String? code) async {}
}
