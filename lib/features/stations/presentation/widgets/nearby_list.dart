import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../l10n/l10n.dart';
import '../../../ev/domain/charge_point.dart';
import '../../domain/entities/station.dart';
import '../../domain/nearby_sort.dart';

/// Nearby fuel stations as a list, nearest first. Tapping opens the same
/// details sheet as the map marker.
class NearbyStationList extends StatelessWidget {
  const NearbyStationList({super.key, required this.stations, required this.onOpen, this.bottomPadding = 0});

  final List<Ranked<Station>> stations;
  final ValueChanged<Station> onOpen;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      key: const ValueKey('nearbyStationList'),
      padding: EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.lg + bottomPadding),
      itemCount: stations.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final s = stations[i];
        return _NearbyTile(
          key: ValueKey('nearby-${s.item.id}'),
          icon: Icons.local_gas_station_rounded,
          title: s.item.name,
          subtitle: s.item.address,
          meters: s.meters,
          onTap: () => onOpen(s.item),
        );
      },
    );
  }
}

/// Nearby chargers as a list, by distance or by charging power.
class NearbyChargerList extends StatelessWidget {
  const NearbyChargerList({
    super.key,
    required this.chargers,
    required this.sort,
    required this.onSort,
    required this.onOpen,
    this.bottomPadding = 0,
  });

  final List<Ranked<ChargePoint>> chargers;
  final ChargerSort sort;
  final ValueChanged<ChargerSort> onSort;
  final ValueChanged<ChargePoint> onOpen;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.sm),
          child: Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (final (value, label) in [(ChargerSort.nearest, l.sortNearest), (ChargerSort.fastest, l.sortFastest)])
                ChoiceChip(label: Text(label), selected: sort == value, onSelected: (_) => onSort(value)),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            key: const ValueKey('nearbyChargerList'),
            padding: EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.lg + bottomPadding),
            itemCount: chargers.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final c = chargers[i].item;
              final down = c.isOperational == false;
              final details = [chargeMarkerLabel(c), ?c.operatorName, if (down) l.chargerOutOfService].join(' · ');
              return _NearbyTile(
                key: ValueKey('nearby-${c.id}'),
                icon: c.isFast ? Icons.bolt_rounded : Icons.ev_station_rounded,
                iconColor: down ? scheme.outline : null,
                title: c.name,
                subtitle: details,
                meters: chargers[i].meters,
                onTap: () => onOpen(c),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _NearbyTile extends StatelessWidget {
  const _NearbyTile({
    super.key,
    required this.icon,
    required this.title,
    required this.meters,
    required this.onTap,
    this.subtitle,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final double meters;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      leading: Icon(icon, color: iconColor ?? theme.colorScheme.primary),
      title: Text(title),
      subtitle: subtitle == null || subtitle!.isEmpty ? null : Text(subtitle!),
      trailing: Text(Fmt.distance(meters), style: theme.textTheme.labelLarge),
      onTap: onTap,
    );
  }
}
