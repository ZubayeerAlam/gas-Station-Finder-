import '../../garage/domain/vehicle_profile.dart';
import 'fill_up.dart';
import 'fill_up_csv.dart';

/// Report windows offered in the History screen.
enum ReportPeriod { last7Days, last30Days, thisMonth, lastMonth, thisYear }

/// Spending on one calendar day in one currency (currencies are never mixed).
class DailySummary {
  const DailySummary({
    required this.day,
    required this.currencyCode,
    required this.totalCost,
    required this.totalAmount,
    required this.count,
  });

  /// Local midnight of the day.
  final DateTime day;
  final String currencyCode;
  final double totalCost;
  final double totalAmount;
  final int count;

  double get averageUnitPrice => totalCost / totalAmount;
}

/// Totals for one currency over the whole period.
class CurrencyTotal {
  const CurrencyTotal({
    required this.currencyCode,
    required this.totalCost,
    required this.totalAmount,
    required this.count,
  });

  final String currencyCode;
  final double totalCost;
  final double totalAmount;
  final int count;

  double get averageUnitPrice => totalCost / totalAmount;
}

class PeriodReport {
  const PeriodReport({
    required this.start,
    required this.end,
    required this.days,
    required this.totals,
    this.odometerDistanceKm,
  });

  /// Inclusive start (local midnight) and exclusive end.
  final DateTime start;
  final DateTime end;

  /// Days with at least one fill-up, newest first.
  final List<DailySummary> days;

  /// One entry per currency, biggest spend first.
  final List<CurrencyTotal> totals;

  /// Highest minus lowest odometer reading inside the period (needs two readings).
  final double? odometerDistanceKm;

  bool get isEmpty => days.isEmpty;

  /// Inclusive last day, for display.
  DateTime get lastDay => end.subtract(const Duration(days: 1));
}

abstract final class HistoryReport {
  /// [start, end) for [period] around [now] (local calendar days).
  static ({DateTime start, DateTime end}) range(ReportPeriod period, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    return switch (period) {
      ReportPeriod.last7Days => (start: DateTime(now.year, now.month, now.day - 6), end: tomorrow),
      ReportPeriod.last30Days => (start: DateTime(now.year, now.month, now.day - 29), end: tomorrow),
      ReportPeriod.thisMonth => (start: DateTime(today.year, today.month), end: tomorrow),
      ReportPeriod.lastMonth => (start: DateTime(today.year, today.month - 1), end: DateTime(today.year, today.month)),
      ReportPeriod.thisYear => (start: DateTime(today.year), end: tomorrow),
    };
  }

  static PeriodReport build(List<FillUp> fillUps, {required DateTime start, required DateTime end}) {
    final inside = [
      for (final f in fillUps)
        if (!f.date.isBefore(start) && f.date.isBefore(end)) f,
    ];
    final byDay = <(DateTime, String), DailySummary>{};
    final byCurrency = <String, CurrencyTotal>{};
    for (final f in inside) {
      final day = DateTime(f.date.year, f.date.month, f.date.day);
      final k = (day, f.currencyCode);
      final d = byDay[k];
      byDay[k] = DailySummary(
        day: day,
        currencyCode: f.currencyCode,
        totalCost: (d?.totalCost ?? 0) + f.totalCost,
        totalAmount: (d?.totalAmount ?? 0) + f.amount,
        count: (d?.count ?? 0) + 1,
      );
      final c = byCurrency[f.currencyCode];
      byCurrency[f.currencyCode] = CurrencyTotal(
        currencyCode: f.currencyCode,
        totalCost: (c?.totalCost ?? 0) + f.totalCost,
        totalAmount: (c?.totalAmount ?? 0) + f.amount,
        count: (c?.count ?? 0) + 1,
      );
    }
    final days = byDay.values.toList()
      ..sort((a, b) {
        final byDate = b.day.compareTo(a.day);
        return byDate != 0 ? byDate : a.currencyCode.compareTo(b.currencyCode);
      });
    final totals = byCurrency.values.toList()..sort((a, b) => b.totalCost.compareTo(a.totalCost));
    final readings = [
      for (final f in inside)
        if (f.odometerKm != null) f.odometerKm!,
    ];
    double? distance;
    if (readings.length >= 2) {
      readings.sort();
      final span = readings.last - readings.first;
      distance = span > 0 ? span : null;
    }
    return PeriodReport(start: start, end: end, days: days, totals: totals, odometerDistanceKm: distance);
  }

  static const csvColumns = [
    'date',
    'vehicle',
    'fill_ups',
    'amount',
    'unit',
    'total_cost',
    'currency',
    'avg_unit_price',
  ];

  /// Daily summary CSV, oldest day first, same conventions as [FillUpCsv].
  static String csv(VehicleProfile vehicle, PeriodReport report) {
    final out = StringBuffer(FillUpCsv.bom)..write(_line(csvColumns));
    for (final d in report.days.reversed) {
      out.write(
        _line([
          _day(d.day),
          vehicle.name,
          '${d.count}',
          _num(d.totalAmount, 3),
          vehicle.unit,
          _num(d.totalCost, 2),
          d.currencyCode,
          _num(d.averageUnitPrice, 3),
        ]),
      );
    }
    return out.toString();
  }

  /// `fuelwise_axio_daily_2026-11-01_2026-11-27.csv`.
  static String fileName(VehicleProfile vehicle, PeriodReport report) {
    final base = FillUpCsv.fileName(vehicle, report.start); // fuelwise_<slug>_<start>.csv
    return '${base.substring(0, base.length - 15)}_daily_${_day(report.start)}_${_day(report.lastDay)}.csv';
  }

  static String _line(List<String> cells) => '${cells.map(FillUpCsv.cell).join(',')}\r\n';

  static String _num(double v, int maxDecimals) {
    var s = v.toStringAsFixed(maxDecimals);
    if (s.contains('.')) s = s.replaceFirst(RegExp(r'\.?0+$'), '');
    return s;
  }

  static String _two(int n) => n.toString().padLeft(2, '0');
  static String _day(DateTime d) => '${d.year}-${_two(d.month)}-${_two(d.day)}';
}
