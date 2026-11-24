import 'package:flutter_test/flutter_test.dart';
import 'package:gas_station_finder/core/utils/units.dart';
import 'package:gas_station_finder/features/garage/domain/vehicle_profile.dart';
import 'package:gas_station_finder/features/ranking/domain/ranking_models.dart';
import 'package:gas_station_finder/features/ranking/domain/trip_cost_engine.dart';

const car = VehicleProfile(
  id: 'car',
  name: 'Corolla',
  energyType: EnergyType.fuel,
  consumptionPer100Km: 6.5, // L/100 km
  capacity: 50, // L
  preferredFuelType: 'REGULAR_UNLEADED',
);

const ev = VehicleProfile(
  id: 'ev',
  name: 'Model 3',
  energyType: EnergyType.electric,
  consumptionPer100Km: 15, // kWh/100 km
  capacity: 60, // kWh
  chargingEfficiency: 0.9,
);

StationOffer offer(
  String id, {
  double? price,
  double detourKm = 1,
  String currency = 'EUR',
  bool? openNow,
  double? reliability,
  double? detourMin,
  double? distanceKm,
  DateTime? updated,
}) =>
    StationOffer(
      stationId: id,
      name: id,
      detourMeters: detourKm * 1000,
      detourSeconds: detourMin == null ? null : detourMin * 60,
      distanceToStationMeters: distanceKm == null ? null : distanceKm * 1000,
      pricePerUnit: price,
      currencyCode: price == null ? null : currency,
      priceSource: price == null ? null : PriceSource.google,
      priceUpdatedAt: updated,
      openNow: openNow,
      reliability: reliability,
    );

final now = DateTime(2026, 11, 25, 12);
const engine = TripCostEngine();

RankedStation byId(RankingResult r, String id) =>
    [...r.ranked, ...r.unpriced].firstWhere((s) => s.offer.stationId == id);

