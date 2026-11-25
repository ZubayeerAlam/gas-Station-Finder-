import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/charge_point.dart';
import '../ev_providers.dart';

const kPowerSteps = <double>[0, 22, 50, 150];

String powerStepLabel(double kw, [AppLocalizations? l]) => kw == 0 ? (l ?? kEnglish).powerAny : '≥ ${kw.round()} kW';

/// Filters built from the connector types actually present nearby.
class EvFilterSheet extends ConsumerWidget {
  const EvFilterSheet({super.key, required this.availableConnectors});

  final List<String> availableConnectors;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(evFilterProvider);
    final notifier = ref.read(evFilterProvider.notifier);
    final theme = Theme.of(context);
    final l = context.l10n;
    return SafeArea(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Row(
            children: [
              Expanded(child: Text(l.chargerFilters, style: theme.textTheme.titleLarge)),
              TextButton(onPressed: filter.isActive ? notifier.reset : null, child: Text(l.reset)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(l.minimumPower, style: theme.textTheme.titleSmall),
          const SizedBox(height: AppSpacing.xs),
          SegmentedButton<double>(
            showSelectedIcon: false,
            segments: [for (final kw in kPowerSteps) ButtonSegment(value: kw, label: Text(powerStepLabel(kw, l)))],
            selected: {filter.minPowerKw},
            onSelectionChanged: (s) => notifier.set(filter.copyWith(minPowerKw: s.first)),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(l.connector, style: theme.textTheme.titleSmall),
          const SizedBox(height: AppSpacing.xs),
          if (availableConnectors.isEmpty)
            Text(l.noConnectorDataNearby, style: theme.textTheme.bodySmall)
          else
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: [
                for (final c in availableConnectors)
                  FilterChip(
                    label: Text(c),
                    selected: filter.connectorTypes.contains(c),
                    onSelected: (on) => notifier.set(
                      filter.copyWith(
                        connectorTypes: on ? {...filter.connectorTypes, c} : ({...filter.connectorTypes}..remove(c)),
                      ),
                    ),
                  ),
              ],
            ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l.onlyOperational),
            subtitle: Text(l.onlyOperationalHelp),
            value: filter.operationalOnly,
            onChanged: (v) => notifier.set(filter.copyWith(operationalOnly: v)),
          ),
        ],
      ),
    );
  }
}

/// Sorted connector names across [points].
List<String> connectorTypesOf(List<ChargePoint> points) =>
    ({for (final p in points) ...p.connectorTypes}.toList()..sort());
