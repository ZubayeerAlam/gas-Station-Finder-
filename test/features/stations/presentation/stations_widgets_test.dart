import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gas_station_finder/core/error/app_failure.dart';
import 'package:gas_station_finder/core/error/result.dart';
import 'package:gas_station_finder/core/location/geo_point.dart';
import 'package:gas_station_finder/core/location/location_service.dart';
import 'package:gas_station_finder/core/theme/app_theme.dart';
import 'package:gas_station_finder/features/stations/data/stations_providers.dart';
import 'package:gas_station_finder/features/stations/domain/entities/station.dart';
import 'package:gas_station_finder/features/stations/domain/repositories/stations_repository.dart';
import 'package:gas_station_finder/features/stations/presentation/map_screen.dart';
import 'package:gas_station_finder/features/stations/presentation/widgets/station_details_sheet.dart';
import 'package:gas_station_finder/l10n/app_localizations.dart';

const _station = Station(
  id: 's1',
  name: 'Shell Central',
  location: GeoPoint(latitude: 52.521, longitude: 13.41),
  address: 'Main St 1',
);

class _FakeRepo implements StationsRepository {
  _FakeRepo(this.details);

  Future<Result<StationDetails>> Function() details;

  @override
  Future<Result<List<Station>>> nearbyStations(GeoPoint center, {double radiusMeters = 5000}) async =>
      const Ok([_station]);

  @override
  Future<Result<StationDetails>> stationDetails(String stationId) => details();
}

class _FakeLocation implements LocationService {
  _FakeLocation(this.result);

  final Result<GeoPoint> result;
  int settingsOpened = 0;

  @override
  Future<Result<GeoPoint>> currentPosition() async => result;

  @override
  Future<bool> openAppSettings() async {
    settingsOpened++;
    return true;
  }

  @override
  Future<bool> openLocationSettings() async {
    settingsOpened++;
    return true;
  }
}

Widget _host(Widget child, List overrides) => ProviderScope(
  overrides: [...overrides],
  retry: (_, _) => null,
  child: MaterialApp(
    theme: AppTheme.light(),
    home: Scaffold(body: child),
  ),
);

Widget _sheet({VoidCallback? onDirections}) => StationDetailsSheet(
  station: _station,
  origin: const GeoPoint(latitude: 52.52, longitude: 13.405),
  onDirections: onDirections ?? () {},
);

StationDetails _details({List<FuelPrice> prices = const []}) => StationDetails(
  id: 's1',
  name: 'Shell Central',
  location: _station.location,
  rating: 4.4,
  userRatingCount: 98,
  openNow: true,
  phone: '+49 30 1',
  fuelPrices: prices,
);

void main() {
  group('StationDetailsSheet accessibility at 200 % text', () {
    for (final locale in [const Locale('en'), const Locale('bn')]) {
      for (final withPrices in [true, false]) {
        testWidgets('${locale.languageCode}, prices: $withPrices', (tester) async {
          final handle = tester.ensureSemantics();
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                stationsRepositoryProvider.overrideWithValue(
                  _FakeRepo(
                    () async => Ok(
                      _details(
                        prices: withPrices
                            ? const [
                                FuelPrice(fuelType: 'DIESEL', amount: 105, currencyCode: 'BDT'),
                                FuelPrice(fuelType: 'REGULAR_UNLEADED', amount: 122, currencyCode: 'BDT'),
                              ]
                            : const [],
                      ),
                    ),
                  ),
                ),
              ],
              retry: (_, _) => null,
              child: MediaQuery(
                data: const MediaQueryData(textScaler: TextScaler.linear(2)),
                child: MaterialApp(
                  theme: AppTheme.light(),
                  locale: locale,
                  localizationsDelegates: AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  home: Scaffold(body: _sheet()),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
          await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
          await expectLater(tester, meetsGuideline(textContrastGuideline));
          handle.dispose();
        });
      }
    }
  });

  group('StationDetailsSheet', () {
    testWidgets('shows loading, then data with fuel prices', (tester) async {
      final completer = Completer<Result<StationDetails>>();
      await tester.pumpWidget(
        _host(_sheet(), [stationsRepositoryProvider.overrideWithValue(_FakeRepo(() => completer.future))]),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Shell Central'), findsOneWidget);
      expect(find.textContaining('away (straight line)'), findsOneWidget);

      completer.complete(
        Ok(
          _details(
            prices: const [FuelPrice(fuelType: 'DIESEL', amount: 1.689, currencyCode: 'EUR')],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Open now'), findsOneWidget);
      expect(find.text('4.4 (98)'), findsOneWidget);
      expect(find.text('Diesel'), findsOneWidget);
      expect(find.text('EUR 1.689'), findsOneWidget);
      expect(find.textContaining('not available'), findsNothing);
    });

    testWidgets('shows "not available" when no prices', (tester) async {
      await tester.pumpWidget(
        _host(_sheet(), [stationsRepositoryProvider.overrideWithValue(_FakeRepo(() async => Ok(_details())))]),
      );
      await tester.pumpAndSettle();
      expect(find.text('Fuel prices are not available for this station.'), findsOneWidget);
    });

    testWidgets('shows error and retries', (tester) async {
      var calls = 0;
      final repo = _FakeRepo(() async {
        calls++;
        return calls == 1 ? const Err(NetworkFailure()) : Ok(_details());
      });
      await tester.pumpWidget(_host(_sheet(), [stationsRepositoryProvider.overrideWithValue(repo)]));
      await tester.pumpAndSettle();
      expect(find.text(const NetworkFailure().message), findsOneWidget);

      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();
      expect(calls, 2);
      expect(find.text('Open now'), findsOneWidget);
    });

    testWidgets('Directions button invokes callback', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _host(_sheet(onDirections: () => tapped = true), [
          stationsRepositoryProvider.overrideWithValue(_FakeRepo(() async => Ok(_details()))),
        ]),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Directions'));
      expect(tapped, isTrue);
    });
  });

  group('MapScreen location states', () {
    testWidgets('permanently denied → message + open settings', (tester) async {
      final loc = _FakeLocation(
        const Err(LocationFailure(LocationFailureReason.deniedForever, 'Location permission is blocked.')),
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [locationServiceProvider.overrideWithValue(loc)],
          retry: (_, _) => null,
          child: const MaterialApp(home: MapScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Location needed'), findsOneWidget);
      expect(find.text('Location permission is blocked.'), findsOneWidget);
      await tester.tap(find.text('Open app settings'));
      expect(loc.settingsOpened, 1);
    });

    testWidgets('denied → try again only (no settings button)', (tester) async {
      final loc = _FakeLocation(const Err(LocationFailure(LocationFailureReason.denied, 'Need permission')));
      await tester.pumpWidget(
        ProviderScope(
          overrides: [locationServiceProvider.overrideWithValue(loc)],
          retry: (_, _) => null,
          child: const MaterialApp(home: MapScreen()),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Try again'), findsOneWidget);
      expect(find.textContaining('settings'), findsNothing);
    });
  });
}
