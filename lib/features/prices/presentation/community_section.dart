import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/result.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../along_route/presentation/along_route_providers.dart' show nowProvider;
import '../../../l10n/domain_labels.dart';
import '../../../l10n/failure_text.dart';
import '../../../l10n/l10n.dart';
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
    final l = context.l10n;

    final header = Row(
      children: [
        Expanded(child: Text(l.communityPrices, style: theme.textTheme.titleMedium)),
        if (repo.isAvailable)
          TextButton.icon(
            onPressed: () => context.push(AppRoutes.reportPrice, extra: widget.station),
            icon: const Icon(Icons.add_rounded),
            label: Text(l.reportPrice),
          ),
      ],
    );

    if (!repo.isAvailable) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header,
          const SizedBox(height: AppSpacing.xs),
          Text(l.communityOff, style: muted),
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
            Text(l.noCommunityReports, style: muted),
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
          AsyncError(:final error) => Text(describeFailure(error, l, fallback: l.couldNotLoadCommunityPrices), style: muted),
          _ => const LinearProgressIndicator(),
        },
        if (_historyFuel case final fuel?) PriceHistoryPanel(stationId: id, fuelType: fuel),
        const SizedBox(height: AppSpacing.md),
        ReliabilityPanel(stationId: id),
      ],
    );
  }
}

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
    final l = context.l10n;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      selected: selected,
      onTap: onTap,
      leading: Icon(price.fuelType == 'EV_KWH' ? Icons.ev_station_rounded : Icons.people_alt_outlined),
      title: Text(localizedFuelType(price.fuelType, l)),
      subtitle: Text([
        l.communityReports(l.reportCount(price.reportCount)),
        l.updatedAgo(relativeTime(price.lastReportAt, l, now: now)),
        if (!fresh) l.outdated,
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
          Icon(selected ? Icons.expand_less_rounded : Icons.show_chart_rounded, semanticLabel: l.priceHistory),
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
    final l = context.l10n;
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
                child: Text(l.fuelHistory(localizedFuelType(widget.fuelType, l)), style: theme.textTheme.titleSmall),
              ),
              SegmentedButton<int>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(value: 7, label: Text(l.days7)),
                  ButtonSegment(value: 30, label: Text(l.days30)),
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
                Center(child: Text(l.noHistoryForPeriod)),
              AsyncData(:final value) => PriceHistoryChart(days: _latestCurrency(value)),
              AsyncError(:final error) => Center(child: Text(describeFailure(error, l, fallback: l.couldNotLoadPriceHistory))),
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
      label: context.l10n.priceHistorySemantics(currency, summary),
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
                  return SideTitleWidget(meta: meta, child: Text('${d.day} ${monthShort(d.month, context.l10n)}', style: label));
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
        Ok() => context.l10n.thanksForConfirming,
        Err(:final failure) => describeFailure(failure, context.l10n),
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
    final l = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.verified_user_outlined, size: 20, color: theme.colorScheme.primary),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(localizedReliability(score, l), style: theme.textTheme.titleSmall)),
            if (score != null)
              Text('${(score * 100).round()}%', style: theme.textTheme.titleSmall, semanticsLabel: l.reliabilitySemantics((score * 100).round())),
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
              if (rel.openVotes > 0) l.votesOpen(rel.openVotes),
              if (rel.closedVotes > 0) l.votesClosed(rel.closedVotes),
              if (rel.outOfStockVotes > 0) l.votesOutOfFuel(rel.outOfStockVotes),
            ].join(' · '),
            style: muted,
          ),
        Text(l.reliabilityDisclaimer, style: muted),
        const SizedBox(height: AppSpacing.sm),
        Text(l.isItOpenNow, style: theme.textTheme.bodyMedium),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.sm,
          children: [
            ChoiceChip(
              label: Text(l.voteOpen),
              selected: mine.open == true,
              onSelected: (_) => _vote(context, ref, mine.copyWith(open: true)),
            ),
            ChoiceChip(
              label: Text(l.voteClosed),
              selected: mine.open == false,
              onSelected: (_) => _vote(context, ref, mine.copyWith(open: false)),
            ),
            ChoiceChip(
              label: Text(l.voteOutOfFuel),
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
