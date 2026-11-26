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
}
