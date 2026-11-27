import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/result.dart';
import '../../../core/theme/app_theme.dart';
import '../../garage/domain/vehicle_profile.dart';
import '../../garage/presentation/garage_providers.dart';
import '../../stations/domain/entities/station.dart';
import '../../stations/presentation/stations_controllers.dart';
import '../domain/community_models.dart';
import '../../../l10n/domain_labels.dart';
import '../../../l10n/failure_text.dart';
import '../../../l10n/l10n.dart';
import 'community_providers.dart';

final _currencyPattern = RegExp(r'^[A-Z]{3}$');

/// Default fuel to report: the active vehicle's (EV → per-kWh price).
/// Open Charge Map chargers use `ocm:<id>` as their community id.
bool isChargerId(String id) => id.startsWith('ocm:');

String defaultReportFuel(VehicleProfile? v) {
  if (v == null) return 'REGULAR_UNLEADED';
  if (v.isElectric) return 'EV_KWH';
  final f = v.preferredFuelType;
  return f != null && kCommunityFuelTypes.contains(f) ? f : 'REGULAR_UNLEADED';
}

/// Default currency: what the station's real prices already use (Google or
/// community). Never guessed from the device locale.
String defaultReportCurrency(StationDetails? details, List<CommunityPrice>? community) =>
    details?.fuelPrices.firstOrNull?.currencyCode ?? community?.firstOrNull?.currencyCode ?? '';

class ReportPriceScreen extends ConsumerStatefulWidget {
  const ReportPriceScreen({super.key, required this.station});

  final Station station;

  @override
  ConsumerState<ReportPriceScreen> createState() => _ReportPriceScreenState();
}

class _ReportPriceScreenState extends ConsumerState<ReportPriceScreen> {
  final _form = GlobalKey<FormState>();
  final _price = TextEditingController();
  late final TextEditingController _currency;

  /// Null until the user picks one; until then it follows the active vehicle
  /// (which may still be loading when the screen opens).
  String? _pickedFuel;
  String get _fuel => _isCharger ? 'EV_KWH' : _pickedFuel ?? defaultReportFuel(ref.read(activeVehicleProvider).value);

  /// An Open Charge Map charger (`ocm:<id>`): only a price per kWh makes sense,
  /// and there is no Google place to look up.
  bool get _isCharger => isChargerId(widget.station.id);
  bool _sending = false;
  String? _reportId;

  @override
  void initState() {
    super.initState();
    final id = widget.station.id;
    _currency = TextEditingController();
    // Prices may still be loading: fill the currency once they arrive, unless
    // the user has typed one already.
    void fill(_, _) {
      if (_currency.text.isNotEmpty) return;
      final c = defaultReportCurrency(
        _isCharger ? null : ref.read(stationDetailsProvider(id)).value,
        ref.read(communityPricesProvider(id)).value,
      );
      if (c.isNotEmpty) _currency.text = c;
    }

    if (!_isCharger) ref.listenManual(stationDetailsProvider(id), fill, fireImmediately: true);
    ref.listenManual(communityPricesProvider(id), fill, fireImmediately: true);
  }

  @override
  void dispose() {
    _price.dispose();
    _currency.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _sending = true);
    final s = widget.station;
    final result = await ref
        .read(communityRepositoryProvider)
        .submitReport(
          PriceReportDraft(
            stationId: s.id,
            stationName: s.name,
            stationLocation: s.location,
            fuelType: _fuel,
            price: double.parse(_price.text.trim().replaceAll(',', '.')),
            currencyCode: _currency.text.trim().toUpperCase(),
          ),
        );
    if (!mounted) return;
    setState(() {
      _sending = false;
      if (result case Ok(:final value)) _reportId = value;
    });
    if (result case Err(:final failure)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(describeFailure(failure, context.l10n))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    ref.watch(activeVehicleProvider);
    final unit = _fuel == 'EV_KWH' ? 'kWh' : 'L';
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.reportAPrice)),
      body: _reportId != null
          ? _Submitted(reportId: _reportId!, onDone: () => context.pop())
          : Form(
              key: _form,
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(_isCharger ? Icons.ev_station_rounded : Icons.local_gas_station_rounded),
                    title: Text(widget.station.name),
                    subtitle: widget.station.address == null ? null : Text(widget.station.address!),
                  ),
                  if (!_isCharger)
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
                          key: const Key('price'),
                          controller: _price,
                          autofocus: true,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
                          decoration: InputDecoration(labelText: l.pricePerUnit(unit)),
                          validator: (t) => validateReportPriceL10n(t, l),
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
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l.reportPriceHelp,
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: _reportId != null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.md),
                child: FilledButton(
                  onPressed: _sending ? null : _submit,
                  child: Text(_sending ? l.sending : l.sendReport),
                ),
              ),
            ),
    );
  }
}

/// Follows the server's verdict on the report (accepted / outlier / …).
class _Submitted extends ConsumerWidget {
  const _Submitted({required this.reportId, required this.onDone});

  final String reportId;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(reportStatusProvider(reportId)).value;
    final processed = status?.status != null;
    final ok = status?.status == 'accepted';
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!processed)
              const CircularProgressIndicator()
            else
              Icon(
                ok ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                size: 56,
                color: ok ? theme.colorScheme.primary : theme.colorScheme.tertiary,
              ),
            const SizedBox(height: AppSpacing.md),
            Text(
              localizedReportStatus(status?.status, status?.reason, context.l10n),
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(onPressed: onDone, child: Text(context.l10n.done)),
          ],
        ),
      ),
    );
  }
}
