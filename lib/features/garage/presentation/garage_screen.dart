import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/state_views.dart';
import '../../stations/domain/entities/station.dart';
import '../domain/vehicle_profile.dart';
import 'garage_providers.dart';

class GarageScreen extends ConsumerWidget {
  const GarageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicles = ref.watch(vehiclesProvider);
    final activeId = ref.watch(activeVehicleIdProvider).value;

    return Scaffold(
      appBar: AppBar(title: const Text('My Garage')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.vehicleNew),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add vehicle'),
      ),
      body: switch (vehicles) {
        AsyncData(:final value) when value.isEmpty => AppMessageView(
            icon: Icons.directions_car_filled_outlined,
            title: 'No vehicles yet',
            message: 'Add your car or EV so FuelWise can calculate real trip costs and range.',
            primaryLabel: 'Add vehicle',
            onPrimary: () => context.push(AppRoutes.vehicleNew),
          ),
        AsyncData(:final value) => ListView.separated(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 96),
            itemCount: value.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, i) => VehicleCard(vehicle: value[i], active: value[i].id == activeId),
          ),
        AsyncError() => const AppErrorView(message: 'Could not load your garage.'),
        _ => const AppLoading(),
      },
    );
  }
}

class VehicleCard extends ConsumerWidget {
  const VehicleCard({super.key, required this.vehicle, required this.active});

  final VehicleProfile vehicle;
  final bool active;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text('Delete ${vehicle.name}?'),
        content: const Text('This removes the vehicle from your garage.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok != true) return;
    final controller = ref.read(garageControllerProvider);
    final result = await controller.delete(vehicle.id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(result.isOk ? '${vehicle.name} deleted' : 'Could not delete vehicle'),
      action: result.isOk
          ? SnackBarAction(label: 'Undo', onPressed: () => controller.save(vehicle))
          : null,
    ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final ev = vehicle.isElectric;
    final details = [
      '${vehicle.consumptionPer100Km.toStringAsFixed(1)} ${ev ? 'kWh' : 'L'}/100 km',
      '${vehicle.capacity.toStringAsFixed(0)} ${vehicle.unit} ${ev ? 'battery' : 'tank'}',
      if (vehicle.preferredFuelType != null) fuelTypeLabel(vehicle.preferredFuelType!),
    ].join(' · ');

    return Card(
      color: active ? theme.colorScheme.primaryContainer : null,
      child: InkWell(
        borderRadius: const BorderRadius.all(AppRadius.md),
        onTap: () => ref.read(garageControllerProvider).setActive(vehicle.id),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: theme.colorScheme.surface,
                child: Icon(ev ? Icons.electric_car_rounded : Icons.directions_car_rounded),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Flexible(child: Text(vehicle.name, style: theme.textTheme.titleMedium)),
                      if (active) ...[
                        const SizedBox(width: AppSpacing.sm),
                        Icon(Icons.check_circle_rounded, size: 18, color: theme.colorScheme.primary,
                            semanticLabel: 'Active vehicle'),
                      ],
                    ]),
                    const SizedBox(height: AppSpacing.xs),
                    Text(details, style: theme.textTheme.bodySmall),
                    Text('Full ${ev ? 'charge' : 'tank'} range ≈ ${Fmt.distance(vehicle.rangeMeters(1))}',
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                tooltip: 'Vehicle options',
                onSelected: (v) => v == 'edit'
                    ? context.push(AppRoutes.vehicleEdit, extra: vehicle)
                    : _delete(context, ref),
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
