import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/result.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/failure_text.dart';
import '../../../l10n/l10n.dart';
import '../../along_route/presentation/along_route_providers.dart' show nowProvider;
import '../../garage/domain/vehicle_profile.dart';
import '../../garage/presentation/vehicle_form_screen.dart' show parsePositive;
import '../domain/care_reminder.dart';
import '../domain/care_schedule.dart';
import 'care_labels.dart';
import 'care_providers.dart';

/// Route argument for the add/edit screen.
class CareFormArgs {
  const CareFormArgs({required this.vehicle, this.initial});

  final VehicleProfile vehicle;

  /// Null = create.
  final CareReminder? initial;
}

const kNotifyChoices = [0, 1, 3, 7, 14, 30];

String _num(double? v) => v == null ? '' : v.toStringAsFixed(v == v.roundToDouble() ? 0 : 1);

class CareFormScreen extends ConsumerStatefulWidget {
  const CareFormScreen({super.key, required this.args});

  final CareFormArgs args;

  @override
  ConsumerState<CareFormScreen> createState() => _CareFormScreenState();
}

class _CareFormScreenState extends ConsumerState<CareFormScreen> {
  final _form = GlobalKey<FormState>();
  late CareType _type;
  late final TextEditingController _title, _dueKm, _repeatMonths, _repeatKm, _note;
  DateTime? _dueDate;
  late int _notify;
  bool _saving = false;
  bool _missingDue = false;

  CareReminder? get _initial => widget.args.initial;

  @override
  void initState() {
    super.initState();
    final r = _initial;
    _type = r?.type ?? CareType.taxToken;
    _title = TextEditingController(text: r?.title ?? '');
    _dueKm = TextEditingController(text: _num(r?.dueOdometerKm));
    _repeatMonths = TextEditingController(text: r?.repeatMonths?.toString() ?? '');
    _repeatKm = TextEditingController(text: _num(r?.repeatKm));
    _note = TextEditingController(text: r?.note ?? '');
    _dueDate = r?.dueDate;
    _notify = r?.notifyDaysBefore ?? 7;
    if (r == null) _applyPreset(_type);
  }

  @override
  void dispose() {
    for (final c in [_title, _dueKm, _repeatMonths, _repeatKm, _note]) {
      c.dispose();
    }
    super.dispose();
  }

  /// New reminders take the preset's default repeat interval.
  void _applyPreset(CareType t) {
    final p = kCarePresets[t];
    _repeatMonths.text = p?.repeatMonths?.toString() ?? '';
    _repeatKm.text = _num(p?.repeatKm);
  }

