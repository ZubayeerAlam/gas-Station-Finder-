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

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Check your network and try again.'**
  String get errorNetwork;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'The server took too long to respond. Please try again.'**
  String get errorTimeout;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'Nothing was found.'**
  String get errorNotFound;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorUnknown;

  /// No description provided for @errorCancelled.
  ///
  /// In en, this message translates to:
  /// **'The request was cancelled.'**
  String get errorCancelled;

  /// No description provided for @errorBadResponse.
  ///
  /// In en, this message translates to:
  /// **'Received an unexpected response from the server.'**
  String get errorBadResponse;

  /// No description provided for @errorRequestRejected.
  ///
  /// In en, this message translates to:
  /// **'The map service rejected the request. Check the API key and its restrictions.'**
  String get errorRequestRejected;

  /// No description provided for @errorTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please wait a moment.'**
  String get errorTooManyRequests;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'Server error ({status}). Please try again.'**
  String errorServer(String status);

  /// No description provided for @errorMissingGoogleKey.
  ///
  /// In en, this message translates to:
  /// **'Google Maps API key is not configured in this build.'**
  String get errorMissingGoogleKey;

  /// No description provided for @errorMissingOcmKey.
  ///
  /// In en, this message translates to:
  /// **'Open Charge Map API key is not configured in this build.'**
  String get errorMissingOcmKey;

  /// No description provided for @errorCommunityUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Community prices are not set up in this build.'**
  String get errorCommunityUnavailable;

  /// No description provided for @errorCommunityNeedsSignIn.
  ///
  /// In en, this message translates to:
  /// **'Community features need anonymous sign-in enabled in Firebase.'**
  String get errorCommunityNeedsSignIn;

  /// No description provided for @errorNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'That change was not allowed. Check the values and try again.'**
  String get errorNotAllowed;

  /// No description provided for @errorSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not sign in.'**
  String get errorSignInFailed;

  /// No description provided for @errorAssistantFailed.
  ///
  /// In en, this message translates to:
  /// **'The assistant could not answer. Please try again.'**
  String get errorAssistantFailed;

  /// No description provided for @errorNoDetours.
  ///
  /// In en, this message translates to:
  /// **'Could not compute detours.'**
  String get errorNoDetours;

  /// No description provided for @errorNoRouteToDestination.
  ///
  /// In en, this message translates to:
  /// **'No route to the destination.'**
  String get errorNoRouteToDestination;

  /// No description provided for @errorNoRouteToStation.
  ///
  /// In en, this message translates to:
  /// **'No driving route found to this station.'**
  String get errorNoRouteToStation;

  /// No description provided for @errorHistorySave.
  ///
  /// In en, this message translates to:
  /// **'Could not update your history. Please try again.'**
  String get errorHistorySave;

  /// No description provided for @errorGarageSave.
  ///
  /// In en, this message translates to:
  /// **'Could not save to the local garage. Please try again.'**
  String get errorGarageSave;

  /// No description provided for @errorLocationServiceDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are turned off. Turn them on to find stations near you.'**
  String get errorLocationServiceDisabled;

  /// No description provided for @errorLocationDenied.
  ///
  /// In en, this message translates to:
  /// **'FuelWise needs location permission to find stations near you.'**
  String get errorLocationDenied;

  /// No description provided for @errorLocationDeniedForever.
  ///
  /// In en, this message translates to:
  /// **'Location permission is blocked. Enable it in Settings to find stations near you.'**
  String get errorLocationDeniedForever;

  /// No description provided for @errorLocationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Could not determine your location. Please try again.'**
  String get errorLocationUnavailable;

  /// No description provided for @timeJustNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get timeJustNow;

  /// No description provided for @timeMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} min ago'**
  String timeMinutesAgo(int count);

  /// No description provided for @timeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} h ago'**
  String timeHoursAgo(int count);

  /// No description provided for @timeDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} d ago'**
  String timeDaysAgo(int count);

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get saving;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// No description provided for @historyTitleFor.
  ///
  /// In en, this message translates to:
  /// **'History · {vehicle}'**
  String historyTitleFor(String vehicle);

  /// No description provided for @addCharge.
  ///
  /// In en, this message translates to:
  /// **'Add charge'**
  String get addCharge;

  /// No description provided for @addFillUp.
  ///
  /// In en, this message translates to:
  /// **'Add fill-up'**
  String get addFillUp;

  /// No description provided for @couldNotLoadHistory.
  ///
  /// In en, this message translates to:
  /// **'Could not load your history.'**
  String get couldNotLoadHistory;

  /// No description provided for @noActiveVehicle.
  ///
  /// In en, this message translates to:
  /// **'No active vehicle'**
  String get noActiveVehicle;

  /// No description provided for @noActiveVehicleMessage.
  ///
  /// In en, this message translates to:
  /// **'Add a vehicle in your garage to track fill-ups, spending and consumption.'**
  String get noActiveVehicleMessage;

  /// No description provided for @openGarage.
  ///
  /// In en, this message translates to:
  /// **'Open garage'**
  String get openGarage;

  /// No description provided for @noChargesYet.
  ///
  /// In en, this message translates to:
  /// **'No charging sessions yet'**
  String get noChargesYet;

  /// No description provided for @noFillUpsYet.
  ///
  /// In en, this message translates to:
  /// **'No fill-ups yet'**
  String get noFillUpsYet;

  /// No description provided for @logChargesHint.
  ///
  /// In en, this message translates to:
  /// **'Log each charge to see your spending and real consumption.'**
  String get logChargesHint;

  /// No description provided for @logFillUpsHint.
  ///
  /// In en, this message translates to:
  /// **'Log each fill-up to see your spending and real consumption.'**
  String get logFillUpsHint;

  /// No description provided for @statThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get statThisMonth;

  /// No description provided for @statAvgConsumption.
  ///
  /// In en, this message translates to:
  /// **'Avg consumption'**
  String get statAvgConsumption;

  /// No description provided for @statCostPerKm.
  ///
  /// In en, this message translates to:
  /// **'Cost per km'**
  String get statCostPerKm;

  /// No description provided for @spendingChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Spending · last 6 months ({currency})'**
  String spendingChartTitle(String currency);

  /// No description provided for @otherCurrencyEntries.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 entry in another currency not shown (no conversion).} other{{count} entries in other currencies not shown (no conversion).}}'**
  String otherCurrencyEntries(int count);

  /// No description provided for @consumptionChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Consumption trend ({unit}/100 km)'**
  String consumptionChartTitle(String unit);

  /// No description provided for @needMoreCharges.
  ///
  /// In en, this message translates to:
  /// **'Log at least three full charges with odometer readings to see a trend.'**
  String get needMoreCharges;

  /// No description provided for @needMoreFillUps.
  ///
  /// In en, this message translates to:
  /// **'Log at least three full fill-ups with odometer readings to see a trend.'**
  String get needMoreFillUps;

  /// No description provided for @measuredFullToFull.
  ///
  /// In en, this message translates to:
  /// **'Measured full-to-full; compare with your garage value {value} {unit}/100 km.'**
  String measuredFullToFull(String value, String unit);

  /// No description provided for @entries.
  ///
  /// In en, this message translates to:
  /// **'Entries'**
  String get entries;

  /// No description provided for @monthlySpendingSemantics.
  ///
  /// In en, this message translates to:
  /// **'Monthly spending: {values}'**
  String monthlySpendingSemantics(String values);

  /// No description provided for @consumptionTrendSemantics.
  ///
  /// In en, this message translates to:
  /// **'Consumption trend: {values}'**
  String consumptionTrendSemantics(String values);

  /// No description provided for @entryDeleted.
  ///
  /// In en, this message translates to:
  /// **'Entry deleted'**
  String get entryDeleted;

  /// No description provided for @couldNotDeleteEntry.
  ///
  /// In en, this message translates to:
  /// **'Could not delete entry'**
  String get couldNotDeleteEntry;

  /// No description provided for @deleteEntry.
  ///
  /// In en, this message translates to:
  /// **'Delete entry'**
  String get deleteEntry;

  /// No description provided for @partialFill.
  ///
  /// In en, this message translates to:
  /// **'partial'**
  String get partialFill;

  /// No description provided for @addVehicleFirst.
  ///
  /// In en, this message translates to:
  /// **'Add a vehicle in your garage first.'**
  String get addVehicleFirst;

  /// No description provided for @enterPositiveNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a positive number'**
  String get enterPositiveNumber;

  /// No description provided for @odometerMustIncrease.
  ///
  /// In en, this message translates to:
  /// **'Must be above the previous reading ({value} km)'**
  String odometerMustIncrease(String value);

  /// No description provided for @couldNotSaveFillUp.
  ///
  /// In en, this message translates to:
  /// **'Could not save fill-up'**
  String get couldNotSaveFillUp;

  /// No description provided for @addChargingSession.
  ///
  /// In en, this message translates to:
  /// **'Add charging session'**
  String get addChargingSession;

  /// No description provided for @energyCharged.
  ///
  /// In en, this message translates to:
  /// **'Energy charged'**
  String get energyCharged;

  /// No description provided for @fuelAdded.
  ///
  /// In en, this message translates to:
  /// **'Fuel added'**
  String get fuelAdded;

  /// No description provided for @totalPaid.
  ///
  /// In en, this message translates to:
  /// **'Total paid'**
  String get totalPaid;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @currencyCodeError.
  ///
  /// In en, this message translates to:
  /// **'3-letter code'**
  String get currencyCodeError;

  /// No description provided for @unitPriceLine.
  ///
  /// In en, this message translates to:
  /// **'Unit price: {price}/{unit}'**
  String unitPriceLine(String price, String unit);

  /// No description provided for @odometerOptional.
  ///
  /// In en, this message translates to:
  /// **'Odometer (optional)'**
  String get odometerOptional;

  /// No description provided for @odometerHelper.
  ///
  /// In en, this message translates to:
  /// **'Needed to measure real consumption and cost per km.'**
  String get odometerHelper;

  /// No description provided for @chargedToTarget.
  ///
  /// In en, this message translates to:
  /// **'Charged to my usual target'**
  String get chargedToTarget;

  /// No description provided for @filledTank.
  ///
  /// In en, this message translates to:
  /// **'Filled the tank'**
  String get filledTank;

  /// No description provided for @partialFillHelp.
  ///
  /// In en, this message translates to:
  /// **'Partial fills are added to the next full one.'**
  String get partialFillHelp;

  /// No description provided for @stationOptional.
  ///
  /// In en, this message translates to:
  /// **'Station (optional)'**
  String get stationOptional;

  /// No description provided for @couldNotSaveVehicle.
  ///
  /// In en, this message translates to:
  /// **'Could not save vehicle'**
  String get couldNotSaveVehicle;

  /// No description provided for @editVehicle.
  ///
  /// In en, this message translates to:
  /// **'Edit vehicle'**
  String get editVehicle;

  /// No description provided for @vehicleName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get vehicleName;

  /// No description provided for @vehicleNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Toyota Corolla'**
  String get vehicleNameHint;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get enterName;

  /// No description provided for @energyFuel.
  ///
  /// In en, this message translates to:
  /// **'Fuel'**
  String get energyFuel;

  /// No description provided for @energyElectric.
  ///
  /// In en, this message translates to:
  /// **'Electric'**
  String get energyElectric;

  /// No description provided for @consumption.
  ///
  /// In en, this message translates to:
  /// **'Consumption'**
  String get consumption;

  /// No description provided for @usableBatteryCapacity.
  ///
  /// In en, this message translates to:
  /// **'Usable battery capacity'**
  String get usableBatteryCapacity;

  /// No description provided for @tankCapacityLabel.
  ///
  /// In en, this message translates to:
  /// **'Tank capacity'**
  String get tankCapacityLabel;

  /// No description provided for @fuelTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Fuel type'**
  String get fuelTypeLabel;

  /// No description provided for @chargingEfficiency.
  ///
  /// In en, this message translates to:
  /// **'Charging efficiency'**
  String get chargingEfficiency;

  /// No description provided for @chargingEfficiencyHelper.
  ///
  /// In en, this message translates to:
  /// **'Share of bought energy that reaches the battery. Leave 100 if unsure.'**
  String get chargingEfficiencyHelper;

  /// No description provided for @efficiencyRangeError.
  ///
  /// In en, this message translates to:
  /// **'Enter a value between 1 and 100'**
  String get efficiencyRangeError;

  /// No description provided for @saveVehicle.
  ///
  /// In en, this message translates to:
  /// **'Save vehicle'**
  String get saveVehicle;

  /// No description provided for @fuelDiesel.
  ///
  /// In en, this message translates to:
  /// **'Diesel'**
  String get fuelDiesel;

  /// No description provided for @fuelDieselPlus.
  ///
  /// In en, this message translates to:
  /// **'Diesel+'**
  String get fuelDieselPlus;

  /// No description provided for @fuelTruckDiesel.
  ///
  /// In en, this message translates to:
  /// **'Truck diesel'**
  String get fuelTruckDiesel;

  /// No description provided for @fuelBioDiesel.
  ///
  /// In en, this message translates to:
  /// **'Biodiesel'**
  String get fuelBioDiesel;

  /// No description provided for @fuelRegular.
  ///
  /// In en, this message translates to:
  /// **'Regular'**
  String get fuelRegular;

  /// No description provided for @fuelMidgrade.
  ///
  /// In en, this message translates to:
  /// **'Midgrade'**
  String get fuelMidgrade;

  /// No description provided for @fuelPremium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get fuelPremium;

  /// No description provided for @fuelMethane.
  ///
  /// In en, this message translates to:
  /// **'CNG / Methane'**
  String get fuelMethane;

  /// No description provided for @fuelEvCharging.
  ///
  /// In en, this message translates to:
  /// **'EV charging'**
  String get fuelEvCharging;

  /// No description provided for @connectorWallOutlet.
  ///
  /// In en, this message translates to:
  /// **'Wall outlet'**
  String get connectorWallOutlet;

  /// No description provided for @connectorOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get connectorOther;

  /// No description provided for @communityPrices.
  ///
  /// In en, this message translates to:
  /// **'Community prices'**
  String get communityPrices;

  /// No description provided for @reportPrice.
  ///
  /// In en, this message translates to:
  /// **'Report price'**
  String get reportPrice;

  /// No description provided for @communityOff.
  ///
  /// In en, this message translates to:
  /// **'Community prices are turned off in this build.'**
  String get communityOff;

  /// No description provided for @noCommunityReports.
  ///
  /// In en, this message translates to:
  /// **'No community reports yet. Be the first to report a price.'**
  String get noCommunityReports;

  /// No description provided for @couldNotLoadCommunityPrices.
  ///
  /// In en, this message translates to:
  /// **'Could not load community prices.'**
  String get couldNotLoadCommunityPrices;

  /// No description provided for @reportCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 report} other{{count} reports}}'**
  String reportCount(int count);

  /// No description provided for @communityReports.
  ///
  /// In en, this message translates to:
  /// **'Community · {reports}'**
  String communityReports(String reports);

  /// No description provided for @updatedAgo.
  ///
  /// In en, this message translates to:
  /// **'updated {time}'**
  String updatedAgo(String time);

  /// No description provided for @outdated.
  ///
  /// In en, this message translates to:
  /// **'outdated'**
  String get outdated;

  /// No description provided for @priceHistory.
  ///
  /// In en, this message translates to:
  /// **'Price history'**
  String get priceHistory;

  /// No description provided for @fuelHistory.
  ///
  /// In en, this message translates to:
  /// **'{fuel} history'**
  String fuelHistory(String fuel);

  /// No description provided for @days7.
  ///
  /// In en, this message translates to:
  /// **'7 days'**
  String get days7;

  /// No description provided for @days30.
  ///
  /// In en, this message translates to:
  /// **'30 days'**
  String get days30;

  /// No description provided for @noHistoryForPeriod.
  ///
  /// In en, this message translates to:
  /// **'No history for this period yet.'**
  String get noHistoryForPeriod;

  /// No description provided for @couldNotLoadPriceHistory.
  ///
  /// In en, this message translates to:
  /// **'Could not load history.'**
  String get couldNotLoadPriceHistory;

  /// No description provided for @priceHistorySemantics.
  ///
  /// In en, this message translates to:
  /// **'Community price history in {currency}: {summary}'**
  String priceHistorySemantics(String currency, String summary);

  /// No description provided for @thanksForConfirming.
  ///
  /// In en, this message translates to:
  /// **'Thanks for confirming!'**
  String get thanksForConfirming;

  /// No description provided for @reliabilitySemantics.
  ///
  /// In en, this message translates to:
  /// **'Data reliability {percent} percent'**
  String reliabilitySemantics(int percent);

  /// No description provided for @votesOpen.
  ///
  /// In en, this message translates to:
  /// **'{count} said open'**
  String votesOpen(int count);

  /// No description provided for @votesClosed.
  ///
  /// In en, this message translates to:
  /// **'{count} said closed'**
  String votesClosed(int count);

  /// No description provided for @votesOutOfFuel.
  ///
  /// In en, this message translates to:
  /// **'{count} said out of fuel'**
  String votesOutOfFuel(int count);

  /// No description provided for @reliabilityDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Based on recent community reports and votes — not an official check.'**
  String get reliabilityDisclaimer;

  /// No description provided for @isItOpenNow.
  ///
  /// In en, this message translates to:
  /// **'Is it open right now?'**
  String get isItOpenNow;

  /// No description provided for @voteOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get voteOpen;

  /// No description provided for @voteClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get voteClosed;

  /// No description provided for @voteOutOfFuel.
  ///
  /// In en, this message translates to:
  /// **'Out of fuel'**
  String get voteOutOfFuel;

  /// No description provided for @reliabilityNone.
  ///
  /// In en, this message translates to:
  /// **'Not enough community data'**
  String get reliabilityNone;

  /// No description provided for @reliabilityHigh.
  ///
  /// In en, this message translates to:
  /// **'Recently confirmed by the community'**
  String get reliabilityHigh;

  /// No description provided for @reliabilityMedium.
  ///
  /// In en, this message translates to:
  /// **'Some community reports'**
  String get reliabilityMedium;

  /// No description provided for @reliabilityLow.
  ///
  /// In en, this message translates to:
  /// **'Community reports are old or disagree'**
  String get reliabilityLow;

  /// No description provided for @reportAccepted.
  ///
  /// In en, this message translates to:
  /// **'Thanks! Your price is now part of the community price.'**
  String get reportAccepted;

  /// No description provided for @reportMinorityCurrency.
  ///
  /// In en, this message translates to:
  /// **'Saved, but most reports here use another currency.'**
  String get reportMinorityCurrency;

  /// No description provided for @reportOutlier.
  ///
  /// In en, this message translates to:
  /// **'This price is far from other recent reports, so it was not used.'**
  String get reportOutlier;

  /// No description provided for @reportDuplicate.
  ///
  /// In en, this message translates to:
  /// **'You already reported this fuel here a few minutes ago.'**
  String get reportDuplicate;

  /// No description provided for @reportTooMany.
  ///
  /// In en, this message translates to:
  /// **'Too many reports in the last hour. Please try later.'**
  String get reportTooMany;

  /// No description provided for @reportRejected.
  ///
  /// In en, this message translates to:
  /// **'This report was not accepted.'**
  String get reportRejected;

  /// No description provided for @reportSent.
  ///
  /// In en, this message translates to:
  /// **'Report sent. It will be checked in a moment.'**
  String get reportSent;

  /// No description provided for @enterPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter a price'**
  String get enterPrice;

  /// No description provided for @enterPriceRange.
  ///
  /// In en, this message translates to:
  /// **'Enter a price between 0.01 and 1000'**
  String get enterPriceRange;

  /// No description provided for @reportAPrice.
  ///
  /// In en, this message translates to:
  /// **'Report a price'**
  String get reportAPrice;

  /// No description provided for @fuel.
  ///
  /// In en, this message translates to:
  /// **'Fuel'**
  String get fuel;

  /// No description provided for @pricePerUnit.
  ///
  /// In en, this message translates to:
  /// **'Price per {unit}'**
  String pricePerUnit(String unit);

  /// No description provided for @reportPriceHelp.
  ///
  /// In en, this message translates to:
  /// **'Report the price shown at the pump right now. Reports are combined with others; prices far from recent reports are not used.'**
  String get reportPriceHelp;

  /// No description provided for @sending.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get sending;

  /// No description provided for @sendReport.
  ///
  /// In en, this message translates to:
  /// **'Send report'**
  String get sendReport;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @priceAlerts.
  ///
  /// In en, this message translates to:
  /// **'Price alerts'**
  String get priceAlerts;

  /// No description provided for @newAlert.
  ///
  /// In en, this message translates to:
  /// **'New alert'**
  String get newAlert;

  /// No description provided for @alertsUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Alerts are not available'**
  String get alertsUnavailableTitle;

  /// No description provided for @alertsUnavailableMessage.
  ///
  /// In en, this message translates to:
  /// **'Price alerts need the FuelWise community backend, which is not set up in this build.'**
  String get alertsUnavailableMessage;

  /// No description provided for @noAlertsTitle.
  ///
  /// In en, this message translates to:
  /// **'No price alerts yet'**
  String get noAlertsTitle;

  /// No description provided for @noAlertsMessage.
  ///
  /// In en, this message translates to:
  /// **'Create an alert to hear when a community price near you drops below your limit.'**
  String get noAlertsMessage;

  /// No description provided for @alertsServerNote.
  ///
  /// In en, this message translates to:
  /// **'Alerts are checked by the server when a new community price is accepted. Push notifications are not enabled in this build yet.'**
  String get alertsServerNote;

  /// No description provided for @alertOnlyAt.
  ///
  /// In en, this message translates to:
  /// **'Only at {station}'**
  String alertOnlyAt(String station);

  /// No description provided for @alertWithinKm.
  ///
  /// In en, this message translates to:
  /// **'Within {km} km of the saved location'**
  String alertWithinKm(String km);

  /// No description provided for @alertOn.
  ///
  /// In en, this message translates to:
  /// **'Alert on'**
  String get alertOn;

  /// No description provided for @alertPaused.
  ///
  /// In en, this message translates to:
  /// **'Alert paused'**
  String get alertPaused;

  /// No description provided for @deleteAlert.
  ///
  /// In en, this message translates to:
  /// **'Delete alert'**
  String get deleteAlert;

  /// No description provided for @alertDeleted.
  ///
  /// In en, this message translates to:
  /// **'Alert deleted'**
  String get alertDeleted;

  /// No description provided for @couldNotLoadAlerts.
  ///
  /// In en, this message translates to:
  /// **'Could not load alerts.'**
  String get couldNotLoadAlerts;

  /// No description provided for @alertSaved.
  ///
  /// In en, this message translates to:
  /// **'Alert saved'**
  String get alertSaved;

  /// No description provided for @newPriceAlert.
  ///
  /// In en, this message translates to:
  /// **'New price alert'**
  String get newPriceAlert;

  /// No description provided for @alertAtOrBelow.
  ///
  /// In en, this message translates to:
  /// **'Alert at or below'**
  String get alertAtOrBelow;

  /// No description provided for @alertRadius.
  ///
  /// In en, this message translates to:
  /// **'Within {km} km of my current location'**
  String alertRadius(int km);

  /// No description provided for @saveAlert.
  ///
  /// In en, this message translates to:
  /// **'Save alert'**
  String get saveAlert;

  /// No description provided for @badgeCheapest.
  ///
  /// In en, this message translates to:
  /// **'Cheapest'**
  String get badgeCheapest;

  /// No description provided for @badgeBestValue.
  ///
  /// In en, this message translates to:
  /// **'Best value'**
  String get badgeBestValue;

  /// No description provided for @badgeLeastDetour.
  ///
  /// In en, this message translates to:
  /// **'Least detour'**
  String get badgeLeastDetour;

  /// No description provided for @badgeMostReliable.
  ///
  /// In en, this message translates to:
  /// **'Most reliable'**
  String get badgeMostReliable;

  /// No description provided for @caveatClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed now'**
  String get caveatClosed;

  /// No description provided for @caveatUnreachable.
  ///
  /// In en, this message translates to:
  /// **'May be out of range'**
  String get caveatUnreachable;

  /// No description provided for @caveatOtherCurrency.
  ///
  /// In en, this message translates to:
  /// **'Other currency (not converted)'**
  String get caveatOtherCurrency;

  /// No description provided for @caveatPriceUnknown.
  ///
  /// In en, this message translates to:
  /// **'No price available'**
  String get caveatPriceUnknown;

  /// No description provided for @caveatStalePrice.
  ///
  /// In en, this message translates to:
  /// **'Price older than 3 days'**
  String get caveatStalePrice;

  /// No description provided for @onRoute.
  ///
  /// In en, this message translates to:
  /// **'on route'**
  String get onRoute;

  /// No description provided for @explainNoPrice.
  ///
  /// In en, this message translates to:
  /// **'No price is available for this station, so its cost cannot be compared.'**
  String get explainNoPrice;

  /// No description provided for @explainUnitOnly.
  ///
  /// In en, this message translates to:
  /// **'{price} per {unit}. Add a vehicle in your garage to compare the total trip cost.'**
  String explainUnitOnly(String price, String unit);

  /// No description provided for @explainBuy.
  ///
  /// In en, this message translates to:
  /// **'Buy {amount} {unit} × {price} = {cost}'**
  String explainBuy(String amount, String unit, String price, String cost);

  /// No description provided for @explainDetour.
  ///
  /// In en, this message translates to:
  /// **'Detour {distance} uses {amount} {unit} = {cost}'**
  String explainDetour(
    String distance,
    String amount,
    String unit,
    String cost,
  );

  /// No description provided for @explainSaves.
  ///
  /// In en, this message translates to:
  /// **' · saves {amount} vs the nearest station'**
  String explainSaves(String amount);

  /// No description provided for @explainMore.
  ///
  /// In en, this message translates to:
  /// **' · {amount} more than the nearest station'**
  String explainMore(String amount);

  /// No description provided for @explainTotal.
  ///
  /// In en, this message translates to:
  /// **'Total {cost}{comparison}'**
  String explainTotal(String cost, String comparison);

  /// No description provided for @explainSourceGoogle.
  ///
  /// In en, this message translates to:
  /// **'Price source: Google'**
  String get explainSourceGoogle;

  /// No description provided for @explainSourceCommunity.
  ///
  /// In en, this message translates to:
  /// **'Price source: community'**
  String get explainSourceCommunity;

  /// No description provided for @explainUpdated.
  ///
  /// In en, this message translates to:
  /// **', updated {time}'**
  String explainUpdated(String time);

  /// No description provided for @trip.
  ///
  /// In en, this message translates to:
  /// **'Trip'**
  String get trip;

  /// No description provided for @tripTo.
  ///
  /// In en, this message translates to:
  /// **'To {destination}'**
  String tripTo(String destination);

  /// No description provided for @changeDestination.
  ///
  /// In en, this message translates to:
  /// **'Change destination'**
  String get changeDestination;

  /// No description provided for @couldNotPlanTrip.
  ///
  /// In en, this message translates to:
  /// **'Could not plan this trip.'**
  String get couldNotPlanTrip;

  /// No description provided for @noTripYet.
  ///
  /// In en, this message translates to:
  /// **'No trip yet'**
  String get noTripYet;

  /// No description provided for @noTripMessage.
  ///
  /// In en, this message translates to:
  /// **'Choose a destination to find stations along the way.'**
  String get noTripMessage;

  /// No description provided for @chooseDestination.
  ///
  /// In en, this message translates to:
  /// **'Choose destination'**
  String get chooseDestination;

  /// No description provided for @findingAlongRoute.
  ///
  /// In en, this message translates to:
  /// **'Finding stations along your route…'**
  String get findingAlongRoute;

  /// No description provided for @stationsOnTheWay.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 station on the way} other{{count} stations on the way}}'**
  String stationsOnTheWay(int count);

  /// No description provided for @comparingFuelPrices.
  ///
  /// In en, this message translates to:
  /// **'Comparing {fuel} prices'**
  String comparingFuelPrices(String fuel);

  /// No description provided for @detoursApproximate.
  ///
  /// In en, this message translates to:
  /// **'Routing service unavailable — detours are straight-line estimates.'**
  String get detoursApproximate;

  /// No description provided for @skippedForDetour.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 more station farther from the route was not compared.} other{{count} more stations farther from the route were not compared.}}'**
  String skippedForDetour(int count);

  /// No description provided for @noStationsAlongRoute.
  ///
  /// In en, this message translates to:
  /// **'No stations along this route'**
  String get noStationsAlongRoute;

  /// No description provided for @nothingWithin5km.
  ///
  /// In en, this message translates to:
  /// **'Nothing found within 5 km of the route.'**
  String get nothingWithin5km;

  /// No description provided for @withoutComparablePrice.
  ///
  /// In en, this message translates to:
  /// **'Without a comparable price ({count})'**
  String withoutComparablePrice(int count);

  /// No description provided for @comparingPricePerLitre.
  ///
  /// In en, this message translates to:
  /// **'Comparing price per litre only'**
  String get comparingPricePerLitre;

  /// No description provided for @addVehicleForTrueCost.
  ///
  /// In en, this message translates to:
  /// **'Add your vehicle to rank by true trip cost.'**
  String get addVehicleForTrueCost;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @batteryNowToFull.
  ///
  /// In en, this message translates to:
  /// **'{vehicle} · battery now {percent}% → full ({amount} {unit})'**
  String batteryNowToFull(
    String vehicle,
    int percent,
    String amount,
    String unit,
  );

  /// No description provided for @tankNowToFull.
  ///
  /// In en, this message translates to:
  /// **'{vehicle} · tank now {percent}% → full ({amount} {unit})'**
  String tankNowToFull(String vehicle, int percent, String amount, String unit);

  /// No description provided for @percentCharge.
  ///
  /// In en, this message translates to:
  /// **'{percent} percent charge'**
  String percentCharge(int percent);

  /// No description provided for @percentFuel.
  ///
  /// In en, this message translates to:
  /// **'{percent} percent fuel'**
  String percentFuel(int percent);

  /// No description provided for @intoTheTrip.
  ///
  /// In en, this message translates to:
  /// **'{detour} · {distance} into the trip'**
  String intoTheTrip(String detour, String distance);

  /// No description provided for @showOnMap.
  ///
  /// In en, this message translates to:
  /// **'Show on map'**
  String get showOnMap;

  /// No description provided for @whereTo.
  ///
  /// In en, this message translates to:
  /// **'Where to?'**
  String get whereTo;

  /// No description provided for @searchFailed.
  ///
  /// In en, this message translates to:
  /// **'Search failed.'**
  String get searchFailed;

  /// No description provided for @searching.
  ///
  /// In en, this message translates to:
  /// **'Searching…'**
  String get searching;

  /// No description provided for @noPlacesFound.
  ///
  /// In en, this message translates to:
  /// **'No places found'**
  String get noPlacesFound;

  /// No description provided for @tryAnotherName.
  ///
  /// In en, this message translates to:
  /// **'Try another name or address.'**
  String get tryAnotherName;

  /// No description provided for @destinationSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search a destination. FuelWise finds stations along your route and ranks them by the true cost of stopping — price plus the fuel used by the detour.'**
  String get destinationSearchHint;

  /// No description provided for @powerAny.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get powerAny;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @minimumPower.
  ///
  /// In en, this message translates to:
  /// **'Minimum power'**
  String get minimumPower;

  /// No description provided for @connector.
  ///
  /// In en, this message translates to:
  /// **'Connector'**
  String get connector;

  /// No description provided for @noConnectorDataNearby.
  ///
  /// In en, this message translates to:
  /// **'No connector data nearby.'**
  String get noConnectorDataNearby;

  /// No description provided for @onlyOperational.
  ///
  /// In en, this message translates to:
  /// **'Only operational'**
  String get onlyOperational;

  /// No description provided for @onlyOperationalHelp.
  ///
  /// In en, this message translates to:
  /// **'Hide chargers reported as not working or with unknown status.'**
  String get onlyOperationalHelp;

  /// No description provided for @statusOperational.
  ///
  /// In en, this message translates to:
  /// **'Operational'**
  String get statusOperational;

  /// No description provided for @statusNotOperational.
  ///
  /// In en, this message translates to:
  /// **'Not operational'**
  String get statusNotOperational;

  /// No description provided for @statusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Status unknown'**
  String get statusUnknown;

  /// No description provided for @upToPower.
  ///
  /// In en, this message translates to:
  /// **'Up to {power}'**
  String upToPower(String power);

  /// No description provided for @fastSuffix.
  ///
  /// In en, this message translates to:
  /// **' · fast'**
  String get fastSuffix;

  /// No description provided for @chargingPoints.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 charging point} other{{count} charging points}}'**
  String chargingPoints(int count);

  /// No description provided for @connectors.
  ///
  /// In en, this message translates to:
  /// **'Connectors'**
  String get connectors;

  /// No description provided for @noConnectorDetails.
  ///
  /// In en, this message translates to:
  /// **'No connector details reported.'**
  String get noConnectorDetails;

  /// No description provided for @notOperationalLower.
  ///
  /// In en, this message translates to:
  /// **'not operational'**
  String get notOperationalLower;

  /// No description provided for @cost.
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get cost;

  /// No description provided for @noCostInfo.
  ///
  /// In en, this message translates to:
  /// **'No cost information reported. Check the operator app or the charger display.'**
  String get noCostInfo;

  /// No description provided for @costAsListed.
  ///
  /// In en, this message translates to:
  /// **'\"{cost}\" — as listed by the community; not verified by FuelWise.'**
  String costAsListed(String cost);

  /// No description provided for @lastVerified.
  ///
  /// In en, this message translates to:
  /// **'Last verified {time}'**
  String lastVerified(String time);

  /// No description provided for @statusUpdated.
  ///
  /// In en, this message translates to:
  /// **'status updated {time}'**
  String statusUpdated(String time);

  /// No description provided for @monthsShort.
  ///
  /// In en, this message translates to:
  /// **'Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec'**
  String get monthsShort;

  /// No description provided for @errorCareSave.
  ///
  /// In en, this message translates to:
  /// **'Could not save the reminder. Please try again.'**
  String get errorCareSave;
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
