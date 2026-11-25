import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gas_station_finder/core/error/app_failure.dart';
import 'package:gas_station_finder/core/router/app_router.dart';
import 'package:gas_station_finder/core/theme/app_theme.dart';
import 'package:gas_station_finder/features/along_route/presentation/ranking_explanation.dart';
import 'package:gas_station_finder/features/garage/data/drift_garage_repository.dart';
import 'package:gas_station_finder/features/history/data/drift_fill_up_repository.dart';
import 'package:gas_station_finder/features/ranking/domain/ranking_models.dart';
import 'package:gas_station_finder/l10n/domain_labels.dart';
import 'package:gas_station_finder/l10n/failure_text.dart';
import 'package:gas_station_finder/l10n/l10n.dart';

import '../features/history/history_test.dart' show car, fill;
import '../helpers/fake_fill_up_repository.dart';
import '../helpers/fake_garage_repository.dart';

final bn = lookupAppLocalizations(const Locale('bn'));

void main() {
  group('failure text', () {
    test('every failure code has an English and a Bengali text', () {
      for (final code in FailureCode.values) {
        final f = ServerFailure('english fallback', statusCode: 500, code: code);
        final en = describeFailure(f, kEnglish), b = describeFailure(f, bn);
        expect(en, isNot(isEmpty), reason: '$code');
        expect(b, isNot(isEmpty), reason: '$code');
        expect(b, isNot(en), reason: '$code is not translated');
      }
    });

    test('default constructors carry codes; custom messages without a code pass through', () {
      expect(const NetworkFailure().code, FailureCode.network);
      expect(const TimeoutFailure().code, FailureCode.timeout);
      expect(const NotFoundFailure().code, FailureCode.notFound);
      expect(const UnknownFailure().code, FailureCode.unknown);
      expect(const NotFoundFailure('No route', FailureCode.noRouteToStation).code, FailureCode.noRouteToStation);
      expect(describeFailure(const NotFoundFailure('Server said: none'), bn), 'Server said: none');
      expect(describeFailure(const ServerFailure('Daily limit reached'), bn), 'Daily limit reached');
      expect(describeFailure(const NetworkFailure(), bn), bn.errorNetwork);
      expect(describeFailure(const ServerFailure('x', statusCode: 503, code: FailureCode.serverError), kEnglish),
          'Server error (503). Please try again.');
    });

    test('non-failures use the fallback, then a generic message', () {
      expect(describeFailure(StateError('boom'), bn, fallback: 'F'), 'F');
      expect(describeFailure(null, bn), bn.errorUnknown);
    });
  });

  test('relative time and month names', () {
    final now = DateTime(2026, 11, 25, 12);
    expect(relativeTime(now, kEnglish, now: now), 'just now');
    expect(relativeTime(now.subtract(const Duration(minutes: 5)), bn, now: now), '5 মিনিট আগে');
    expect(relativeTime(now.subtract(const Duration(hours: 3)), kEnglish, now: now), '3 h ago');
    expect(relativeTime(now.subtract(const Duration(days: 2)), bn, now: now), '2 দিন আগে');
    expect(relativeTime(DateTime(2026, 1, 2), bn, now: now), '2026-01-02');
    expect(monthShort(3, kEnglish), 'Mar');
    expect(monthShort(12, bn), 'ডিসে');
  });

  test('domain labels: translated where the word differs, code otherwise', () {
    expect(localizedFuelType('DIESEL', bn), 'ডিজেল');
    expect(localizedFuelType('E10', bn), 'E10');
    expect(localizedFuelType('SP95_E10', bn), 'SP95 E10');
    expect(localizedReliability(0.9, bn), bn.reliabilityHigh);
    expect(localizedReliability(null, kEnglish), 'Not enough community data');
    expect(localizedReportStatus('rejected', 'outlier', bn), bn.reportOutlier);
    expect(validateReportPriceL10n('abc', bn), bn.enterPrice);
    expect(validateReportPriceL10n('5000', kEnglish), 'Enter a price between 0.01 and 1000');
    expect(validateReportPriceL10n('1.79', bn), isNull);
  });

  test('ranking labels: Bengali in the UI, English by default (AI tool results)', () {
    expect(badgeLabel(RankingBadge.cheapestOverall), 'Cheapest');
    expect(badgeLabel(RankingBadge.cheapestOverall, bn), 'সবচেয়ে সস্তা');
    expect(caveatLabel(Caveat.closed, bn), 'এখন বন্ধ');
    expect(strategyLabel(RankingStrategy.bestValue, bn), 'সেরা মূল্য');
    expect(detourText(const StationOffer(stationId: 'x', name: 'x', detourMeters: 10), bn), 'পথের উপরেই');
  });

  group('Bengali screens', () {
    Future<void> pump(WidgetTester tester, String location, {double textScale = 1}) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.5;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(ProviderScope(
        overrides: [
          garageRepositoryProvider.overrideWithValue(FakeGarageRepository([car])),
          fillUpRepositoryProvider.overrideWithValue(FakeFillUpRepository([
            fill('a', DateTime(2026, 10, 1), 40, 70, odo: 1000),
            fill('b', DateTime(2026, 11, 1), 50, 80, odo: 1600, full: false),
          ])),
        ],
        retry: (_, _) => null,
        child: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
          child: MaterialApp.router(
            theme: AppTheme.light(),
            locale: const Locale('bn'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: buildRouter(initialLocation: location),
          ),
        ),
      ));
      await tester.pumpAndSettle();
    }

    Future<void> expectAccessible(WidgetTester tester) async {
      expect(tester.takeException(), isNull);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
    }

    testWidgets('history with entries at 200 % text', (tester) async {
      final handle = tester.ensureSemantics();
      await pump(tester, AppRoutes.history, textScale: 2);
      expect(find.text('ইতিহাস · Corolla'), findsOneWidget);
      expect(find.text('এই মাস'), findsOneWidget);
      expect(find.text('ফুয়েল যোগ করুন'), findsOneWidget);
      await expectAccessible(tester);
      await tester.scrollUntilVisible(find.textContaining('আংশিক'), 300);
      expect(find.textContaining('আংশিক'), findsOneWidget);
      expect(tester.takeException(), isNull);
      handle.dispose();
    });

    testWidgets('fill-up form validates in Bengali at 200 % text', (tester) async {
      final handle = tester.ensureSemantics();
      await pump(tester, AppRoutes.fillUpNew, textScale: 2);
      expect(find.text('ফুয়েল যোগ করুন'), findsOneWidget);
      await tester.tap(find.text('সংরক্ষণ'));
      await tester.pumpAndSettle();
      expect(find.text('একটি ধনাত্মক সংখ্যা লিখুন'), findsNWidgets(2));
      await expectAccessible(tester);
      handle.dispose();
    });

    testWidgets('vehicle form at 200 % text', (tester) async {
      final handle = tester.ensureSemantics();
      await pump(tester, AppRoutes.vehicleNew, textScale: 2);
      expect(find.text('গাড়ি যোগ করুন'), findsWidgets);
      expect(find.text('ইলেকট্রিক'), findsOneWidget);
      expect(find.text('রেগুলার (অকটেন)'), findsOneWidget);
      await expectAccessible(tester);
      handle.dispose();
    });

    testWidgets('alerts without a backend explain why, in Bengali', (tester) async {
      final handle = tester.ensureSemantics();
      await pump(tester, AppRoutes.alerts, textScale: 2);
      expect(find.text('দামের সতর্কতা'), findsOneWidget);
      expect(find.text('সতর্কতা চালু নেই'), findsOneWidget);
      await expectAccessible(tester);
      handle.dispose();
    });

    testWidgets('destination search hint', (tester) async {
      await pump(tester, AppRoutes.plan);
      expect(find.text('কোথায় যাবেন?'), findsOneWidget);
      expect(find.text(bn.destinationSearchHint), findsOneWidget);
    });
  });
}
