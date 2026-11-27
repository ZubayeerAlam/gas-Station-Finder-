import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../ev/presentation/widgets/route_chargers_section.dart';
import '../../trips/presentation/saved_trips_section.dart';

import '../../../core/location/geo_point.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/state_views.dart';
import '../../garage/domain/vehicle_profile.dart';
import '../../garage/presentation/garage_providers.dart';
import '../../ranking/domain/ranking_models.dart';
import '../../../l10n/domain_labels.dart';
import '../../../l10n/failure_text.dart';
import '../../../l10n/l10n.dart';
import '../../stations/domain/entities/station.dart';
import '../domain/along_route_models.dart';
import '../../history/presentation/history_providers.dart';
import '../../route/domain/route_energy.dart';
import '../../route/presentation/route_summary_card.dart';
import 'along_route_providers.dart';
import 'ranking_explanation.dart';

LatLng _ll(GeoPoint p) => LatLng(p.latitude, p.longitude);

/// Route + ranked stations along it.
class AlongRouteScreen extends ConsumerWidget {
  const AlongRouteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(alongRouteControllerProvider);
    final title = plan.value?.destination.name;
    final l = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(title == null ? l.trip : l.tripTo(title), overflow: TextOverflow.ellipsis),
        actions: [
          if (plan.value != null)
            IconButton(
              key: const ValueKey('saveTrip'),
              tooltip: l.saveTrip,
              icon: const Icon(Icons.bookmark_add_outlined),
              onPressed: () => showSaveTripDialog(context, ref),
            ),
          IconButton(
            tooltip: l.changeDestination,
            icon: const Icon(Icons.search_rounded),
            onPressed: () => context.pushReplacement(AppRoutes.plan),
          ),
        ],
      ),
      body: switch (plan) {
        AsyncData(value: final p?) => _PlanView(plan: p),
        AsyncError(:final error) => AppErrorView(
          message: describeFailure(error, l, fallback: l.couldNotPlanTrip),
          onRetry: () => context.pushReplacement(AppRoutes.plan),
        ),
        AsyncData() => AppMessageView(
          icon: Icons.alt_route_rounded,
          title: l.noTripYet,
          message: l.noTripMessage,
          primaryLabel: l.chooseDestination,
          onPrimary: () => context.pushReplacement(AppRoutes.plan),
        ),
        _ => AppLoading(label: l.findingAlongRoute),
      },
    );
  }
}

class _PlanView extends ConsumerStatefulWidget {
  const _PlanView({required this.plan});

  final AlongRoutePlan plan;

  @override
  ConsumerState<_PlanView> createState() => _PlanViewState();
}

class _PlanViewState extends ConsumerState<_PlanView> {
  GoogleMapController? _map;
  String? _selected;

  void _fit() {
    final pts = widget.plan.route.points;
    if (_map == null || pts.isEmpty) return;
    var s = pts.first.latitude, n = s, w = pts.first.longitude, e = w;
    for (final p in pts) {
      s = p.latitude < s ? p.latitude : s;
      n = p.latitude > n ? p.latitude : n;
      w = p.longitude < w ? p.longitude : w;
      e = p.longitude > e ? p.longitude : e;
    }
    _map!.animateCamera(
      CameraUpdate.newLatLngBounds(LatLngBounds(southwest: LatLng(s, w), northeast: LatLng(n, e)), 48),
    );
  }

  void _select(Station s) {
    setState(() => _selected = s.id);
    _map?.animateCamera(CameraUpdate.newLatLngZoom(_ll(s.location), 14));
  }

