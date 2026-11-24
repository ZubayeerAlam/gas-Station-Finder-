import 'package:flutter_test/flutter_test.dart';
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
}
