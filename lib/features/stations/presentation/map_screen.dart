import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/error/app_failure.dart';
import '../../../core/location/geo_point.dart';
import '../../../core/location/location_controller.dart';
import '../../../core/location/location_service.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/failure_text.dart';
import '../../../l10n/l10n.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/state_views.dart';
import '../../route/domain/route_info.dart';
import '../../route/presentation/route_controller.dart';
import '../../route/presentation/route_summary_card.dart';
import '../../ev/domain/charge_point.dart';
import '../../ev/presentation/ev_providers.dart';
import '../../ev/presentation/widgets/charge_point_sheet.dart';
import '../../ev/presentation/widgets/ev_filter_sheet.dart';
import '../../ev/presentation/widgets/marker_icons.dart';
import '../domain/entities/station.dart';
import '../domain/nearby_sort.dart';
import 'stations_controllers.dart';
import 'widgets/nearby_list.dart';
import 'widgets/station_details_sheet.dart';

LatLng _latLng(GeoPoint p) => LatLng(p.latitude, p.longitude);

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = ref.watch(locationControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.appTitle),
        actions: [
          IconButton(
            tooltip: context.l10n.tooltipAssistant,
            onPressed: () => context.push(AppRoutes.assistant),
            icon: const Icon(Icons.auto_awesome_outlined),
          ),
          IconButton(
            tooltip: context.l10n.tooltipAlerts,
            onPressed: () => context.push(AppRoutes.alerts),
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: FilledButton.tonalIcon(
              onPressed: () => context.push(AppRoutes.plan),
              icon: const Icon(Icons.alt_route_rounded),
              label: Text(context.l10n.planTrip),
            ),
          ),
        ],
      ),
      body: switch (location) {
        AsyncData(:final value) => _StationsMap(origin: value),
        AsyncError(:final error) => LocationProblemView(error: error),
        _ => AppLoading(label: context.l10n.findingLocation),
      },
    );
  }
}

/// Shown when location is unavailable (permission, services off, etc.).
class LocationProblemView extends ConsumerWidget {
  const LocationProblemView({super.key, required this.error});

  final Object error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final failure = error is LocationFailure ? error as LocationFailure : null;
    final service = ref.read(locationServiceProvider);
    final retry = ref.read(locationControllerProvider.notifier).relocate;

    final (String? settingsLabel, VoidCallback? openSettings) = switch (failure?.reason) {
      LocationFailureReason.deniedForever => (context.l10n.openAppSettings, () => service.openAppSettings()),
      LocationFailureReason.serviceDisabled => (context.l10n.openLocationSettings, () => service.openLocationSettings()),
      _ => (null, null),
    };

    return AppMessageView(
      icon: Icons.location_off_rounded,
      title: context.l10n.locationNeeded,
      message: describeFailure(failure, context.l10n, fallback: context.l10n.couldNotDetermineLocation),
      primaryLabel: context.l10n.tryAgain,
      onPrimary: retry,
      secondaryLabel: settingsLabel,
      onSecondary: openSettings,
    );
  }
}

class _StationsMap extends ConsumerStatefulWidget {
  const _StationsMap({required this.origin});

  final GeoPoint origin;

  @override
  ConsumerState<_StationsMap> createState() => _StationsMapState();
}

class _StationsMapState extends ConsumerState<_StationsMap> {
  GoogleMapController? _map;

  /// List view instead of the map (the map stays alive underneath).
  bool _list = false;
  ChargerSort _chargerSort = ChargerSort.nearest;

