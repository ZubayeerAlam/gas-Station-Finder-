import '../../../core/utils/units.dart';
import 'vehicle_profile.dart';

/// Units a user may enter consumption in. Stored values are always per 100 km.
enum ConsumptionUnit {
  litresPer100Km('L/100 km', EnergyType.fuel),
  kmPerLitre('km/L', EnergyType.fuel),
  mpgUs('mpg (US)', EnergyType.fuel),
  mpgUk('mpg (UK)', EnergyType.fuel),
  kwhPer100Km('kWh/100 km', EnergyType.electric),
  whPerKm('Wh/km', EnergyType.electric),
  milesPerKwh('mi/kWh', EnergyType.electric);

  const ConsumptionUnit(this.label, this.energyType);

  final String label;
  final EnergyType energyType;

  static List<ConsumptionUnit> forType(EnergyType t) => values.where((u) => u.energyType == t).toList();

  static ConsumptionUnit defaultFor(EnergyType t) =>
      t == EnergyType.fuel ? litresPer100Km : kwhPer100Km;

  /// Entered value → stored per-100-km value.
  double toPer100Km(double v) => switch (this) {
        litresPer100Km || kwhPer100Km => v,
        kmPerLitre => Units.kmPerLitreToLitresPer100Km(v),
        mpgUs => Units.mpgUsToLitresPer100Km(v),
        mpgUk => Units.mpgImperialToLitresPer100Km(v),
        whPerKm => Units.whPerKmToKwhPer100Km(v),
        milesPerKwh => Units.milesPerKwhToKwhPer100Km(v),
      };

  /// Stored per-100-km value → this unit (for editing/display).
  /// The reciprocal units are their own inverse: f(f(x)) = x.
  double fromPer100Km(double per100) => switch (this) {
        litresPer100Km || kwhPer100Km => per100,
        kmPerLitre => Units.kmPerLitreToLitresPer100Km(per100),
        mpgUs => Units.mpgUsToLitresPer100Km(per100),
        mpgUk => Units.mpgImperialToLitresPer100Km(per100),
        whPerKm => per100 * 10,
        milesPerKwh => Units.milesPerKwhToKwhPer100Km(per100),
      };
}
