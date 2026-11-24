import 'package:freezed_annotation/freezed_annotation.dart';

part 'ranking_models.freezed.dart';

/// Where a price came from. Only real sources exist — there is no "estimated".
enum PriceSource { google, community }

/// One station as a refuelling candidate. Built by the caller from station
/// data + route/detour calculations; the engine never fetches anything.
@freezed
abstract class StationOffer with _$StationOffer {
  const factory StationOffer({
    required String stationId,
    required String name,

    /// Extra driving distance caused by stopping here (vs. not stopping).
    /// Along a route: route-via-station minus direct route.
    /// Nearby mode: drive there and back.
    required double detourMeters,

    /// Extra driving time, if known.
    double? detourSeconds,

    /// Driving distance from the current position to the station, if known
    /// (used for reachability on the current tank/charge).
    double? distanceToStationMeters,

    /// Price per litre (fuel) or per kWh (EV). Null = unknown — never guessed.
    double? pricePerUnit,
    String? currencyCode,
    PriceSource? priceSource,
    DateTime? priceUpdatedAt,

    /// Null = unknown.
    bool? openNow,

    /// 0..1 community/data reliability score, null = unknown (Phase 1.7).
    double? reliability,
  }) = _StationOffer;
}

/// How much the user wants to buy.
sealed class FillRequest {
  const FillRequest();
}

/// Fill from [currentLevel] up to [targetLevel] (fractions of capacity).
final class FillToLevel extends FillRequest {
  const FillToLevel({required this.currentLevel, this.targetLevel = 1.0})
      : assert(currentLevel >= 0 && currentLevel <= 1),
        assert(targetLevel >= 0 && targetLevel <= 1);

  final double currentLevel;
  final double targetLevel;
}

/// Buy a fixed amount (litres or kWh).
final class FillAmount extends FillRequest {
  const FillAmount(this.units) : assert(units > 0);

  final double units;
}

enum RankingStrategy {
  /// Lowest total trip cost (purchase + detour energy).
  cheapestTotal,

  /// Smallest detour distance.
  shortestDetour,

  /// Heuristic balance of cost, detour time/distance and reliability.
  bestValue,
}

/// What the engine could compute, given the inputs.
enum CostMode {
  /// Vehicle + fill known: full total-cost comparison.
  totalCost,

  /// No vehicle: only per-unit prices can be compared honestly.
  unitPriceOnly,
}

enum RankingBadge { cheapestOverall, bestValue, shortestDetour, mostReliable }

/// Why a station is excluded from recommendations (still listed).
enum Caveat { closed, unreachable, otherCurrency, priceUnknown, stalePrice }

@freezed
abstract class RankedStation with _$RankedStation {
  const factory RankedStation({
    required StationOffer offer,

    /// Units bought (L or kWh). Null in [CostMode.unitPriceOnly].
    double? purchaseUnits,
    double? purchaseCost,

    /// Units (bought) needed to cover the detour itself.
    double? detourUnits,
    double? detourCost,

    /// purchaseCost + detourCost.
    double? totalCost,

    /// Positive = cheaper than the nearest priced station (same currency).
    double? savingsVsNearest,

    /// Heuristic best-value score, 0..1, bigger is better. Computed for every
    /// eligible station (open/unknown and reachable); null otherwise.
    double? valueScore,
    @Default(<RankingBadge>{}) Set<RankingBadge> badges,
    @Default(<Caveat>{}) Set<Caveat> caveats,
  }) = _RankedStation;
}

@freezed
abstract class RankingResult with _$RankingResult {
  const factory RankingResult({
    required CostMode mode,
    required RankingStrategy strategy,

    /// Currency all comparable prices share (null if no prices).
    String? currencyCode,

    /// Comparable stations (priced, same currency), best first.
    /// Closed/unreachable ones are kept but sorted after the rest.
    required List<RankedStation> ranked,

    /// Stations that cannot be priced honestly (unknown price or other
    /// currency), ordered by detour.
    required List<RankedStation> unpriced,

    /// The nearest (smallest-detour) priced station used for savings.
    String? nearestStationId,
  }) = _RankingResult;
}
