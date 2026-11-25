import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/state_views.dart';
import '../../garage/domain/vehicle_profile.dart';
import '../../garage/presentation/garage_providers.dart';
import '../../garage/presentation/vehicle_form_screen.dart' show parsePositive;
import '../domain/fill_up.dart';
import '../../../l10n/l10n.dart';
import 'history_providers.dart';

final _currencyPattern = RegExp(r'^[A-Z]{3}$');

/// Highest odometer reading recorded on or before [date] (for validation).
double? previousOdometer(List<FillUp> history, DateTime date) {
  double? best;
  for (final f in history) {
    final odo = f.odometerKm;
    if (odo != null && !f.date.isAfter(date) && (best == null || odo > best)) best = odo;
  }
  return best;
}

/// Adds a fill-up / charging session for the active vehicle.
class FillUpFormScreen extends ConsumerWidget {
  const FillUpFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicle = ref.watch(activeVehicleProvider);
    final l = context.l10n;
    return switch (vehicle) {
      AsyncData(value: final v?) => _FillUpForm(vehicle: v, history: ref.watch(fillUpsProvider(v.id)).value ?? []),
      AsyncData() => Scaffold(
          appBar: AppBar(),
          body: AppMessageView(
            icon: Icons.directions_car_filled_outlined,
            title: l.noActiveVehicle,
            message: l.addVehicleFirst,
            primaryLabel: l.openGarage,
            onPrimary: () => context.go(AppRoutes.garage),
          ),
        ),
      AsyncError() => Scaffold(body: AppErrorView(message: l.couldNotLoadGarage)),
      _ => const Scaffold(body: AppLoading()),
    };
  }
}

class _FillUpForm extends ConsumerStatefulWidget {
  const _FillUpForm({required this.vehicle, required this.history});

  final VehicleProfile vehicle;
  final List<FillUp> history;

  @override
  ConsumerState<_FillUpForm> createState() => _FillUpFormState();
}

class _FillUpFormState extends ConsumerState<_FillUpForm> {
  final _form = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _cost = TextEditingController();
  final _odometer = TextEditingController();
  final _station = TextEditingController();
  late final TextEditingController _currency;
  DateTime _date = DateTime.now();
  bool _full = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    // Reuse the last currency; never guessed from locale.
    _currency = TextEditingController(text: widget.history.isEmpty ? '' : widget.history.first.currencyCode);
    for (final c in [_amount, _cost, _currency]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (final c in [_amount, _cost, _odometer, _station, _currency]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(now.year - 10),
      lastDate: now,
    );
    if (picked != null) {
      setState(() => _date = DateTime(picked.year, picked.month, picked.day, _date.hour, _date.minute));
    }
  }

  String? _validateOdometer(String? text) {
    if ((text ?? '').trim().isEmpty) return null; // optional
    final v = parsePositive(text);
    if (v == null) return context.l10n.enterPositiveNumber;
    final prev = previousOdometer(widget.history, _date);
    if (prev != null && v <= prev) return context.l10n.odometerMustIncrease(Fmt.number(prev));
    return null;
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    final controller = ref.read(historyControllerProvider);
    final station = _station.text.trim();
    final result = await controller.save(FillUp(
      id: controller.newId(),
      vehicleId: widget.vehicle.id,
      date: _date,
      amount: parsePositive(_amount.text)!,
      totalCost: parsePositive(_cost.text)!,
      currencyCode: _currency.text.trim().toUpperCase(),
      odometerKm: parsePositive(_odometer.text),
      isFull: _full,
      stationName: station.isEmpty ? null : station,
    ));
    if (!mounted) return;
    setState(() => _saving = false);
    if (result.isOk) {
      context.canPop() ? context.pop() : context.go(AppRoutes.history);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.couldNotSaveFillUp)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final v = widget.vehicle;
    final ev = v.isElectric;
    final decimal = [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))];
    final amount = parsePositive(_amount.text), cost = parsePositive(_cost.text);
    final theme = Theme.of(context);
    final l = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(ev ? l.addChargingSession : l.addFillUp)),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(ev ? Icons.electric_car_rounded : Icons.directions_car_rounded),
              title: Text(v.name),
              subtitle: Text(l.activeVehicle),
            ),
            OutlinedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.event_rounded),
              label: Text(Fmt.date(_date)),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              key: const Key('amount'),
              controller: _amount,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: decimal,
              decoration: InputDecoration(labelText: ev ? l.energyCharged : l.fuelAdded, suffixText: v.unit),
              validator: (t) => parsePositive(t) == null ? l.enterPositiveNumber : null,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    key: const Key('cost'),
                    controller: _cost,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: decimal,
                    decoration: InputDecoration(labelText: l.totalPaid),
                    validator: (t) => parsePositive(t) == null ? l.enterPositiveNumber : null,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: TextFormField(
                    key: const Key('currency'),
                    controller: _currency,
                    maxLength: 3,
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[A-Za-z]')),
                      TextInputFormatter.withFunction((_, n) => n.copyWith(text: n.text.toUpperCase())),
                    ],
                    decoration: InputDecoration(labelText: l.currency, hintText: 'EUR', counterText: ''),
                    validator: (t) => _currencyPattern.hasMatch((t ?? '').trim()) ? null : l.currencyCodeError,
                  ),
                ),
              ],
            ),
            if (amount != null && cost != null)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Text(
                  l.unitPriceLine(Fmt.price(cost / amount, _currency.text).trim(), v.unit),
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              key: const Key('odometer'),
              controller: _odometer,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: decimal,
              decoration: InputDecoration(
                labelText: l.odometerOptional,
                suffixText: 'km',
                helperText: l.odometerHelper,
              ),
              validator: _validateOdometer,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _full,
              onChanged: (x) => setState(() => _full = x),
              title: Text(ev ? l.chargedToTarget : l.filledTank),
              subtitle: Text(l.partialFillHelp),
            ),
            TextFormField(
              controller: _station,
              maxLength: 80,
              decoration: InputDecoration(labelText: l.stationOptional),
            ),
          ],
        ),
      ),
      // Pinned so it stays reachable on small screens / with the keyboard open.
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.md),
          child: FilledButton(
            onPressed: _saving ? null : _save,
            child: Text(_saving ? l.saving : l.save),
          ),
        ),
      ),
    );
  }
}
