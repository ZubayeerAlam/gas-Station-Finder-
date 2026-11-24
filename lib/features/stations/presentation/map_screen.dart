import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/error/app_failure.dart';
import '../../../core/location/geo_point.dart';
import '../../../core/location/location_controller.dart';
import '../../../core/location/location_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/state_views.dart';
import '../../route/domain/route_info.dart';
import '../../route/presentation/route_controller.dart';
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
      appBar: AppBar(title: const Text('FuelWise')),
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
    _map?.animateCamera(CameraUpdate.newLatLngBounds(
      LatLngBounds(southwest: LatLng(minLat, minLng), northeast: LatLng(maxLat, maxLng)),
      64,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final stations = ref.watch(nearbyStationsProvider);
    final route = ref.watch(routeControllerProvider);
    final scheme = Theme.of(context).colorScheme;

    ref.listen(routeControllerProvider, (prev, next) {
      switch (next) {
        case AsyncData(:final value?):
          _fitRoute(value);
        case AsyncError(:final error):
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(error is AppFailure ? error.message : 'Could not get directions.'),
          ));
        default:
      }
    });

    final markers = <Marker>{
      for (final s in stations.value ?? const <Station>[])
        Marker(
          markerId: MarkerId(s.id),
          position: _latLng(s.location),
          infoWindow: InfoWindow(title: s.name, snippet: Fmt.distance(widget.origin.distanceTo(s.location))),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          onTap: () => _openStation(s),
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

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(target: _latLng(widget.origin), zoom: 14),
          onMapCreated: (c) => _map = c,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          markers: markers,
          polylines: polylines,
        ),
        Positioned(
          top: AppSpacing.md,
          left: AppSpacing.md,
          right: 72,
          child: _StatusBanner(
            stations: stations,
            onRetry: () => ref.invalidate(nearbyStationsProvider),
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

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.stations, required this.onRetry});

  final AsyncValue<List<Station>> stations;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final (IconData icon, String text, bool showRetry) = switch (stations) {
      AsyncLoading() => (Icons.search_rounded, 'Searching nearby stations…', false),
      AsyncError(:final error) =>
        (Icons.error_outline_rounded, error is AppFailure ? error.message : 'Could not load stations.', true),
      AsyncData(:final value) when value.isEmpty =>
        (Icons.search_off_rounded, 'No fuel stations within 5 km.', true),
      AsyncData(:final value) => (Icons.local_gas_station_rounded, '${value.length} stations nearby', false),
    };
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(text, maxLines: 4, overflow: TextOverflow.ellipsis)),
            if (showRetry) TextButton(onPressed: onRetry, child: const Text('Retry')),
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
            IconButton(
              tooltip: 'Clear route',
              onPressed: onClear,
              icon: const Icon(Icons.close_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
