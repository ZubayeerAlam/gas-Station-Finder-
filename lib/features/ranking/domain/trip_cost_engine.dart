import 'dart:math' as math;

import '../../garage/domain/vehicle_profile.dart';
import 'ranking_models.dart';

/// Ranks refuelling/charging candidates by *true trip cost*.
///
/// **Fuel / EV model** (all prices per litre or per kWh):
/// ```
/// purchaseUnits = capacity × (target − current) / efficiency   (or a fixed amount)
/// detourUnits   = detourKm × consumption/100 / efficiency
/// totalCost     = (purchaseUnits + detourUnits) × pricePerUnit
/// ```
/// The detour energy is valued at the same station's price because it is
/// energy you must buy again. `efficiency` is 1.0 for fuel and the vehicle's
/// charging efficiency for EVs.
///
/// Honesty rules:
/// * Missing prices are never estimated — such stations go to `unpriced`.
/// * Prices in another currency are not converted — also `unpriced`.
/// * Without a vehicle + fill request only per-unit prices are compared
///   ([CostMode.unitPriceOnly]).
/// * "Best value" is a transparent heuristic, not an optimum:
///   `0.60 × cost + 0.25 × detour + 0.15 × reliability` (each min-max
///   normalised across eligible stations; unknown reliability = 0.5).
class TripCostEngine {
  const TripCostEngine({
    this.staleAfter = const Duration(days: 3),
    this.costWeight = 0.60,
    this.detourWeight = 0.25,
    this.reliabilityWeight = 0.15,
  });

  /// Prices older than this get a [Caveat.stalePrice] (still ranked).
  final Duration staleAfter;
  final double costWeight;
  final double detourWeight;
  final double reliabilityWeight;

  static const _eps = 1e-9;

  RankingResult rank({
    required List<StationOffer> offers,
    VehicleProfile? vehicle,
    FillRequest? fill,
    RankingStrategy strategy = RankingStrategy.cheapestTotal,
    DateTime? now,
  }) {
    final clock = now ?? DateTime.now();
    final mode = vehicle != null && fill != null ? CostMode.totalCost : CostMode.unitPriceOnly;
    final purchaseUnits = mode == CostMode.totalCost ? _purchaseUnits(vehicle!, fill!) : null;
    final currency = _dominantCurrency(offers);

    final comparable = <RankedStation>[];
    final unpriced = <RankedStation>[];

    for (final o in offers) {
      final caveats = <Caveat>{
        if (o.openNow == false) Caveat.closed,
        if (_isUnreachable(o, vehicle, fill)) Caveat.unreachable,
        if (o.priceUpdatedAt != null && clock.difference(o.priceUpdatedAt!) > staleAfter) Caveat.stalePrice,
      };
      final price = o.pricePerUnit;
      if (price == null || price <= 0 || o.currencyCode == null) {
        unpriced.add(RankedStation(offer: o, caveats: {...caveats, Caveat.priceUnknown}));
        continue;
      }
      if (o.currencyCode != currency) {
        unpriced.add(RankedStation(offer: o, caveats: {...caveats, Caveat.otherCurrency}));
        continue;
      }
      if (mode == CostMode.totalCost) {
        final detourUnits = vehicle!.unitsToBuyForDistance(o.detourMeters);
        final purchaseCost = purchaseUnits! * price;
        final detourCost = detourUnits * price;
        comparable.add(RankedStation(
          offer: o,
          purchaseUnits: purchaseUnits,
          purchaseCost: purchaseCost,
          detourUnits: detourUnits,
          detourCost: detourCost,
          totalCost: purchaseCost + detourCost,
          caveats: caveats,
        ));
      } else {
        comparable.add(RankedStation(offer: o, caveats: caveats));
      }
    }

    final eligible = comparable.where(_isEligible).toList();
    final scored = _withValueScores(comparable, eligible, mode);
    final withSavings = _withSavings(scored, mode);
    final nearestId = _nearest(withSavings)?.offer.stationId;
    final badged = _withBadges(withSavings, mode);

    int byStrategy(RankedStation a, RankedStation b) {
      final ea = _isEligible(a), eb = _isEligible(b);
      if (ea != eb) return ea ? -1 : 1; // eligible first
      return switch (strategy) {
        RankingStrategy.cheapestTotal => _cmp(_metric(a, mode), _metric(b, mode)) != 0
            ? _cmp(_metric(a, mode), _metric(b, mode))
            : _cmp(a.offer.detourMeters, b.offer.detourMeters),
        RankingStrategy.shortestDetour => _cmp(a.offer.detourMeters, b.offer.detourMeters) != 0
            ? _cmp(a.offer.detourMeters, b.offer.detourMeters)
            : _cmp(_metric(a, mode), _metric(b, mode)),
        RankingStrategy.bestValue => _cmp(b.valueScore ?? -1, a.valueScore ?? -1) != 0
            ? _cmp(b.valueScore ?? -1, a.valueScore ?? -1)
            : _cmp(_metric(a, mode), _metric(b, mode)),
      };
    }

    badged.sort(byStrategy);
    unpriced.sort((a, b) => _cmp(a.offer.detourMeters, b.offer.detourMeters));

    return RankingResult(
      mode: mode,
      strategy: strategy,
      currencyCode: comparable.isEmpty ? null : currency,
      ranked: badged,
      unpriced: unpriced,
      nearestStationId: nearestId,
    );
  }

