import 'package:gas_station_finder/features/ranking/domain/ranking_models.dart';
import 'package:gas_station_finder/features/along_route/domain/along_route_repositories.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gas_station_finder/core/location/geo_point.dart';
import 'package:gas_station_finder/features/ev/domain/charge_point.dart';
import 'package:gas_station_finder/features/stations/domain/entities/station.dart';
import 'package:gas_station_finder/features/stations/domain/nearby_sort.dart';

const origin = GeoPoint(latitude: 23.7806, longitude: 90.4070); // Dhaka

GeoPoint north(double km) => GeoPoint(latitude: origin.latitude + km / 111.2, longitude: origin.longitude);

ChargePoint cp(String id, double km, {double? kw, bool? up}) => ChargePoint(
  id: id,
  name: id,
  location: north(km),
  isOperational: up,
  connectors: [if (kw != null) ChargeConnector(type: 'CCS', powerKw: kw)],
);

void main() {
  test('stations: nearest first with distances, ties keep search order', () {
    final r = nearestFirst(
      [
        Station(id: 'far', name: 'far', location: north(3)),
        Station(id: 'a', name: 'a', location: north(1)),
        Station(id: 'b', name: 'b', location: north(1)),
        Station(id: 'here', name: 'here', location: origin),
      ],
      origin,
      (s) => s.location,
    );
    expect(r.map((e) => e.item.id), ['here', 'a', 'b', 'far']);
    expect(r.first.meters, 0);
    expect(r[1].meters, closeTo(1000, 15));
  });

  test('chargers nearest: out-of-service last, unknown status counts as available', () {
    final r = sortChargers(
      [cp('down', 0.5, up: false), cp('far', 4), cp('near', 1, up: true)],
      origin,
      ChargerSort.nearest,
    );
    expect(r.map((e) => e.item.id), ['near', 'far', 'down']);
  });

  test('chargers fastest: by power, unknown power last, then distance', () {
    final r = sortChargers(
      [
        cp('slow', 0.2, kw: 7),
        cp('unknown', 0.1),
        cp('fastFar', 5, kw: 150),
        cp('fastNear', 2, kw: 150),
        cp('fastDown', 0.1, kw: 350, up: false),
      ],
      origin,
      ChargerSort.fastest,
    );
    expect(r.map((e) => e.item.id), ['fastNear', 'fastFar', 'slow', 'unknown', 'fastDown']);
  });

  test('empty input', () {
    expect(sortChargers(const [], origin, ChargerSort.fastest), isEmpty);
  });

  group('cheapestFirst', () {
    Station st(String id, double km) => Station(
      id: id,
      name: id,
      location: GeoPoint(latitude: 23.78 + km / 111.2, longitude: 90.40),
    );
    StationQuote q(double amount, {String cur = 'BDT', PriceSource src = PriceSource.google}) => StationQuote(
      price: FuelPrice(fuelType: 'REGULAR_UNLEADED', amount: amount, currencyCode: cur),
      priceSource: src,
    );
    final here = const GeoPoint(latitude: 23.78, longitude: 90.40);
    final ranked = nearestFirst(
      [st('far', 3), st('mid', 2), st('near', 1), st('none', 0.5), st('usd', 0.2)],
      here,
      (s) => s.location,
    );

    test('cheapest first in the main currency; ties go to the nearer; rest nearest first', () {
      final out = cheapestFirst(ranked, {
        'far': q(120),
        'mid': q(125, src: PriceSource.community),
        'near': q(120),
        'usd': q(1.1, cur: 'USD'),
      });
      expect(out.map((p) => p.ranked.item.id), ['near', 'far', 'mid', 'usd', 'none']);
      expect(out[2].source, PriceSource.community);
      expect(out[3].price, isNull, reason: 'other currency is not compared');
    });

    test('no prices at all keeps the nearest order', () {
      expect(cheapestFirst(ranked, const {}).map((p) => p.ranked.item.id), ['usd', 'none', 'near', 'mid', 'far']);
    });
  });
}