void main() {
  group('fuel total cost (hand-computed)', () {
    // Fill 20% → 100% of 50 L = 40 L. 6.5 L/100 km.
    // A: 1.80 €/L, 0.4 km detour → 0.026 L → 72.0 + 0.0468  = 72.0468
    // B: 1.70 €/L, 6 km detour   → 0.39 L  → 68.0 + 0.663   = 68.663
    // C: 1.65 €/L, 30 km detour  → 1.95 L  → 66.0 + 3.2175  = 69.2175
    final offers = [
      offer('A', price: 1.80, detourKm: 0.4),
      offer('B', price: 1.70, detourKm: 6),
      offer('C', price: 1.65, detourKm: 30),
    ];
    final r = engine.rank(
      offers: offers,
      vehicle: car,
      fill: const FillToLevel(currentLevel: 0.2),
      now: now,
    );

    test('computes purchase, detour and total cost', () {
      expect(r.mode, CostMode.totalCost);
      expect(r.currencyCode, 'EUR');
      final a = byId(r, 'A'), b = byId(r, 'B'), c = byId(r, 'C');
      expect(a.purchaseUnits, closeTo(40, 1e-9));
      expect(a.detourUnits, closeTo(0.026, 1e-9));
      expect(a.totalCost, closeTo(72.0468, 1e-9));
      expect(b.totalCost, closeTo(68.663, 1e-9));
      expect(c.detourCost, closeTo(3.2175, 1e-9));
      expect(c.totalCost, closeTo(69.2175, 1e-9));
    });

    test('lowest pump price is NOT cheapest once the detour is counted', () {
      expect(r.ranked.map((s) => s.offer.stationId), ['B', 'C', 'A']);
      expect(byId(r, 'B').badges, contains(RankingBadge.cheapestOverall));
      expect(byId(r, 'C').badges, isNot(contains(RankingBadge.cheapestOverall)));
    });

    test('savings vs nearest are real calculated differences', () {
      expect(r.nearestStationId, 'A');
      expect(byId(r, 'A').savingsVsNearest, isNull);
      expect(byId(r, 'B').savingsVsNearest, closeTo(72.0468 - 68.663, 1e-9)); // 3.3838
      expect(byId(r, 'C').savingsVsNearest, closeTo(72.0468 - 69.2175, 1e-9));
    });

    test('shortest detour badge and strategy', () {
      expect(byId(r, 'A').badges, contains(RankingBadge.shortestDetour));
      final s = engine.rank(
        offers: offers,
        vehicle: car,
        fill: const FillToLevel(currentLevel: 0.2),
        strategy: RankingStrategy.shortestDetour,
        now: now,
      );
      expect(s.ranked.map((x) => x.offer.stationId), ['A', 'B', 'C']);
    });
  });

  group('best value heuristic', () {
    test('score = 0.60·cost + 0.25·detour + 0.15·reliability (normalised)', () {
      // Unit-price mode for easy numbers.
      // prices 1.0 / 1.5 / 2.0 → costN 1, 0.5, 0
      // detour 10 / 0 / 5 km   → detourN 0, 1, 0.5
      // reliability 0.2 / null(0.5) / 1.0
      final r = engine.rank(
        offers: [
          offer('X', price: 1.0, detourKm: 10, reliability: 0.2),
          offer('Y', price: 1.5, detourKm: 0, reliability: null),
          offer('Z', price: 2.0, detourKm: 5, reliability: 1.0),
        ],
        strategy: RankingStrategy.bestValue,
        now: now,
      );
      expect(byId(r, 'X').valueScore, closeTo(0.60 * 1 + 0.25 * 0 + 0.15 * 0.2, 1e-9)); // 0.63
      expect(byId(r, 'Y').valueScore, closeTo(0.60 * 0.5 + 0.25 * 1 + 0.15 * 0.5, 1e-9)); // 0.625
      expect(byId(r, 'Z').valueScore, closeTo(0.60 * 0 + 0.25 * 0.5 + 0.15 * 1.0, 1e-9)); // 0.275
      expect(r.ranked.map((s) => s.offer.stationId), ['X', 'Y', 'Z']);
      expect(byId(r, 'X').badges, containsAll([RankingBadge.bestValue, RankingBadge.cheapestOverall]));
      expect(byId(r, 'Z').badges, contains(RankingBadge.mostReliable));
    });

    test('uses detour time when every station has it', () {
      final r = engine.rank(
        offers: [
          offer('far-fast', price: 1.0, detourKm: 10, detourMin: 2),
          offer('near-slow', price: 1.0, detourKm: 2, detourMin: 12),
        ],
        strategy: RankingStrategy.bestValue,
        now: now,
      );
      expect(r.ranked.first.offer.stationId, 'far-fast');
    });

    test('equal values normalise to 1 (no division by zero)', () {
      final r = engine.rank(offers: [offer('only', price: 1.5)], now: now);
      expect(r.ranked.single.valueScore, closeTo(0.60 + 0.25 + 0.15 * 0.5, 1e-9));
    });
  });

  group('honesty rules', () {
    test('unknown prices are never estimated → unpriced, sorted by detour', () {
      final r = engine.rank(
        offers: [
          offer('priced', price: 1.7),
          offer('noprice-far', detourKm: 9),
          offer('noprice-near', detourKm: 2),
        ],
        vehicle: car,
        fill: const FillToLevel(currentLevel: 0.5),
        now: now,
      );
      expect(r.ranked.map((s) => s.offer.stationId), ['priced']);
      expect(r.unpriced.map((s) => s.offer.stationId), ['noprice-near', 'noprice-far']);
      for (final s in r.unpriced) {
        expect(s.totalCost, isNull);
        expect(s.caveats, contains(Caveat.priceUnknown));
        expect(s.badges, isEmpty);
      }
    });

    test('other currencies are not converted', () {
      final r = engine.rank(
        offers: [
          offer('eur1', price: 1.7),
          offer('eur2', price: 1.8),
          offer('chf', price: 1.9, currency: 'CHF'),
        ],
        now: now,
      );
      expect(r.currencyCode, 'EUR');
      expect(byId(r, 'chf').caveats, contains(Caveat.otherCurrency));
      expect(r.unpriced.single.offer.stationId, 'chf');
    });

    test('currency tie → nearest station currency wins', () {
      final r = engine.rank(
        offers: [offer('usd', price: 3.5, currency: 'USD', detourKm: 5), offer('cad', price: 1.6, currency: 'CAD', detourKm: 1)],
        now: now,
      );
      expect(r.currencyCode, 'CAD');
    });

    test('no vehicle → unit-price mode, no invented totals', () {
      final r = engine.rank(offers: [offer('A', price: 1.8), offer('B', price: 1.6, detourKm: 3)], now: now);
      expect(r.mode, CostMode.unitPriceOnly);
      expect(r.ranked.first.offer.stationId, 'B');
      expect(r.ranked.first.totalCost, isNull);
      expect(r.ranked.first.savingsVsNearest, closeTo(0.2, 1e-9)); // per-unit saving
    });

    test('no stations / no prices → empty, no currency', () {
      expect(engine.rank(offers: const [], now: now).ranked, isEmpty);
      final r = engine.rank(offers: [offer('x')], now: now);
      expect(r.ranked, isEmpty);
      expect(r.currencyCode, isNull);
      expect(r.nearestStationId, isNull);
    });
  });

  group('eligibility', () {
    test('closed stations are listed last and get no badges', () {
      final r = engine.rank(
        offers: [offer('cheap-closed', price: 1.0, openNow: false), offer('open', price: 1.9, openNow: true)],
        vehicle: car,
        fill: const FillToLevel(currentLevel: 0.1),
        now: now,
      );
      expect(r.ranked.map((s) => s.offer.stationId), ['open', 'cheap-closed']);
      expect(byId(r, 'cheap-closed').badges, isEmpty);
      expect(byId(r, 'cheap-closed').caveats, contains(Caveat.closed));
      expect(byId(r, 'open').badges, contains(RankingBadge.cheapestOverall));
    });

    test('unknown opening status is still eligible', () {
      final r = engine.rank(offers: [offer('unknown', price: 1.0)], now: now);
      expect(r.ranked.single.badges, contains(RankingBadge.cheapestOverall));
    });

    test('stations beyond current range are unreachable', () {
      // 50 L at 10 % = 5 L / 6.5 L per 100 km = 76.92 km range.
      expect(car.rangeMeters(0.1), closeTo(76923.08, 0.01));
      final r = engine.rank(
        offers: [offer('ok', price: 1.9, distanceKm: 70), offer('too-far', price: 1.2, distanceKm: 80)],
        vehicle: car,
        fill: const FillToLevel(currentLevel: 0.1),
        now: now,
      );
      expect(byId(r, 'too-far').caveats, contains(Caveat.unreachable));
      expect(r.ranked.first.offer.stationId, 'ok');
    });

    test('stale prices are flagged but still ranked', () {
      final r = engine.rank(
        offers: [offer('old', price: 1.5, updated: now.subtract(const Duration(days: 5)))],
        now: now,
      );
      expect(r.ranked.single.caveats, contains(Caveat.stalePrice));
      expect(r.ranked.single.badges, contains(RankingBadge.cheapestOverall));
    });
  });

  group('EV', () {
    test('charging losses increase energy bought', () {
      // 60 kWh, 20 % → 80 %: 36 kWh stored / 0.9 = 40 kWh bought.
      // detour 10 km × 15 kWh/100 km = 1.5 kWh / 0.9 = 1.6667 kWh.
      // 0.40 €/kWh → 16.0 + 0.6667 = 16.6667
      final r = engine.rank(
        offers: [offer('hpc', price: 0.40, detourKm: 10)],
        vehicle: ev,
        fill: const FillToLevel(currentLevel: 0.2, targetLevel: 0.8),
        now: now,
      );
      final s = r.ranked.single;
      expect(s.purchaseUnits, closeTo(40, 1e-9));
      expect(s.detourUnits, closeTo(1.5 / 0.9, 1e-9));
      expect(s.totalCost, closeTo(16 + 0.4 * 1.5 / 0.9, 1e-9));
    });

    test('fixed amount is what is bought', () {
      final r = engine.rank(
        offers: [offer('s', price: 0.5, detourKm: 0)],
        vehicle: ev,
        fill: const FillAmount(20),
        now: now,
      );
      expect(r.ranked.single.purchaseUnits, closeTo(20, 1e-9));
      expect(r.ranked.single.totalCost, closeTo(10, 1e-9));
    });

    test('already above target → buys nothing, cost is only detour', () {
      final r = engine.rank(
        offers: [offer('s', price: 2.0, detourKm: 10)],
        vehicle: car,
        fill: const FillToLevel(currentLevel: 1.0),
        now: now,
      );
      expect(r.ranked.single.purchaseUnits, 0);
      expect(r.ranked.single.totalCost, closeTo(10 * 6.5 / 100 * 2.0, 1e-9));
    });
  });

  group('Units', () {
    test('mpg and km/L conversions', () {
      expect(Units.mpgUsToLitresPer100Km(30), closeTo(7.8405, 1e-4));
      expect(Units.mpgImperialToLitresPer100Km(40), closeTo(7.0620, 1e-4));
      expect(Units.kmPerLitreToLitresPer100Km(12.5), closeTo(8, 1e-9));
      expect(Units.milesPerKwhToKwhPer100Km(4), closeTo(15.5343, 1e-4));
      expect(Units.whPerKmToKwhPer100Km(160), 16);
      expect(Units.pricePerUsGallonToPerLitre(3.785411784), closeTo(1, 1e-12));
    });

    test('rejects non-positive input', () {
      expect(() => Units.mpgUsToLitresPer100Km(0), throwsArgumentError);
      expect(() => Units.kmPerLitreToLitresPer100Km(-1), throwsArgumentError);
    });
  });

  test('VehicleProfile asserts invalid values', () {
    expect(
      () => VehicleProfile(id: 'x', name: 'x', energyType: EnergyType.fuel, consumptionPer100Km: 0, capacity: 40),
      throwsA(isA<AssertionError>()),
    );
  });
}
