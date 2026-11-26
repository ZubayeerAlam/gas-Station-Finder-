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
  String get assistantDemoLabel => 'Offline demo, not the AI';

  @override
  String get assistantTooManySteps =>
      'That took too many steps. Please try a simpler question.';

  @override
  String get errorNetwork =>
      'No internet connection. Check your network and try again.';

  @override
  String get errorTimeout =>
      'The server took too long to respond. Please try again.';

  @override
  String get errorNotFound => 'Nothing was found.';

  @override
  String get errorUnknown => 'Something went wrong. Please try again.';

  @override
  String get errorCancelled => 'The request was cancelled.';

  @override
  String get errorBadResponse =>
      'Received an unexpected response from the server.';

  @override
  String get errorRequestRejected =>
      'The map service rejected the request. Check the API key and its restrictions.';

  @override
  String get errorTooManyRequests => 'Too many requests. Please wait a moment.';

  @override
  String errorServer(String status) {
    return 'Server error ($status). Please try again.';
  }

  @override
  String get errorMissingGoogleKey =>
      'Google Maps API key is not configured in this build.';

  @override
  String get errorMissingOcmKey =>
      'Open Charge Map API key is not configured in this build.';

  @override
  String get errorCommunityUnavailable =>
      'Community prices are not set up in this build.';

  @override
  String get errorCommunityNeedsSignIn =>
      'Community features need anonymous sign-in enabled in Firebase.';

  @override
  String get errorNotAllowed =>
      'That change was not allowed. Check the values and try again.';

  @override
  String get errorSignInFailed => 'Could not sign in.';

  @override
  String get errorAssistantFailed =>
      'The assistant could not answer. Please try again.';

  @override
  String get errorNoDetours => 'Could not compute detours.';

  @override
  String get errorNoRouteToDestination => 'No route to the destination.';

  @override
  String get errorNoRouteToStation => 'No driving route found to this station.';

  @override
  String get errorHistorySave =>
      'Could not update your history. Please try again.';

  @override
  String get errorGarageSave =>
      'Could not save to the local garage. Please try again.';

  @override
  String get errorLocationServiceDisabled =>
      'Location services are turned off. Turn them on to find stations near you.';

  @override
  String get errorLocationDenied =>
      'FuelWise needs location permission to find stations near you.';

  @override
  String get errorLocationDeniedForever =>
      'Location permission is blocked. Enable it in Settings to find stations near you.';

  @override
  String get errorLocationUnavailable =>
      'Could not determine your location. Please try again.';

  @override
  String get timeJustNow => 'just now';

  @override
  String timeMinutesAgo(int count) {
    return '$count min ago';
  }

  @override
  String timeHoursAgo(int count) {
    return '$count h ago';
  }

  @override
  String timeDaysAgo(int count) {
    return '$count d ago';
  }

  @override
  String get save => 'Save';

  @override
  String get saving => 'Saving…';

  @override
  String get historyTitle => 'History';

  @override
  String historyTitleFor(String vehicle) {
    return 'History · $vehicle';
  }

  @override
  String get addCharge => 'Add charge';

  @override
  String get addFillUp => 'Add fill-up';

  @override
  String get couldNotLoadHistory => 'Could not load your history.';

  @override
  String get noActiveVehicle => 'No active vehicle';

  @override
  String get noActiveVehicleMessage =>
      'Add a vehicle in your garage to track fill-ups, spending and consumption.';

  @override
  String get openGarage => 'Open garage';

  @override
  String get noChargesYet => 'No charging sessions yet';

  @override
  String get noFillUpsYet => 'No fill-ups yet';

  @override
  String get logChargesHint =>
      'Log each charge to see your spending and real consumption.';

  @override
  String get logFillUpsHint =>
      'Log each fill-up to see your spending and real consumption.';

  @override
  String get statThisMonth => 'This month';

  @override
  String get statAvgConsumption => 'Avg consumption';

  @override
  String get statCostPerKm => 'Cost per km';

  @override
  String spendingChartTitle(String currency) {
    return 'Spending · last 6 months ($currency)';
  }

  @override
  String otherCurrencyEntries(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entries in other currencies not shown (no conversion).',
      one: '1 entry in another currency not shown (no conversion).',
    );
    return '$_temp0';
  }

  @override
  String consumptionChartTitle(String unit) {
    return 'Consumption trend ($unit/100 km)';
  }

  @override
  String get needMoreCharges =>
      'Log at least three full charges with odometer readings to see a trend.';

  @override
  String get needMoreFillUps =>
      'Log at least three full fill-ups with odometer readings to see a trend.';

  @override
  String measuredFullToFull(String value, String unit) {
    return 'Measured full-to-full; compare with your garage value $value $unit/100 km.';
  }

  @override
  String get entries => 'Entries';

  @override
  String monthlySpendingSemantics(String values) {
    return 'Monthly spending: $values';
  }

  @override
  String consumptionTrendSemantics(String values) {
    return 'Consumption trend: $values';
  }

  @override
  String get entryDeleted => 'Entry deleted';

  @override
  String get couldNotDeleteEntry => 'Could not delete entry';

  @override
  String get deleteEntry => 'Delete entry';

  @override
  String get partialFill => 'partial';

  @override
  String get addVehicleFirst => 'Add a vehicle in your garage first.';

  @override
  String get enterPositiveNumber => 'Enter a positive number';

  @override
  String odometerMustIncrease(String value) {
    return 'Must be above the previous reading ($value km)';
  }

  @override
  String get couldNotSaveFillUp => 'Could not save fill-up';

  @override
  String get addChargingSession => 'Add charging session';

  @override
  String get energyCharged => 'Energy charged';

  @override
  String get fuelAdded => 'Fuel added';

  @override
  String get totalPaid => 'Total paid';

  @override
  String get currency => 'Currency';

  @override
  String get currencyCodeError => '3-letter code';

  @override
  String unitPriceLine(String price, String unit) {
    return 'Unit price: $price/$unit';
  }

  @override
  String get odometerOptional => 'Odometer (optional)';

  @override
  String get odometerHelper =>
      'Needed to measure real consumption and cost per km.';

  @override
  String get chargedToTarget => 'Charged to my usual target';

  @override
  String get filledTank => 'Filled the tank';

  @override
  String get partialFillHelp => 'Partial fills are added to the next full one.';

  @override
  String get stationOptional => 'Station (optional)';

  @override
  String get couldNotSaveVehicle => 'Could not save vehicle';

  @override
  String get editVehicle => 'Edit vehicle';

  @override
  String get vehicleName => 'Name';

  @override
  String get vehicleNameHint => 'e.g. Toyota Corolla';

  @override
  String get enterName => 'Enter a name';

  @override
  String get energyFuel => 'Fuel';

  @override
  String get energyElectric => 'Electric';

  @override
  String get consumption => 'Consumption';

  @override
  String get usableBatteryCapacity => 'Usable battery capacity';

  @override
  String get tankCapacityLabel => 'Tank capacity';

  @override
  String get fuelTypeLabel => 'Fuel type';

  @override
  String get chargingEfficiency => 'Charging efficiency';

  @override
  String get chargingEfficiencyHelper =>
      'Share of bought energy that reaches the battery. Leave 100 if unsure.';

  @override
  String get efficiencyRangeError => 'Enter a value between 1 and 100';

  @override
  String get saveVehicle => 'Save vehicle';

  @override
  String get fuelDiesel => 'Diesel';

  @override
  String get fuelDieselPlus => 'Diesel+';

  @override
  String get fuelTruckDiesel => 'Truck diesel';

  @override
  String get fuelBioDiesel => 'Biodiesel';

  @override
  String get fuelRegular => 'Regular';

  @override
  String get fuelMidgrade => 'Midgrade';

  @override
  String get fuelPremium => 'Premium';

  @override
  String get fuelMethane => 'CNG / Methane';

  @override
  String get fuelEvCharging => 'EV charging';

  @override
  String get connectorWallOutlet => 'Wall outlet';

  @override
  String get connectorOther => 'Other';

  @override
  String get communityPrices => 'Community prices';

  @override
  String get reportPrice => 'Report price';

  @override
  String get communityOff => 'Community prices are turned off in this build.';

  @override
  String get noCommunityReports =>
      'No community reports yet. Be the first to report a price.';

  @override
  String get couldNotLoadCommunityPrices => 'Could not load community prices.';

  @override
  String reportCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reports',
      one: '1 report',
    );
    return '$_temp0';
  }

  @override
  String communityReports(String reports) {
    return 'Community · $reports';
  }

  @override
  String updatedAgo(String time) {
    return 'updated $time';
  }

  @override
  String get outdated => 'outdated';

  @override
  String get priceHistory => 'Price history';

  @override
  String fuelHistory(String fuel) {
    return '$fuel history';
  }

  @override
  String get days7 => '7 days';

  @override
  String get days30 => '30 days';

  @override
  String get noHistoryForPeriod => 'No history for this period yet.';

  @override
  String get couldNotLoadPriceHistory => 'Could not load history.';

  @override
  String priceHistorySemantics(String currency, String summary) {
    return 'Community price history in $currency: $summary';
  }

  @override
  String get thanksForConfirming => 'Thanks for confirming!';

  @override
  String reliabilitySemantics(int percent) {
    return 'Data reliability $percent percent';
  }

  @override
  String votesOpen(int count) {
    return '$count said open';
  }

  @override
  String votesClosed(int count) {
    return '$count said closed';
  }

  @override
  String votesOutOfFuel(int count) {
    return '$count said out of fuel';
  }

  @override
  String get reliabilityDisclaimer =>
      'Based on recent community reports and votes — not an official check.';

  @override
  String get isItOpenNow => 'Is it open right now?';

  @override
  String get voteOpen => 'Open';

  @override
  String get voteClosed => 'Closed';

  @override
  String get voteOutOfFuel => 'Out of fuel';

  @override
  String get reliabilityNone => 'Not enough community data';

  @override
  String get reliabilityHigh => 'Recently confirmed by the community';

  @override
  String get reliabilityMedium => 'Some community reports';

  @override
  String get reliabilityLow => 'Community reports are old or disagree';

  @override
  String get reportAccepted =>
      'Thanks! Your price is now part of the community price.';

  @override
  String get reportMinorityCurrency =>
      'Saved, but most reports here use another currency.';

  @override
  String get reportOutlier =>
      'This price is far from other recent reports, so it was not used.';

  @override
  String get reportDuplicate =>
      'You already reported this fuel here a few minutes ago.';

  @override
  String get reportTooMany =>
      'Too many reports in the last hour. Please try later.';

  @override
  String get reportRejected => 'This report was not accepted.';

  @override
  String get reportSent => 'Report sent. It will be checked in a moment.';

  @override
  String get enterPrice => 'Enter a price';

  @override
  String get enterPriceRange => 'Enter a price between 0.01 and 1000';

  @override
  String get reportAPrice => 'Report a price';

  @override
  String get fuel => 'Fuel';

  @override
  String pricePerUnit(String unit) {
    return 'Price per $unit';
  }

  @override
  String get reportPriceHelp =>
      'Report the price shown at the pump right now. Reports are combined with others; prices far from recent reports are not used.';

  @override
  String get sending => 'Sending…';

  @override
  String get sendReport => 'Send report';

  @override
  String get done => 'Done';

  @override
  String get priceAlerts => 'Price alerts';

  @override
  String get newAlert => 'New alert';

  @override
  String get alertsUnavailableTitle => 'Alerts are not available';

  @override
  String get alertsUnavailableMessage =>
      'Price alerts need the FuelWise community backend, which is not set up in this build.';

  @override
  String get noAlertsTitle => 'No price alerts yet';

  @override
  String get noAlertsMessage =>
      'Create an alert to hear when a community price near you drops below your limit.';

  @override
  String get alertsServerNote =>
      'Alerts are checked by the server when a new community price is accepted. Push notifications are not enabled in this build yet.';

  @override
  String alertOnlyAt(String station) {
    return 'Only at $station';
  }

  @override
  String alertWithinKm(String km) {
    return 'Within $km km of the saved location';
  }

  @override
  String get alertOn => 'Alert on';

  @override
  String get alertPaused => 'Alert paused';

  @override
  String get deleteAlert => 'Delete alert';

  @override
  String get alertDeleted => 'Alert deleted';

  @override
  String get couldNotLoadAlerts => 'Could not load alerts.';

  @override
  String get alertSaved => 'Alert saved';

  @override
  String get newPriceAlert => 'New price alert';

  @override
  String get alertAtOrBelow => 'Alert at or below';

  @override
  String alertRadius(int km) {
    return 'Within $km km of my current location';
  }

  @override
  String get saveAlert => 'Save alert';

  @override
  String get badgeCheapest => 'Cheapest';

  @override
  String get badgeBestValue => 'Best value';

  @override
  String get badgeLeastDetour => 'Least detour';

  @override
  String get badgeMostReliable => 'Most reliable';

  @override
  String get caveatClosed => 'Closed now';

  @override
  String get caveatUnreachable => 'May be out of range';

  @override
  String get caveatOtherCurrency => 'Other currency (not converted)';

  @override
  String get caveatPriceUnknown => 'No price available';

  @override
  String get caveatStalePrice => 'Price older than 3 days';

  @override
  String get onRoute => 'on route';

  @override
  String get explainNoPrice =>
      'No price is available for this station, so its cost cannot be compared.';

  @override
  String explainUnitOnly(String price, String unit) {
    return '$price per $unit. Add a vehicle in your garage to compare the total trip cost.';
  }

  @override
  String explainBuy(String amount, String unit, String price, String cost) {
    return 'Buy $amount $unit × $price = $cost';
  }

  @override
  String explainDetour(
    String distance,
    String amount,
    String unit,
    String cost,
  ) {
    return 'Detour $distance uses $amount $unit = $cost';
  }

  @override
  String explainSaves(String amount) {
    return ' · saves $amount vs the nearest station';
  }

  @override
  String explainMore(String amount) {
    return ' · $amount more than the nearest station';
  }

  @override
  String explainTotal(String cost, String comparison) {
    return 'Total $cost$comparison';
  }

  @override
  String get explainSourceGoogle => 'Price source: Google';

  @override
  String get explainSourceCommunity => 'Price source: community';

  @override
  String explainUpdated(String time) {
    return ', updated $time';
  }

  @override
  String get trip => 'Trip';

  @override
  String tripTo(String destination) {
    return 'To $destination';
  }

  @override
  String get changeDestination => 'Change destination';

  @override
  String get couldNotPlanTrip => 'Could not plan this trip.';

  @override
  String get noTripYet => 'No trip yet';

  @override
  String get noTripMessage =>
      'Choose a destination to find stations along the way.';

  @override
  String get chooseDestination => 'Choose destination';

  @override
  String get findingAlongRoute => 'Finding stations along your route…';

  @override
  String stationsOnTheWay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stations on the way',
      one: '1 station on the way',
    );
    return '$_temp0';
  }

  @override
  String comparingFuelPrices(String fuel) {
    return 'Comparing $fuel prices';
  }

  @override
  String get detoursApproximate =>
      'Routing service unavailable — detours are straight-line estimates.';

  @override
  String skippedForDetour(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count more stations farther from the route were not compared.',
      one: '1 more station farther from the route was not compared.',
    );
    return '$_temp0';
  }

  @override
  String get noStationsAlongRoute => 'No stations along this route';

  @override
  String get nothingWithin5km => 'Nothing found within 5 km of the route.';

  @override
  String withoutComparablePrice(int count) {
    return 'Without a comparable price ($count)';
  }

  @override
  String get comparingPricePerLitre => 'Comparing price per litre only';

  @override
  String get addVehicleForTrueCost =>
      'Add your vehicle to rank by true trip cost.';

  @override
  String get add => 'Add';

  @override
  String batteryNowToFull(
    String vehicle,
    int percent,
    String amount,
    String unit,
  ) {
    return '$vehicle · battery now $percent% → full ($amount $unit)';
  }

  @override
  String tankNowToFull(
    String vehicle,
    int percent,
    String amount,
    String unit,
  ) {
    return '$vehicle · tank now $percent% → full ($amount $unit)';
  }

  @override
  String percentCharge(int percent) {
    return '$percent percent charge';
  }

  @override
  String percentFuel(int percent) {
    return '$percent percent fuel';
  }

  @override
  String intoTheTrip(String detour, String distance) {
    return '$detour · $distance into the trip';
  }

  @override
  String get showOnMap => 'Show on map';

  @override
  String get whereTo => 'Where to?';

  @override
  String get searchFailed => 'Search failed.';

  @override
  String get searching => 'Searching…';

  @override
  String get noPlacesFound => 'No places found';

  @override
  String get tryAnotherName => 'Try another name or address.';

  @override
  String get destinationSearchHint =>
      'Search a destination. FuelWise finds stations along your route and ranks them by the true cost of stopping — price plus the fuel used by the detour.';

  @override
  String get powerAny => 'Any';

  @override
  String get reset => 'Reset';

  @override
  String get minimumPower => 'Minimum power';

  @override
  String get connector => 'Connector';

  @override
  String get noConnectorDataNearby => 'No connector data nearby.';

  @override
  String get onlyOperational => 'Only operational';

  @override
  String get onlyOperationalHelp =>
      'Hide chargers reported as not working or with unknown status.';

  @override
  String get statusOperational => 'Operational';

  @override
  String get statusNotOperational => 'Not operational';

  @override
  String get statusUnknown => 'Status unknown';

  @override
  String upToPower(String power) {
    return 'Up to $power';
  }

  @override
  String get fastSuffix => ' · fast';

  @override
  String chargingPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count charging points',
      one: '1 charging point',
    );
    return '$_temp0';
  }

  @override
  String get connectors => 'Connectors';

  @override
  String get noConnectorDetails => 'No connector details reported.';

  @override
  String get notOperationalLower => 'not operational';

  @override
  String get cost => 'Cost';

  @override
  String get noCostInfo =>
      'No cost information reported. Check the operator app or the charger display.';

  @override
  String costAsListed(String cost) {
    return '\"$cost\" — as listed by the community; not verified by FuelWise.';
  }

  @override
  String lastVerified(String time) {
    return 'Last verified $time';
  }

  @override
  String statusUpdated(String time) {
    return 'status updated $time';
  }

  @override
  String get monthsShort => 'Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec';

  @override
  String get errorCareSave => 'Could not save the reminder. Please try again.';

  @override
  String get careMenu => 'Care & reminders';

  @override
  String careTitle(String vehicle) {
    return 'Care · $vehicle';
  }

  @override
  String get careAddReminder => 'Add reminder';

  @override
  String get careEditReminder => 'Edit reminder';

  @override
  String get careEmptyTitle => 'No reminders yet';

  @override
  String get careEmptyMessage =>
      'Never miss a tax token, fitness, insurance or service date again. Start with the suggestions for this vehicle.';

  @override
  String get careAddSuggested => 'Add suggested reminders';

  @override
  String careSuggestedAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reminders added — set their dates',
      one: '1 reminder added — set its date',
    );
    return '$_temp0';
  }

  @override
  String get careDisclaimer =>
      'Suggested intervals are only starting points. Check your documents (BRTA, insurer, cylinder certificate) for the real dates.';

  @override
  String careOdometerKnown(String km) {
    return 'Odometer $km (from your history)';
  }

  @override
  String careOdometerRate(String km) {
    return ' · about $km per day';
  }

  @override
  String get careNoOdometer =>
      'No odometer readings yet. Add one with your next fill-up in History to track service by km.';

  @override
  String get careBandOverdue => 'Overdue';

  @override
  String get careBandDueSoon => 'Due soon';

  @override
  String get careBandUpcoming => 'Upcoming';

  @override
  String get careBandNeedsSetup => 'Needs a date';

  @override
  String get careBandDone => 'Done';

  @override
  String get careTypeTaxToken => 'Tax token';

  @override
  String get careTypeFitness => 'Fitness certificate';

  @override
  String get careTypeInsurance => 'Insurance';

  @override
  String get careTypeRoutePermit => 'Route permit';

  @override
  String get careTypeCngRetest => 'CNG cylinder retest';

  @override
  String get careTypeOilChange => 'Oil change';

  @override
  String get careTypeTyreRotation => 'Tyre rotation';

  @override
  String get careTypeCustom => 'Custom';

  @override
  String get careNeedsSetup => 'Tap to set the due date or km';

  @override
  String get careNeedsOdometer =>
      'Add an odometer reading in History to track this';

  @override
  String careDoneOn(String date) {
    return 'Done on $date';
  }

  @override
  String careOverdueDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Overdue by $count days',
      one: 'Overdue by 1 day',
    );
    return '$_temp0';
  }

  @override
  String careOverdueKm(String km) {
    return 'Overdue by $km';
  }

  @override
  String get careDueToday => 'Due today';

  @override
  String careDueInDays(int count, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Due in $count days · $date',
      one: 'Due tomorrow · $date',
    );
    return '$_temp0';
  }

  @override
  String careInKm(String km) {
    return 'In $km';
  }

  @override
  String careEstimatedDate(String date) {
    return ' (≈ $date)';
  }

  @override
  String get careMarkDone => 'Mark done';

  @override
  String get careMarkedDone => 'Marked as done';

  @override
  String careMarkedDoneNext(String when) {
    return 'Marked as done · next $when';
  }

  @override
  String get careDeleted => 'Reminder deleted';

  @override
  String get careDoneDate => 'Done on';

  @override
  String get careOdometerNow => 'Odometer now (optional)';

  @override
  String get careTypeField => 'Type';

  @override
  String get careTitleField => 'Name';

  @override
  String get careTitleRequired => 'Enter a name';

  @override
  String get careDueDate => 'Due date';

  @override
  String get careNoDueDate => 'No due date';

  @override
  String get careClearDate => 'Clear date';

  @override
  String get careDueKm => 'Due at odometer';

  @override
  String get careRepeatMonths => 'Repeat every (months)';

  @override
  String get careRepeatKm => 'Repeat every (km)';

  @override
  String get careRepeatHelp =>
      'Used when you mark it done. Leave empty for a one-off.';

  @override
  String get careNotify => 'Remind me';

  @override
  String careNotifyDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days before',
      one: '1 day before',
      zero: 'On the day only',
    );
    return '$_temp0';
  }

  @override
  String get careNote => 'Note (optional)';

  @override
  String get careNeedDue => 'Set a due date or a due odometer';

  @override
  String careCurrentOdometer(String km) {
    return 'Current odometer: $km';
  }

  @override
  String get careSaveReminder => 'Save reminder';

  @override
  String careAttention(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reminders need attention',
      one: '1 reminder needs attention',
    );
    return '$_temp0';
  }

  @override
  String get careWholeNumber => 'Enter a whole number';

  @override
  String careProgressSemantics(int percent) {
    return '$percent percent of the interval used';
  }

  @override
  String get careOptions => 'Reminder options';

  @override
  String careNoticeTitle(String reminder, String vehicle) {
    return '$reminder · $vehicle';
  }

  @override
  String get careNoticeEstimated => ' (estimated from your driving)';

  @override
  String get careChannelName => 'Vehicle care reminders';

  @override
  String get careChannelDescription =>
      'Document expiry and service reminders for your vehicles';

  @override
  String get privacyTitle => 'Privacy & data';

  @override
  String get privacyDeviceTitle => 'On this device';

  @override
  String get privacyDeviceBody =>
      'Your vehicles, fill-up history, care reminders, saved station positions and settings are stored only on this phone.';

  @override
  String get privacyDeleteDevice => 'Delete data on this device';

  @override
  String get privacyDeleteDeviceConfirmTitle =>
      'Delete all data on this device?';

  @override
  String get privacyDeleteDeviceConfirmBody =>
      'Vehicles, history, reminders (and their notifications), saved station positions and settings will be erased. This cannot be undone.';

  @override
  String get privacyDeviceDeleted => 'Data on this device deleted';

  @override
  String get privacyCommunityTitle => 'Community (online)';

  @override
  String get privacyCommunityBody =>
      'If you used community prices, votes, price alerts or the AI assistant, that data is stored online under an anonymous account.';

  @override
  String get privacyCommunityOff =>
      'Community features are off in this build, so nothing is stored online.';

  @override
  String get privacyDeleteCommunity => 'Delete my online data';

  @override
  String get privacyDeleteCommunityConfirmTitle => 'Delete your online data?';

  @override
  String get privacyDeleteCommunityConfirmBody =>
      'Your price reports, votes, price alerts, assistant conversations and anonymous account will be deleted. Station prices already calculated from many reports hold no personal data and expire within 72 hours. This cannot be undone.';

  @override
  String privacyCommunityDeleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items deleted online',
      one: '1 item deleted online',
      zero: 'Nothing was stored online',
    );
    return '$_temp0';
  }

  @override
  String get errorDataDeletion =>
      'Could not delete your online data. Check your connection and try again.';

  @override
  String get historyExportCsv => 'Export as CSV';

  @override
  String historyExportSubject(String vehicle) {
    return 'FuelWise history: $vehicle';
  }

  @override
  String get errorExport => 'Could not export the history. Please try again.';

  @override
  String get nearbyShowList => 'Show as list';

  @override
  String get nearbyShowMap => 'Show map';

  @override
  String get sortNearest => 'Nearest';

  @override
  String get sortFastest => 'Fastest charging';

  @override
  String get chargerOutOfService => 'Out of service';

  @override
  String routeFastest(String distance) {
    return 'Fastest · $distance';
  }

  @override
  String routeAlternativeSlower(int minutes, String distance) {
    return '+$minutes min · $distance';
  }

  @override
  String routeAlternativeSameTime(String distance) {
    return 'Similar time · $distance';
  }

  @override
  String get savedTripsTitle => 'Saved trips';

  @override
  String get saveTrip => 'Save trip';

  @override
  String get saveTripDialogTitle => 'Save this trip';

  @override
  String get tripLabel => 'Name';

  @override
  String get tripLabelHint => 'e.g. Home, Office';

  @override
  String get tripLabelInvalid => 'Enter a name (up to 40 characters)';

  @override
  String get tripSaved => 'Trip saved';

  @override
  String get tripRemoved => 'Saved trip removed';

  @override
  String get removeSavedTrip => 'Remove saved trip';

  @override
  String savedTripLastTime(String summary) {
    return 'Last time: $summary';
  }

  @override
  String get savedTripNeedsLookup => 'Location will be looked up again';

  @override
  String get errorTripSave => 'Could not save the trip. Please try again.';

  @override
  String get errorTripLocationExpired =>
      'This saved place has expired. Please search for it again.';
}
