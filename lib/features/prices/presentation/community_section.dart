import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/app_failure.dart';
import '../../../core/error/result.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../along_route/presentation/along_route_providers.dart' show nowProvider;
import '../../stations/domain/entities/station.dart';
import '../domain/community_models.dart';
import 'community_providers.dart';

/// Community prices, reliability and votes for one station (inside the
/// station details sheet). Every number shown comes from the backend.
class CommunitySection extends ConsumerStatefulWidget {
  const CommunitySection({super.key, required this.station});

  final Station station;

  @override
  ConsumerState<CommunitySection> createState() => _CommunitySectionState();
}

class _CommunitySectionState extends ConsumerState<CommunitySection> {
  String? _historyFuel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    final repo = ref.watch(communityRepositoryProvider);
    final id = widget.station.id;

    final header = Row(
      children: [
        Expanded(child: Text('Community prices', style: theme.textTheme.titleMedium)),
        if (repo.isAvailable)
          TextButton.icon(
            onPressed: () => context.push(AppRoutes.reportPrice, extra: widget.station),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Report price'),
          ),
      ],
    );

    if (!repo.isAvailable) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header,
          const SizedBox(height: AppSpacing.xs),
          Text('Community prices are turned off in this build.', style: muted),
        ],
      );
    }

    final now = ref.watch(nowProvider)();
    final prices = ref.watch(communityPricesProvider(id));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header,
        switch (prices) {
          AsyncData(value: final list) when list.isEmpty =>
            Text('No community reports yet. Be the first to report a price.', style: muted),
          AsyncData(value: final list) => Column(
              children: [
                for (final p in list)
                  CommunityPriceTile(
                    price: p,
                    now: now,
                    selected: _historyFuel == p.fuelType,
                    onTap: () => setState(() => _historyFuel = _historyFuel == p.fuelType ? null : p.fuelType),
                  ),
              ],
            ),
          AsyncError(:final error) => Text(_message(error, 'Could not load community prices.'), style: muted),
          _ => const LinearProgressIndicator(),
        },
        if (_historyFuel case final fuel?) PriceHistoryPanel(stationId: id, fuelType: fuel),
        const SizedBox(height: AppSpacing.md),
        ReliabilityPanel(stationId: id),
      ],
    );
  }
}

String _message(Object error, String fallback) => error is AppFailure ? error.message : fallback;

class CommunityPriceTile extends StatelessWidget {
  const CommunityPriceTile({super.key, required this.price, required this.now, this.selected = false, this.onTap});

  final CommunityPrice price;
  final DateTime now;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fresh = price.isFresh(now);
    final reports = price.reportCount == 1 ? '1 report' : '${price.reportCount} reports';
    return ListTile(
      contentPadding: EdgeInsets.zero,
      selected: selected,
      onTap: onTap,
      leading: Icon(price.fuelType == 'EV_KWH' ? Icons.ev_station_rounded : Icons.people_alt_outlined),
      title: Text(fuelTypeLabel(price.fuelType)),
      subtitle: Text([
        'Community · $reports',
        'updated ${Fmt.relativeTime(price.lastReportAt, now: now)}',
        if (!fresh) 'outdated',
      ].join(' · ')),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            Fmt.price(price.price, price.currencyCode),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: fresh ? null : theme.colorScheme.onSurfaceVariant,
              decoration: fresh ? null : TextDecoration.lineThrough,
            ),
          ),
          Icon(selected ? Icons.expand_less_rounded : Icons.show_chart_rounded, semanticLabel: 'Price history'),
        ],
      ),
    );
  }
}

class PriceHistoryPanel extends ConsumerStatefulWidget {
  const PriceHistoryPanel({super.key, required this.stationId, required this.fuelType});

  final String stationId;
  final String fuelType;

  @override
  ConsumerState<PriceHistoryPanel> createState() => _PriceHistoryPanelState();
}

class _PriceHistoryPanelState extends ConsumerState<PriceHistoryPanel> {
  int _days = 7;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final history = ref.watch(
      priceHistoryProvider((stationId: widget.stationId, fuelType: widget.fuelType, days: _days)),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('${fuelTypeLabel(widget.fuelType)} history', style: theme.textTheme.titleSmall),
              ),
              SegmentedButton<int>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(value: 7, label: Text('7 days')),
                  ButtonSegment(value: 30, label: Text('30 days')),
                ],
                selected: {_days},
                onSelectionChanged: (s) => setState(() => _days = s.first),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 160,
            child: switch (history) {
              AsyncData(:final value) when value.isEmpty =>
                const Center(child: Text('No history for this period yet.')),
              AsyncData(:final value) => PriceHistoryChart(days: _latestCurrency(value)),
              AsyncError(:final error) => Center(child: Text(_message(error, 'Could not load history.'))),
              _ => const Center(child: CircularProgressIndicator()),
            },
          ),
        ],
      ),
    );
  }
}