  @override
  void didUpdateWidget(covariant _StationsMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.origin != widget.origin) {
      _map?.animateCamera(CameraUpdate.newLatLngZoom(_latLng(widget.origin), 14));
    }
  }

  @override
  void dispose() {
    _map?.dispose();
    super.dispose();
  }

  void _openStation(Station station) {
    showStationDetailsSheet(
      context,
      station: station,
      origin: widget.origin,
      onDirections: () {
        Navigator.of(context).pop();
        setState(() => _list = false);
        ref.read(routeControllerProvider.notifier).routeTo(station.location);
      },
    );
  }

  void _fitRoute(RoutePlan plan) {
    final pts = [for (final r in plan.routes) ...r.points];
    var minLat = pts.first.latitude, maxLat = minLat;
    var minLng = pts.first.longitude, maxLng = minLng;
    for (final p in pts) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }
    _map?.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(southwest: LatLng(minLat, minLng), northeast: LatLng(maxLat, maxLng)),
        64,
      ),
    );
  }

  static const _cluster = ClusterManagerId('places');
  final _icons = PillMarkerIcons();
  final _readyIcons = <String, BitmapDescriptor>{};
  final _pendingIcons = <String>{};

  /// Pill icon for a charger, drawn once and cached; null until ready.
  BitmapDescriptor? _chargerIcon(ChargePoint p, ColorScheme scheme, double dpr) {
    final label = chargeMarkerLabel(p);
    final (bg, fg) = p.isOperational == false
        ? (Colors.grey.shade600, Colors.white)
        : p.isFast
        ? (scheme.primary, scheme.onPrimary)
        : (scheme.tertiary, scheme.onTertiary);
    final key = '$label|${bg.toARGB32()}';
    final ready = _readyIcons[key];
    if (ready == null && _pendingIcons.add(key)) {
      _icons.get(label, background: bg, foreground: fg, dpr: dpr).then((d) {
        if (mounted) setState(() => _readyIcons[key] = d);
      });
    }
    return ready;
  }

  void _openChargePoint(ChargePoint p) {
    showChargePointSheet(
      context,
      point: p,
      origin: widget.origin,
      onDirections: () {
        Navigator.of(context).pop();
        setState(() => _list = false);
        ref.read(routeControllerProvider.notifier).routeTo(p.location);
      },
    );
  }

  Future<void> _openFilters(List<ChargePoint> all) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => EvFilterSheet(availableConnectors: connectorTypesOf(all)),
  );

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(mapModeProvider);
    final ev = mode == MapMode.ev;
    // Only the active mode's data source is queried (each search is billed).
    final AsyncValue<List<Station>> stations = ev ? const AsyncData(<Station>[]) : ref.watch(nearbyStationsProvider);
    final AsyncValue<List<ChargePoint>> chargers = ev
        ? ref.watch(filteredChargePointsProvider)
        : const AsyncData(<ChargePoint>[]);
    final allChargers = ev
        ? ref.watch(nearbyChargePointsProvider).value ?? const <ChargePoint>[]
        : const <ChargePoint>[];
    final filter = ref.watch(evFilterProvider);
    final route = ref.watch(routeControllerProvider);
    final scheme = Theme.of(context).colorScheme;
    final dpr = MediaQuery.devicePixelRatioOf(context);

    ref.listen(routeControllerProvider, (prev, next) {
      switch (next) {
        case AsyncData(:final value?) when !identical(prev?.value?.routes, value.routes):
          _fitRoute(value); // new routes only; switching between them keeps the camera
        case AsyncError(:final error):
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(describeFailure(error, context.l10n, fallback: context.l10n.couldNotGetDirections))));
        default:
      }
    });

    final markers = <Marker>{
      if (!ev)
        for (final s in stations.value ?? const <Station>[])
          Marker(
            markerId: MarkerId(s.id),
            clusterManagerId: _cluster,
            position: _latLng(s.location),
            infoWindow: InfoWindow(title: s.name, snippet: Fmt.distance(widget.origin.distanceTo(s.location))),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            onTap: () => _openStation(s),
          )
      else
        for (final p in chargers.value ?? const <ChargePoint>[])
          Marker(
            markerId: MarkerId(p.id),
            clusterManagerId: _cluster,
            position: _latLng(p.location),
            infoWindow: InfoWindow(title: p.name, snippet: chargeMarkerLabel(p)),
            icon: _chargerIcon(p, scheme, dpr) ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
            onTap: () => _openChargePoint(p),
          ),
    };

    final plan = route.value;
    final polylines = <Polyline>{
      if (plan != null)
        for (var i = 0; i < plan.routes.length; i++)
          Polyline(
            polylineId: PolylineId('route-$i'),
            points: plan.routes[i].points.map(_latLng).toList(),
            color: i == plan.selectedIndex ? scheme.primary : scheme.outline.withValues(alpha: 0.7),
            width: i == plan.selectedIndex ? 6 : 4,
            // The selected route is drawn on top; others can be tapped to pick them.
            zIndex: i == plan.selectedIndex ? 2 : 1,
            consumeTapEvents: i != plan.selectedIndex,
            onTap: () => ref.read(routeControllerProvider.notifier).select(i),
          ),
    };

    final l10n = context.l10n;
    final status = ev ? evStatus(chargers, filtered: filter.isActive, l: l10n) : fuelStatus(stations, l: l10n);
    final VoidCallback? retry = !status.showRetry
        ? null
        : ev
        ? () => ref.invalidate(nearbyChargePointsProvider)
        : () => ref.invalidate(nearbyStationsProvider);

    final hasItems = ev ? (chargers.value?.isNotEmpty ?? false) : (stations.value?.isNotEmpty ?? false);
    final showList = _list && hasItems;
    final routeShown = route.isLoading || route.value != null;

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(target: _latLng(widget.origin), zoom: 14),
          onMapCreated: (c) => _map = c,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          clusterManagers: {const ClusterManager(clusterManagerId: _cluster)},
          markers: markers,
          polylines: polylines,
        ),
        if (showList) Positioned.fill(child: ColoredBox(color: scheme.surface)),
        Positioned(
          top: AppSpacing.md,
          left: AppSpacing.md,
          right: showList ? AppSpacing.md : 72,
          bottom: showList ? 0 : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MapModeBar(
                mode: mode,
                filterActive: filter.isActive,
                onMode: (m) => ref.read(mapModeProvider.notifier).set(m),
                onFilters: ev ? () => _openFilters(allChargers) : null,
              ),
              const SizedBox(height: AppSpacing.sm),
              _StatusBanner(
                status: status,
                onRetry: retry,
                listShown: showList,
                onToggleList: hasItems ? () => setState(() => _list = !showList) : null,
              ),
              if (ev && (chargers.value?.isNotEmpty ?? false))
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xs),
                  child: Text(kOcmAttribution, style: Theme.of(context).textTheme.labelSmall),
                ),
              if (showList)
                Expanded(
                  child: ev
                      ? NearbyChargerList(
                          chargers: sortChargers(chargers.value!, widget.origin, _chargerSort),
                          sort: _chargerSort,
                          onSort: (v) => setState(() => _chargerSort = v),
                          onOpen: _openChargePoint,
                          bottomPadding: routeShown ? 160 : 0,
                        )
                      : NearbyStationList(
                          stations: nearestFirst(stations.value!, widget.origin, (s) => s.location),
                          onOpen: _openStation,
                          bottomPadding: routeShown ? 160 : 0,
                        ),
                ),
            ],
          ),
        ),
        if (routeShown)
          Positioned(
            left: AppSpacing.md,
            right: AppSpacing.md,
            bottom: AppSpacing.lg,
            child: SafeArea(
              child: RouteSummaryCard(
                plan: route.value,
                loading: route.isLoading,
                onSelect: (i) => ref.read(routeControllerProvider.notifier).select(i),
                onClear: () => ref.read(routeControllerProvider.notifier).clear(),
              ),
            ),
          ),
      ],
    );
  }
}

