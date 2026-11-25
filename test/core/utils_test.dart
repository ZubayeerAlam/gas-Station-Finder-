import 'package:flutter_test/flutter_test.dart';
import 'package:gas_station_finder/core/location/geo_point.dart';
import 'package:gas_station_finder/core/utils/formatters.dart';

void main() {
  group('GeoPoint.distanceTo', () {
    test('zero for same point', () {
      const p = GeoPoint(latitude: 23.81, longitude: 90.41);
      expect(p.distanceTo(p), 0);
    });

    test('one degree of latitude ≈ 111.2 km', () {
      const a = GeoPoint(latitude: 0, longitude: 0);
      const b = GeoPoint(latitude: 1, longitude: 0);
      expect(a.distanceTo(b), closeTo(111195, 50));
    });

    test('London → Paris ≈ 343.5 km', () {
      const london = GeoPoint(latitude: 51.5074, longitude: -0.1278);
      const paris = GeoPoint(latitude: 48.8566, longitude: 2.3522);
      expect(london.distanceTo(paris) / 1000, closeTo(343.5, 1.0));
    });
  });

  group('Fmt', () {
    test('distance', () {
      expect(Fmt.distance(420), '420 m');
      expect(Fmt.distance(1234), '1.2 km');
      expect(Fmt.distance(15400), '15 km');
    });
    test('duration', () {
      expect(Fmt.duration(const Duration(seconds: 20)), '< 1 min');
      expect(Fmt.duration(const Duration(minutes: 42)), '42 min');
      expect(Fmt.duration(const Duration(minutes: 125)), '2 h 5 min');
    });
    test('price keeps up to 3 decimals', () {
      expect(Fmt.price(1.789, 'EUR'), 'EUR 1.789');
      expect(Fmt.price(3.5, 'USD'), 'USD 3.50');
    });
    test('relativeTime', () {
      final now = DateTime(2026, 1, 10, 12);
      expect(Fmt.relativeTime(now.subtract(const Duration(minutes: 5)), now: now), '5 min ago');
      expect(Fmt.relativeTime(now.subtract(const Duration(hours: 3)), now: now), '3 h ago');
      expect(Fmt.relativeTime(now.subtract(const Duration(days: 2)), now: now), '2 d ago');
    });
  });

  test('Fmt.number trims decimal zeros but keeps integer zeros', () {
    expect(Fmt.number(10), '10');
    expect(Fmt.number(10.5), '10.5');
    expect(Fmt.number(1.25), '1.25');
    expect(Fmt.number(11900, maxDecimals: 0), '11900');
    expect(Fmt.number(500, maxDecimals: 0), '500');
    expect(Fmt.number(40.4, maxDecimals: 0), '40');
  });
}