  @override
  Widget build(BuildContext context) {
    final ranking = ref.watch(alongRouteRankingProvider);
    final mapsEnabled = ref.watch(mapsEnabledProvider);
    final content = _ResultsList(plan: widget.plan, ranking: ranking, selectedId: _selected, onSelect: _select);
    if (!mapsEnabled) return content(null);

    final scheme = Theme.of(context).colorScheme;
    final top = {for (final r in ranking?.ranked.take(3) ?? const <RankedStation>[]) r.offer.stationId};
    final stations = {for (final s in widget.plan.stops) s.station.id: s.station};
    return Stack(
      children: [
        Positioned.fill(
          child: GoogleMap(
            initialCameraPosition: CameraPosition(target: _ll(widget.plan.origin), zoom: 11),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            padding: EdgeInsets.only(bottom: MediaQuery.sizeOf(context).height * 0.4),
            onMapCreated: (c) {
              _map = c;
              _fit();
            },
            polylines: {
              Polyline(
                polylineId: const PolylineId('trip'),
                points: widget.plan.route.points.map(_ll).toList(),
                color: scheme.primary,
                width: 5,
              ),
            },
            markers: {
              Marker(
                markerId: const MarkerId('destination'),
                position: _ll(widget.plan.destination.location),
                infoWindow: InfoWindow(title: widget.plan.destination.name),
              ),
              for (final s in stations.values)
                Marker(
                  markerId: MarkerId(s.id),
                  position: _ll(s.location),
                  infoWindow: InfoWindow(title: s.name),
                  zIndexInt: top.contains(s.id) ? 2 : 1,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    s.id == _selected
                        ? BitmapDescriptor.hueAzure
                        : top.contains(s.id)
                        ? BitmapDescriptor.hueGreen
                        : BitmapDescriptor.hueOrange,
                  ),
                  onTap: () => setState(() => _selected = s.id),
                ),
            },
          ),
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.45,
          minChildSize: 0.2,
          maxChildSize: 0.92,
          snap: true,
          builder: (context, controller) => Material(
            elevation: 8,
            color: scheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            clipBehavior: Clip.antiAlias,
            child: content(controller),
          ),
        ),
      ],
    );
  }
}

/// Builds the result list (scroll controller comes from the sheet, if any).
class _ResultsList {
  const _ResultsList({required this.plan, required this.ranking, required this.selectedId, required this.onSelect});

  final AlongRoutePlan plan;
  final RankingResult? ranking;
  final String? selectedId;
  final void Function(Station) onSelect;

  Widget call(ScrollController? controller) => Consumer(
    builder: (context, ref, _) {
      final vehicle = ref.watch(activeVehicleProvider).value;
      final strategy = ref.watch(rankingStrategyProvider);
      final r = ranking;
      final byId = {for (final s in plan.stops) s.station.id: s};
      final unit = vehicle?.unit ?? 'L';
      final theme = Theme.of(context);
      final l = context.l10n;

      Widget tile(RankedStation rs, int? rank) {
        final stop = byId[rs.offer.stationId]!;
        return StationResultCard(
          key: ValueKey(rs.offer.stationId),
          ranked: rs,
          stop: stop,
          rank: rank,
          mode: r!.mode,
          unit: unit,
          selected: selectedId == rs.offer.stationId,
          onShowOnMap: () => onSelect(stop.station),
        );
      }

      return ListView(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.xl),
        children: [
          if (controller != null)
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          Text(
            '${Fmt.distance(plan.route.distanceMeters)} · ${Fmt.duration(plan.route.duration)} · '
            '${l.stationsOnTheWay(plan.stops.length)}',
            style: theme.textTheme.titleMedium,
          ),
          if (plan.fuelType != null)
            Text(
              l.comparingFuelPrices(localizedFuelType(plan.fuelType!, l)),
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          if (plan.detoursApproximate)
            _Notice(
              icon: Icons.info_outline_rounded,
              text: l.detoursApproximate,
            ),
          if (plan.skippedForDetour > 0)
            _Notice(
              icon: Icons.filter_alt_outlined,
              text: l.skippedForDetour(plan.skippedForDetour),
            ),
          const SizedBox(height: AppSpacing.sm),
          _VehicleControls(vehicle: vehicle, routeMeters: plan.route.distanceMeters),
          const SizedBox(height: AppSpacing.sm),
          SegmentedButton<RankingStrategy>(
            showSelectedIcon: false,
            segments: [for (final s in RankingStrategy.values) ButtonSegment(value: s, label: Text(strategyLabel(s, l)))],
            selected: {strategy},
            onSelectionChanged: (s) => ref.read(rankingStrategyProvider.notifier).set(s.first),
          ),
          const SizedBox(height: AppSpacing.md),
          if (r == null || (r.ranked.isEmpty && r.unpriced.isEmpty))
            AppEmptyView(
              title: l.noStationsAlongRoute,
              message: l.nothingWithin5km,
            )
          else ...[
            for (var i = 0; i < r.ranked.length; i++) tile(r.ranked[i], i + 1),
            if (r.unpriced.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.xs),
                child: Text(l.withoutComparablePrice(r.unpriced.length), style: theme.textTheme.titleSmall),
              ),
              for (final u in r.unpriced) tile(u, null),
            ],
          ],
          const RouteChargersSection(),
        ],
      );
    },
  );
}

class _Notice extends StatelessWidget {
  const _Notice({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: AppSpacing.xs),
    child: Row(
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: AppSpacing.xs),
        Expanded(child: Text(text, style: Theme.of(context).textTheme.bodySmall)),
      ],
    ),
  );
}

