import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/result.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../l10n/failure_text.dart';
import '../../../l10n/l10n.dart';
import '../../garage/domain/vehicle_profile.dart';
import '../data/share_history_exporter.dart';
import '../domain/fill_up.dart';
import '../domain/history_report.dart';

Future<void> showHistoryReportSheet(
  BuildContext context, {
  required VehicleProfile vehicle,
  required List<FillUp> fillUps,
  required DateTime now,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  showDragHandle: true,
  builder: (_) => DraggableScrollableSheet(
    expand: false,
    initialChildSize: 0.7,
    minChildSize: 0.4,
    maxChildSize: 0.95,
    builder: (context, controller) =>
        HistoryReportSheet(vehicle: vehicle, fillUps: fillUps, now: now, scrollController: controller),
  ),
);

String reportPeriodLabel(ReportPeriod p, AppLocalizations l) => switch (p) {
  ReportPeriod.last7Days => l.reportLast7Days,
  ReportPeriod.last30Days => l.reportLast30Days,
  ReportPeriod.thisMonth => l.reportThisMonth,
  ReportPeriod.lastMonth => l.reportLastMonth,
  ReportPeriod.thisYear => l.reportThisYear,
};

/// Totals and per-day spending for a chosen period, exportable as CSV.
class HistoryReportSheet extends ConsumerStatefulWidget {
  const HistoryReportSheet({
    super.key,
    required this.vehicle,
    required this.fillUps,
    required this.now,
    this.scrollController,
  });

  final VehicleProfile vehicle;
  final List<FillUp> fillUps;
  final DateTime now;
  final ScrollController? scrollController;

  @override
  ConsumerState<HistoryReportSheet> createState() => _HistoryReportSheetState();
}

class _HistoryReportSheetState extends ConsumerState<HistoryReportSheet> {
  ReportPeriod _period = ReportPeriod.thisMonth;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    final r = HistoryReport.range(_period, widget.now);
    final report = HistoryReport.build(widget.fillUps, start: r.start, end: r.end);
    final unit = widget.vehicle.unit;

    return ListView(
      controller: widget.scrollController,
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.xl),
      children: [
        Text(l.reportTitle, style: theme.textTheme.titleLarge),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          children: [
            for (final p in ReportPeriod.values)
              ChoiceChip(
                key: ValueKey('reportPeriod-${p.name}'),
                label: Text(reportPeriodLabel(p, l)),
                selected: p == _period,
                onSelected: (_) => setState(() => _period = p),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(l.reportRange(Fmt.date(report.start), Fmt.date(report.lastDay)), style: muted),
        const SizedBox(height: AppSpacing.md),
        if (report.isEmpty)
          Text(l.reportEmpty, key: const Key('reportEmpty'))
        else ...[
          for (final t in report.totals)
            Card(
              key: ValueKey('reportTotal-${t.currencyCode}'),
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Fmt.money(t.totalCost, t.currencyCode), style: theme.textTheme.headlineSmall),
                    Text(
                      l.reportTotalLine(
                        '${Fmt.number(t.totalAmount, maxDecimals: 1)} $unit',
                        t.count,
                        '${Fmt.price(t.averageUnitPrice, t.currencyCode)}/$unit',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (report.odometerDistanceKm case final km?)
            Text(l.reportDistance(Fmt.distance(km * 1000)), key: const Key('reportDistance'), style: muted),
          const SizedBox(height: AppSpacing.md),
          Text(l.reportDailyTitle, style: theme.textTheme.titleSmall),
          for (final d in report.days)
            ListTile(
              key: ValueKey('reportDay-${Fmt.date(d.day)}-${d.currencyCode}'),
              contentPadding: EdgeInsets.zero,
              title: Text(Fmt.date(d.day)),
              subtitle: Text(
                l.reportDayLine(
                  '${Fmt.money(d.totalCost, d.currencyCode)} · ${Fmt.number(d.totalAmount, maxDecimals: 1)} $unit',
                  d.count,
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.md),
          FilledButton.tonalIcon(
            key: const Key('reportExport'),
            icon: const Icon(Icons.ios_share_rounded),
            label: Text(l.reportExport),
            onPressed: () => _export(context, report),
          ),
        ],
      ],
    );
  }

  Future<void> _export(BuildContext context, PeriodReport report) async {
    final l = context.l10n;
    final box = context.findRenderObject() as RenderBox?;
    final origin = box == null ? null : box.localToGlobal(Offset.zero) & box.size;
    final messenger = ScaffoldMessenger.of(context);
    final result = await ref
        .read(historyExporterProvider)
        .export(
          fileName: HistoryReport.fileName(widget.vehicle, report),
          csv: HistoryReport.csv(widget.vehicle, report),
          subject: l.reportExportSubject(widget.vehicle.name),
          origin: origin,
        );
    if (result case Err(:final failure)) {
      messenger.showSnackBar(SnackBar(content: Text(describeFailure(failure, l))));
    }
  }
}
