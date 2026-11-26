import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/consumption_unit.dart';
import '../domain/vehicle_catalog.dart';
import '../domain/vehicle_profile.dart';
import '../../../l10n/domain_labels.dart';
import '../../../l10n/l10n.dart';
import 'garage_providers.dart';
import 'vehicle_catalog_sheet.dart';

const kFuelTypeChoices = [
  'REGULAR_UNLEADED', 'MIDGRADE', 'PREMIUM', 'DIESEL', 'LPG', 'METHANE', 'E85', //
];

/// Parses a positive decimal, accepting `,` as decimal separator.
double? parsePositive(String? text) {
  final v = double.tryParse((text ?? '').trim().replaceAll(',', '.'));
  return v != null && v > 0 && v.isFinite ? v : null;
}

String _trim(double v) => v.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), '');

class VehicleFormScreen extends ConsumerStatefulWidget {
  const VehicleFormScreen({super.key, this.initial});

  /// Null = create.
  final VehicleProfile? initial;

  @override
  ConsumerState<VehicleFormScreen> createState() => _VehicleFormScreenState();
}

class _VehicleFormScreenState extends ConsumerState<VehicleFormScreen> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _consumption;
  late final TextEditingController _capacity;
  late final TextEditingController _efficiency;
  late EnergyType _type;
  late ConsumptionUnit _unit;
  String? _fuelType;

  /// The catalog entry the values came from (shows the "typical values" note).
  CatalogVehicle? _picked;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final v = widget.initial;
    _type = v?.energyType ?? EnergyType.fuel;
    _unit = ConsumptionUnit.defaultFor(_type);
    _name = TextEditingController(text: v?.name ?? '');
    _consumption = TextEditingController(text: v == null ? '' : _trim(v.consumptionPer100Km));
    _capacity = TextEditingController(text: v == null ? '' : _trim(v.capacity));
    _efficiency = TextEditingController(text: _trim((v?.chargingEfficiency ?? 1.0) * 100));
    _fuelType = v?.preferredFuelType ?? (_type == EnergyType.fuel ? 'REGULAR_UNLEADED' : null);
  }

  @override
  void dispose() {
    for (final c in [_name, _consumption, _capacity, _efficiency]) {
      c.dispose();
    }
    super.dispose();
  }

  void _setType(EnergyType t) => setState(() {
    _type = t;
    _unit = ConsumptionUnit.defaultFor(t);
    _fuelType = t == EnergyType.fuel ? (_fuelType ?? 'REGULAR_UNLEADED') : null;
  });

  void _setUnit(ConsumptionUnit u) {
    final current = parsePositive(_consumption.text);
    setState(() {
      if (current != null) {
        // Convert the entered value so the meaning stays the same.
        _consumption.text = _trim(u.fromPer100Km(_unit.toPer100Km(current)));
      }
      _unit = u;
    });
  }

  Future<void> _pickFromCatalog() async {
    final v = await showVehicleCatalogSheet(context);
    if (v == null || !mounted) return;
    setState(() {
      _picked = v;
      _type = v.energyType;
      _unit = ConsumptionUnit.defaultFor(v.energyType);
      _name.text = v.name;
      _consumption.text = _trim(_unit.fromPer100Km(v.consumptionPer100Km));
      _capacity.text = _trim(v.capacity);
      _fuelType = v.fuelType;
    });
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    final controller = ref.read(garageControllerProvider);
    final ev = _type == EnergyType.electric;
    final vehicle = VehicleProfile(
      id: widget.initial?.id ?? controller.newId(),
      name: _name.text.trim(),
      energyType: _type,
      consumptionPer100Km: _unit.toPer100Km(parsePositive(_consumption.text)!),
      capacity: parsePositive(_capacity.text)!,
      preferredFuelType: ev ? null : _fuelType,
      chargingEfficiency: ev ? parsePositive(_efficiency.text)! / 100 : 1.0,
    );
    final result = await controller.save(vehicle);
    if (!mounted) return;
    setState(() => _saving = false);
    if (result.isOk) {
      // Opened via deep link there may be nothing to pop.
      context.canPop() ? context.pop() : context.go(AppRoutes.garage);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.couldNotSaveVehicle)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ev = _type == EnergyType.electric;
    final decimal = [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))];
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(widget.initial == null ? l.addVehicle : l.editVehicle)),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            if (widget.initial == null) ...[
              OutlinedButton.icon(
                key: const Key('pickCommonVehicle'),
                onPressed: _pickFromCatalog,
                icon: const Icon(Icons.list_alt_rounded),
                label: Text(l.pickCommonVehicle),
              ),
              if (_picked case final p?)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline_rounded, size: 20, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(child: Text(l.catalogTypicalNote(p.name), key: const Key('catalogNote'))),
                    ],
                  ),
                ),
              const SizedBox(height: AppSpacing.md),
            ],
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              maxLength: 60,
              decoration: InputDecoration(labelText: l.vehicleName, hintText: l.vehicleNameHint),
              validator: (v) => (v ?? '').trim().isEmpty ? l.enterName : null,
            ),
            const SizedBox(height: AppSpacing.sm),
            SegmentedButton<EnergyType>(
              segments: [
                ButtonSegment(
                  value: EnergyType.fuel,
                  icon: const Icon(Icons.local_gas_station_rounded),
                  label: Text(l.energyFuel),
                ),
                ButtonSegment(
                  value: EnergyType.electric,
                  icon: const Icon(Icons.ev_station_rounded),
                  label: Text(l.energyElectric),
                ),
              ],
              selected: {_type},
              onSelectionChanged: (s) => _setType(s.first),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    key: const Key('consumption'),
                    controller: _consumption,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: decimal,
                    decoration: InputDecoration(labelText: l.consumption),
                    validator: (v) => parsePositive(v) == null ? l.enterPositiveNumber : null,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                // Expanded + isExpanded so large text ellipsizes instead of overflowing.
                Expanded(
                  flex: 2,
                  child: DropdownButton<ConsumptionUnit>(
                    value: _unit,
                    isExpanded: true,
                    onChanged: (u) => u == null ? null : _setUnit(u),
                    items: [
                      for (final u in ConsumptionUnit.forType(_type))
                        DropdownMenuItem(
                          value: u,
                          child: Text(u.label, overflow: TextOverflow.ellipsis),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              key: const Key('capacity'),
              controller: _capacity,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: decimal,
              decoration: InputDecoration(
                labelText: ev ? l.usableBatteryCapacity : l.tankCapacityLabel,
                suffixText: ev ? 'kWh' : 'L',
              ),
              validator: (v) => parsePositive(v) == null ? l.enterPositiveNumber : null,
            ),
            const SizedBox(height: AppSpacing.md),
            if (!ev)
              DropdownButtonFormField<String>(
                key: ValueKey(_fuelType), // re-reads initialValue when a catalog pick changes it
                isExpanded: true, // long labels at large text sizes ellipsize instead of overflowing
                initialValue: _fuelType,
                decoration: InputDecoration(labelText: l.fuelTypeLabel),
                items: [
                  for (final f in kFuelTypeChoices)
                    DropdownMenuItem(
                      value: f,
                      child: Text(localizedFuelType(f, l), overflow: TextOverflow.ellipsis),
                    ),
                ],
                onChanged: (f) => setState(() => _fuelType = f),
              )
            else
              TextFormField(
                key: const Key('efficiency'),
                controller: _efficiency,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: decimal,
                decoration: InputDecoration(
                  labelText: l.chargingEfficiency,
                  suffixText: '%',
                  helperText: l.chargingEfficiencyHelper,
                ),
                validator: (v) {
                  final p = parsePositive(v);
                  return p == null || p > 100 ? l.efficiencyRangeError : null;
                },
              ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(onPressed: _saving ? null : _save, child: Text(_saving ? l.saving : l.saveVehicle)),
          ],
        ),
      ),
    );
  }
}
