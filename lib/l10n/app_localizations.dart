import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'FuelWise'**
  String get appTitle;

  /// No description provided for @navMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get navMap;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navGarage.
  ///
  /// In en, this message translates to:
  /// **'Garage'**
  String get navGarage;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageBengali.
  ///
  /// In en, this message translates to:
  /// **'বাংলা (Bengali)'**
  String get languageBengali;

  /// No description provided for @tooltipAssistant.
  ///
  /// In en, this message translates to:
  /// **'Trip assistant'**
  String get tooltipAssistant;

  /// No description provided for @tooltipAlerts.
  ///
  /// In en, this message translates to:
  /// **'Price alerts'**
  String get tooltipAlerts;

  /// No description provided for @planTrip.
  ///
  /// In en, this message translates to:
  /// **'Plan trip'**
  String get planTrip;

  /// No description provided for @findingLocation.
  ///
  /// In en, this message translates to:
  /// **'Finding your location…'**
  String get findingLocation;

  /// No description provided for @openAppSettings.
  ///
  /// In en, this message translates to:
  /// **'Open app settings'**
  String get openAppSettings;

  /// No description provided for @openLocationSettings.
  ///
  /// In en, this message translates to:
  /// **'Open location settings'**
  String get openLocationSettings;

  /// No description provided for @locationNeeded.
  ///
  /// In en, this message translates to:
  /// **'Location needed'**
  String get locationNeeded;

  /// No description provided for @couldNotDetermineLocation.
  ///
  /// In en, this message translates to:
  /// **'Could not determine your location.'**
  String get couldNotDetermineLocation;

  /// No description provided for @couldNotGetDirections.
  ///
  /// In en, this message translates to:
  /// **'Could not get directions.'**
  String get couldNotGetDirections;

  /// No description provided for @searchingStations.
  ///
  /// In en, this message translates to:
  /// **'Searching nearby stations…'**
  String get searchingStations;

  /// No description provided for @couldNotLoadStations.
  ///
  /// In en, this message translates to:
  /// **'Could not load stations.'**
  String get couldNotLoadStations;

  /// No description provided for @noStationsNearby.
  ///
  /// In en, this message translates to:
  /// **'No fuel stations within 5 km.'**
  String get noStationsNearby;

  /// No description provided for @stationsNearby.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 station nearby} other{{count} stations nearby}}'**
  String stationsNearby(int count);

  /// No description provided for @offlineSavedStations.
  ///
  /// In en, this message translates to:
  /// **'Offline · {count} saved station positions ({age}). Names and prices need a connection.'**
  String offlineSavedStations(int count, String age);

  /// No description provided for @searchingChargers.
  ///
  /// In en, this message translates to:
  /// **'Searching chargers…'**
  String get searchingChargers;

  /// No description provided for @couldNotLoadChargers.
  ///
  /// In en, this message translates to:
  /// **'Could not load chargers.'**
  String get couldNotLoadChargers;

  /// No description provided for @noChargersMatchFilters.
  ///
  /// In en, this message translates to:
  /// **'No chargers match your filters.'**
  String get noChargersMatchFilters;

  /// No description provided for @noChargersNearby.
  ///
  /// In en, this message translates to:
  /// **'No chargers within 10 km.'**
  String get noChargersNearby;

  /// No description provided for @chargersNearby.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 charger nearby} other{{count} chargers nearby}}'**
  String chargersNearby(int count);

  /// No description provided for @chargersNearbyFiltered.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 charger nearby (filtered)} other{{count} chargers nearby (filtered)}}'**
  String chargersNearbyFiltered(int count);

  /// No description provided for @modeFuel.
  ///
  /// In en, this message translates to:
  /// **'Fuel'**
  String get modeFuel;

  /// No description provided for @modeEv.
  ///
  /// In en, this message translates to:
  /// **'EV'**
  String get modeEv;

  /// No description provided for @chargerFilters.
  ///
  /// In en, this message translates to:
  /// **'Charger filters'**
  String get chargerFilters;

  /// No description provided for @calculatingRoute.
  ///
  /// In en, this message translates to:
  /// **'Calculating route…'**
  String get calculatingRoute;

  /// No description provided for @clearRoute.
  ///
  /// In en, this message translates to:
  /// **'Clear route'**
  String get clearRoute;

  /// No description provided for @distanceAwayStraight.
  ///
  /// In en, this message translates to:
  /// **'{distance} away (straight line)'**
  String distanceAwayStraight(String distance);

  /// No description provided for @directions.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get directions;

  /// No description provided for @couldNotLoadStationDetails.
  ///
  /// In en, this message translates to:
  /// **'Could not load station details.'**
  String get couldNotLoadStationDetails;

  /// No description provided for @loadingStationDetails.
  ///
  /// In en, this message translates to:
  /// **'Loading station details'**
  String get loadingStationDetails;

  /// No description provided for @openNow.
  ///
  /// In en, this message translates to:
  /// **'Open now'**
  String get openNow;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// No description provided for @fuelPrices.
  ///
  /// In en, this message translates to:
  /// **'Fuel prices'**
  String get fuelPrices;

  /// No description provided for @fuelPricesUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Fuel prices are not available for this station.'**
  String get fuelPricesUnavailable;

  /// No description provided for @evCharging.
  ///
  /// In en, this message translates to:
  /// **'EV charging'**
  String get evCharging;

  /// No description provided for @connectorCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 connector} other{{count} connectors}}'**
  String connectorCount(int count);

  /// No description provided for @availableReported.
  ///
  /// In en, this message translates to:
  /// **'{count} available (reported)'**
  String availableReported(int count);

  /// No description provided for @openingHours.
  ///
  /// In en, this message translates to:
  /// **'Opening hours'**
  String get openingHours;

  /// No description provided for @sourceGoogle.
  ///
  /// In en, this message translates to:
  /// **'Source: Google'**
  String get sourceGoogle;

  /// No description provided for @sourceGoogleUpdated.
  ///
  /// In en, this message translates to:
  /// **'Source: Google · updated {age}'**
  String sourceGoogleUpdated(String age);

  /// No description provided for @garageTitle.
  ///
  /// In en, this message translates to:
  /// **'My Garage'**
  String get garageTitle;

  /// No description provided for @addVehicle.
  ///
  /// In en, this message translates to:
  /// **'Add vehicle'**
  String get addVehicle;

  /// No description provided for @noVehiclesTitle.
  ///
  /// In en, this message translates to:
  /// **'No vehicles yet'**
  String get noVehiclesTitle;

  /// No description provided for @noVehiclesMessage.
  ///
  /// In en, this message translates to:
  /// **'Add your car or EV so FuelWise can calculate real trip costs and range.'**
  String get noVehiclesMessage;

  /// No description provided for @couldNotLoadGarage.
  ///
  /// In en, this message translates to:
  /// **'Could not load your garage.'**
  String get couldNotLoadGarage;

  /// No description provided for @deleteVehicleTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String deleteVehicleTitle(String name);

  /// No description provided for @deleteVehicleBody.
  ///
  /// In en, this message translates to:
  /// **'This removes the vehicle from your garage.'**
  String get deleteVehicleBody;

  /// No description provided for @vehicleDeleted.
  ///
  /// In en, this message translates to:
  /// **'{name} deleted'**
  String vehicleDeleted(String name);

  /// No description provided for @couldNotDeleteVehicle.
  ///
  /// In en, this message translates to:
  /// **'Could not delete vehicle'**
  String get couldNotDeleteVehicle;

  /// No description provided for @batteryCapacity.
  ///
  /// In en, this message translates to:
  /// **'{capacity} battery'**
  String batteryCapacity(String capacity);

  /// No description provided for @tankCapacity.
  ///
  /// In en, this message translates to:
  /// **'{capacity} tank'**
  String tankCapacity(String capacity);

  /// No description provided for @activeVehicle.
  ///
  /// In en, this message translates to:
  /// **'Active vehicle'**
  String get activeVehicle;

  /// No description provided for @fullChargeRange.
  ///
  /// In en, this message translates to:
  /// **'Full charge range ≈ {distance}'**
  String fullChargeRange(String distance);

  /// No description provided for @fullTankRange.
  ///
  /// In en, this message translates to:
  /// **'Full tank range ≈ {distance}'**
  String fullTankRange(String distance);

  /// No description provided for @vehicleOptions.
  ///
  /// In en, this message translates to:
  /// **'Vehicle options'**
  String get vehicleOptions;

  /// No description provided for @assistantTitle.
  ///
  /// In en, this message translates to:
  /// **'Trip assistant'**
  String get assistantTitle;

  /// No description provided for @assistantNewChat.
  ///
  /// In en, this message translates to:
  /// **'New chat'**
  String get assistantNewChat;

  /// No description provided for @assistantUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Assistant not available'**
  String get assistantUnavailableTitle;

  /// No description provided for @assistantUnavailableMessage.
  ///
  /// In en, this message translates to:
  /// **'The trip assistant runs on the FuelWise server, which is not set up in this build.'**
  String get assistantUnavailableMessage;

  /// No description provided for @assistantInputHint.
  ///
  /// In en, this message translates to:
  /// **'Ask about fuel or charging on your trip'**
  String get assistantInputHint;

  /// No description provided for @assistantSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get assistantSend;

  /// No description provided for @assistantFooter.
  ///
  /// In en, this message translates to:
  /// **'Answers use the app\'s own route ranking. Check prices at the pump.'**
  String get assistantFooter;

  /// No description provided for @assistantWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan smarter stops'**
  String get assistantWelcomeTitle;

  /// No description provided for @assistantWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Tell me where you are driving. I rank fuel or charging stops on the way by total cost, detour and reliability, using your vehicle from the garage.'**
  String get assistantWelcomeBody;

  /// No description provided for @assistantSuggestion1.
  ///
  /// In en, this message translates to:
  /// **'Where should I fill up on my way to the airport?'**
  String get assistantSuggestion1;

  /// No description provided for @assistantSuggestion2.
  ///
  /// In en, this message translates to:
  /// **'Cheapest charging stop on the way to Hamburg?'**
  String get assistantSuggestion2;

  /// No description provided for @assistantSuggestion3.
  ///
  /// In en, this message translates to:
  /// **'Which station has the smallest detour on my way to work?'**
  String get assistantSuggestion3;

  /// No description provided for @assistantThinking.
  ///
  /// In en, this message translates to:
  /// **'Thinking…'**
  String get assistantThinking;

  /// No description provided for @assistantPlanning.
  ///
  /// In en, this message translates to:
  /// **'Planning your route and ranking stations…'**
  String get assistantPlanning;

  /// No description provided for @assistantCheckingVehicle.
  ///
  /// In en, this message translates to:
  /// **'Checking your vehicle…'**
  String get assistantCheckingVehicle;

  /// No description provided for @assistantWorking.
  ///
  /// In en, this message translates to:
  /// **'Working…'**
  String get assistantWorking;

  /// No description provided for @assistantDemoLabel.
  ///
  /// In en, this message translates to:
  /// **'Offline demo — not Claude'**
  String get assistantDemoLabel;

  /// No description provided for @assistantTooManySteps.
  ///
  /// In en, this message translates to:
  /// **'That took too many steps. Please try a simpler question.'**
  String get assistantTooManySteps;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
