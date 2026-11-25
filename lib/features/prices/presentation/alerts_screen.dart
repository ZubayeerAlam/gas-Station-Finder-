import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_failure.dart';
import '../../../l10n/domain_labels.dart';
import '../../../l10n/failure_text.dart';
import '../../../l10n/l10n.dart';
import '../../../core/error/result.dart';
import '../../../core/location/location_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/state_views.dart';
import '../../garage/presentation/garage_providers.dart';
import '../domain/community_models.dart';
import 'community_providers.dart';
import 'report_price_screen.dart' show defaultReportFuel;

/// Price alert rules: "tell me when Diesel ≤ 1.65 EUR within 10 km".
/// Matching runs server-side on every accepted community price.
class AlertsScreen extends ConsumerWidget {
  const AlertsScreen({super.key});

  Future<void> _show(BuildContext context, Future<Result<void>> action, String okText) async {
    final result = await action;
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(switch (result) {
          Ok() => okText,
          Err(:final failure) => describeFailure(failure, context.l10n),
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(communityRepositoryProvider);
    final rules = ref.watch(alertRulesProvider);
    final theme = Theme.of(context);
    final l = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l.priceAlerts)),
      floatingActionButton: repo.isAvailable
          ? FloatingActionButton.extended(
              onPressed: () => showAlertRuleSheet(context),
              icon: const Icon(Icons.add_alert_rounded),
              label: Text(l.newAlert),
            )
          : null,
      body: !repo.isAvailable
          ? AppMessageView(
              icon: Icons.notifications_off_outlined,
              title: l.alertsUnavailableTitle,
              message: l.alertsUnavailableMessage,
            )
          : switch (rules) {
              AsyncData(:final value) when value.isEmpty => AppMessageView(
                icon: Icons.notifications_none_rounded,
                title: l.noAlertsTitle,
                message: l.noAlertsMessage,
              ),
              AsyncData(:final value) => ListView(
                padding: const EdgeInsets.only(bottom: 96),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Text(
                      l.alertsServerNote,
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ),
                  for (final r in value)
                    ListTile(
                      title: Text('${localizedFuelType(r.fuelType, l)} ≤ ${Fmt.price(r.maxPrice, r.currencyCode)}'),
                      subtitle: Text(
                        r.stationName != null ? l.alertOnlyAt(r.stationName!) : l.alertWithinKm(Fmt.number(r.radiusKm)),
                      ),
                      leading: Switch(
                        value: r.enabled,
                        onChanged: (on) => _show(
                          context,
                          ref.read(communityRepositoryProvider).saveAlertRule(r.copyWith(enabled: on)),
                          on ? l.alertOn : l.alertPaused,
                        ),
                      ),
                      trailing: IconButton(
                        tooltip: l.deleteAlert,
                        icon: const Icon(Icons.delete_outline_rounded),
                        onPressed: () =>
                            _show(context, ref.read(communityRepositoryProvider).deleteAlertRule(r.id), l.alertDeleted),
                      ),
                    ),
                ],
              ),
              AsyncError(:final error) => AppErrorView(
                message: describeFailure(error, l, fallback: l.couldNotLoadAlerts),
                onRetry: () => ref.invalidate(alertRulesProvider),
              ),
              _ => const AppLoading(),
            },
    );
  }
}

Future<void> showAlertRuleSheet(BuildContext context) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  // The sheet's own context: it rebuilds when the keyboard opens.
  builder: (sheetContext) => Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(sheetContext).bottom),
    child: const AlertRuleForm(),
  ),
);

class AlertRuleForm extends ConsumerStatefulWidget {
  const AlertRuleForm({super.key});

  @override
  ConsumerState<AlertRuleForm> createState() => _AlertRuleFormState();
}

class _AlertRuleFormState extends ConsumerState<AlertRuleForm> {
  final _form = GlobalKey<FormState>();
  final _max = TextEditingController();
  final _currency = TextEditingController();
  String? _pickedFuel;
  String get _fuel => _pickedFuel ?? defaultReportFuel(ref.read(activeVehicleProvider).value);
  double _radius = 10;
  bool _saving = false;

  @override
  void dispose() {
    _max.dispose();
    _currency.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final l = context.l10n;
    try {
      final here = await ref.read(locationControllerProvider.future);
      final repo = ref.read(communityRepositoryProvider);
      final result = await repo.saveAlertRule(
        PriceAlertRule(
          id: repo.newId(),
          fuelType: _fuel,
          currencyCode: _currency.text.trim().toUpperCase(),
          maxPrice: double.parse(_max.text.trim().replaceAll(',', '.')),
          center: here,
          radiusKm: _radius,
        ),
      );
      if (result case Err(:final failure)) {
        messenger.showSnackBar(SnackBar(content: Text(describeFailure(failure, l))));
      } else {
        navigator.pop();
        messenger.showSnackBar(SnackBar(content: Text(l.alertSaved)));
      }
    } on AppFailure catch (f) {
      messenger.showSnackBar(SnackBar(content: Text(describeFailure(f, l))));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    ref.watch(activeVehicleProvider);
    final l = context.l10n;
    return Form(
      key: _form,
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(l.newPriceAlert, style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<String>(
            isExpanded: true, // long labels at large text sizes ellipsize instead of overflowing
            key: ValueKey('fuel-$_fuel'),
            initialValue: _fuel,
            decoration: InputDecoration(labelText: l.fuel),
            items: [
              for (final f in kCommunityFuelTypes)
                DropdownMenuItem(
                  value: f,
                  child: Text(localizedFuelType(f, l), overflow: TextOverflow.ellipsis),
                ),
            ],
            onChanged: (f) => setState(() => _pickedFuel = f),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  key: const Key('maxPrice'),
                  controller: _max,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
                  decoration: InputDecoration(labelText: l.alertAtOrBelow),
                  validator: (t) => validateReportPriceL10n(t, l),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: TextFormField(
                  key: const Key('alertCurrency'),
                  controller: _currency,
                  maxLength: 3,
                  textCapitalization: TextCapitalization.characters,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[A-Za-z]')),
                    TextInputFormatter.withFunction((_, n) => n.copyWith(text: n.text.toUpperCase())),
                  ],
                  decoration: InputDecoration(labelText: l.currency, hintText: 'EUR', counterText: ''),
                  validator: (t) => RegExp(r'^[A-Z]{3}$').hasMatch((t ?? '').trim()) ? null : l.currencyCodeError,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(l.alertRadius(_radius.round()), style: theme.textTheme.bodyMedium),
          Slider(
            value: _radius,
            min: 1,
            max: 50,
            divisions: 49,
            label: '${_radius.round()} km',
            onChanged: (v) => setState(() => _radius = v.roundToDouble()),
          ),
          const SizedBox(height: AppSpacing.sm),
          FilledButton(onPressed: _saving ? null : _save, child: Text(_saving ? l.saving : l.saveAlert)),
        ],
      ),
    );
  }
}
