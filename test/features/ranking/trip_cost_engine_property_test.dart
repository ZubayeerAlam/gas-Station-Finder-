import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:gas_station_finder/features/garage/domain/vehicle_profile.dart';
import 'package:gas_station_finder/features/ranking/domain/ranking_models.dart';
import 'package:gas_station_finder/features/ranking/domain/trip_cost_engine.dart';

/// Seeded randomized check of the ranking maths against an independent
/// re-computation (complements the hand-computed cases in
/// trip_cost_engine_test.dart). Deterministic: the same 500 scenarios run
/// every time, so a failure is reproducible from its index.
void main() {
  const engine = TripCostEngine();
  final now = DateTime(2026, 11, 27, 12);
  const scenarios = 500;

  test('$scenarios random scenarios: cost identities, ordering, savings, honesty', () {
    final rnd = Random(20261127);
    double between(double a, double b) => a + rnd.nextDouble() * (b - a);
    var withRanked = 0, withClosed = 0, withUnreachable = 0, withOtherCurrency = 0, multiRanked = 0;

    for (var i = 0; i < scenarios; i++) {
      final electric = rnd.nextInt(4) == 0;
      final vehicle = VehicleProfile(
        id: 'v$i',
        name: 'v$i',
        energyType: electric ? EnergyType.electric : EnergyType.fuel,
        consumptionPer100Km: electric ? between(12, 25) : between(3, 15),
        capacity: electric ? between(30, 100) : between(5, 80),
        chargingEfficiency: electric ? between(0.8, 1) : 1,
      );
      final level = between(0, 0.9);
      final fill = FillToLevel(currentLevel: level);
      final offers = [
        for (var j = 0; j < 1 + rnd.nextInt(8); j++)
          StationOffer(
            stationId: 's$j',
            name: 's$j',
            detourMeters: between(0, 30000),
            distanceToStationMeters: between(0, 400000),
            pricePerUnit: rnd.nextInt(6) == 0 ? null : between(0.5, 200),
            currencyCode: rnd.nextInt(10) == 0 ? 'EUR' : 'BDT',
            openNow: [true, false, null][rnd.nextInt(3)],
            reliability: rnd.nextBool() ? rnd.nextDouble() : null,
          ),
      ];
      final strategy = RankingStrategy.values[rnd.nextInt(RankingStrategy.values.length)];
      final r = engine.rank(offers: offers, vehicle: vehicle, fill: fill, strategy: strategy, now: now);
      final why = 'scenario $i ($strategy)';
      if (r.ranked.isNotEmpty) withRanked++;
      if (r.ranked.length > 1) multiRanked++;
      if (r.ranked.any((s) => s.caveats.contains(Caveat.closed))) withClosed++;
      if (r.ranked.any((s) => s.caveats.contains(Caveat.unreachable))) withUnreachable++;
      if (r.unpriced.any((s) => s.caveats.contains(Caveat.otherCurrency))) withOtherCurrency++;

      // Every offer is accounted for exactly once.
      expect(r.ranked.length + r.unpriced.length, offers.length, reason: why);

      // Independent re-computation of the cost identities.
      final bought = vehicle.capacity * (1 - level) / vehicle.chargingEfficiency;
      for (final s in r.ranked) {
        final o = s.offer;
        expect(o.currencyCode, r.currencyCode, reason: '$why: currencies are never mixed');
        final detourUnits = o.detourMeters / 1000 * vehicle.consumptionPer100Km / 100 / vehicle.chargingEfficiency;
        expect(s.purchaseUnits, closeTo(bought, 1e-9), reason: why);
        expect(s.detourUnits, closeTo(detourUnits, 1e-9), reason: why);
        expect(s.purchaseCost, closeTo(bought * o.pricePerUnit!, 1e-6), reason: why);
        expect(s.detourCost, closeTo(detourUnits * o.pricePerUnit!, 1e-6), reason: why);
        expect(s.totalCost, closeTo(s.purchaseCost! + s.detourCost!, 1e-9), reason: why);
        final unreachable = o.distanceToStationMeters! > vehicle.rangeMeters(level) + 1e-9;
        expect(s.caveats.contains(Caveat.unreachable), unreachable, reason: why);
        expect(s.caveats.contains(Caveat.closed), o.openNow == false, reason: why);
      }

      // Unpriced / other-currency offers are never given a cost.
      for (final s in r.unpriced) {
        expect(s.totalCost, isNull, reason: why);
        expect(
          s.caveats.contains(Caveat.priceUnknown) || s.caveats.contains(Caveat.otherCurrency),
          isTrue,
          reason: why,
        );
      }

      // Eligible (open-or-unknown and reachable) stations come first …
      bool eligible(RankedStation s) => !s.caveats.contains(Caveat.closed) && !s.caveats.contains(Caveat.unreachable);
      final firstIneligible = r.ranked.indexWhere((s) => !eligible(s));
      if (firstIneligible >= 0) {
        expect(r.ranked.skip(firstIneligible).every((s) => !eligible(s)), isTrue, reason: why);
      }
      // … and each group is ordered by the chosen strategy.
      for (final group in [r.ranked.where(eligible).toList(), r.ranked.where((s) => !eligible(s)).toList()]) {
        for (var k = 1; k < group.length; k++) {
          final a = group[k - 1], b = group[k];
          switch (strategy) {
            case RankingStrategy.cheapestTotal:
              expect(a.totalCost!, lessThanOrEqualTo(b.totalCost! + 1e-9), reason: why);
            case RankingStrategy.shortestDetour:
              expect(a.offer.detourMeters, lessThanOrEqualTo(b.offer.detourMeters + 1e-9), reason: why);
            case RankingStrategy.bestValue:
              expect(a.valueScore ?? -1, greaterThanOrEqualTo((b.valueScore ?? -1) - 1e-9), reason: why);
          }
        }
      }

      // Savings are exact differences to the nearest (least detour) eligible station.
      if (r.ranked.isNotEmpty) {
        final pool = r.ranked.where(eligible).toList();
        final candidates = pool.isEmpty ? r.ranked : pool;
        final nearest = candidates.reduce((a, b) => b.offer.detourMeters < a.offer.detourMeters ? b : a);
        expect(r.nearestStationId, nearest.offer.stationId, reason: why);
        for (final s in r.ranked) {
          if (s.offer.stationId == nearest.offer.stationId) continue;
          expect(s.savingsVsNearest, closeTo(nearest.totalCost! - s.totalCost!, 1e-6), reason: why);
        }
        // The "cheapest" badge goes to an eligible station with the minimum total.
        final cheapest = r.ranked.where((s) => s.badges.contains(RankingBadge.cheapestOverall)).toList();
        if (pool.isNotEmpty) {
          final minTotal = pool.map((s) => s.totalCost!).reduce(min);
          expect(cheapest, isNotEmpty, reason: why);
          for (final c in cheapest) {
            expect(eligible(c), isTrue, reason: why);
            expect(c.totalCost, closeTo(minTotal, 1e-9), reason: why);
          }
        } else {
          expect(cheapest, isEmpty, reason: why);
        }
      }
    }
    // The scenarios really exercise every branch (not vacuously true).
    expect(withRanked, greaterThan(scenarios * 0.9));
    expect(multiRanked, greaterThan(scenarios * 0.6));
    expect(withClosed, greaterThan(50));
    expect(withUnreachable, greaterThan(50));
    expect(withOtherCurrency, greaterThan(50));
  });
}