/// Text shown in the map's status banner.
typedef MapStatus = ({IconData icon, String text, bool showRetry});

MapStatus fuelStatus(AsyncValue<List<Station>> stations, {DateTime? now, AppLocalizations? l}) {
  final t = l ?? kEnglish;
  return switch (stations) {
  AsyncLoading() => (icon: Icons.search_rounded, text: t.searchingStations, showRetry: false),
  AsyncError(:final error) => (
    icon: Icons.error_outline_rounded,
    text: describeFailure(error, t, fallback: t.couldNotLoadStations),
    showRetry: error is! ConfigFailure, // retrying cannot fix missing config
  ),
  AsyncData(:final value) when value.isEmpty => (
    icon: Icons.search_off_rounded,
    text: t.noStationsNearby,
    showRetry: true,
  ),
  AsyncData(:final value) when value.first.offlineSavedAt != null => (
    icon: Icons.cloud_off_rounded,
    text: t.offlineSavedStations(value.length, relativeTime(value.first.offlineSavedAt!, t, now: now)),
    showRetry: true,
  ),
  AsyncData(:final value) => (
    icon: Icons.local_gas_station_rounded,
    text: t.stationsNearby(value.length),
    showRetry: false,
  ),
  };
}

MapStatus evStatus(AsyncValue<List<ChargePoint>> chargers, {required bool filtered, AppLocalizations? l}) {
  final t = l ?? kEnglish;
  return switch (chargers) {
  AsyncLoading() => (icon: Icons.search_rounded, text: t.searchingChargers, showRetry: false),
  AsyncError(:final error) => (
    icon: Icons.error_outline_rounded,
    text: describeFailure(error, t, fallback: t.couldNotLoadChargers),
    showRetry: error is! ConfigFailure,
  ),
  AsyncData(:final value) when value.isEmpty => (
    icon: Icons.search_off_rounded,
    text: filtered ? t.noChargersMatchFilters : t.noChargersNearby,
    showRetry: !filtered,
  ),
  AsyncData(:final value) => (
    icon: Icons.ev_station_rounded,
    text: filtered ? t.chargersNearbyFiltered(value.length) : t.chargersNearby(value.length),
    showRetry: false,
  ),
  };
}

