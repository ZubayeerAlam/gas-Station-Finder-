import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gas_station_finder/app.dart';
import 'package:gas_station_finder/core/database/app_database.dart';
import 'package:gas_station_finder/core/router/app_router.dart';
import 'package:gas_station_finder/core/theme/app_theme.dart';
import 'package:gas_station_finder/features/assistant/data/unavailable_assistant_api.dart';
import 'package:gas_station_finder/features/assistant/presentation/assistant_controller.dart';
import 'package:gas_station_finder/features/assistant/presentation/assistant_screen.dart';
import 'package:gas_station_finder/features/garage/data/drift_garage_repository.dart';
import 'package:gas_station_finder/l10n/l10n.dart';

import '../helpers/fake_garage_repository.dart';
import '../features/assistant/assistant_test.dart' show FakeAssistantApi;

class _MemoryLocaleStore implements LocalePreferenceStore {
  String? value;
  final _changes = StreamController<String?>.broadcast();

  @override
  Stream<String?> watch() => Stream.multi((c) {
        c.add(value);
        final sub = _changes.stream.listen(c.add);
        c.onCancel = sub.cancel;
      });

  @override
  Future<void> save(String? code) async => _changes.add(value = code);
}

Map<String, dynamic> arb(String code) =>
    jsonDecode(File('lib/l10n/app_$code.arb').readAsStringSync()) as Map<String, dynamic>;

void main() {
  test('every English string has a Bengali translation', () {
    final en = arb('en').keys.where((k) => !k.startsWith('@')).toSet();
    final bn = arb('bn').keys.where((k) => !k.startsWith('@')).toSet();
    expect(en.difference(bn), isEmpty, reason: 'missing in app_bn.arb');
    expect(bn.difference(en), isEmpty, reason: 'unknown keys in app_bn.arb');
  });

  test('locale preference: null / unknown follow the device', () {
    expect(localeFromPreference(null), isNull);
    expect(localeFromPreference('fr'), isNull);
    expect(localeFromPreference('bn'), const Locale('bn'));
  });

  test('plural forms', () {
    expect(kEnglish.stationsNearby(1), '1 station nearby');
    expect(kEnglish.stationsNearby(3), '3 stations nearby');
    final bn = lookupAppLocalizations(const Locale('bn'));
    expect(bn.stationsNearby(3), 'কাছে 3টি স্টেশন');
  });

  Future<void> pumpRouter(WidgetTester tester, String location, {Locale? locale, double textScale = 1}) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(ProviderScope(
      overrides: [garageRepositoryProvider.overrideWithValue(FakeGarageRepository())],
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
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('Bengali: navigation and garage empty state', (tester) async {
    await pumpRouter(tester, AppRoutes.garage, locale: const Locale('bn'));
    expect(find.text('আমার গ্যারেজ'), findsOneWidget);
    expect(find.text('এখনো কোনো গাড়ি নেই'), findsOneWidget);
    expect(find.text('ম্যাপ'), findsOneWidget);
    expect(find.text('গ্যারেজ'), findsOneWidget);
    expect(find.byTooltip('ভাষা'), findsOneWidget);
  });

  test('drift store round-trips the choice', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final store = DriftLocalePreferenceStore(db);
    await store.save('bn');
    expect(await store.watch().first, 'bn');
    await store.save(null);
    expect(await store.watch().first, isNull);
  });

  testWidgets('language menu stores the choice and the app switches to Bengali', (tester) async {
    final store = _MemoryLocaleStore();
    await tester.pumpWidget(ProviderScope(
      overrides: [
        localePreferenceStoreProvider.overrideWithValue(store),
        garageRepositoryProvider.overrideWithValue(FakeGarageRepository()),
        appRouterProvider.overrideWithValue(buildRouter(initialLocation: AppRoutes.garage)),
      ],
      retry: (_, _) => null,
      child: const FuelWiseApp(),
    ));
    await tester.pumpAndSettle();
    expect(find.text('My Garage'), findsOneWidget);
    await tester.tap(find.byTooltip('Language'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('বাংলা (Bengali)'));
    await tester.pumpAndSettle();
    expect(store.value, 'bn');
    expect(find.text('আমার গ্যারেজ'), findsOneWidget);
    await tester.tap(find.byTooltip('ভাষা'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ডিভাইসের ভাষা'));
    await tester.pumpAndSettle();
    expect(store.value, isNull);
    expect(find.text('My Garage'), findsOneWidget); // test device is English
  });

  group('accessibility', () {
    testWidgets('garage empty state at 200 % text: no overflow; tap targets and contrast', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpRouter(tester, AppRoutes.garage, textScale: 2);
      expect(tester.takeException(), isNull);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      handle.dispose();
    });

    for (final locale in [const Locale('en'), const Locale('bn')]) {
      testWidgets('assistant welcome (${locale.languageCode}) at 200 % text', (tester) async {
        final handle = tester.ensureSemantics();
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.5;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(ProviderScope(
          overrides: [assistantApiProvider.overrideWithValue(FakeAssistantApi())],
          child: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: MaterialApp(
              theme: AppTheme.light(),
              locale: locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: const AssistantScreen(),
            ),
          ),
        ));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        await expectLater(tester, meetsGuideline(textContrastGuideline));
        handle.dispose();
      });
    }

    testWidgets('assistant unavailable state is readable', (tester) async {
      await tester.pumpWidget(ProviderScope(
        overrides: [assistantApiProvider.overrideWithValue(const UnavailableAssistantApi('off'))],
        child: MaterialApp(
          locale: const Locale('bn'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const AssistantScreen(),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('সহকারী পাওয়া যাচ্ছে না'), findsOneWidget);
    });
  });
}
