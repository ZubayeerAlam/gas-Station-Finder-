import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gas_station_finder/core/error/crash_handler.dart';
import 'package:gas_station_finder/core/router/app_router.dart';
import 'package:gas_station_finder/core/theme/app_theme.dart';
import 'package:gas_station_finder/features/along_route/presentation/along_route_providers.dart';
import 'package:gas_station_finder/l10n/app_localizations.dart';

void main() {
  group('CrashHandler', () {
    test('keeps newest first, capped, shortened, one line', () {
      var t = DateTime(2026, 11, 27);
      final h = CrashHandler(capacity: 3, maxMessageLength: 10, clock: () => t = t.add(const Duration(seconds: 1)));
      for (var i = 0; i < 5; i++) {
        h.record(StateError('error\nnumber $i is long'), source: 'test');
      }
      expect(h.records, hasLength(3));
      expect(h.records.first.message, 'Bad state:…');
      expect(h.records.first.type, 'StateError');
      expect(h.records.first.at.isAfter(h.records.last.at), isTrue);
      h.clear();
      expect(h.records, isEmpty);
    });

    test('install: uncaught async errors are recorded and marked handled', () {
      final savedFlutter = FlutterError.onError;
      final savedPlatform = PlatformDispatcher.instance.onError;
      addTearDown(() {
        FlutterError.onError = savedFlutter;
        PlatformDispatcher.instance.onError = savedPlatform;
      });
      final h = CrashHandler()..install(releaseFallback: false);
      expect(PlatformDispatcher.instance.onError!(Exception('late timer'), StackTrace.empty), isTrue);
      expect(h.records.single.source, 'async');
    });

    test('install: framework errors are recorded', () {
      final savedFlutter = FlutterError.onError;
      final savedPlatform = PlatformDispatcher.instance.onError;
      addTearDown(() {
        FlutterError.onError = savedFlutter;
        PlatformDispatcher.instance.onError = savedPlatform;
      });
      final h = CrashHandler()..install(releaseFallback: false);
      final presented = <FlutterErrorDetails>[];
      // Avoid dumping to the test console: swap in a quiet presenter.
      final savedPresent = FlutterError.presentError;
      FlutterError.presentError = presented.add;
      addTearDown(() => FlutterError.presentError = savedPresent);
      FlutterError.onError!(FlutterErrorDetails(exception: ArgumentError('bad size'), library: 'rendering'));
      expect(h.records.single.source, 'rendering');
      expect(presented, hasLength(1), reason: 'still shown to developers in debug');
    });

    test('provider observer records failing providers', () async {
      final h = CrashHandler();
      final failing = FutureProvider<int>((ref) => throw StateError('boom'), name: 'failing');
      final c = ProviderContainer(observers: [CrashProviderObserver(h)], retry: (_, _) => null);
      addTearDown(c.dispose);
      await expectLater(c.read(failing.future), throwsStateError);
      expect(h.records.single.source, 'provider failing');
    });
  });

  testWidgets('BuildErrorCard is localized', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('bn'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const BuildErrorCard(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(lookupAppLocalizations(const Locale('bn')).errorPartNotShown), findsOneWidget);
  });

  testWidgets('unknown path shows Page not found with a way back to the map', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [mapsEnabledProvider.overrideWithValue(false)],
        retry: (_, _) => null,
        child: MaterialApp.router(
          theme: AppTheme.light(),
          routerConfig: buildRouter(initialLocation: '/nope/123'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Page not found'), findsOneWidget);
    await tester.tap(find.text('Go to the map'));
    await tester.pump(); // the map keeps animating (location lookup), so no pumpAndSettle
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(NotFoundScreen), findsNothing);
  });
}
