import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../l10n/failure_text.dart';
import '../../../../l10n/l10n.dart';
import '../../../route/presentation/route_controller.dart';
import '../../domain/route_chargers.dart';
import '../ev_providers.dart';
import 'charge_point_sheet.dart';

/// "Chargers on this route" for EV trips on the along-route screen.
/// Renders nothing for fuel vehicles.
class RouteChargersSection extends ConsumerWidget {
  const RouteChargersSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(routeChargersProvider);
    if (async case AsyncData(value: null)) return const SizedBox.shrink();
    final l = context.l10n;
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant);

    Widget body = switch (async) {
      AsyncData(:final value?) when value.chargers.isEmpty => Text(
        l.routeChargersNone,
        key: const Key('routeChargersNone'),
      ),
      AsyncData(:final value?) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (value.partial)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Text(l.routeChargersPartial, key: const Key('routeChargersPartial'), style: muted),
            ),
          for (final c in value.chargers) _ChargerTile(charger: c),
          Text(l.routeChargersStraightLine, style: muted),
        ],
      ),
      AsyncError(:final error) => Text(describeFailure(error, l), key: const Key('routeChargersError')),
      _ => const Padding(
        padding: EdgeInsets.all(AppSpacing.sm),
        child: Center(child: CircularProgressIndicator()),
      ),
    };

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      child: Column(
        key: const Key('routeChargers'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l.routeChargersTitle, style: theme.textTheme.titleSmall),
          Text(l.routeChargersSubtitle, style: muted),
          const SizedBox(height: AppSpacing.xs),
          body,
          const SizedBox(height: AppSpacing.xs),
          Text(kOcmAttribution, style: theme.textTheme.labelSmall),
        ],
      ),
    );
  }
}

class _ChargerTile extends ConsumerWidget {
  const _ChargerTile({required this.charger});

  final RouteCharger charger;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final p = charger.point;
    final theme = Theme.of(context);
    final status = switch (p.isOperational) {
      true => l.statusOperational,
      false => l.statusNotOperational,
      null => l.statusUnknown,
    };
    final lines = [
      l.routeChargerPosition(Fmt.distance(charger.alongMeters), Fmt.distance(charger.offRouteMeters)),
      [if (p.maxPowerKw != null) l.routeChargerPower(Fmt.number(p.maxPowerKw!, maxDecimals: 0)), status].join(' · '),
    ];
    return ListTile(
      key: ValueKey('routeCharger-${p.id}'),
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        p.isFast ? Icons.bolt_rounded : Icons.ev_station_rounded,
        color: p.isOperational == false ? theme.colorScheme.error : theme.colorScheme.primary,
      ),
      title: Text(p.name),
      subtitle: Text(lines.join('\n')),
      isThreeLine: true,
      onTap: () => showChargePointSheet(
        context,
        point: p,
        onDirections: () {
          Navigator.of(context).pop();
          ref.read(routeControllerProvider.notifier).routeTo(p.location);
          context.go(AppRoutes.map);
        },
      ),
    );
  }
}
