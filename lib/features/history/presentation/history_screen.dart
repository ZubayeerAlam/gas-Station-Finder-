import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/state_views.dart';
import '../../garage/domain/vehicle_profile.dart';
import '../../garage/presentation/garage_providers.dart';
import '../domain/fill_up.dart';
import '../domain/history_analytics.dart';
import 'history_providers.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key, this.now});

  /// Injectable clock for tests.
  final DateTime? now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicle = ref.watch(activeVehicleProvider);
    final v = vehicle.value;
    final fillUps = v == null ? null : ref.watch(fillUpsProvider(v.id));

    return Scaffold(
      appBar: AppBar(title: Text(v == null ? 'History' : 'History · ${v.name}')),
      floatingActionButton: v == null
          ? null
          : FloatingActionButton.extended(
              onPressed: () => context.push(AppRoutes.fillUpNew),
              icon: const Icon(Icons.add_rounded),
              label: Text(v.isElectric ? 'Add charge' : 'Add fill-up'),
            ),
      body: switch ((vehicle, fillUps)) {
        (AsyncError(), _) || (_, AsyncError()) => const AppErrorView(message: 'Could not load your history.'),
        (AsyncData(value: null), _) => AppMessageView(
            icon: Icons.directions_car_filled_outlined,
            title: 'No active vehicle',
            message: 'Add a vehicle in your garage to track fill-ups, spending and consumption.',
            primaryLabel: 'Open garage',
            onPrimary: () => context.go(AppRoutes.garage),
          ),
        (_, AsyncData(value: final list)) when list.isEmpty => AppMessageView(
            icon: Icons.receipt_long_outlined,
            title: v!.isElectric ? 'No charging sessions yet' : 'No fill-ups yet',
            message: 'Log each ${v.isElectric ? 'charge' : 'fill-up'} to see your spending and real consumption.',
          ),
        (_, AsyncData(value: final list)) => _HistoryBody(vehicle: v!, fillUps: list, now: now ?? DateTime.now()),
        _ => const AppLoading(),
      },
    );
  }
}

class _HistoryBody extends ConsumerWidget {
  const _HistoryBody({required this.vehicle, required this.fillUps, required this.now});

  final VehicleProfile vehicle;
  final List<FillUp> fillUps;
  final DateTime now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = HistoryAnalytics.primaryCurrency(fillUps)!;
    final points = HistoryAnalytics.consumption(fillUps);
    final avg = HistoryAnalytics.averagePer100Km(points);
    final costPoints = points.where((p) => p.currencyCode == currency).toList();
    final costDistance = costPoints.fold<double>(0, (s, p) => s + p.distanceKm);
    final costPerKm =
        costDistance > 0 ? costPoints.fold<double>(0, (s, p) => s + p.costPerKm! * p.distanceKm) / costDistance : null;
    final spend = HistoryAnalytics.spendByMonth(fillUps, currency, now: now);
    final otherCurrency = fillUps.where((f) => f.currencyCode != currency).length;
    final unit = vehicle.unit;

    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 96),
      children: [
        Row(children: [
          Expanded(child: _Stat(label: 'This month', value: Fmt.money(spend.last.$2, currency))),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _Stat(
              label: 'Avg consumption',
              value: avg == null ? '—' : '${avg.toStringAsFixed(1)} $unit/100 km',
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _Stat(
              label: 'Cost per km',
              value: costPerKm == null ? '—' : Fmt.price(costPerKm, currency),
            ),
          ),
        ]),
        const SizedBox(height: AppSpacing.md),
        _ChartCard(
          title: 'Spending · last 6 months ($currency)',
          caption: otherCurrency > 0
              ? '$otherCurrency ${otherCurrency == 1 ? 'entry' : 'entries'} in other currencies not shown (no conversion).'
              : null,
          child: _SpendChart(spend: spend),
        ),
        const SizedBox(height: AppSpacing.md),
        _ChartCard(
          title: 'Consumption trend ($unit/100 km)',
          caption: points.length < 2
              ? 'Log at least three full ${vehicle.isElectric ? 'charges' : 'fill-ups'} with odometer readings to see a trend.'
              : 'Measured full-to-full; compare with your garage value '
                  '${vehicle.consumptionPer100Km.toStringAsFixed(1)} $unit/100 km.',
          child: points.length < 2 ? null : _ConsumptionChart(points: points, reference: vehicle.consumptionPer100Km),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Entries', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.xs),
        for (final f in fillUps) FillUpTile(fillUp: f, unit: unit),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: AppSpacing.xs),
            Text(value, style: theme.textTheme.titleSmall, maxLines: 2),
          ],
        ),
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.title, this.caption, this.child});

  final String title;
  final String? caption;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleSmall),
            if (child != null) ...[
              const SizedBox(height: AppSpacing.md),
              SizedBox(height: 160, child: child),
            ],
            if (caption != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(caption!,
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ],
        ),
      ),
    );
  }
}

