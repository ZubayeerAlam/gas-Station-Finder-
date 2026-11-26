import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gas_station_finder/core/location/geo_point.dart';
import 'package:gas_station_finder/core/theme/app_theme.dart';
import 'package:gas_station_finder/features/route/domain/route_info.dart';
import 'package:gas_station_finder/features/route/presentation/route_summary_card.dart';
import 'package:gas_station_finder/l10n/app_localizations.dart';

const a = GeoPoint(latitude: 23.8, longitude: 90.4);
const b = GeoPoint(latitude: 23.7, longitude: 90.4);
RouteInfo route(double m, double s) => RouteInfo(distanceMeters: m, durationSeconds: s, points: const [a, b]);

Future<void> pump(
  WidgetTester tester,
  RoutePlan? plan, {
  bool loading = false,
  ValueChanged<int>? onSelect,
  Locale locale = const Locale('en'),
  double scale = 1,
}) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 2.75;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light(),
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, c) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
        child: c!,
      ),
      home: Scaffold(
        body: Align(
          alignment: Alignment.bottomCenter,
          child: RouteSummaryCard(plan: plan, loading: loading, onSelect: onSelect ?? (_) {}, onClear: () {}),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  final plan = RoutePlan([route(12300, 1500), route(11800, 1740), route(14000, 1520)]);

  testWidgets('single route: no chips', (tester) async {
    await pump(tester, RoutePlan([route(2400, 300)]));
    expect(find.text('2.4 km · 5 min'), findsOneWidget);
    expect(find.byType(ChoiceChip), findsNothing);
  });

  testWidgets('loading shows calculating', (tester) async {
    await pump(tester, null, loading: true);
    expect(find.text('Calculating route…'), findsOneWidget);
  });

  testWidgets('alternatives: labels relative to fastest, tap selects', (tester) async {
    int? picked;
    await pump(tester, plan, onSelect: (i) => picked = i);
    expect(find.text('12 km · 25 min'), findsOneWidget);
    expect(find.text('Fastest · 12 km'), findsOneWidget);
    expect(find.text('+4 min · 12 km'), findsOneWidget);
    expect(find.text('Similar time · 14 km'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('routeOption-1')));
    expect(picked, 1);
  });

  testWidgets('selected alternative is shown in the headline', (tester) async {
    await pump(tester, plan.select(1));
    expect(find.text('12 km · 29 min'), findsOneWidget);
    expect(tester.widget<ChoiceChip>(find.byKey(const ValueKey('routeOption-1'))).selected, isTrue);
  });

  testWidgets('Bengali at 200 % text is accessible', (tester) async {
    final handle = tester.ensureSemantics();
    await pump(tester, plan, locale: const Locale('bn'), scale: 2);
    expect(find.text('দ্রুততম · 12 km'), findsOneWidget);
    expect(find.text('+4 মিনিট · 12 km'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    handle.dispose();
  });
}