/// Keeps only the most recent currency so the line never mixes currencies.
List<PriceHistoryDay> _latestCurrency(List<PriceHistoryDay> days) {
  final currency = days.last.currencyCode;
  return [for (final d in days) if (d.currencyCode == currency) d];
}

class PriceHistoryChart extends StatelessWidget {
  const PriceHistoryChart({super.key, required this.days});

  /// Oldest first, one currency.
  final List<PriceHistoryDay> days;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final label = Theme.of(context).textTheme.labelSmall;
    final currency = days.first.currencyCode;
    final first = days.first.day;
    double x(PriceHistoryDay d) => d.day.difference(first).inDays.toDouble();
    final summary = days.map((d) => '${Fmt.date(d.day)} ${Fmt.price(d.close, currency)}').join(', ');

    return Semantics(
      label: 'Community price history in $currency: $summary',
      child: ExcludeSemantics(
        child: LineChart(LineChartData(
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(drawVerticalLine: false),
          minX: 0,
          maxX: days.length == 1 ? 1 : x(days.last),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                interval: days.length == 1 ? 1 : (x(days.last) / 3).clamp(1, 30).ceilToDouble(),
                getTitlesWidget: (value, meta) {
                  final d = first.add(Duration(days: value.round()));
                  return SideTitleWidget(meta: meta, child: Text('${d.day} ${Fmt.monthShort(d.month)}', style: label));
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 44,
                getTitlesWidget: (value, meta) =>
                    SideTitleWidget(meta: meta, child: Text(value.toStringAsFixed(2), style: label)),
              ),
            ),
          ),
          lineBarsData: [
            // Daily min–max range as a faint band, consensus close as the line.
            LineChartBarData(
              spots: [for (final d in days) FlSpot(x(d), d.max)],
              color: Colors.transparent,
              dotData: const FlDotData(show: false),
            ),
            LineChartBarData(
              spots: [for (final d in days) FlSpot(x(d), d.min)],
              color: Colors.transparent,
              dotData: const FlDotData(show: false),
            ),
            LineChartBarData(
              spots: [for (final d in days) FlSpot(x(d), d.close)],
              color: scheme.primary,
              barWidth: 3,
              dotData: FlDotData(show: days.length < 12),
            ),
          ],
          betweenBarsData: [BetweenBarsData(fromIndex: 0, toIndex: 1, color: scheme.primary.withValues(alpha: 0.12))],
        )),
      ),
    );
  }
}

class ReliabilityPanel extends ConsumerWidget {
  const ReliabilityPanel({super.key, required this.stationId});

  final String stationId;

  Future<void> _vote(BuildContext context, WidgetRef ref, StationVote vote) async {
    final result = await ref.read(communityRepositoryProvider).vote(stationId, vote);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(switch (result) {
        Ok() => 'Thanks for confirming!',
        Err(:final failure) => failure.message,
      }),
    ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    final rel = ref.watch(stationReliabilityProvider(stationId)).value;
    final mine = ref.watch(myVoteProvider(stationId)).value ?? const StationVote();
    final score = rel?.score;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.verified_user_outlined, size: 20, color: theme.colorScheme.primary),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(reliabilityLabel(score), style: theme.textTheme.titleSmall)),
            if (score != null)
              Text('${(score * 100).round()}%', style: theme.textTheme.titleSmall, semanticsLabel: 'Data reliability ${(score * 100).round()} percent'),
          ],
        ),
        if (score != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: ExcludeSemantics(child: LinearProgressIndicator(value: score, minHeight: 6)),
          ),
        if (rel != null && (rel.totalOpenClosedVotes > 0 || rel.outOfStockVotes > 0))
          Text(
            [
              if (rel.openVotes > 0) '${rel.openVotes} said open',
              if (rel.closedVotes > 0) '${rel.closedVotes} said closed',
              if (rel.outOfStockVotes > 0) '${rel.outOfStockVotes} said out of fuel',
            ].join(' · '),
            style: muted,
          ),
        Text('Based on recent community reports and votes — not an official check.', style: muted),
        const SizedBox(height: AppSpacing.sm),
        Text('Is it open right now?', style: theme.textTheme.bodyMedium),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.sm,
          children: [
            ChoiceChip(
              label: const Text('Open'),
              selected: mine.open == true,
              onSelected: (_) => _vote(context, ref, mine.copyWith(open: true)),
            ),
            ChoiceChip(
              label: const Text('Closed'),
              selected: mine.open == false,
              onSelected: (_) => _vote(context, ref, mine.copyWith(open: false)),
            ),
            ChoiceChip(
              label: const Text('Out of fuel'),
              selected: mine.fuelAvailable == false,
              onSelected: (_) => _vote(
                context,
                ref,
                mine.copyWith(fuelAvailable: mine.fuelAvailable == false ? true : false),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
