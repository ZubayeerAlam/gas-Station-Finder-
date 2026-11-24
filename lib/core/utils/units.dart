/// Unit conversions. FuelWise computes internally in metric:
/// distance in meters/km, fuel in litres, energy in kWh, consumption per 100 km.
abstract final class Units {
  static const litresPerUsGallon = 3.785411784;
  static const litresPerImperialGallon = 4.54609;
  static const metersPerMile = 1609.344;

  /// US mpg → L/100 km (235.215 / mpg).
  static double mpgUsToLitresPer100Km(double mpg) {
    _requirePositive(mpg, 'mpg');
    return 100 * litresPerUsGallon * 1000 / (mpg * metersPerMile);
  }

  /// Imperial (UK) mpg → L/100 km (282.481 / mpg).
  static double mpgImperialToLitresPer100Km(double mpg) {
    _requirePositive(mpg, 'mpg');
    return 100 * litresPerImperialGallon * 1000 / (mpg * metersPerMile);
  }

  /// km per litre (common in South Asia) → L/100 km.
  static double kmPerLitreToLitresPer100Km(double kmPerLitre) {
    _requirePositive(kmPerLitre, 'km/L');
    return 100 / kmPerLitre;
  }

  /// EV: Wh/km → kWh/100 km.
  static double whPerKmToKwhPer100Km(double whPerKm) => whPerKm / 10;

  /// EV: miles/kWh → kWh/100 km.
  static double milesPerKwhToKwhPer100Km(double milesPerKwh) {
    _requirePositive(milesPerKwh, 'mi/kWh');
    return 100 * 1000 / (milesPerKwh * metersPerMile);
  }

  /// Price per US gallon → price per litre.
  static double pricePerUsGallonToPerLitre(double price) => price / litresPerUsGallon;

  static void _requirePositive(double v, String name) {
    if (v <= 0 || v.isNaN || v.isInfinite) {
      throw ArgumentError.value(v, name, 'must be a positive number');
    }
  }
}
