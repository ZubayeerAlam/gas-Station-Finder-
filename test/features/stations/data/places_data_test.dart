import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gas_station_finder/core/config/app_config.dart';
import 'package:gas_station_finder/core/error/app_failure.dart';
import 'package:gas_station_finder/core/error/result.dart';
import 'package:gas_station_finder/core/location/geo_point.dart';
import 'package:gas_station_finder/features/stations/data/places_mapper.dart';
import 'package:gas_station_finder/features/stations/data/places_remote_data_source.dart';
import 'package:gas_station_finder/features/stations/data/places_stations_repository.dart';
import 'package:gas_station_finder/features/stations/data/stations_providers.dart';
import 'package:mocktail/mocktail.dart';

class _MockRemote extends Mock implements PlacesRemoteDataSource {}

const _center = GeoPoint(latitude: 52.52, longitude: 13.405);

Map<String, dynamic> _details({bool withFuel = true, bool withEv = false}) => {
      'id': 'abc',
      'displayName': {'text': 'Aral Mitte', 'languageCode': 'de'},
      'location': {'latitude': 52.521, 'longitude': 13.41},
      'formattedAddress': 'Hauptstr. 1, Berlin',
      'internationalPhoneNumber': '+49 30 123',
      'rating': 4.3,
      'userRatingCount': 210,
      'currentOpeningHours': {
        'openNow': true,
        'weekdayDescriptions': ['Monday: Open 24 hours'],
      },
      if (withFuel)
        'fuelOptions': {
          'fuelPrices': [
            {
              'type': 'DIESEL',
              'price': {'currencyCode': 'EUR', 'units': '1', 'nanos': 689000000},
              'updateTime': '2026-11-20T08:00:00Z',
            },
            {
              'type': 'SP95_E10',
              'price': {'currencyCode': 'EUR', 'units': '1', 'nanos': 789000000},
            },
            // Malformed: no price → must be skipped, never invented.
            {'type': 'LPG'},
          ],
        },
      if (withEv)
        'evChargeOptions': {
          'connectorCount': 4,
          'connectorAggregation': [
            {
              'type': 'EV_CONNECTOR_TYPE_CCS_COMBO_2',
              'maxChargeRateKw': 150,
              'count': 4,
              'availableCount': 2,
            },
          ],
        },
    };

