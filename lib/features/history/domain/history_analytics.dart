import 'package:freezed_annotation/freezed_annotation.dart';

import 'fill_up.dart';

part 'history_analytics.freezed.dart';

/// Spending in one calendar month and one currency (currencies never mixed).
@freezed
abstract class MonthlySummary with _$MonthlySummary {
  const factory MonthlySummary({
    required int year,
    required int month,
    required String currencyCode,
    required double totalCost,
    required double totalAmount,
    required int count,
  }) = _MonthlySummary;
}

/// Measured consumption between two full fill-ups.
@freezed
abstract class ConsumptionPoint with _$ConsumptionPoint {
  const factory ConsumptionPoint({
    required DateTime date,
    required double distanceKm,
    required double amount,

    /// L/100 km or kWh/100 km (as bought, i.e. including charging losses).
    required double per100Km,

    /// Cost per km; null when the segment mixes currencies.
    double? costPerKm,
    String? currencyCode,
  }) = _ConsumptionPoint;
}

abstract final class HistoryAnalytics {
  /// Groups by (year, month, currency), newest month first.
  static List<MonthlySummary> monthly(List<FillUp> fillUps) {
    final map = <(int, int, String), MonthlySummary>{};
    for (final f in fillUps) {
      final k = (f.date.year, f.date.month, f.currencyCode);
      final s = map[k];
      map[k] = s == null
          ? MonthlySummary(
              year: k.$1, month: k.$2, currencyCode: k.$3, totalCost: f.totalCost, totalAmount: f.amount, count: 1)
          : s.copyWith(
              totalCost: s.totalCost + f.totalCost, totalAmount: s.totalAmount + f.amount, count: s.count + 1);
    }
    return map.values.toList()
      ..sort((a, b) => (b.year * 12 + b.month).compareTo(a.year * 12 + a.month));
  }

  /// Full-to-full method: for each full fill-up with an odometer reading, the
  /// energy bought since the previous full fill-up (partials included) divided
  /// by the distance driven. Segments with no distance are skipped.
  /// Returned oldest first.
  static List<ConsumptionPoint> consumption(List<FillUp> fillUps) {
    final sorted = [...fillUps]..sort((a, b) {
        final byDate = a.date.compareTo(b.date);
        if (byDate != 0) return byDate;
        return (a.odometerKm ?? 0).compareTo(b.odometerKm ?? 0);
      });
    final points = <ConsumptionPoint>[];
    FillUp? anchor; // last full fill-up with odometer
    final since = <FillUp>[];
    for (final f in sorted) {
      if (anchor == null) {
        if (f.isFull && f.odometerKm != null) anchor = f;
        continue;
      }
      since.add(f);
      if (!f.isFull || f.odometerKm == null) continue;
      final distance = f.odometerKm! - anchor.odometerKm!;
      if (distance > 0) {
        final amount = since.fold<double>(0, (s, e) => s + e.amount);
        final currencies = since.map((e) => e.currencyCode).toSet();
        final cost = since.fold<double>(0, (s, e) => s + e.totalCost);
        points.add(ConsumptionPoint(
          date: f.date,
          distanceKm: distance,
          amount: amount,
          per100Km: amount / distance * 100,
          costPerKm: currencies.length == 1 ? cost / distance : null,
          currencyCode: currencies.length == 1 ? currencies.single : null,
        ));
      }
      anchor = f;
      since.clear();
    }
    return points;
  }

  /// Distance-weighted average consumption over all measured segments.
  static double? averagePer100Km(List<ConsumptionPoint> points) {
    final distance = points.fold<double>(0, (s, p) => s + p.distanceKm);
    if (distance <= 0) return null;
    return points.fold<double>(0, (s, p) => s + p.amount) / distance * 100;
  }

  /// The currency used most often (ties → most recent); null if none.
  static String? primaryCurrency(List<FillUp> fillUps) {
    if (fillUps.isEmpty) return null;
    final counts = <String, int>{};
    for (final f in fillUps) {
      counts[f.currencyCode] = (counts[f.currencyCode] ?? 0) + 1;
    }
    final latest = ([...fillUps]..sort((a, b) => b.date.compareTo(a.date))).first.currencyCode;
    final best = counts.values.reduce((a, b) => a > b ? a : b);
    return counts[latest] == best ? latest : counts.entries.firstWhere((e) => e.value == best).key;
  }

  /// Last [months] calendar months ending at [now] (oldest first) with the
  /// spend in [currency]; months without fill-ups are 0.
  static List<(DateTime month, double cost)> spendByMonth(
      List<FillUp> fillUps, String currency, {required DateTime now, int months = 6}) {
    final out = <(DateTime, double)>[];
    for (var i = months - 1; i >= 0; i--) {
      final m = DateTime(now.year, now.month - i);
      final cost = fillUps
          .where((f) => f.currencyCode == currency && f.date.year == m.year && f.date.month == m.month)
          .fold<double>(0, (s, f) => s + f.totalCost);
      out.add((m, cost));
    }
    return out;
  }

  /// Latest odometer (the highest reading — entries may be logged out of
  /// order) and the average km driven per day between the earliest and the
  /// latest dated readings. km/day needs ≥ 2 readings at least a day apart.
  static ({double? latestKm, double? kmPerDay}) odometerStats(List<FillUp> fillUps) {
    final readings = [for (final f in fillUps) if (f.odometerKm != null) f]..sort((a, b) => a.date.compareTo(b.date));
    if (readings.isEmpty) return (latestKm: null, kmPerDay: null);
    final latestKm = readings.map((f) => f.odometerKm!).reduce((a, b) => a > b ? a : b);
    final first = readings.first, last = readings.last;
    final days = last.date.difference(first.date).inHours / 24;
    final km = last.odometerKm! - first.odometerKm!;
    return (latestKm: latestKm, kmPerDay: days >= 1 && km > 0 ? km / days : null);
  }
}
