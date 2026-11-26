import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/l10n.dart';
import '../domain/vehicle_catalog.dart';

/// Searchable list of common vehicles; returns the picked one (or null).
Future<CatalogVehicle?> showVehicleCatalogSheet(BuildContext context) => showModalBottomSheet<CatalogVehicle>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => const FractionallySizedBox(heightFactor: 0.85, child: VehicleCatalogSheet()),
);

class VehicleCatalogSheet extends StatefulWidget {
  const VehicleCatalogSheet({super.key});

  @override
  State<VehicleCatalogSheet> createState() => _VehicleCatalogSheetState();
}

class _VehicleCatalogSheetState extends State<VehicleCatalogSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final matches = searchCatalog(_query);
    String kindLabel(CatalogKind k) => switch (k) {
      CatalogKind.car => l.catalogCars,
      CatalogKind.motorbike => l.catalogMotorbikes,
      CatalogKind.electric => l.catalogElectric,
    };
    IconData icon(CatalogKind k) => switch (k) {
      CatalogKind.car => Icons.directions_car_rounded,
      CatalogKind.motorbike => Icons.two_wheeler_rounded,
      CatalogKind.electric => Icons.electric_car_rounded,
    };
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.sm),
          child: TextField(
            key: const Key('catalogSearch'),
            autofocus: false,
            decoration: InputDecoration(prefixIcon: const Icon(Icons.search_rounded), hintText: l.searchVehicleModel),
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        Expanded(
          child: matches.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Text(l.catalogNoMatch, textAlign: TextAlign.center),
                )
              : ListView(
                  children: [
                    for (final kind in CatalogKind.values)
                      if (matches.any((v) => v.kind == kind)) ...[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, 0),
                          child: Text(kindLabel(kind), style: Theme.of(context).textTheme.titleSmall),
                        ),
                        for (final v in matches.where((v) => v.kind == kind))
                          ListTile(
                            leading: Icon(icon(kind)),
                            title: Text(v.name),
                            subtitle: Text(
                              '${_num(v.capacity)} ${v.kind == CatalogKind.electric ? 'kWh' : 'L'} · '
                              '${_num(v.consumptionPer100Km)} ${v.kind == CatalogKind.electric ? 'kWh' : 'L'}/100 km',
                            ),
                            onTap: () => Navigator.of(context).pop(v),
                          ),
                      ],
                  ],
                ),
        ),
      ],
    );
  }

  static String _num(double v) => v == v.roundToDouble() ? v.toStringAsFixed(0) : '$v';
}
