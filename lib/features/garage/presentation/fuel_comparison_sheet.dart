import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../l10n/domain_labels.dart';
import '../../../l10n/l10n.dart';
import '../../history/domain/history_analytics.dart';
import '../../history/presentation/history_providers.dart';
import '../domain/fuel_comparison.dart';
import '../domain/vehicle_profile.dart';
import 'vehicle_form_screen.dart' show parsePositive;

/// Opens the petrol-vs-CNG (any two fuels) cost comparison for a dual-fuel vehicle.
Future<void> showFuelComparisonSheet(BuildContext context, VehicleProfile vehicle) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => FuelComparisonSheet(vehicle: vehicle),
);

class FuelComparisonSheet extends ConsumerStatefulWidget {
  const FuelComparisonSheet({super.key, required this.vehicle});

  final VehicleProfile vehicle;

  @override
  ConsumerState<FuelComparisonSheet> createState() => _FuelComparisonSheetState();
}

class _FuelComparisonSheetState extends ConsumerState<FuelComparisonSheet> {
  final _primary = TextEditingController();
  final _secondary = TextEditingController();
  late final TextEditingController _currency;
  bool _currencyFromHistory = false;

  @override
  void initState() {
    super.initState();
    _currency = TextEditingController(text: 'BDT');
  }

  @override
  void dispose() {
    for (final c in [_primary, _secondary, _currency]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final v = widget.vehicle;
    final fillUps = ref.watch(fillUpsProvider(v.id)).value ?? const [];
    // Prefer the currency the user actually pays in (latest fill-up), once.
    if (!_currencyFromHistory && fillUps.isNotEmpty) {
      _currencyFromHistory = true;
      final latest = [...fillUps]..sort((a, b) => b.date.compareTo(a.date));
      _currency.text = latest.first.currencyCode;
    }
    final kmPerDay = HistoryAnalytics.odometerStats(fillUps).kmPerDay;
    final cmp = compareFuels(
      v,
      primaryPrice: parsePositive(_primary.text),
      secondaryPrice: parsePositive(_secondary.text),
    );
    if (cmp == null) return const SizedBox.shrink();
    final currency = _currency.text.trim().toUpperCase();
    String money(double x) => currency.isEmpty ? Fmt.number(x) : Fmt.money(x, currency);
    final decimal = [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))];
    final first = localizedFuelType(cmp.primary.fuelType, l);
    final second = localizedFuelType(cmp.secondary.fuelType, l);

    Widget priceField(Key key, TextEditingController c, FuelCostLine line, String name) => TextField(
      key: key,
      controller: c,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: decimal,
      decoration: InputDecoration(labelText: l.pricePerUnitLabel(name, line.unit)),
      onChanged: (_) => setState(() {}),
    );

    Widget lineTile(FuelCostLine line, String name) {
      final cheapest = identical(cmp.cheaper, line);
      // No trailing widget: at large text sizes the cost wraps under the name
      // instead of squeezing the title.
      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(
          cheapest ? Icons.check_circle_rounded : Icons.local_gas_station_rounded,
          color: cheapest ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
        ),
        title: Text(name, style: cheapest ? const TextStyle(fontWeight: FontWeight.w700) : null),
        subtitle: Text(
          [
            l.kmPerUnitValue(Fmt.number(line.kmPerUnit, maxDecimals: 1), line.unit),
            if (line.costPer100Km != null) l.costPer100Km(money(line.costPer100Km!)),
          ].join('\n'),
        ),
        isThreeLine: line.costPer100Km != null,
      );
    }

    final String summary;
    if (!cmp.isComplete) {
      summary = l.enterBothPrices;
    } else if (cmp.cheaper == null) {
      summary = l.fuelsCostSame;
    } else {
      final winner = identical(cmp.cheaper, cmp.primary) ? first : second;
      summary = l.fuelCheaperBy(winner, money(cmp.savingPer100Km!), (cmp.savingShare! * 100).toStringAsFixed(0));
    }

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l.compareFuelsTitle(first, second), style: theme.textTheme.titleLarge),
              const SizedBox(height: AppSpacing.xs),
              Text(l.compareFuelsIntro, style: theme.textTheme.bodySmall),
              const SizedBox(height: AppSpacing.md),
              priceField(const Key('primaryPrice'), _primary, cmp.primary, first),
              const SizedBox(height: AppSpacing.sm),
              priceField(const Key('secondaryPrice'), _secondary, cmp.secondary, second),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                key: const Key('compareCurrency'),
                controller: _currency,
                maxLength: 8,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(labelText: l.currencyLabel, counterText: ''),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: AppSpacing.sm),
              lineTile(cmp.primary, first),
              lineTile(cmp.secondary, second),
              const SizedBox(height: AppSpacing.sm),
              Text(summary, key: const Key('fuelCompareSummary'), style: theme.textTheme.bodyLarge),
              if (cmp.isComplete && cmp.cheaper != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  kmPerDay == null
                      ? l.fuelSavingNoHistory
                      : l.fuelSavingMonthly(Fmt.distance(kmPerDay * 30 * 1000), money(cmp.savingFor(kmPerDay * 30)!)),
                  key: const Key('fuelCompareMonthly'),
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
