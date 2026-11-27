import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gas_station_finder/core/error/result.dart';
import 'package:gas_station_finder/core/theme/app_theme.dart';
import 'package:gas_station_finder/features/garage/data/drift_garage_repository.dart';
import 'package:gas_station_finder/features/history/data/drift_fill_up_repository.dart';
import 'package:gas_station_finder/features/history/data/share_history_exporter.dart';
import 'package:gas_station_finder/features/history/domain/fill_up.dart';
import 'package:gas_station_finder/features/history/domain/history_report.dart';
import 'package:gas_station_finder/features/history/presentation/history_report_sheet.dart';
import 'package:gas_station_finder/features/history/presentation/history_screen.dart';
import 'package:gas_station_finder/l10n/app_localizations.dart';

import '../../helpers/fake_fill_up_repository.dart';
import '../../helpers/fake_garage_repository.dart';
import 'history_test.dart' show car, fill;

class _Exporter implements HistoryExporter {
  final calls = <(String, String, String?)>[];
  @override
  Future<Result<void>> export({required String fileName, required String csv, String? subject, Rect? origin}) async {
    calls.add((fileName, csv, subject));
    return const Ok(null);
  }
}

final now = DateTime(2026, 11, 27, 15);

final sample = [
  fill('a', DateTime(2026, 11, 27, 8), 30, 3900, odo: 12000, ccy: 'BDT'),
  fill('b', DateTime(2026, 11, 27, 19), 10, 1300, ccy: 'BDT'),
  fill('c', DateTime(2026, 11, 20), 20, 2600, odo: 11500, ccy: 'BDT'),
  fill('d', DateTime(2026, 11, 2), 5, 9, ccy: 'EUR'),
  fill('e', DateTime(2026, 10, 31, 23, 59), 25, 3250, odo: 11000, ccy: 'BDT'),
  fill('f', DateTime(2025, 12, 31), 25, 3000, ccy: 'BDT'),
];

