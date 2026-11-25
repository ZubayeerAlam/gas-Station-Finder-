import 'dart:math';

import '../../../core/error/app_failure.dart';
import '../../../core/error/result.dart';
import '../../../core/location/geo_point.dart';
import '../../../core/utils/formatters.dart';
import '../../along_route/domain/along_route_models.dart';
import '../../along_route/domain/along_route_planner.dart';
import '../../along_route/domain/along_route_repositories.dart';
import '../../along_route/presentation/along_route_providers.dart' show offersFromPlan, searchTargetFor;
import '../../along_route/presentation/ranking_explanation.dart';
import '../../garage/domain/vehicle_profile.dart';
import '../../ranking/domain/ranking_models.dart';
import '../../ranking/domain/trip_cost_engine.dart';
import '../domain/assistant_models.dart';

/// A trip the assistant planned, ranked exactly like the trip screen does.
class PlannedTrip {
  const PlannedTrip({required this.plan, required this.ranking, required this.unit});

  final AlongRoutePlan plan;
  final RankingResult ranking;
  final String unit;
}

class ToolRun {
  const ToolRun(this.output, {this.isError = false, this.trip});

  final Object? output;
  final bool isError;
  final PlannedTrip? trip;
}

/// Runs the assistant's client-side tools with the app's own planner and
/// [TripCostEngine], so every number the model sees is the app's calculation.
class AssistantToolRunner {
  AssistantToolRunner({
    required this.vehicle,
    required this.fillLevel,
    required this.origin,
    required this.places,
    required this.planner,
    required this.now,
    this.engine = const TripCostEngine(),
  });

  final Future<VehicleProfile?> Function() vehicle;
  final double Function() fillLevel;
  final Future<GeoPoint> Function() origin;
  final PlaceSearchRepository places;
  final AlongRoutePlanner planner;
  final DateTime Function() now;
  final TripCostEngine engine;

  static final _rand = Random();

  Future<ToolRun> run(ClientToolCall call) async {
    try {
      return switch (call.name) {
        'get_vehicle' => ToolRun(vehicleJson(await vehicle())),
        'plan_route_stops' => await _planRoute(call.input),
        _ => ToolRun({'error': 'Unknown tool ${call.name}'}, isError: true),
      };
    } on AppFailure catch (f) {
      return ToolRun({'error': f.message}, isError: true);
    }
  }

  Future<ToolRun> _planRoute(Map<String, Object?> input) async {
    final dest = (input['destination'] as String?)?.trim() ?? '';
    if (dest.isEmpty || dest.length > 200) return const ToolRun({'error': 'destination is required'}, isError: true);
    final strategy = switch (input['strategy']) {
      'shortest_detour' => RankingStrategy.shortestDetour,
      'best_value' => RankingStrategy.bestValue,
      _ => RankingStrategy.cheapestTotal,
    };
    final here = await origin();
    // One autocomplete + details billing session, like the destination screen.
    final session = List.generate(16, (_) => _rand.nextInt(16).toRadixString(16)).join();
    final suggestions = (await places.autocomplete(dest, near: here, sessionToken: session)).getOrThrow();
    if (suggestions.isEmpty) return ToolRun({'error': 'No place found for "$dest".'}, isError: true);
    final destination = (await places.resolve(suggestions.first.placeId, sessionToken: session)).getOrThrow();

    final v = await vehicle();
    final target = searchTargetFor(v);
    final planned = await planner.plan(
      origin: here,
      destination: destination,
      fuelType: target.fuelType,
      includedType: target.includedType,
    );
    if (planned case Err(:final failure)) return ToolRun({'error': failure.message}, isError: true);
    final plan = planned.getOrThrow();
    final ranking = engine.rank(
      offers: offersFromPlan(plan),
      vehicle: v,
      fill: v == null ? null : FillToLevel(currentLevel: fillLevel()),
      strategy: strategy,
      now: now(),
    );
    final trip = PlannedTrip(plan: plan, ranking: ranking, unit: v?.unit ?? 'L');
    return ToolRun(planJson(trip), trip: trip);
  }

  /// What the model sees about the vehicle. Pure — exposed for tests.
  static Map<String, Object?> vehicleJson(VehicleProfile? v) => v == null
      ? {'vehicle': null, 'note': 'No vehicle saved; only per-unit prices can be compared.'}
      : {
          'vehicle': {
            'name': v.name,
            'energy_type': v.isElectric ? 'electric' : 'fuel',
            'consumption_per_100km': '${Fmt.number(v.consumptionPer100Km)} ${v.unit}',
            'capacity': '${Fmt.number(v.capacity)} ${v.unit}',
            'preferred_fuel': v.preferredFuelType,
          },
        };

  /// The plan as the model sees it: ranked stations in the engine's order,
  /// with the same figures the trip screen shows. Pure — exposed for tests.
  static Map<String, Object?> planJson(PlannedTrip t) {
    final r = t.ranking;
    final p = t.plan;
    Map<String, Object?> station(RankedStation s, int? rank) {
      final o = s.offer;
      return {
        'id': o.stationId,
        'name': o.name,
        'rank': rank,
        'price': o.pricePerUnit == null || o.currencyCode == null
            ? null
            : '${Fmt.price(o.pricePerUnit!, o.currencyCode!)}/${t.unit}',
        'price_source': o.priceSource?.name,
        'detour': detourText(o),
        'total_cost': s.totalCost == null || o.currencyCode == null ? null : Fmt.money(s.totalCost!, o.currencyCode!),
        'savings_vs_nearest': s.savingsVsNearest == null || o.currencyCode == null
            ? null
            : Fmt.money(s.savingsVsNearest!, o.currencyCode!),
        'reliability': o.reliability == null ? null : '${(o.reliability! * 100).round()}%',
        'open_now': o.openNow,
        'badges': [for (final b in s.badges) badgeLabel(b)],
        'caveats': [for (final c in s.caveats) caveatLabel(c)],
      };
    }

    return {
      'destination': p.destination.name,
      'route': '${Fmt.distance(p.route.distanceMeters)}, ${Fmt.duration(p.route.duration)}',
      'mode': r.mode == CostMode.totalCost ? 'total_cost' : 'unit_price_only',
      'strategy': switch (r.strategy) {
        RankingStrategy.cheapestTotal => 'cheapest_total',
        RankingStrategy.shortestDetour => 'shortest_detour',
        RankingStrategy.bestValue => 'best_value',
      },
      'stations': [
        for (final (i, s) in r.ranked.take(8).indexed) station(s, i + 1),
        for (final s in r.unpriced.take(3)) station(s, null),
      ],
      'notes': [
        'Ranked by the app\'s cost engine; best_value is a heuristic.',
        if (r.mode == CostMode.unitPriceOnly) 'No vehicle saved, so totals are not computed.',
        if (p.detoursApproximate) 'Detours are straight-line estimates (routing failed).',
        if (r.ranked.isEmpty) 'No station on this route has a known price.',
      ],
    };
  }
}
