import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/state_views.dart';
import '../../care/presentation/care_providers.dart';
import '../domain/vehicle_profile.dart';
import 'garage_providers.dart';
import '../../../l10n/domain_labels.dart';
import '../../../l10n/l10n.dart';
import '../../../l10n/language_menu.dart';

class GarageScreen extends ConsumerWidget {
  const GarageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicles = ref.watch(vehiclesProvider);
    final activeId = ref.watch(activeVehicleIdProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.garageTitle),
        actions: [
          IconButton(
            tooltip: context.l10n.privacyTitle,
            icon: const Icon(Icons.privacy_tip_outlined),
            onPressed: () => context.push(AppRoutes.privacy),
          ),
          const LanguageMenuButton(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.vehicleNew),
        icon: const Icon(Icons.add_rounded),
        label: Text(context.l10n.addVehicle),
      ),
      body: switch (vehicles) {
        AsyncData(:final value) when value.isEmpty => AppMessageView(
            icon: Icons.directions_car_filled_outlined,
            title: context.l10n.noVehiclesTitle,
            message: context.l10n.noVehiclesMessage,
            primaryLabel: context.l10n.addVehicle,
            onPrimary: () => context.push(AppRoutes.vehicleNew),
          ),
        AsyncData(:final value) => ListView.separated(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 96),
            itemCount: value.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, i) => VehicleCard(vehicle: value[i], active: value[i].id == activeId),
          ),
        AsyncError() => AppErrorView(message: context.l10n.couldNotLoadGarage),
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
        title: Text(context.l10n.deleteVehicleTitle(vehicle.name)),
        content: Text(context.l10n.deleteVehicleBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(context.l10n.cancel)),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(context.l10n.delete)),
        ],
      ),
    );
    if (ok != true) return;
    final controller = ref.read(garageControllerProvider);
    final result = await controller.delete(vehicle.id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(result.isOk ? context.l10n.vehicleDeleted(vehicle.name) : context.l10n.couldNotDeleteVehicle),
      action: result.isOk
          ? SnackBarAction(label: context.l10n.undo, onPressed: () => controller.save(vehicle))
          : null,
    ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final ev = vehicle.isElectric;
    final attention = ref.watch(careAttentionCountProvider(vehicle.id));
    final details = [
      '${vehicle.consumptionPer100Km.toStringAsFixed(1)} ${ev ? 'kWh' : 'L'}/100 km',
      ev
          ? context.l10n.batteryCapacity('${vehicle.capacity.toStringAsFixed(0)} ${vehicle.unit}')
          : context.l10n.tankCapacity('${vehicle.capacity.toStringAsFixed(0)} ${vehicle.unit}'),
      if (vehicle.preferredFuelType != null) localizedFuelType(vehicle.preferredFuelType!, context.l10n),
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
                            semanticLabel: context.l10n.activeVehicle),
                      ],
                    ]),
                    const SizedBox(height: AppSpacing.xs),
                    Text(details, style: theme.textTheme.bodySmall),
                    Text(ev ? context.l10n.fullChargeRange(Fmt.distance(vehicle.rangeMeters(1))) : context.l10n.fullTankRange(Fmt.distance(vehicle.rangeMeters(1))),
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                    if (attention > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.xs),
                        // A button rather than a chip: its label wraps, so long
                        // translations and large text sizes are never clipped.
                        child: OutlinedButton.icon(
                          key: ValueKey('careChip-${vehicle.id}'),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: theme.colorScheme.surface,
                            foregroundColor: theme.colorScheme.onSurface,
                            alignment: Alignment.centerLeft,
                          ),
                          icon: Icon(Icons.build_circle_rounded, size: 18, color: theme.colorScheme.error),
                          label: Text(context.l10n.careAttention(attention)),
                          onPressed: () => context.push(AppRoutes.care, extra: vehicle),
                        ),
                      ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                tooltip: context.l10n.vehicleOptions,
                onSelected: (v) => switch (v) {
                  'care' => context.push(AppRoutes.care, extra: vehicle),
                  'edit' => context.push(AppRoutes.vehicleEdit, extra: vehicle),
                  _ => _delete(context, ref),
                },
                itemBuilder: (_) => [
                  PopupMenuItem(value: 'care', child: Text(context.l10n.careMenu)),
                  PopupMenuItem(value: 'edit', child: Text(context.l10n.edit)),
                  PopupMenuItem(value: 'delete', child: Text(context.l10n.delete)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