/// Fuel / EV switch + filter button.
class MapModeBar extends StatelessWidget {
  const MapModeBar({super.key, required this.mode, required this.onMode, this.onFilters, this.filterActive = false});

  final MapMode mode;
  final ValueChanged<MapMode> onMode;
  final VoidCallback? onFilters;
  final bool filterActive;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: scheme.surface,
          elevation: 2,
          shape: const StadiumBorder(),
          child: SegmentedButton<MapMode>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(
                  value: MapMode.fuel,
                  icon: const Icon(Icons.local_gas_station_rounded),
                  label: Text(context.l10n.modeFuel)),
              ButtonSegment(
                  value: MapMode.ev, icon: const Icon(Icons.ev_station_rounded), label: Text(context.l10n.modeEv)),
            ],
            selected: {mode},
            onSelectionChanged: (s) => onMode(s.first),
          ),
        ),
        if (onFilters != null) ...[
          const SizedBox(width: AppSpacing.sm),
          Badge(
            isLabelVisible: filterActive,
            smallSize: 10,
            child: IconButton.filledTonal(
              tooltip: context.l10n.chargerFilters,
              onPressed: onFilters,
              icon: const Icon(Icons.tune_rounded),
            ),
          ),
        ],
      ],
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.status, this.onRetry, this.onToggleList, this.listShown = false});

  final MapStatus status;
  final VoidCallback? onRetry;

  /// Switches between the map and the nearby list; null when there is nothing to list.
  final VoidCallback? onToggleList;
  final bool listShown;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        child: Row(
          children: [
            Icon(status.icon, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(status.text, maxLines: 4, overflow: TextOverflow.ellipsis)),
            if (onRetry != null) TextButton(onPressed: onRetry, child: Text(context.l10n.retry)),
            if (onToggleList != null)
              IconButton(
                key: const ValueKey('toggleNearbyList'),
                tooltip: listShown ? context.l10n.nearbyShowMap : context.l10n.nearbyShowList,
                onPressed: onToggleList,
                icon: Icon(listShown ? Icons.map_outlined : Icons.view_list_rounded),
              ),
          ],
        ),
      ),
    );
  }
}