  // ---- helpers -----------------------------------------------------------

  static double _purchaseUnits(VehicleProfile v, FillRequest fill) {
    final stored = switch (fill) {
      FillToLevel(:final currentLevel, :final targetLevel) =>
        v.capacity * math.max(0, targetLevel - currentLevel),
      FillAmount(:final units) => units * v.chargingEfficiency, // amount is what's bought
    };
    return stored / v.chargingEfficiency;
  }

  static bool _isUnreachable(StationOffer o, VehicleProfile? v, FillRequest? fill) {
    if (v == null || fill is! FillToLevel || o.distanceToStationMeters == null) return false;
    return o.distanceToStationMeters! > v.rangeMeters(fill.currentLevel) + _eps;
  }

  static bool _isEligible(RankedStation s) =>
      !s.caveats.contains(Caveat.closed) && !s.caveats.contains(Caveat.unreachable);

  /// The value compared for "cheapest": total cost, or unit price.
  static double _metric(RankedStation s, CostMode mode) =>
      mode == CostMode.totalCost ? s.totalCost! : s.offer.pricePerUnit!;

  /// Most common currency among priced offers; ties → nearest station's.
  static String? _dominantCurrency(List<StationOffer> offers) {
    final priced = offers.where((o) => o.currencyCode != null && (o.pricePerUnit ?? 0) > 0).toList();
    if (priced.isEmpty) return null;
    final counts = <String, int>{};
    for (final o in priced) {
      counts[o.currencyCode!] = (counts[o.currencyCode!] ?? 0) + 1;
    }
    final best = counts.values.reduce(math.max);
    final tied = counts.keys.where((c) => counts[c] == best).toSet();
    if (tied.length == 1) return tied.single;
    priced.sort((a, b) => _cmp(a.detourMeters, b.detourMeters));
    return priced.firstWhere((o) => tied.contains(o.currencyCode)).currencyCode;
  }

  List<RankedStation> _withValueScores(
    List<RankedStation> all,
    List<RankedStation> eligible,
    CostMode mode,
  ) {
    if (eligible.isEmpty) return all;
    final costs = eligible.map((s) => _metric(s, mode)).toList();
    final useTime = eligible.every((s) => s.offer.detourSeconds != null);
    double detourOf(RankedStation s) => useTime ? s.offer.detourSeconds! : s.offer.detourMeters;
    final detours = eligible.map(detourOf).toList();

    double norm(double v, List<double> values) {
      final lo = values.reduce(math.min), hi = values.reduce(math.max);
      if (hi - lo < _eps) return 1; // all equal → equally good
      return (hi - v) / (hi - lo); // lower is better → 1
    }

    return [
      for (final s in all)
        if (_isEligible(s))
          s.copyWith(
            valueScore: costWeight * norm(_metric(s, mode), costs) +
                detourWeight * norm(detourOf(s), detours) +
                reliabilityWeight * (s.offer.reliability?.clamp(0.0, 1.0) ?? 0.5),
          )
        else
          s,
    ];
  }

  static RankedStation? _nearest(List<RankedStation> stations) {
    if (stations.isEmpty) return null;
    final pool = stations.where(_isEligible).toList();
    final candidates = pool.isEmpty ? stations : pool;
    return candidates.reduce((a, b) => b.offer.detourMeters < a.offer.detourMeters ? b : a);
  }

  static List<RankedStation> _withSavings(List<RankedStation> stations, CostMode mode) {
    final nearest = _nearest(stations);
    if (nearest == null) return stations;
    final base = _metric(nearest, mode);
    return [
      for (final s in stations)
        identical(s, nearest) ? s : s.copyWith(savingsVsNearest: base - _metric(s, mode)),
    ];
  }

  static List<RankedStation> _withBadges(List<RankedStation> stations, CostMode mode) {
    final eligible = stations.where(_isEligible).toList();
    if (eligible.isEmpty) return stations;

    RankedStation pick(int Function(RankedStation, RankedStation) better) =>
        eligible.reduce((a, b) => better(b, a) < 0 ? b : a);

    final cheapest = pick((a, b) {
      final c = _cmp(_metric(a, mode), _metric(b, mode));
      return c != 0 ? c : _cmp(a.offer.detourMeters, b.offer.detourMeters);
    });
    final shortest = pick((a, b) {
      final c = _cmp(a.offer.detourMeters, b.offer.detourMeters);
      return c != 0 ? c : _cmp(_metric(a, mode), _metric(b, mode));
    });
    final best = pick((a, b) => _cmp(b.valueScore ?? -1, a.valueScore ?? -1));
    final withReliability = eligible.where((s) => s.offer.reliability != null).toList();
    final reliable = withReliability.isEmpty
        ? null
        : withReliability.reduce((a, b) => b.offer.reliability! > a.offer.reliability! ? b : a);

    return [
      for (final s in stations)
        s.copyWith(badges: {
          if (identical(s, cheapest)) RankingBadge.cheapestOverall,
          if (identical(s, shortest)) RankingBadge.shortestDetour,
          if (identical(s, best)) RankingBadge.bestValue,
          if (identical(s, reliable)) RankingBadge.mostReliable,
        }),
    ];
  }

  static int _cmp(double a, double b) => (a - b).abs() < _eps ? 0 : (a < b ? -1 : 1);
}
