import 'package:flutter/material.dart';

import '../../../../core/location/geo_point.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/charge_point.dart';

const kOcmAttribution = 'Charging data © Open Charge Map contributors (CC BY-SA 4.0)';

Future<void> showChargePointSheet(
  BuildContext context, {
  required ChargePoint point,
  GeoPoint? origin,
  required VoidCallback onDirections,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.55,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (context, controller) =>
          ChargePointSheet(point: point, origin: origin, onDirections: onDirections, scrollController: controller),
    ),
  );
}

class ChargePointSheet extends StatelessWidget {
  const ChargePointSheet({
    super.key,
    required this.point,
    this.origin,
    required this.onDirections,
    this.scrollController,
    this.now,
  });

  final ChargePoint point;
  final GeoPoint? origin;
  final VoidCallback onDirections;
  final ScrollController? scrollController;
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = point;
    final muted = theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    final (statusText, statusColor, statusIcon) = switch (p.isOperational) {
      true => (p.statusLabel ?? 'Operational', theme.colorScheme.primaryContainer, Icons.check_circle_outline_rounded),
      false => (p.statusLabel ?? 'Not operational', theme.colorScheme.errorContainer, Icons.cancel_outlined),
      null => ('Status unknown', theme.colorScheme.surfaceContainerHighest, Icons.help_outline_rounded),
    };

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Text(p.name, style: theme.textTheme.titleLarge),
        if (p.operatorName != null) Text(p.operatorName!, style: theme.textTheme.bodyMedium),
        if (p.address != null || origin != null)
          Text(
            [
              if (p.address != null) p.address!,
              if (origin != null) Fmt.distance(origin!.distanceTo(p.location)),
            ].join(' · '),
            style: muted,
          ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          children: [
            Chip(avatar: Icon(statusIcon, size: 18), label: Text(statusText), backgroundColor: statusColor),
            if (p.maxPowerKw != null)
              Chip(
                avatar: const Icon(Icons.bolt_rounded, size: 18),
                label: Text('Up to ${chargeMarkerLabel(p)}${p.isFast ? ' · fast' : ''}'),
              ),
            if (p.numberOfPoints != null) Chip(label: Text('${p.numberOfPoints} charging points')),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Connectors', style: theme.textTheme.titleMedium),
        if (p.connectors.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Text('No connector details reported.', style: muted),
          )
        else
          for (final c in p.connectors)
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: Icon(c.isDc == true ? Icons.electric_bolt_rounded : Icons.power_rounded),
              title: Text(c.type),
              subtitle: Text(
                [
                  if (c.powerKw != null) '${Fmt.number(c.powerKw!, maxDecimals: 1)} kW',
                  if (c.isDc != null) c.isDc! ? 'DC' : 'AC',
                  if (c.quantity != null) '×${c.quantity}',
                  if (c.isOperational == false) 'not operational',
                ].join(' · '),
              ),
            ),
        const SizedBox(height: AppSpacing.sm),
        Text('Cost', style: theme.textTheme.titleMedium),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Text(
            p.usageCost == null
                ? 'No cost information reported. Check the operator app or the charger display.'
                : '"${p.usageCost}" — as listed by the community; not verified by FuelWise.',
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (p.lastVerified != null || p.lastStatusUpdate != null)
          Text(
            [
              if (p.lastVerified != null) 'Last verified ${Fmt.relativeTime(p.lastVerified!, now: now)}',
              if (p.lastStatusUpdate != null) 'status updated ${Fmt.relativeTime(p.lastStatusUpdate!, now: now)}',
            ].join(' · '),
            style: muted,
          ),
        const SizedBox(height: AppSpacing.md),
        FilledButton.icon(
          onPressed: onDirections,
          icon: const Icon(Icons.directions_rounded),
          label: const Text('Directions'),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(kOcmAttribution, style: muted),
      ],
    );
  }
}
