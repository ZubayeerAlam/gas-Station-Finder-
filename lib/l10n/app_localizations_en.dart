// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'FuelWise';

  @override
  String get navMap => 'Map';

  @override
  String get navHistory => 'History';

  @override
  String get navGarage => 'Garage';

  @override
  String get loading => 'Loading';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get tryAgain => 'Try again';

  @override
  String get retry => 'Retry';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get undo => 'Undo';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'System default';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageBengali => 'বাংলা (Bengali)';

  @override
  String get tooltipAssistant => 'Trip assistant';

  @override
  String get tooltipAlerts => 'Price alerts';

  @override
  String get planTrip => 'Plan trip';

  @override
  String get findingLocation => 'Finding your location…';

  @override
  String get openAppSettings => 'Open app settings';

  @override
  String get openLocationSettings => 'Open location settings';

  @override
  String get locationNeeded => 'Location needed';

  @override
  String get couldNotDetermineLocation => 'Could not determine your location.';

  @override
  String get couldNotGetDirections => 'Could not get directions.';

  @override
  String get searchingStations => 'Searching nearby stations…';

  @override
  String get couldNotLoadStations => 'Could not load stations.';

  @override
  String get noStationsNearby => 'No fuel stations within 5 km.';

  @override
  String stationsNearby(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stations nearby',
      one: '1 station nearby',
    );
    return '$_temp0';
  }

  @override
  String offlineSavedStations(int count, String age) {
    return 'Offline · $count saved station positions ($age). Names and prices need a connection.';
  }

  @override
  String get searchingChargers => 'Searching chargers…';

  @override
  String get couldNotLoadChargers => 'Could not load chargers.';

  @override
  String get noChargersMatchFilters => 'No chargers match your filters.';

  @override
  String get noChargersNearby => 'No chargers within 10 km.';

  @override
  String chargersNearby(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chargers nearby',
      one: '1 charger nearby',
    );
    return '$_temp0';
  }

  @override
  String chargersNearbyFiltered(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chargers nearby (filtered)',
      one: '1 charger nearby (filtered)',
    );
    return '$_temp0';
  }

  @override
  String get modeFuel => 'Fuel';

  @override
  String get modeEv => 'EV';

  @override
  String get chargerFilters => 'Charger filters';

  @override
  String get calculatingRoute => 'Calculating route…';

  @override
  String get clearRoute => 'Clear route';

  @override
  String distanceAwayStraight(String distance) {
    return '$distance away (straight line)';
  }

  @override
  String get directions => 'Directions';

  @override
  String get couldNotLoadStationDetails => 'Could not load station details.';

  @override
  String get loadingStationDetails => 'Loading station details';

  @override
  String get openNow => 'Open now';

  @override
  String get closed => 'Closed';

  @override
  String get fuelPrices => 'Fuel prices';

  @override
  String get fuelPricesUnavailable =>
      'Fuel prices are not available for this station.';

  @override
  String get evCharging => 'EV charging';

  @override
  String connectorCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count connectors',
      one: '1 connector',
    );
    return '$_temp0';
  }

  @override
  String availableReported(int count) {
    return '$count available (reported)';
  }

  @override
  String get openingHours => 'Opening hours';

  @override
  String get sourceGoogle => 'Source: Google';

  @override
  String sourceGoogleUpdated(String age) {
    return 'Source: Google · updated $age';
  }

  @override
  String get garageTitle => 'My Garage';

  @override
  String get addVehicle => 'Add vehicle';

  @override
  String get noVehiclesTitle => 'No vehicles yet';

  @override
  String get noVehiclesMessage =>
      'Add your car or EV so FuelWise can calculate real trip costs and range.';

  @override
  String get couldNotLoadGarage => 'Could not load your garage.';

  @override
  String deleteVehicleTitle(String name) {
    return 'Delete $name?';
  }

  @override
  String get deleteVehicleBody => 'This removes the vehicle from your garage.';

  @override
  String vehicleDeleted(String name) {
    return '$name deleted';
  }

  @override
  String get couldNotDeleteVehicle => 'Could not delete vehicle';

  @override
  String batteryCapacity(String capacity) {
    return '$capacity battery';
  }

  @override
  String tankCapacity(String capacity) {
    return '$capacity tank';
  }

  @override
  String get activeVehicle => 'Active vehicle';

  @override
  String fullChargeRange(String distance) {
    return 'Full charge range ≈ $distance';
  }

  @override
  String fullTankRange(String distance) {
    return 'Full tank range ≈ $distance';
  }

  @override
  String get vehicleOptions => 'Vehicle options';

  @override
  String get assistantTitle => 'Trip assistant';

  @override
  String get assistantNewChat => 'New chat';

  @override
  String get assistantUnavailableTitle => 'Assistant not available';

  @override
  String get assistantUnavailableMessage =>
      'The trip assistant runs on the FuelWise server, which is not set up in this build.';

  @override
  String get assistantInputHint => 'Ask about fuel or charging on your trip';

  @override
  String get assistantSend => 'Send';

  @override
  String get assistantFooter =>
      'Answers use the app\'s own route ranking. Check prices at the pump.';

  @override
  String get assistantWelcomeTitle => 'Plan smarter stops';

  @override
  String get assistantWelcomeBody =>
      'Tell me where you are driving. I rank fuel or charging stops on the way by total cost, detour and reliability, using your vehicle from the garage.';

  @override
  String get assistantSuggestion1 =>
      'Where should I fill up on my way to the airport?';

  @override
  String get assistantSuggestion2 =>
      'Cheapest charging stop on the way to Hamburg?';

  @override
  String get assistantSuggestion3 =>
      'Which station has the smallest detour on my way to work?';

  @override
  String get assistantThinking => 'Thinking…';

  @override
  String get assistantPlanning => 'Planning your route and ranking stations…';

  @override
  String get assistantCheckingVehicle => 'Checking your vehicle…';

  @override
  String get assistantWorking => 'Working…';

  @override
  String get assistantDemoLabel => 'Offline demo — not Claude';

  @override
  String get assistantTooManySteps =>
      'That took too many steps. Please try a simpler question.';
}
