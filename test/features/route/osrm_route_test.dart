import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gas_station_finder/core/error/result.dart';
import 'package:gas_station_finder/core/location/geo_point.dart';
import 'package:gas_station_finder/core/error/app_failure.dart';
import 'package:gas_station_finder/features/route/data/osrm_route_repository.dart';

void main() {
  group('OsrmRouteRepository.parseOsrmRoute', () {
    test('parses distance, duration and [lng,lat] geometry', () {
      final route = OsrmRouteRepository.parseOsrmRoute({
        'code': 'Ok',
        'routes': [
          {
            'distance': 2450.5,
            'duration': 312.4,
            'geometry': {
              'type': 'LineString',
              'coordinates': [
                [90.41, 23.81],
                [90.42, 23.82],
                [90.43, 23.83],
              ],
            },
          },
        ],
      });
      expect(route.distanceMeters, 2450.5);
      expect(route.distanceKm, closeTo(2.4505, 1e-9));
      expect(route.duration, const Duration(seconds: 312));
      expect(route.points, hasLength(3));
      // OSRM order is [lng, lat] — must be swapped.
      expect(route.points.first.latitude, 23.81);
      expect(route.points.first.longitude, 90.41);
    });

    test('NoRoute → NotFoundFailure', () {
      expect(
        () => OsrmRouteRepository.parseOsrmRoute({'code': 'NoRoute', 'routes': []}),
        throwsA(isA<NotFoundFailure>()),
      );
    });

    test('missing geometry → FormatException', () {
      expect(
        () => OsrmRouteRepository.parseOsrmRoute({
          'code': 'Ok',
          'routes': [
            {'distance': 1, 'duration': 1},
          ],
        }),
        throwsFormatException,
      );
    });
  });

  group('alternatives', () {
    Map<String, dynamic> r(double dist, double dur, {bool broken = false}) => {
      'distance': dist,
      'duration': dur,
      'geometry': broken
          ? null
          : {
              'type': 'LineString',
              'coordinates': [
                [90.41, 23.81],
                [90.43, 23.83],
              ],
            },
    };

    test('parses main + alternatives, fastest first, drops broken ones, caps at 3', () {
      final routes = OsrmRouteRepository.parseOsrmRoutes({
        'code': 'Ok',
        'routes': [r(5000, 600), r(4500, 540), r(1, 1, broken: true), r(6000, 700), r(7000, 800)],
      });
      expect(routes.map((x) => x.durationSeconds), [540, 600, 700]);
    });

    test('a broken main route is still an error', () {
      expect(
        () => OsrmRouteRepository.parseOsrmRoutes({'code': 'Ok', 'routes': [r(1, 1, broken: true), r(5000, 600)]}),
        throwsA(isA<FormatException>()),
      );
    });

    test('drivingRoutes asks OSRM for alternatives', () async {
      RequestOptions? sent;
      final dio = Dio(BaseOptions(baseUrl: 'https://osrm.test'))
        ..interceptors.add(InterceptorsWrapper(onRequest: (o, h) {
          sent = o;
          h.resolve(Response(requestOptions: o, statusCode: 200, data: {'code': 'Ok', 'routes': [r(5000, 600), r(5200, 660)]}));
        }));
      final result = await OsrmRouteRepository(dio).drivingRoutes(
        const GeoPoint(latitude: 23.81, longitude: 90.41),
        const GeoPoint(latitude: 23.75, longitude: 90.39),
      );
      expect(sent!.path, '/route/v1/driving/90.41,23.81;90.39,23.75');
      expect(sent!.queryParameters['alternatives'], 3);
      expect((result as Ok).value, hasLength(2));
    });
  });
}
