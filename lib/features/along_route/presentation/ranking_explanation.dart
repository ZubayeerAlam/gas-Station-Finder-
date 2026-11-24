import '../../../core/utils/formatters.dart';
import '../../ranking/domain/ranking_models.dart';

String badgeLabel(RankingBadge b) => switch (b) {
  RankingBadge.cheapestOverall => 'Cheapest',
  RankingBadge.bestValue => 'Best value',
  RankingBadge.shortestDetour => 'Least detour',
  RankingBadge.mostReliable => 'Most reliable',
};

String caveatLabel(Caveat c) => switch (c) {
  Caveat.closed => 'Closed now',
  Caveat.unreachable => 'May be out of range',
  Caveat.otherCurrency => 'Other currency (not converted)',
  Caveat.priceUnknown => 'No price available',
  Caveat.stalePrice => 'Price older than 3 days',
};

String strategyLabel(RankingStrategy s) => switch (s) {
  RankingStrategy.cheapestTotal => 'Cheapest',
  RankingStrategy.shortestDetour => 'Least detour',
  RankingStrategy.bestValue => 'Best value',
};

/// "+2.0 km · +3 min" (time only when known).
String detourText(StationOffer o) {
  final km = o.detourMeters < 50 ? 'on route' : '+${Fmt.distance(o.detourMeters)}';
  final t = o.detourSeconds;
  return t == null || o.detourMeters < 50 ? km : '$km · +${Fmt.duration(Duration(seconds: t.round()))}';
}

/// Plain-language "why" for one result — every number shown is computed,
/// nothing is estimated.
List<String> explainRanking(RankedStation r, {required CostMode mode, required String unit, DateTime? now}) {
  final o = r.offer;
  final ccy = o.currencyCode;
  final price = o.pricePerUnit;
  final lines = <String>[];
  if (price == null || ccy == null) {
    lines.add('No price is available for this station, so its cost cannot be compared.');
  } else if (mode == CostMode.unitPriceOnly) {
    lines.add('${Fmt.price(price, ccy)} per $unit. Add a vehicle in your garage to compare the total trip cost.');
  } else {
    lines.add(
      'Buy ${Fmt.number(r.purchaseUnits!)} $unit × ${Fmt.price(price, ccy)} = ${Fmt.money(r.purchaseCost!, ccy)}',
    );
    if (o.detourMeters >= 50) {
      lines.add(
        'Detour ${Fmt.distance(o.detourMeters)} uses ${Fmt.number(r.detourUnits!)} $unit '
        '= ${Fmt.money(r.detourCost!, ccy)}',
      );
    }
    final savings = r.savingsVsNearest;
    final cmp = savings == null || savings.abs() < 0.005
        ? ''
        : savings > 0
        ? ' · saves ${Fmt.money(savings, ccy)} vs the nearest station'
        : ' · ${Fmt.money(-savings, ccy)} more than the nearest station';
    lines.add('Total ${Fmt.money(r.totalCost!, ccy)}$cmp');
  }
  if (price != null && o.priceSource != null) {
    final when = o.priceUpdatedAt == null ? '' : ', updated ${Fmt.relativeTime(o.priceUpdatedAt!, now: now)}';
    lines.add('Price source: ${o.priceSource == PriceSource.google ? 'Google' : 'community'}$when');
  }
  for (final c in r.caveats) {
    if (c != Caveat.priceUnknown) lines.add(caveatLabel(c));
  }
  return lines;
}
