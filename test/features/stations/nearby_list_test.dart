import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gas_station_finder/core/location/geo_point.dart';
import 'package:gas_station_finder/core/theme/app_theme.dart';
import 'package:gas_station_finder/features/ev/domain/charge_point.dart';
import 'package:gas_station_finder/features/stations/domain/entities/station.dart';
import 'package:gas_station_finder/features/stations/domain/nearby_sort.dart';
import 'package:gas_station_finder/features/stations/presentation/widgets/nearby_list.dart';
import 'package:gas_station_finder/l10n/app_localizations.dart';

const origin = GeoPoint(latitude: 23.7806, longitude: 90.4070);
GeoPoint north(double km) => GeoPoint(latitude: origin.latitude + km / 111.2, longitude: origin.longitude);

Future<void> pump(WidgetTester tester, Widget child, {Locale locale = const Locale('en'), double scale = 1}) async {
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
      home: Scaffold(body: child),
    ),
  );
  await tester.pumpAndSettle();
}

final chargers = [
  ChargePoint(
    id: 'fast',
    name: 'Bashundhara DC',
    location: north(3),
    operatorName: 'Petromax',
    connectors: const [ChargeConnector(type: 'CCS', powerKw: 120)],
  ),
  ChargePoint(
    id: 'slow',
    name: 'Gulshan AC',
    location: north(1),
    connectors: const [ChargeConnector(type: 'T2', powerKw: 7)],
  ),
  ChargePoint(id: 'down', name: 'Old Depot', location: north(0.5), isOperational: false),
];

void main() {
  testWidgets('stations: nearest first, distance shown, tap opens', (tester) async {
    Station? opened;
    final ranked = nearestFirst(
      [
        Station(id: 'b', name: 'Meghna Filling', location: north(2.4), address: 'Mirpur Rd'),
        Station(id: 'a', name: 'Padma Oil', location: north(0.3)),
      ],
      origin,
      (s) => s.location,
    );
    await pump(tester, NearbyStationList(stations: ranked, onOpen: (s) => opened = s));

    final first = tester.getTopLeft(find.text('Padma Oil'));
    final second = tester.getTopLeft(find.text('Meghna Filling'));
    expect(first.dy, lessThan(second.dy));
    expect(find.text('Mirpur Rd'), findsOneWidget);
    expect(find.text('300 m'), findsOneWidget);
    expect(find.text('2.4 km'), findsOneWidget);

    await tester.tap(find.text('Meghna Filling'));
    expect(opened?.id, 'b');
  });

  testWidgets('chargers: power, operator, out of service, sort chips', (tester) async {
    var sort = ChargerSort.nearest;
    ChargePoint? opened;
    await pump(
      tester,
      StatefulBuilder(
        builder: (context, setState) => NearbyChargerList(
          chargers: sortChargers(chargers, origin, sort),
          sort: sort,
          onSort: (v) => setState(() => sort = v),
          onOpen: (c) => opened = c,
        ),
      ),
    );
    double y(String name) => tester.getTopLeft(find.text(name)).dy;
    // nearest: out-of-service goes last even though it is closest
    expect(y('Gulshan AC'), lessThan(y('Bashundhara DC')));
    expect(y('Bashundhara DC'), lessThan(y('Old Depot')));
    expect(find.text('120 kW · Petromax'), findsOneWidget);
    expect(find.text('EV · Out of service'), findsOneWidget);

    await tester.tap(find.text('Fastest charging'));
    await tester.pumpAndSettle();
    expect(sort, ChargerSort.fastest);
    expect(y('Bashundhara DC'), lessThan(y('Gulshan AC')));

    await tester.tap(find.text('Old Depot'));
    expect(opened?.id, 'down');
  });

  testWidgets('Bengali at 200 % text is accessible', (tester) async {
    final handle = tester.ensureSemantics();
    await pump(
      tester,
      NearbyChargerList(
        chargers: sortChargers(chargers, origin, ChargerSort.nearest),
        sort: ChargerSort.nearest,
        onSort: (_) {},
        onOpen: (_) {},
      ),
      locale: const Locale('bn'),
      scale: 2,
    );
    expect(find.text('সবচেয়ে কাছে'), findsOneWidget);
    expect(find.textContaining('বন্ধ আছে'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    handle.dispose();
  });
}