class _VehicleControls extends ConsumerWidget {
  const _VehicleControls({required this.vehicle, required this.routeMeters});

  final VehicleProfile? vehicle;
  final double routeMeters;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = vehicle;
    final l = context.l10n;
    if (v == null) {
      return Card(
        margin: EdgeInsets.zero,
        child: ListTile(
          leading: const Icon(Icons.directions_car_filled_outlined),
          title: Text(l.comparingPricePerLitre),
          subtitle: Text(l.addVehicleForTrueCost),
          trailing: TextButton(onPressed: () => context.push(AppRoutes.vehicleNew), child: Text(l.add)),
        ),
      );
    }
    final level = ref.watch(fillLevelProvider);
    final theme = Theme.of(context);
    final lastFillUp = ref.watch(fillUpsProvider(v.id)).value?.firstOrNull;
    final need = estimateRouteEnergy(routeMeters, v, lastFillUp: lastFillUp);
    final reach = tripReach(v, level: level, routeMeters: routeMeters);
    final muted = theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              (v.isElectric ? l.batteryNowToFull : l.tankNowToFull)(
                v.name,
                (level * 100).round(),
                Fmt.number(v.capacity * (1 - level) / (v.isElectric ? v.chargingEfficiency : 1), maxDecimals: 1),
                v.unit,
              ),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Slider(
              value: level,
              divisions: 20,
              label: '${(level * 100).round()}%',
              semanticFormatterCallback: (x) => (v.isElectric ? l.percentCharge : l.percentFuel)((x * 100).round()),
              onChanged: (x) => ref.read(fillLevelProvider.notifier).set(x),
            ),
            Text(RouteSummaryCard.estimateText(l, need), key: const Key('tripNeed'), style: muted),
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs, bottom: AppSpacing.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    reach.reachesDestination ? Icons.flag_rounded : Icons.warning_amber_rounded,
                    size: 18,
                    color: reach.reachesDestination ? theme.colorScheme.primary : theme.colorScheme.error,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      reach.reachesDestination
                          ? l.tripReaches((reach.arrivalLevel * 100).floor())
                          : l.tripShortfall(Fmt.distance(reach.rangeMeters), Fmt.distance(reach.shortfallMeters)),
                      key: const Key('tripReach'),
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StationResultCard extends StatelessWidget {
  const StationResultCard({
    super.key,
    required this.ranked,
    required this.stop,
    required this.rank,
    required this.mode,
    required this.unit,
    required this.selected,
    required this.onShowOnMap,
  });

  final RankedStation ranked;
  final RouteStop stop;
  final int? rank;
  final CostMode mode;
  final String unit;
  final bool selected;
  final VoidCallback onShowOnMap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    final o = ranked.offer;
    final dimmed = ranked.caveats.contains(Caveat.closed) || ranked.caveats.contains(Caveat.unreachable);
    final headline = switch ((mode, ranked.totalCost, o.pricePerUnit, o.currencyCode)) {
      (CostMode.totalCost, final t?, _, final c?) => Fmt.money(t, c),
      (_, _, final p?, final c?) => '${Fmt.price(p, c)}/$unit',
      _ => '—',
    };
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      color: selected ? theme.colorScheme.secondaryContainer : null,
      child: Opacity(
        opacity: dimmed ? 0.6 : 1,
        child: ExpansionTile(
          shape: const Border(),
          leading: CircleAvatar(
            backgroundColor: rank == 1 ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest,
            foregroundColor: rank == 1 ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
            child: rank == null ? const Icon(Icons.help_outline_rounded, size: 20) : Text('$rank'),
          ),
          title: Text(o.name, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.intoTheTrip(detourText(o, l), Fmt.distance(stop.alongMeters))),
              if (ranked.badges.isNotEmpty || ranked.caveats.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xs),
                  child: Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: [
                      for (final b in ranked.badges)
                        _Chip(text: badgeLabel(b, l), color: theme.colorScheme.primaryContainer),
                      for (final c in ranked.caveats)
                        _Chip(text: caveatLabel(c, l), color: theme.colorScheme.errorContainer),
                    ],
                  ),
                ),
            ],
          ),
          trailing: Text(headline, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          childrenPadding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.sm),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final line in explainRanking(ranked, mode: mode, unit: unit, l: l))
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Text(line, style: theme.textTheme.bodyMedium),
              ),
            if (stop.station.address != null) Text(stop.station.address!, style: theme.textTheme.bodySmall),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onShowOnMap,
                icon: const Icon(Icons.map_outlined),
                label: Text(l.showOnMap),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
    child: Text(text, style: Theme.of(context).textTheme.labelSmall),
  );
}