void main() {
  group('range', () {
    test('periods are whole local days ending today', () {
      final r7 = HistoryReport.range(ReportPeriod.last7Days, now);
      expect(r7.start, DateTime(2026, 11, 21));
      expect(r7.end, DateTime(2026, 11, 28));
      expect(HistoryReport.range(ReportPeriod.last30Days, now).start, DateTime(2026, 10, 29));
      expect(HistoryReport.range(ReportPeriod.thisMonth, now).start, DateTime(2026, 11, 1));
      final last = HistoryReport.range(ReportPeriod.lastMonth, now);
      expect((last.start, last.end), (DateTime(2026, 10, 1), DateTime(2026, 11, 1)));
      expect(HistoryReport.range(ReportPeriod.thisYear, now).start, DateTime(2026));
      // January → last month is December of the previous year.
      final jan = HistoryReport.range(ReportPeriod.lastMonth, DateTime(2027, 1, 5));
      expect((jan.start, jan.end), (DateTime(2026, 12, 1), DateTime(2027, 1, 1)));
    });
  });

  group('build', () {
    test('this month: per-day per-currency, newest first; totals per currency; odometer span', () {
      final r = HistoryReport.range(ReportPeriod.thisMonth, now);
      final report = HistoryReport.build(sample, start: r.start, end: r.end);
      expect(report.days.map((d) => (d.day.day, d.currencyCode, d.count)), [
        (27, 'BDT', 2),
        (20, 'BDT', 1),
        (2, 'EUR', 1),
      ]);
      expect(report.days.first.totalCost, 5200);
      expect(report.days.first.totalAmount, 40);
      expect(report.days.first.averageUnitPrice, 130);
      expect(report.totals.map((t) => (t.currencyCode, t.totalCost, t.count)), [('BDT', 7800.0, 3), ('EUR', 9.0, 1)]);
      expect(report.odometerDistanceKm, 500);
      expect(report.lastDay, DateTime(2026, 11, 27));
    });

    test('boundaries: last minute of the previous month stays out; empty period; one reading → no distance', () {
      final last = HistoryReport.range(ReportPeriod.lastMonth, now);
      final oct = HistoryReport.build(sample, start: last.start, end: last.end);
      expect(oct.days.single.day, DateTime(2026, 10, 31));
      expect(oct.odometerDistanceKm, isNull);
      final empty = HistoryReport.build(sample, start: DateTime(2026, 6), end: DateTime(2026, 7));
      expect(empty.isEmpty, isTrue);
      expect(empty.totals, isEmpty);
    });

    test('CSV: oldest day first, same conventions as the history CSV', () {
      final r = HistoryReport.range(ReportPeriod.thisMonth, now);
      final report = HistoryReport.build(sample, start: r.start, end: r.end);
      final lines = HistoryReport.csv(car, report).split('\r\n');
      expect(lines.first, '﻿date,vehicle,fill_ups,amount,unit,total_cost,currency,avg_unit_price');
      expect(lines[1], '2026-11-02,Corolla,1,5,L,9,EUR,1.8');
      expect(lines[3], '2026-11-27,Corolla,2,40,L,5200,BDT,130');
      expect(HistoryReport.fileName(car, report), 'fuelwise_corolla_daily_2026-11-01_2026-11-27.csv');
    });
  });

  group('sheet', () {
    Future<_Exporter> pump(
      WidgetTester tester, {
      Locale locale = const Locale('en'),
      double textScale = 1,
      DateTime? at,
    }) async {
      final exporter = _Exporter();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            garageRepositoryProvider.overrideWithValue(FakeGarageRepository([car])),
            fillUpRepositoryProvider.overrideWithValue(FakeFillUpRepository(<FillUp>[...sample])),
            historyExporterProvider.overrideWithValue(exporter),
          ],
          retry: (_, _) => null,
          child: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
            child: MaterialApp(
              theme: AppTheme.light(),
              locale: locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: HistoryScreen(now: at ?? now),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      return exporter;
    }

    Finder inSheet(Finder f) => find.descendant(of: find.byType(HistoryReportSheet), matching: f);

    Future<void> scrollSheetTo(WidgetTester tester, Finder f) => tester.dragUntilVisible(
      f,
      find.descendant(of: find.byType(HistoryReportSheet), matching: find.byType(Scrollable)).first,
      const Offset(0, -200),
    );

    testWidgets('opens on this month, switches period, exports the daily CSV', (tester) async {
      final exporter = await pump(tester);
      await tester.tap(find.byTooltip('Spending report'));
      await tester.pumpAndSettle();
      expect(find.text('2026-11-01 to 2026-11-27'), findsOneWidget);
      expect(inSheet(find.text('BDT 7800.00')), findsOneWidget);
      expect(find.textContaining('60 L · 3 fill-ups · average'), findsOneWidget);
      expect(find.byKey(const Key('reportDistance')), findsOneWidget);
      await scrollSheetTo(tester, find.byKey(const ValueKey('reportDay-2026-11-27-BDT')));
      expect(find.byKey(const ValueKey('reportDay-2026-11-27-BDT')), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('reportPeriod-lastMonth')));
      await tester.pumpAndSettle();
      expect(find.text('2026-10-01 to 2026-10-31'), findsOneWidget);
      expect(inSheet(find.text('BDT 3250.00')), findsOneWidget);
      expect(find.byKey(const Key('reportDistance')), findsNothing);

      await scrollSheetTo(tester, find.byKey(const Key('reportExport')));
      await tester.tap(find.byKey(const Key('reportExport')));
      await tester.pumpAndSettle();
      final call = exporter.calls.single;
      expect(call.$1, 'fuelwise_corolla_daily_2026-10-01_2026-10-31.csv');
      expect(call.$2.split('\r\n')[1], '2026-10-31,Corolla,1,25,L,3250,BDT,130');
      expect(call.$3, 'FuelWise daily report: Corolla');
    });

    testWidgets('empty period says so and offers no export', (tester) async {
      await pump(tester, at: DateTime(2027, 6, 1));
      await tester.tap(find.byTooltip('Spending report'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('reportPeriod-last7Days')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('reportEmpty')), findsOneWidget);
      expect(find.byKey(const Key('reportExport')), findsNothing);
    });

    testWidgets('Bengali at 200 % text meets accessibility guidelines', (tester) async {
      final handle = tester.ensureSemantics();
      await pump(tester, locale: const Locale('bn'), textScale: 2);
      final bn = lookupAppLocalizations(const Locale('bn'));
      await tester.tap(find.byTooltip(bn.reportTitle));
      await tester.pumpAndSettle();
      expect(inSheet(find.text(bn.reportThisMonth)), findsOneWidget);
      expect(tester.takeException(), isNull);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      handle.dispose();
    });
  });
}
