import '../../garage/domain/vehicle_profile.dart';
import 'fill_up.dart';

/// CSV export of a vehicle's fill-up / charging history.
///
/// Machine-readable on purpose, in both app languages: English column names,
/// `.` decimals, no thousands separators, `yyyy-MM-dd HH:mm` local time,
/// oldest first. RFC 4180 quoting with CRLF line ends, and a UTF-8 BOM so
/// spreadsheet apps show Bengali station names correctly.
abstract final class FillUpCsv {
  static const columns = [
    'date',
    'vehicle',
    'amount',
    'unit',
    'total_cost',
    'currency',
    'unit_price',
    'odometer_km',
    'full_fill',
    'station',
  ];

  static const bom = '﻿';

  static String build(VehicleProfile vehicle, List<FillUp> fillUps) {
    final rows = [...fillUps]..sort((a, b) => a.date.compareTo(b.date));
    final out = StringBuffer(bom)..write(_line(columns));
    for (final f in rows) {
      out.write(
        _line([
          _date(f.date),
          vehicle.name,
          _num(f.amount, 3),
          vehicle.unit,
          _num(f.totalCost, 2),
          f.currencyCode,
          _num(f.unitPrice, 3),
          f.odometerKm == null ? '' : _num(f.odometerKm!, 1),
          f.isFull ? 'yes' : 'no',
          f.stationName ?? '',
        ]),
      );
    }
    return out.toString();
  }

  /// `fuelwise_axio_2026-11-27.csv`: only ASCII letters, digits and `-`.
  static String fileName(VehicleProfile vehicle, DateTime now) {
    final slug = vehicle.name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-').replaceAll(RegExp(r'^-+|-+$'), '');
    return 'fuelwise_${slug.isEmpty ? 'vehicle' : slug}_${_day(now)}.csv';
  }

  static String _line(List<String> cells) => '${cells.map(cell).join(',')}\r\n';

  /// Quotes when needed and defuses spreadsheet formulas (`=`, `+`, `-`, `@`,
  /// tab, CR at the start of user text), so a station name can't run code.
  static String cell(String value) {
    var v = value;
    if (v.isNotEmpty && '=+-@\t\r'.contains(v[0])) v = "'$v";
    if (v.contains(RegExp('[",\r\n]'))) v = '"${v.replaceAll('"', '""')}"';
    return v;
  }

  static String _num(double v, int maxDecimals) {
    var s = v.toStringAsFixed(maxDecimals);
    if (s.contains('.')) s = s.replaceFirst(RegExp(r'\.?0+$'), '');
    return s;
  }

  static String _two(int n) => n.toString().padLeft(2, '0');
  static String _day(DateTime d) => '${d.year}-${_two(d.month)}-${_two(d.day)}';
  static String _date(DateTime d) => '${_day(d)} ${_two(d.hour)}:${_two(d.minute)}';
}
