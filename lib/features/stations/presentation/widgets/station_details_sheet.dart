import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/location/geo_point.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../prices/presentation/community_section.dart';
import '../../domain/entities/station.dart';
import '../stations_controllers.dart';
import '../../../../l10n/domain_labels.dart';
import '../../../../l10n/failure_text.dart';
import '../../../../l10n/l10n.dart';

/// Opens the station details bottom sheet.
Future<void> showStationDetailsSheet(
  BuildContext context, {
  required Station station,
  GeoPoint? origin,
  required VoidCallback onDirections,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (context, controller) => StationDetailsSheet(
        station: station,
        origin: origin,
        onDirections: onDirections,
        scrollController: controller,
      ),
    ),
  );
}

class StationDetailsSheet extends ConsumerWidget {
  const StationDetailsSheet({
    super.key,
    required this.station,
    required this.onDirections,
    this.origin,
    this.scrollController,
  });

  final Station station;
  final GeoPoint? origin;
  final VoidCallback onDirections;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final details = ref.watch(stationDetailsProvider(station.id));
    final distance = origin?.distanceTo(station.location);

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
      children: [
        Text(station.name, style: theme.textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.xs),
        Text(
          [
            if (distance != null) context.l10n.distanceAwayStraight(Fmt.distance(distance)),
            if (station.address != null) station.address!,
          ].join(' · '),
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.md),
        FilledButton.icon(
          onPressed: onDirections,
          icon: const Icon(Icons.directions_rounded),
          label: Text(context.l10n.directions),
        ),
        const SizedBox(height: AppSpacing.md),
        const Divider(),
        switch (details) {
          AsyncData(:final value) => _DetailsBody(details: value),
          AsyncError(:final error) => _DetailsError(
              message: describeFailure(error, context.l10n, fallback: context.l10n.couldNotLoadStationDetails),
              onRetry: () => ref.invalidate(stationDetailsProvider(station.id)),
            ),
          _ => Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Center(child: CircularProgressIndicator(semanticsLabel: context.l10n.loadingStationDetails)),
            ),
        },
        const Divider(height: AppSpacing.lg * 2),
        CommunitySection(station: station),
      ],
    );
  }
}

class _DetailsError extends StatelessWidget {
  const _DetailsError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Column(
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton(onPressed: onRetry, child: Text(context.l10n.tryAgain)),
        ],
      ),
    );
  }
}

class _DetailsBody extends StatelessWidget {
  const _DetailsBody({required this.details});

  final StationDetails details;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            if (details.openNow != null)
              Chip(
                avatar: Icon(
                  details.openNow! ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  size: 18,
                  color: details.openNow! ? Colors.green.shade700 : theme.colorScheme.error,
                ),
                label: Text(details.openNow! ? context.l10n.openNow : context.l10n.closed),
              ),
            if (details.rating != null)
              Chip(
                avatar: const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
                label: Text(
                  '${details.rating!.toStringAsFixed(1)}'
                  '${details.userRatingCount != null ? ' (${details.userRatingCount})' : ''}',
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(context.l10n.fuelPrices, style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        if (details.hasFuelPrices)
          ...details.fuelPrices.map((p) => _FuelPriceTile(price: p))
        else
          Text(
            context.l10n.fuelPricesUnavailable,
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        if (details.evCharge != null && details.evCharge!.connectors.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          Text(context.l10n.evCharging, style: theme.textTheme.titleMedium),
          ...details.evCharge!.connectors.map(
            (c) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.ev_station_rounded),
              title: Text(localizedConnector(c.type, context.l10n)),
              subtitle: Text([
                if (c.maxChargeRateKw != null) '${c.maxChargeRateKw!.toStringAsFixed(0)} kW',
                if (c.count != null) context.l10n.connectorCount(c.count!),
                if (c.availableCount != null) context.l10n.availableReported(c.availableCount!),
              ].join(' · ')),
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        if (details.address != null)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.place_outlined),
            title: Text(details.address!),
          ),
        if (details.phone != null)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.phone_outlined),
            title: Text(details.phone!),
          ),
        if (details.weekdayHours.isNotEmpty)
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            leading: const Icon(Icons.schedule_outlined),
            title: Text(context.l10n.openingHours),
            children: [
              for (final line in details.weekdayHours)
                Align(alignment: Alignment.centerLeft, child: Text(line)),
            ],
          ),
      ],
    );
  }
}

class _FuelPriceTile extends StatelessWidget {
  const _FuelPriceTile({required this.price});

  final FuelPrice price;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.local_gas_station_rounded),
      title: Text(localizedFuelType(price.fuelType, context.l10n)),
      subtitle: price.updatedAt == null
          ? Text(context.l10n.sourceGoogle)
          : Text(context.l10n.sourceGoogleUpdated(relativeTime(price.updatedAt!, context.l10n))),
      trailing: Text(
        Fmt.price(price.amount, price.currencyCode),
        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}