class _SpendChart extends StatelessWidget {
  const _SpendChart({required this.spend});

  final List<(DateTime, double)> spend;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final label = Theme.of(context).textTheme.labelSmall;
    return Semantics(
      label: 'Monthly spending: ${spend.map((e) => '${Fmt.monthShort(e.$1.month)} ${Fmt.number(e.$2)}').join(', ')}',
      child: ExcludeSemantics(
        child: BarChart(BarChartData(
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, _, rod, _) => BarTooltipItem(Fmt.number(rod.toY), label ?? const TextStyle()),
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            topTitles: const AxisTitles(),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => SideTitleWidget(
                  meta: meta,
                  child: Text(Fmt.monthShort(spend[value.toInt()].$1.month), style: label),
                ),
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < spend.length; i++)
              BarChartGroupData(x: i, barRods: [
                BarChartRodData(
                  toY: spend[i].$2,
                  width: 18,
                  color: i == spend.length - 1 ? scheme.primary : scheme.primary.withValues(alpha: 0.45),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                ),
              ]),
          ],
        )),
      ),
    );
  }
}

class _ConsumptionChart extends StatelessWidget {
  const _ConsumptionChart({required this.points, required this.reference});

  final List<ConsumptionPoint> points;
  final double reference;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final label = Theme.of(context).textTheme.labelSmall;
    return Semantics(
      label: 'Consumption trend: ${points.map((p) => p.per100Km.toStringAsFixed(1)).join(', ')}',
      child: ExcludeSemantics(
        child: LineChart(LineChartData(
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(drawVerticalLine: false),
          extraLinesData: ExtraLinesData(horizontalLines: [
            HorizontalLine(y: reference, color: scheme.outline, strokeWidth: 1, dashArray: [4, 4]),
          ]),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            bottomTitles: const AxisTitles(),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                getTitlesWidget: (value, meta) =>
                    SideTitleWidget(meta: meta, child: Text(Fmt.number(value, maxDecimals: 1), style: label)),
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [for (var i = 0; i < points.length; i++) FlSpot(i.toDouble(), points[i].per100Km)],
              isCurved: true,
              preventCurveOverShooting: true,
              color: scheme.primary,
              barWidth: 3,
              belowBarData: BarAreaData(show: true, color: scheme.primary.withValues(alpha: 0.12)),
            ),
          ],
        )),
      ),
    );
  }
}

class FillUpTile extends ConsumerWidget {
  const FillUpTile({super.key, required this.fillUp, required this.unit});

  final FillUp fillUp;
  final String unit;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(historyControllerProvider);
    final result = await controller.delete(fillUp.id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(result.isOk ? 'Entry deleted' : 'Could not delete entry'),
      action: result.isOk ? SnackBarAction(label: 'Undo', onPressed: () => controller.save(fillUp)) : null,
    ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final f = fillUp;
    final details = [
      Fmt.date(f.date),
      '${Fmt.price(f.unitPrice, f.currencyCode)}/$unit',
      if (f.odometerKm != null) '${Fmt.number(f.odometerKm!, maxDecimals: 0)} km',
      if (!f.isFull) 'partial',
      if (f.stationName != null) f.stationName!,
    ].join(' · ');
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(child: Icon(unit == 'kWh' ? Icons.bolt_rounded : Icons.local_gas_station_rounded)),
      title: Text('${Fmt.number(f.amount)} $unit · ${Fmt.money(f.totalCost, f.currencyCode)}'),
      subtitle: Text(details),
      trailing: IconButton(
        tooltip: 'Delete entry',
        icon: const Icon(Icons.delete_outline_rounded),
        onPressed: () => _delete(context, ref),
      ),
    );
  }
}