  Future<void> _pickDate() async {
    final now = ref.read(nowProvider)();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 15),
    );
    if (picked == null) return;
    setState(() {
      _dueDate = picked;
      _missingDue = false;
    });
  }

  Future<void> _save() async {
    final dueKm = parsePositive(_dueKm.text);
    setState(() => _missingDue = _dueDate == null && dueKm == null);
    if (!_form.currentState!.validate() || _missingDue) return;
    setState(() => _saving = true);
    final l = context.l10n;
    final controller = ref.read(careControllerProvider);
    final base =
        _initial ??
        CareReminder(
          id: controller.newId(),
          vehicleId: widget.args.vehicle.id,
          type: _type,
          createdAt: ref.read(nowProvider)(),
        );
    final reminder = base.copyWith(
      type: _type,
      title: _title.text.trim().isEmpty ? null : _title.text.trim(),
      dueDate: _dueDate,
      dueOdometerKm: dueKm,
      repeatMonths: int.tryParse(_repeatMonths.text.trim()),
      repeatKm: parsePositive(_repeatKm.text),
      notifyDaysBefore: _notify,
      note: _note.text.trim().isEmpty ? null : _note.text.trim(),
    );
    final result = await controller.save(reminder);
    if (!mounted) return;
    setState(() => _saving = false);
    switch (result) {
      case Ok():
        context.pop();
      case Err(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(describeFailure(failure, l))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final decimal = [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))];
    final latestKm = ref.watch(odometerStatsProvider(widget.args.vehicle.id)).latestKm;
    final muted = theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant);

    return Scaffold(
      appBar: AppBar(title: Text(_initial == null ? l.careAddReminder : l.careEditReminder)),
      body: Form(
        key: _form,
        // A Column (not a lazy ListView) so every field exists and is validated.
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<CareType>(
                isExpanded: true,
                initialValue: _type,
                decoration: InputDecoration(labelText: l.careTypeField),
                items: [
                  for (final t in CareType.values)
                    DropdownMenuItem(
                      value: t,
                      child: Row(
                        children: [
                          Icon(careTypeIcon(t), size: 20),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(child: Text(careTypeLabel(t, l), overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    ),
                ],
                onChanged: (t) => setState(() {
                  if (t == null) return;
                  _type = t;
                  if (_initial == null) _applyPreset(t);
                }),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                key: const Key('careTitle'),
                controller: _title,
                maxLength: 60,
                decoration: InputDecoration(labelText: l.careTitleField, hintText: careTypeLabel(_type, l)),
                validator: (t) => _type == CareType.custom && (t ?? '').trim().isEmpty ? l.careTitleRequired : null,
              ),
              Text(l.careDueDate, style: theme.textTheme.labelLarge),
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: AppSpacing.sm,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  OutlinedButton.icon(
                    key: const Key('careDueDate'),
                    onPressed: _pickDate,
                    icon: const Icon(Icons.event_rounded),
                    label: Text(_dueDate == null ? l.careNoDueDate : careDate(_dueDate!, l)),
                  ),
                  if (_dueDate != null)
                    TextButton(onPressed: () => setState(() => _dueDate = null), child: Text(l.careClearDate)),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                key: const Key('careDueKm'),
                controller: _dueKm,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: decimal,
                onChanged: (_) => _missingDue ? setState(() => _missingDue = false) : null,
                decoration: InputDecoration(
                  labelText: l.careDueKm,
                  suffixText: 'km',
                  helperText: latestKm == null ? null : l.careCurrentOdometer(kmText(latestKm)),
                ),
                validator: (t) => (t ?? '').trim().isEmpty || parsePositive(t) != null ? null : l.enterPositiveNumber,
              ),
              if (_missingDue)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xs),
                  child: Text(
                    l.careNeedDue,
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error),
                  ),
                ),
              const SizedBox(height: AppSpacing.md),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      key: const Key('careRepeatMonths'),
                      controller: _repeatMonths,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(labelText: l.careRepeatMonths),
                      validator: (t) {
                        if ((t ?? '').trim().isEmpty) return null;
                        final v = int.tryParse(t!.trim());
                        return v == null || v < 1 || v > 240 ? l.careWholeNumber : null;
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: TextFormField(
                      key: const Key('careRepeatKm'),
                      controller: _repeatKm,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: decimal,
                      decoration: InputDecoration(labelText: l.careRepeatKm),
                      validator: (t) =>
                          (t ?? '').trim().isEmpty || parsePositive(t) != null ? null : l.enterPositiveNumber,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Text(l.careRepeatHelp, style: muted),
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<int>(
                isExpanded: true,
                initialValue: kNotifyChoices.contains(_notify) ? _notify : 7,
                decoration: InputDecoration(labelText: l.careNotify),
                items: [
                  for (final d in kNotifyChoices)
                    DropdownMenuItem(
                      value: d,
                      child: Text(l.careNotifyDays(d), overflow: TextOverflow.ellipsis),
                    ),
                ],
                onChanged: (d) => setState(() => _notify = d ?? 7),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _note,
                maxLength: 200,
                maxLines: 2,
                decoration: InputDecoration(labelText: l.careNote),
              ),
              Text(l.careDisclaimer, style: muted),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.md),
          child: FilledButton(onPressed: _saving ? null : _save, child: Text(_saving ? l.saving : l.careSaveReminder)),
        ),
      ),
    );
  }
}