void main() {
  setUpAll(() => registerFallbackValue(_center));

  group('PlacesMapper', () {
    test('maps search results and deduplicates / skips invalid', () {
      final stations = PlacesMapper.stationsFromSearch({
        'places': [
          {
            'id': 'a',
            'displayName': {'text': 'Shell'},
            'location': {'latitude': 1.0, 'longitude': 2.0},
            'shortFormattedAddress': 'Main St',
          },
          {
            'id': 'a', // duplicate
            'displayName': {'text': 'Shell dup'},
            'location': {'latitude': 1.0, 'longitude': 2.0},
          },
          {'id': 'no-location', 'displayName': {'text': 'X'}},
          {
            'id': 'b',
            'location': {'latitude': 3.0, 'longitude': 4.0},
          },
        ],
      });
      expect(stations.map((s) => s.id), ['a', 'b']);
      expect(stations.first.name, 'Shell');
      expect(stations.first.address, 'Main St');
      expect(stations.last.name, 'Unnamed station');
    });

    test('empty response {} → empty list', () {
      expect(PlacesMapper.stationsFromSearch({}), isEmpty);
    });

    test('details with fuel prices', () {
      final d = PlacesMapper.detailsFromJson(_details());
      expect(d.name, 'Aral Mitte');
      expect(d.openNow, isTrue);
      expect(d.rating, 4.3);
      expect(d.userRatingCount, 210);
      expect(d.weekdayHours, ['Monday: Open 24 hours']);
      expect(d.fuelPrices, hasLength(2));
      expect(d.fuelPrices.first.fuelType, 'DIESEL');
      expect(d.fuelPrices.first.amount, closeTo(1.689, 1e-9));
      expect(d.fuelPrices.first.currencyCode, 'EUR');
      expect(d.fuelPrices.first.updatedAt, DateTime.utc(2026, 11, 20, 8));
      expect(d.fuelPrices[1].updatedAt, isNull);
      expect(d.evCharge, isNull);
    });

    test('details without fuel options → no prices (not fabricated)', () {
      final d = PlacesMapper.detailsFromJson(_details(withFuel: false));
      expect(d.fuelPrices, isEmpty);
      expect(d.hasFuelPrices, isFalse);
    });

    test('details with EV options', () {
      final d = PlacesMapper.detailsFromJson(_details(withFuel: false, withEv: true));
      expect(d.evCharge!.connectorCount, 4);
      final c = d.evCharge!.connectors.single;
      expect(c.type, 'EV_CONNECTOR_TYPE_CCS_COMBO_2');
      expect(c.maxChargeRateKw, 150);
      expect(c.availableCount, 2);
    });

    test('details missing id throws FormatException', () {
      expect(() => PlacesMapper.detailsFromJson({'displayName': {'text': 'x'}}), throwsFormatException);
    });

    test('parseMoney handles numeric units and nanos-only', () {
      expect(PlacesMapper.parseMoney({'currencyCode': 'USD', 'units': 3, 'nanos': 990000000})!.amount,
          closeTo(3.99, 1e-9));
      expect(PlacesMapper.parseMoney({'currencyCode': 'USD', 'nanos': 500000000})!.amount, 0.5);
      expect(PlacesMapper.parseMoney({'units': '1'}), isNull);
      expect(PlacesMapper.parseMoney(null), isNull);
    });
  });

  group('PlacesStationsRepository', () {
    late _MockRemote remote;
    setUp(() => remote = _MockRemote());

    test('returns ConfigFailure without calling network when key missing', () async {
      final repo = PlacesStationsRepository(remote, hasApiKey: false);
      final r = await repo.nearbyStations(_center);
      expect((r as Err).failure, isA<ConfigFailure>());
      verifyNever(() => remote.searchNearby(any(), radiusMeters: any(named: 'radiusMeters')));
    });

    test('maps success', () async {
      when(() => remote.searchNearby(_center, radiusMeters: 5000)).thenAnswer((_) async => {
            'places': [
              {
                'id': 'a',
                'displayName': {'text': 'Shell'},
                'location': {'latitude': 1.0, 'longitude': 2.0},
              },
            ],
          });
      final r = await PlacesStationsRepository(remote, hasApiKey: true).nearbyStations(_center);
      expect(r.getOrThrow().single.name, 'Shell');
    });

    test('maps Dio 403 to ServerFailure', () async {
      final ro = RequestOptions(path: '/places:searchNearby');
      when(() => remote.searchNearby(_center, radiusMeters: 5000)).thenThrow(DioException(
        requestOptions: ro,
        type: DioExceptionType.badResponse,
        response: Response<dynamic>(requestOptions: ro, statusCode: 403),
      ));
      final r = await PlacesStationsRepository(remote, hasApiKey: true).nearbyStations(_center);
      expect((r as Err).failure, isA<ServerFailure>());
    });

    test('details maps malformed payload to ServerFailure', () async {
      when(() => remote.placeDetails('x')).thenAnswer((_) async => {'nope': true});
      final r = await PlacesStationsRepository(remote, hasApiKey: true).stationDetails('x');
      expect((r as Err).failure, isA<ServerFailure>());
    });
  });

  group('placesHeaders', () {
    const config = AppConfig(
      googleMapsApiKey: 'k',
      osrmBaseUrl: 'https://o',
      androidCertSha1: 'ABC',
    );

    test('android adds package + cert', () {
      final h = placesHeaders(config, TargetPlatform.android);
      expect(h['X-Goog-Api-Key'], 'k');
      expect(h['X-Android-Package'], config.androidPackageName);
      expect(h['X-Android-Cert'], 'ABC');
      expect(h.containsKey('X-Ios-Bundle-Identifier'), isFalse);
    });

    test('iOS adds bundle id', () {
      final h = placesHeaders(config, TargetPlatform.iOS);
      expect(h['X-Ios-Bundle-Identifier'], config.iosBundleId);
      expect(h.containsKey('X-Android-Package'), isFalse);
    });

    test('android without cert omits X-Android-Cert', () {
      const noCert = AppConfig(googleMapsApiKey: 'k', osrmBaseUrl: 'https://o');
      expect(placesHeaders(noCert, TargetPlatform.android).containsKey('X-Android-Cert'), isFalse);
    });
  });
}
