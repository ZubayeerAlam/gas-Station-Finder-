import '../../../core/utils/formatters.dart';
import '../../../l10n/failure_text.dart';
import '../../../l10n/l10n.dart';
import '../../ranking/domain/ranking_models.dart';

// Every function takes an optional [AppLocalizations]; without one it uses
// English. The AI assistant's tool results deliberately stay in English.

String badgeLabel(RankingBadge b, [AppLocalizations? l]) {
  final t = l ?? kEnglish;
  return switch (b) {
    RankingBadge.cheapestOverall => t.badgeCheapest,
    RankingBadge.bestValue => t.badgeBestValue,
    RankingBadge.shortestDetour => t.badgeLeastDetour,
    RankingBadge.mostReliable => t.badgeMostReliable,
  };
}

String caveatLabel(Caveat c, [AppLocalizations? l]) {
  final t = l ?? kEnglish;
  return switch (c) {
    Caveat.closed => t.caveatClosed,
    Caveat.unreachable => t.caveatUnreachable,
    Caveat.otherCurrency => t.caveatOtherCurrency,
    Caveat.priceUnknown => t.caveatPriceUnknown,
    Caveat.stalePrice => t.caveatStalePrice,
  };
}

String strategyLabel(RankingStrategy s, [AppLocalizations? l]) {
  final t = l ?? kEnglish;
  return switch (s) {
    RankingStrategy.cheapestTotal => t.badgeCheapest,
    RankingStrategy.shortestDetour => t.badgeLeastDetour,
    RankingStrategy.bestValue => t.badgeBestValue,
  };
}

/// "+2.0 km · +3 min" (time only when known).
String detourText(StationOffer o, [AppLocalizations? l]) {
  final km = o.detourMeters < 50 ? (l ?? kEnglish).onRoute : '+${Fmt.distance(o.detourMeters)}';
  final t = o.detourSeconds;
  return t == null || o.detourMeters < 50 ? km : '$km · +${Fmt.duration(Duration(seconds: t.round()))}';
}

/// Plain-language "why" for one result — every number shown is computed,
/// nothing is estimated.
List<String> explainRanking(
  RankedStation r, {
  required CostMode mode,
  required String unit,
  DateTime? now,
  AppLocalizations? l,
}) {
  final t = l ?? kEnglish;
  final o = r.offer;
  final ccy = o.currencyCode;
  final price = o.pricePerUnit;
  final lines = <String>[];
  if (price == null || ccy == null) {
    lines.add(t.explainNoPrice);
  } else if (mode == CostMode.unitPriceOnly) {
    lines.add(t.explainUnitOnly(Fmt.price(price, ccy), unit));
  } else {
    lines.add(t.explainBuy(Fmt.number(r.purchaseUnits!), unit, Fmt.price(price, ccy), Fmt.money(r.purchaseCost!, ccy)));
    if (o.detourMeters >= 50) {
      lines.add(t.explainDetour(
          Fmt.distance(o.detourMeters), Fmt.number(r.detourUnits!), unit, Fmt.money(r.detourCost!, ccy)));
    }
    final savings = r.savingsVsNearest;
    final cmp = savings == null || savings.abs() < 0.005
        ? ''
        : savings > 0
        ? t.explainSaves(Fmt.money(savings, ccy))
        : t.explainMore(Fmt.money(-savings, ccy));
    lines.add(t.explainTotal(Fmt.money(r.totalCost!, ccy), cmp));
  }
  if (price != null && o.priceSource != null) {
    final when = o.priceUpdatedAt == null ? '' : t.explainUpdated(relativeTime(o.priceUpdatedAt!, t, now: now));
    lines.add('${o.priceSource == PriceSource.google ? t.explainSourceGoogle : t.explainSourceCommunity}$when');
  }
  for (final c in r.caveats) {
    if (c != Caveat.priceUnknown) lines.add(caveatLabel(c, t));
  }
  return lines;
}
