import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../l10n/l10n.dart';
import '../domain/route_energy.dart';
import '../domain/route_info.dart';

/// Bottom card for the active route: distance and time of the selected route,
/// plus one chip per alternative so the driver can compare and switch.
class RouteSummaryCard extends StatelessWidget {
  const RouteSummaryCard({
    super.key,
    required this.plan,
    required this.loading,
    required this.onSelect,
    required this.onClear,
    this.estimateFor,
  });

  /// Fuel / cost for a route distance (null = no active vehicle).
  final RouteEnergyEstimate Function(double meters)? estimateFor;

  final RoutePlan? plan;
  final bool loading;
  final ValueChanged<int> onSelect;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    final p = plan;
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.route_rounded),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: loading || p == null
                      ? Text(l.calculatingRoute)
                      : Text(
                          '${Fmt.distance(p.selected.distanceMeters)} · ${Fmt.duration(p.selected.duration)}',
                          style: theme.textTheme.titleMedium,
                        ),
                ),
                IconButton(tooltip: l.clearRoute, onPressed: onClear, icon: const Icon(Icons.close_rounded)),
              ],
            ),
            if (!loading && p != null && estimateFor != null)
              Padding(
                padding: const EdgeInsets.only(left: 40, bottom: AppSpacing.xs),
                child: Text(
                  _estimateText(l, estimateFor!(p.selected.distanceMeters)),
                  key: const Key('routeEstimate'),
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ),
            if (!loading && p != null && p.hasAlternatives)
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                children: [
                  for (var i = 0; i < p.routes.length; i++)
                    ChoiceChip(
                      key: ValueKey('routeOption-$i'),
                      selected: i == p.selectedIndex,
                      onSelected: (_) => onSelect(i),
                      label: Text(_label(l, p, i)),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  static String _estimateText(AppLocalizations l, RouteEnergyEstimate e) {
    final units = '${e.units.toStringAsFixed(1)} ${e.unit}';
    return switch ((e.cost, e.currencyCode)) {
      (final c?, final cur?) => l.routeEnergyWithCost(units, Fmt.money(c, cur)),
      _ => l.routeEnergyOnly(units),
    };
  }

  static String _label(AppLocalizations l, RoutePlan p, int i) {
    final dist = Fmt.distance(p.routes[i].distanceMeters);
    if (i == 0) return l.routeFastest(dist);
    final extraMin = (p.differenceFromFastest(i).seconds / 60).round();
    return extraMin <= 0 ? l.routeAlternativeSameTime(dist) : l.routeAlternativeSlower(extraMin, dist);
  }
}
