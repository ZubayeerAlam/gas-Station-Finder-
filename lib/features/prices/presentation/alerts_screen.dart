import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_failure.dart';
import '../../../core/error/result.dart';
import '../../../core/location/location_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/state_views.dart';
import '../../garage/presentation/garage_providers.dart';
import '../../stations/domain/entities/station.dart';
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(switch (result) {
        Ok() => okText,
        Err(:final failure) => failure.message,
      }),
    ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(communityRepositoryProvider);
    final rules = ref.watch(alertRulesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Price alerts')),
      floatingActionButton: repo.isAvailable
          ? FloatingActionButton.extended(
              onPressed: () => showAlertRuleSheet(context),
              icon: const Icon(Icons.add_alert_rounded),
              label: const Text('New alert'),
            )
          : null,
      body: !repo.isAvailable
          ? const AppMessageView(
              icon: Icons.notifications_off_outlined,
              title: 'Alerts are not available',
              message: 'Price alerts need the FuelWise community backend, which is not set up in this build.',
            )
          : switch (rules) {
              AsyncData(:final value) when value.isEmpty => const AppMessageView(
                  icon: Icons.notifications_none_rounded,
                  title: 'No price alerts yet',
                  message: 'Create an alert to hear when a community price near you drops below your limit.',
                ),
              AsyncData(:final value) => ListView(
                  padding: const EdgeInsets.only(bottom: 96),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Text(
                        'Alerts are checked by the server when a new community price is accepted. '
                        'Push notifications are not enabled in this build yet.',
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ),
                    for (final r in value)
                      ListTile(
                        title: Text('${fuelTypeLabel(r.fuelType)} ≤ ${Fmt.price(r.maxPrice, r.currencyCode)}'),
                        subtitle: Text(r.stationName != null
                            ? 'Only at ${r.stationName}'
                            : 'Within ${Fmt.number(r.radiusKm)} km of the saved location'),
                        leading: Switch(
                          value: r.enabled,
                          onChanged: (on) => _show(
                            context,
                            ref.read(communityRepositoryProvider).saveAlertRule(r.copyWith(enabled: on)),
                            on ? 'Alert on' : 'Alert paused',
                          ),
                        ),
                        trailing: IconButton(
                          tooltip: 'Delete alert',
                          icon: const Icon(Icons.delete_outline_rounded),
                          onPressed: () =>
                              _show(context, ref.read(communityRepositoryProvider).deleteAlertRule(r.id), 'Alert deleted'),
                        ),
                      ),
                  ],
                ),
              AsyncError(:final error) => AppErrorView(
                  message: error is AppFailure ? error.message : 'Could not load alerts.',
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
    try {
      final here = await ref.read(locationControllerProvider.future);
      final repo = ref.read(communityRepositoryProvider);
      final result = await repo.saveAlertRule(PriceAlertRule(
        id: repo.newId(),
        fuelType: _fuel,
        currencyCode: _currency.text.trim().toUpperCase(),
        maxPrice: double.parse(_max.text.trim().replaceAll(',', '.')),
        center: here,
        radiusKm: _radius,
      ));
      if (result case Err(:final failure)) {
        messenger.showSnackBar(SnackBar(content: Text(failure.message)));
      } else {
        navigator.pop();
        messenger.showSnackBar(const SnackBar(content: Text('Alert saved')));
      }
    } on AppFailure catch (f) {
      messenger.showSnackBar(SnackBar(content: Text(f.message)));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    ref.watch(activeVehicleProvider);
    return Form(
      key: _form,
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text('New price alert', style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<String>(
            key: ValueKey('fuel-$_fuel'),
            initialValue: _fuel,
            decoration: const InputDecoration(labelText: 'Fuel'),
            items: [for (final f in kCommunityFuelTypes) DropdownMenuItem(value: f, child: Text(fuelTypeLabel(f)))],
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
                  decoration: const InputDecoration(labelText: 'Alert at or below'),
                  validator: validateReportPrice,
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
                  decoration: const InputDecoration(labelText: 'Currency', hintText: 'EUR', counterText: ''),
                  validator: (t) => RegExp(r'^[A-Z]{3}$').hasMatch((t ?? '').trim()) ? null : '3-letter code',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text('Within ${_radius.round()} km of my current location', style: theme.textTheme.bodyMedium),
          Slider(
            value: _radius,
            min: 1,
            max: 50,
            divisions: 49,
            label: '${_radius.round()} km',
            onChanged: (v) => setState(() => _radius = v.roundToDouble()),
          ),
          const SizedBox(height: AppSpacing.sm),
          FilledButton(onPressed: _saving ? null : _save, child: Text(_saving ? 'Saving…' : 'Save alert')),
        ],
      ),
    );
  }
}
