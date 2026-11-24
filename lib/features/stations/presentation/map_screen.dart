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
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/state_views.dart';
import '../../route/domain/route_info.dart';
import '../../route/presentation/route_controller.dart';
import '../../ev/domain/charge_point.dart';
import '../../ev/presentation/ev_providers.dart';
import '../../ev/presentation/widgets/charge_point_sheet.dart';
import '../../ev/presentation/widgets/ev_filter_sheet.dart';
import '../../ev/presentation/widgets/marker_icons.dart';
import '../domain/entities/station.dart';
import 'stations_controllers.dart';
import 'widgets/station_details_sheet.dart';

LatLng _latLng(GeoPoint p) => LatLng(p.latitude, p.longitude);

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = ref.watch(locationControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FuelWise'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: FilledButton.tonalIcon(
              onPressed: () => context.push(AppRoutes.plan),
              icon: const Icon(Icons.alt_route_rounded),
              label: const Text('Plan trip'),
            ),
          ),
        ],
      ),
      body: switch (location) {
        AsyncData(:final value) => _StationsMap(origin: value),
        AsyncError(:final error) => LocationProblemView(error: error),
        _ => const AppLoading(label: 'Finding your location…'),
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
      LocationFailureReason.deniedForever => ('Open app settings', () => service.openAppSettings()),
      LocationFailureReason.serviceDisabled => ('Open location settings', () => service.openLocationSettings()),
      _ => (null, null),
    };

    return AppMessageView(
      icon: Icons.location_off_rounded,
      title: 'Location needed',
      message: failure?.message ?? 'Could not determine your location.',
      primaryLabel: 'Try again',
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
        ref.read(routeControllerProvider.notifier).routeTo(station.location);
      },
    );
  }

  void _fitRoute(RouteInfo route) {
    final pts = route.points;
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
        case AsyncData(:final value?):
          _fitRoute(value);
        case AsyncError(:final error):
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(error is AppFailure ? error.message : 'Could not get directions.')));
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

    final polylines = <Polyline>{
      if (route.value case final r?)
        Polyline(
          polylineId: const PolylineId('route'),
          points: r.points.map(_latLng).toList(),
          color: scheme.primary,
          width: 5,
        ),
    };

    final status = ev ? evStatus(chargers, filtered: filter.isActive) : fuelStatus(stations);
    final VoidCallback? retry = !status.showRetry
        ? null
        : ev
        ? () => ref.invalidate(nearbyChargePointsProvider)
        : () => ref.invalidate(nearbyStationsProvider);

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
        Positioned(
          top: AppSpacing.md,
          left: AppSpacing.md,
          right: 72,
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
              _StatusBanner(status: status, onRetry: retry),
              if (ev && (chargers.value?.isNotEmpty ?? false))
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xs),
                  child: Text(kOcmAttribution, style: Theme.of(context).textTheme.labelSmall),
                ),
            ],
          ),
        ),
        if (route.isLoading || route.value != null)
          Positioned(
            left: AppSpacing.md,
            right: AppSpacing.md,
            bottom: AppSpacing.lg,
            child: SafeArea(
              child: _RouteSummaryCard(
                route: route.value,
                loading: route.isLoading,
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

MapStatus fuelStatus(AsyncValue<List<Station>> stations) => switch (stations) {
  AsyncLoading() => (icon: Icons.search_rounded, text: 'Searching nearby stations…', showRetry: false),
  AsyncError(:final error) => (
    icon: Icons.error_outline_rounded,
    text: error is AppFailure ? error.message : 'Could not load stations.',
    showRetry: error is! ConfigFailure, // retrying cannot fix missing config
  ),
  AsyncData(:final value) when value.isEmpty => (
    icon: Icons.search_off_rounded,
    text: 'No fuel stations within 5 km.',
    showRetry: true,
  ),
  AsyncData(:final value) => (
    icon: Icons.local_gas_station_rounded,
    text: '${value.length} stations nearby',
    showRetry: false,
  ),
};

MapStatus evStatus(AsyncValue<List<ChargePoint>> chargers, {required bool filtered}) => switch (chargers) {
  AsyncLoading() => (icon: Icons.search_rounded, text: 'Searching chargers…', showRetry: false),
  AsyncError(:final error) => (
    icon: Icons.error_outline_rounded,
    text: error is AppFailure ? error.message : 'Could not load chargers.',
    showRetry: error is! ConfigFailure,
  ),
  AsyncData(:final value) when value.isEmpty => (
    icon: Icons.search_off_rounded,
    text: filtered ? 'No chargers match your filters.' : 'No chargers within 10 km.',
    showRetry: !filtered,
  ),
  AsyncData(:final value) => (
    icon: Icons.ev_station_rounded,
    text: '${value.length} ${value.length == 1 ? 'charger' : 'chargers'} nearby${filtered ? ' (filtered)' : ''}',
    showRetry: false,
  ),
};

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
            segments: const [
              ButtonSegment(value: MapMode.fuel, icon: Icon(Icons.local_gas_station_rounded), label: Text('Fuel')),
              ButtonSegment(value: MapMode.ev, icon: Icon(Icons.ev_station_rounded), label: Text('EV')),
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
              tooltip: 'Charger filters',
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
  const _StatusBanner({required this.status, this.onRetry});

  final MapStatus status;
  final VoidCallback? onRetry;

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
            if (onRetry != null) TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

class _RouteSummaryCard extends StatelessWidget {
  const _RouteSummaryCard({required this.route, required this.loading, required this.onClear});

  final RouteInfo? route;
  final bool loading;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            const Icon(Icons.route_rounded),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: loading || route == null
                  ? const Text('Calculating route…')
                  : Text(
                      '${Fmt.distance(route!.distanceMeters)} · ${Fmt.duration(route!.duration)}',
                      style: theme.textTheme.titleMedium,
                    ),
            ),
            IconButton(tooltip: 'Clear route', onPressed: onClear, icon: const Icon(Icons.close_rounded)),
          ],
        ),
      ),
    );
  }
}
