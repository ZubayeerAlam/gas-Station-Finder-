import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../l10n/l10n.dart';
import '../../../ev/domain/charge_point.dart';
import '../../domain/entities/station.dart';
import '../../domain/nearby_sort.dart';
import '../../../ranking/domain/ranking_models.dart';

/// Nearby fuel stations as a list: nearest first, or cheapest first for one
/// fuel type. Tapping opens the same details sheet as the map marker.
class NearbyStationList extends StatelessWidget {
  const NearbyStationList({
    super.key,
    required this.stations,
    required this.onOpen,
    this.sort = StationSort.nearest,
    this.onSort,
    this.comparingLabel,
    this.pricesLoading = false,
    this.bottomPadding = 0,
  });

  final List<PricedStation> stations;
  final ValueChanged<Station> onOpen;
  final StationSort sort;

  /// Null hides the sort chips (e.g. no way to look prices up).
  final ValueChanged<StationSort>? onSort;

  /// "Comparing Regular prices", shown while sorting by price.
  final String? comparingLabel;
  final bool pricesLoading;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final cheapest = sort == StationSort.cheapest;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (onSort case final onSort?)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: Wrap(
              spacing: AppSpacing.sm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                for (final (value, label) in [
                  (StationSort.nearest, l.sortNearest),
                  (StationSort.cheapest, l.sortCheapest),
                ])
                  ChoiceChip(
                    key: ValueKey('stationSort-${value.name}'),
                    label: Text(label),
                    selected: sort == value,
                    onSelected: (_) => onSort(value),
                  ),
                if (cheapest && pricesLoading)
                  const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                else if (cheapest && comparingLabel != null)
                  Text(comparingLabel!, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        Expanded(
          child: ListView.separated(
            key: const ValueKey('nearbyStationList'),
            padding: EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.lg + bottomPadding),
            itemCount: stations.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final s = stations[i];
              final price = s.price;
              final priceText = !cheapest || pricesLoading
                  ? null
                  : price == null
                  ? l.noComparablePrice
                  : '${Fmt.price(price.amount, price.currencyCode)} · '
                        '${s.source == PriceSource.community ? l.priceSourceCommunityShort : l.priceSourceGoogleShort}';
              return _NearbyTile(
                key: ValueKey('nearby-${s.ranked.item.id}'),
                icon: Icons.local_gas_station_rounded,
                title: s.ranked.item.name,
                subtitle: [?s.ranked.item.address, ?priceText].join('\n'),
                meters: s.ranked.meters,
                onTap: () => onOpen(s.ranked.item),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Wraps a nearest-first list without prices.
List<PricedStation> unpriced(List<Ranked<Station>> ranked) => [
  for (final r in ranked) (ranked: r, price: null, source: null),
];

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
