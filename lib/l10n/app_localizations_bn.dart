// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'FuelWise';

  @override
  String get navMap => 'ম্যাপ';

  @override
  String get navHistory => 'ইতিহাস';

  @override
  String get navGarage => 'গ্যারেজ';

  @override
  String get loading => 'লোড হচ্ছে';

  @override
  String get somethingWentWrong => 'কিছু একটা সমস্যা হয়েছে';

  @override
  String get tryAgain => 'আবার চেষ্টা করুন';

  @override
  String get retry => 'আবার চেষ্টা';

  @override
  String get cancel => 'বাতিল';

  @override
  String get delete => 'মুছুন';

  @override
  String get edit => 'সম্পাদনা';

  @override
  String get undo => 'ফিরিয়ে আনুন';

  @override
  String get language => 'ভাষা';

  @override
  String get languageSystem => 'ডিভাইসের ভাষা';

  @override
  String get languageEnglish => 'English (ইংরেজি)';

  @override
  String get languageBengali => 'বাংলা';

  @override
  String get tooltipAssistant => 'ট্রিপ সহকারী';

  @override
  String get tooltipAlerts => 'দামের সতর্কতা';

  @override
  String get planTrip => 'ট্রিপ পরিকল্পনা';

  @override
  String get findingLocation => 'আপনার অবস্থান খোঁজা হচ্ছে…';

  @override
  String get openAppSettings => 'অ্যাপ সেটিংস খুলুন';

  @override
  String get openLocationSettings => 'লোকেশন সেটিংস খুলুন';

  @override
  String get locationNeeded => 'লোকেশন প্রয়োজন';

  @override
  String get couldNotDetermineLocation => 'আপনার অবস্থান নির্ণয় করা যায়নি।';

  @override
  String get couldNotGetDirections => 'পথনির্দেশ পাওয়া যায়নি।';

  @override
  String get searchingStations => 'কাছের স্টেশন খোঁজা হচ্ছে…';

  @override
  String get couldNotLoadStations => 'স্টেশন লোড করা যায়নি।';

  @override
  String get noStationsNearby => '৫ কিমির মধ্যে কোনো ফুয়েল স্টেশন নেই।';

  @override
  String stationsNearby(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'কাছে $countটি স্টেশন',
    );
    return '$_temp0';
  }

  @override
  String offlineSavedStations(int count, String age) {
    return 'অফলাইন · $countটি সংরক্ষিত স্টেশনের অবস্থান ($age)। নাম ও দাম দেখতে ইন্টারনেট লাগবে।';
  }

  @override
  String get searchingChargers => 'চার্জার খোঁজা হচ্ছে…';

  @override
  String get couldNotLoadChargers => 'চার্জার লোড করা যায়নি।';

  @override
  String get noChargersMatchFilters =>
      'আপনার ফিল্টারের সাথে মেলে এমন কোনো চার্জার নেই।';

  @override
  String get noChargersNearby => '১০ কিমির মধ্যে কোনো চার্জার নেই।';

  @override
  String chargersNearby(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'কাছে $countটি চার্জার',
    );
    return '$_temp0';
  }

  @override
  String chargersNearbyFiltered(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'কাছে $countটি চার্জার (ফিল্টার করা)',
    );
    return '$_temp0';
  }

  @override
  String get modeFuel => 'ফুয়েল';

  @override
  String get modeEv => 'ইভি';

  @override
  String get chargerFilters => 'চার্জার ফিল্টার';

  @override
  String get calculatingRoute => 'রুট হিসাব করা হচ্ছে…';

  @override
  String get clearRoute => 'রুট মুছুন';

  @override
  String distanceAwayStraight(String distance) {
    return '$distance দূরে (সরলরেখায়)';
  }

  @override
  String get directions => 'পথনির্দেশ';

  @override
  String get couldNotLoadStationDetails => 'স্টেশনের তথ্য লোড করা যায়নি।';

  @override
  String get loadingStationDetails => 'স্টেশনের তথ্য লোড হচ্ছে';

  @override
  String get openNow => 'এখন খোলা';

  @override
  String get closed => 'বন্ধ';

  @override
  String get fuelPrices => 'জ্বালানির দাম';

  @override
  String get fuelPricesUnavailable =>
      'এই স্টেশনের জ্বালানির দাম পাওয়া যায়নি।';

  @override
  String get evCharging => 'ইভি চার্জিং';

  @override
  String connectorCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি কানেক্টর',
    );
    return '$_temp0';
  }

  @override
  String availableReported(int count) {
    return '$countটি খালি (রিপোর্ট অনুযায়ী)';
  }

  @override
  String get openingHours => 'খোলার সময়';

  @override
  String get sourceGoogle => 'উৎস: Google';

  @override
  String sourceGoogleUpdated(String age) {
    return 'উৎস: Google · হালনাগাদ $age';
  }

  @override
  String get garageTitle => 'আমার গ্যারেজ';

  @override
  String get addVehicle => 'গাড়ি যোগ করুন';

  @override
  String get noVehiclesTitle => 'এখনো কোনো গাড়ি নেই';

  @override
  String get noVehiclesMessage =>
      'আপনার গাড়ি বা ইভি যোগ করুন, যাতে FuelWise আসল ট্রিপ খরচ ও রেঞ্জ হিসাব করতে পারে।';

  @override
  String get couldNotLoadGarage => 'আপনার গ্যারেজ লোড করা যায়নি।';

  @override
  String deleteVehicleTitle(String name) {
    return '$name মুছবেন?';
  }

  @override
  String get deleteVehicleBody => 'এটি গাড়িটি আপনার গ্যারেজ থেকে সরিয়ে দেবে।';

  @override
  String vehicleDeleted(String name) {
    return '$name মুছে ফেলা হয়েছে';
  }

  @override
  String get couldNotDeleteVehicle => 'গাড়ি মোছা যায়নি';

  @override
  String batteryCapacity(String capacity) {
    return '$capacity ব্যাটারি';
  }

  @override
  String tankCapacity(String capacity) {
    return '$capacity ট্যাংক';
  }

  @override
  String get activeVehicle => 'সক্রিয় গাড়ি';

  @override
  String fullChargeRange(String distance) {
    return 'পূর্ণ চার্জে রেঞ্জ ≈ $distance';
  }

  @override
  String fullTankRange(String distance) {
    return 'পূর্ণ ট্যাংকে রেঞ্জ ≈ $distance';
  }

  @override
  String get vehicleOptions => 'গাড়ির অপশন';

  @override
  String get assistantTitle => 'ট্রিপ সহকারী';

  @override
  String get assistantNewChat => 'নতুন চ্যাট';

  @override
  String get assistantUnavailableTitle => 'সহকারী পাওয়া যাচ্ছে না';

  @override
  String get assistantUnavailableMessage =>
      'ট্রিপ সহকারী FuelWise সার্ভারে চলে, যা এই বিল্ডে চালু করা নেই।';

  @override
  String get assistantInputHint =>
      'আপনার ট্রিপে ফুয়েল বা চার্জিং নিয়ে জিজ্ঞেস করুন';

  @override
  String get assistantSend => 'পাঠান';

  @override
  String get assistantFooter =>
      'উত্তরগুলো অ্যাপের নিজস্ব রুট র‍্যাংকিং ব্যবহার করে। পাম্পে দাম যাচাই করে নিন।';

  @override
  String get assistantWelcomeTitle => 'আরও বুদ্ধিমানভাবে থামুন';

  @override
  String get assistantWelcomeBody =>
      'আপনি কোথায় যাচ্ছেন বলুন। আপনার গ্যারেজের গাড়ি অনুযায়ী পথের ফুয়েল বা চার্জিং স্টপগুলো মোট খরচ, বাড়তি পথ ও নির্ভরযোগ্যতা দিয়ে সাজিয়ে দেব।';

  @override
  String get assistantSuggestion1 => 'এয়ারপোর্টে যাওয়ার পথে কোথায় তেল নেব?';

  @override
  String get assistantSuggestion2 =>
      'হামবুর্গ যাওয়ার পথে সবচেয়ে সস্তা চার্জিং স্টপ কোনটি?';

  @override
  String get assistantSuggestion3 =>
      'অফিসে যাওয়ার পথে কোন স্টেশনে সবচেয়ে কম ঘুরতে হবে?';

  @override
  String get assistantThinking => 'ভাবছি…';

  @override
  String get assistantPlanning => 'রুট পরিকল্পনা ও স্টেশন সাজানো হচ্ছে…';

  @override
  String get assistantCheckingVehicle => 'আপনার গাড়ির তথ্য দেখছি…';

  @override
  String get assistantWorking => 'কাজ চলছে…';

  @override
  String get assistantDemoLabel => 'অফলাইন ডেমো — Claude নয়';

  @override
  String get assistantTooManySteps =>
      'অনেক বেশি ধাপ লেগে গেছে। একটু সহজ প্রশ্ন করে দেখুন।';

  @override
  String get errorNetwork =>
      'ইন্টারনেট সংযোগ নেই। নেটওয়ার্ক দেখে আবার চেষ্টা করুন।';

  @override
  String get errorTimeout =>
      'সার্ভার সাড়া দিতে অনেক সময় নিয়েছে। আবার চেষ্টা করুন।';

  @override
  String get errorNotFound => 'কিছু পাওয়া যায়নি।';

  @override
  String get errorUnknown => 'কিছু একটা সমস্যা হয়েছে। আবার চেষ্টা করুন।';

  @override
  String get errorCancelled => 'অনুরোধটি বাতিল হয়েছে।';

  @override
  String get errorBadResponse => 'সার্ভার থেকে অপ্রত্যাশিত উত্তর এসেছে।';

  @override
  String get errorRequestRejected =>
      'ম্যাপ সার্ভিস অনুরোধটি গ্রহণ করেনি। API key ও তার restrictions দেখুন।';

  @override
  String get errorTooManyRequests =>
      'অনেক বেশি অনুরোধ হয়েছে। একটু অপেক্ষা করুন।';

  @override
  String errorServer(String status) {
    return 'সার্ভার ত্রুটি ($status)। আবার চেষ্টা করুন।';
  }

  @override
  String get errorMissingGoogleKey =>
      'এই বিল্ডে Google Maps API key সেট করা নেই।';

  @override
  String get errorMissingOcmKey =>
      'এই বিল্ডে Open Charge Map API key সেট করা নেই।';

  @override
  String get errorCommunityUnavailable =>
      'এই বিল্ডে কমিউনিটি দাম চালু করা নেই।';

  @override
  String get errorCommunityNeedsSignIn =>
      'কমিউনিটি ফিচারের জন্য Firebase-এ anonymous sign-in চালু থাকতে হবে।';

  @override
  String get errorNotAllowed =>
      'এই পরিবর্তনটি অনুমোদিত নয়। মানগুলো দেখে আবার চেষ্টা করুন।';

  @override
  String get errorSignInFailed => 'সাইন ইন করা যায়নি।';

  @override
  String get errorAssistantFailed =>
      'অ্যাসিস্ট্যান্ট উত্তর দিতে পারেনি। আবার চেষ্টা করুন।';

  @override
  String get errorNoDetours => 'ঘুরপথ হিসাব করা যায়নি।';

  @override
  String get errorNoRouteToDestination =>
      'গন্তব্যে যাওয়ার কোনো পথ পাওয়া যায়নি।';

  @override
  String get errorNoRouteToStation =>
      'এই স্টেশনে গাড়ি চালিয়ে যাওয়ার কোনো পথ পাওয়া যায়নি।';

  @override
  String get errorHistorySave =>
      'আপনার ইতিহাস আপডেট করা যায়নি। আবার চেষ্টা করুন।';

  @override
  String get errorGarageSave =>
      'গ্যারেজে সংরক্ষণ করা যায়নি। আবার চেষ্টা করুন।';

  @override
  String get errorLocationServiceDisabled =>
      'লোকেশন সার্ভিস বন্ধ আছে। কাছের স্টেশন খুঁজতে এটি চালু করুন।';

  @override
  String get errorLocationDenied =>
      'কাছের স্টেশন খুঁজতে FuelWise-এর লোকেশন অনুমতি দরকার।';

  @override
  String get errorLocationDeniedForever =>
      'লোকেশন অনুমতি বন্ধ করা আছে। কাছের স্টেশন খুঁজতে Settings থেকে চালু করুন।';

  @override
  String get errorLocationUnavailable =>
      'আপনার অবস্থান নির্ধারণ করা যায়নি। আবার চেষ্টা করুন।';

  @override
  String get timeJustNow => 'এইমাত্র';

  @override
  String timeMinutesAgo(int count) {
    return '$count মিনিট আগে';
  }

  @override
  String timeHoursAgo(int count) {
    return '$count ঘণ্টা আগে';
  }

  @override
  String timeDaysAgo(int count) {
    return '$count দিন আগে';
  }

  @override
  String get save => 'সংরক্ষণ';

  @override
  String get saving => 'সংরক্ষণ হচ্ছে…';

  @override
  String get historyTitle => 'ইতিহাস';

  @override
  String historyTitleFor(String vehicle) {
    return 'ইতিহাস · $vehicle';
  }

  @override
  String get addCharge => 'চার্জ যোগ করুন';

  @override
  String get addFillUp => 'ফুয়েল যোগ করুন';

  @override
  String get couldNotLoadHistory => 'আপনার ইতিহাস লোড করা যায়নি।';

  @override
  String get noActiveVehicle => 'কোনো সক্রিয় গাড়ি নেই';

  @override
  String get noActiveVehicleMessage =>
      'ফুয়েল, খরচ ও মাইলেজ ট্র্যাক করতে গ্যারেজে একটি গাড়ি যোগ করুন।';

  @override
  String get openGarage => 'গ্যারেজ খুলুন';

  @override
  String get noChargesYet => 'এখনো কোনো চার্জিং সেশন নেই';

  @override
  String get noFillUpsYet => 'এখনো কোনো ফুয়েল এন্ট্রি নেই';

  @override
  String get logChargesHint =>
      'খরচ ও আসল খরচের হার দেখতে প্রতিটি চার্জ লিখে রাখুন।';

  @override
  String get logFillUpsHint =>
      'খরচ ও আসল মাইলেজ দেখতে প্রতিবার ফুয়েল নেওয়া লিখে রাখুন।';

  @override
  String get statThisMonth => 'এই মাস';

  @override
  String get statAvgConsumption => 'গড় খরচের হার';

  @override
  String get statCostPerKm => 'প্রতি কিমি খরচ';

  @override
  String spendingChartTitle(String currency) {
    return 'খরচ · গত ৬ মাস ($currency)';
  }

  @override
  String otherCurrencyEntries(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'অন্য মুদ্রার $countটি এন্ট্রি দেখানো হয়নি (রূপান্তর করা হয় না)।',
    );
    return '$_temp0';
  }

  @override
  String consumptionChartTitle(String unit) {
    return 'খরচের হারের প্রবণতা ($unit/100 km)';
  }

  @override
  String get needMoreCharges =>
      'প্রবণতা দেখতে ওডোমিটার রিডিংসহ অন্তত তিনটি পূর্ণ চার্জ লিখুন।';

  @override
  String get needMoreFillUps =>
      'প্রবণতা দেখতে ওডোমিটার রিডিংসহ অন্তত তিনবার ট্যাংক পূর্ণ করার তথ্য লিখুন।';

  @override
  String measuredFullToFull(String value, String unit) {
    return 'পূর্ণ থেকে পূর্ণ মাপা হয়েছে; গ্যারেজের মান $value $unit/100 km-এর সাথে তুলনা করুন।';
  }

  @override
  String get entries => 'এন্ট্রি';

  @override
  String monthlySpendingSemantics(String values) {
    return 'মাসিক খরচ: $values';
  }

  @override
  String consumptionTrendSemantics(String values) {
    return 'খরচের হারের প্রবণতা: $values';
  }

  @override
  String get entryDeleted => 'এন্ট্রি মুছে ফেলা হয়েছে';

  @override
  String get couldNotDeleteEntry => 'এন্ট্রি মুছে ফেলা যায়নি';

  @override
  String get deleteEntry => 'এন্ট্রি মুছুন';

  @override
  String get partialFill => 'আংশিক';

  @override
  String get addVehicleFirst => 'প্রথমে গ্যারেজে একটি গাড়ি যোগ করুন।';

  @override
  String get enterPositiveNumber => 'একটি ধনাত্মক সংখ্যা লিখুন';

  @override
  String odometerMustIncrease(String value) {
    return 'আগের রিডিং ($value km)-এর চেয়ে বেশি হতে হবে';
  }

  @override
  String get couldNotSaveFillUp => 'ফুয়েল এন্ট্রি সংরক্ষণ করা যায়নি';

  @override
  String get addChargingSession => 'চার্জিং সেশন যোগ করুন';

  @override
  String get energyCharged => 'চার্জ করা এনার্জি';

  @override
  String get fuelAdded => 'নেওয়া ফুয়েল';

  @override
  String get totalPaid => 'মোট পরিশোধ';

  @override
  String get currency => 'মুদ্রা';

  @override
  String get currencyCodeError => '৩ অক্ষরের কোড';

  @override
  String unitPriceLine(String price, String unit) {
    return 'একক দাম: $price/$unit';
  }

  @override
  String get odometerOptional => 'ওডোমিটার (ঐচ্ছিক)';

  @override
  String get odometerHelper =>
      'আসল খরচের হার ও প্রতি কিমি খরচ মাপার জন্য দরকার।';

  @override
  String get chargedToTarget => 'স্বাভাবিক লক্ষ্য পর্যন্ত চার্জ করেছি';

  @override
  String get filledTank => 'ট্যাংক পূর্ণ করেছি';

  @override
  String get partialFillHelp => 'আংশিক ভরা পরের পূর্ণ ভরার সাথে যোগ হয়।';

  @override
  String get stationOptional => 'স্টেশন (ঐচ্ছিক)';

  @override
  String get couldNotSaveVehicle => 'গাড়ি সংরক্ষণ করা যায়নি';

  @override
  String get editVehicle => 'গাড়ি সম্পাদনা';

  @override
  String get vehicleName => 'নাম';

  @override
  String get vehicleNameHint => 'যেমন Toyota Corolla';

  @override
  String get enterName => 'একটি নাম লিখুন';

  @override
  String get energyFuel => 'ফুয়েল';

  @override
  String get energyElectric => 'ইলেকট্রিক';

  @override
  String get consumption => 'খরচের হার';

  @override
  String get usableBatteryCapacity => 'ব্যবহারযোগ্য ব্যাটারি ক্ষমতা';

  @override
  String get tankCapacityLabel => 'ট্যাংকের ধারণক্ষমতা';

  @override
  String get fuelTypeLabel => 'ফুয়েলের ধরন';

  @override
  String get chargingEfficiency => 'চার্জিং দক্ষতা';

  @override
  String get chargingEfficiencyHelper =>
      'কেনা এনার্জির কত অংশ ব্যাটারিতে পৌঁছায়। নিশ্চিত না হলে 100 রাখুন।';

  @override
  String get efficiencyRangeError => '1 থেকে 100-এর মধ্যে একটি মান লিখুন';

  @override
  String get saveVehicle => 'গাড়ি সংরক্ষণ করুন';

  @override
  String get fuelDiesel => 'ডিজেল';

  @override
  String get fuelDieselPlus => 'ডিজেল+';

  @override
  String get fuelTruckDiesel => 'ট্রাক ডিজেল';

  @override
  String get fuelBioDiesel => 'বায়োডিজেল';

  @override
  String get fuelRegular => 'রেগুলার (অকটেন)';

  @override
  String get fuelMidgrade => 'মিডগ্রেড';

  @override
  String get fuelPremium => 'প্রিমিয়াম';

  @override
  String get fuelMethane => 'সিএনজি / মিথেন';

  @override
  String get fuelEvCharging => 'ইভি চার্জিং';

  @override
  String get connectorWallOutlet => 'দেয়ালের সকেট';

  @override
  String get connectorOther => 'অন্যান্য';

  @override
  String get communityPrices => 'কমিউনিটি দাম';

  @override
  String get reportPrice => 'দাম জানান';

  @override
  String get communityOff => 'এই বিল্ডে কমিউনিটি দাম বন্ধ আছে।';

  @override
  String get noCommunityReports =>
      'এখনো কোনো কমিউনিটি রিপোর্ট নেই। প্রথম দাম আপনিই জানান।';

  @override
  String get couldNotLoadCommunityPrices => 'কমিউনিটি দাম লোড করা যায়নি।';

  @override
  String reportCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি রিপোর্ট',
    );
    return '$_temp0';
  }

  @override
  String communityReports(String reports) {
    return 'কমিউনিটি · $reports';
  }

  @override
  String updatedAgo(String time) {
    return 'হালনাগাদ $time';
  }

  @override
  String get outdated => 'পুরোনো';

  @override
  String get priceHistory => 'দামের ইতিহাস';

  @override
  String fuelHistory(String fuel) {
    return '$fuel-এর ইতিহাস';
  }

  @override
  String get days7 => '৭ দিন';

  @override
  String get days30 => '৩০ দিন';

  @override
  String get noHistoryForPeriod => 'এই সময়ের কোনো ইতিহাস এখনো নেই।';

  @override
  String get couldNotLoadPriceHistory => 'ইতিহাস লোড করা যায়নি।';

  @override
  String priceHistorySemantics(String currency, String summary) {
    return '$currency-এ কমিউনিটি দামের ইতিহাস: $summary';
  }

  @override
  String get thanksForConfirming => 'নিশ্চিত করার জন্য ধন্যবাদ!';

  @override
  String reliabilitySemantics(int percent) {
    return 'তথ্যের নির্ভরযোগ্যতা $percent শতাংশ';
  }

  @override
  String votesOpen(int count) {
    return '$count জন বলেছেন খোলা';
  }

  @override
  String votesClosed(int count) {
    return '$count জন বলেছেন বন্ধ';
  }

  @override
  String votesOutOfFuel(int count) {
    return '$count জন বলেছেন ফুয়েল নেই';
  }

  @override
  String get reliabilityDisclaimer =>
      'সাম্প্রতিক কমিউনিটি রিপোর্ট ও ভোটের ভিত্তিতে — এটি কোনো অফিসিয়াল যাচাই নয়।';

  @override
  String get isItOpenNow => 'এখন কি খোলা আছে?';

  @override
  String get voteOpen => 'খোলা';

  @override
  String get voteClosed => 'বন্ধ';

  @override
  String get voteOutOfFuel => 'ফুয়েল নেই';

  @override
  String get reliabilityNone => 'যথেষ্ট কমিউনিটি তথ্য নেই';

  @override
  String get reliabilityHigh => 'সম্প্রতি কমিউনিটি নিশ্চিত করেছে';

  @override
  String get reliabilityMedium => 'কিছু কমিউনিটি রিপোর্ট আছে';

  @override
  String get reliabilityLow => 'কমিউনিটি রিপোর্ট পুরোনো বা পরস্পরবিরোধী';

  @override
  String get reportAccepted =>
      'ধন্যবাদ! আপনার দেওয়া দাম এখন কমিউনিটি দামের অংশ।';

  @override
  String get reportMinorityCurrency =>
      'সংরক্ষিত হয়েছে, তবে এখানে বেশিরভাগ রিপোর্ট অন্য মুদ্রায়।';

  @override
  String get reportOutlier =>
      'এই দাম সাম্প্রতিক অন্য রিপোর্ট থেকে অনেক আলাদা, তাই ব্যবহার করা হয়নি।';

  @override
  String get reportDuplicate =>
      'কয়েক মিনিট আগেই আপনি এখানে এই ফুয়েলের দাম জানিয়েছেন।';

  @override
  String get reportTooMany =>
      'গত এক ঘণ্টায় অনেক বেশি রিপোর্ট হয়েছে। পরে আবার চেষ্টা করুন।';

  @override
  String get reportRejected => 'এই রিপোর্টটি গ্রহণ করা হয়নি।';

  @override
  String get reportSent => 'রিপোর্ট পাঠানো হয়েছে। একটু পরেই যাচাই হবে।';

  @override
  String get enterPrice => 'একটি দাম লিখুন';

  @override
  String get enterPriceRange => '0.01 থেকে 1000-এর মধ্যে একটি দাম লিখুন';

  @override
  String get reportAPrice => 'দাম জানান';

  @override
  String get fuel => 'ফুয়েল';

  @override
  String pricePerUnit(String unit) {
    return 'প্রতি $unit দাম';
  }

  @override
  String get reportPriceHelp =>
      'এই মুহূর্তে পাম্পে দেখানো দামটি জানান। রিপোর্টগুলো একসাথে মেলানো হয়; সাম্প্রতিক রিপোর্ট থেকে অনেক আলাদা দাম ব্যবহার করা হয় না।';

  @override
  String get sending => 'পাঠানো হচ্ছে…';

  @override
  String get sendReport => 'রিপোর্ট পাঠান';

  @override
  String get done => 'শেষ';

  @override
  String get priceAlerts => 'দামের সতর্কতা';

  @override
  String get newAlert => 'নতুন সতর্কতা';

  @override
  String get alertsUnavailableTitle => 'সতর্কতা চালু নেই';

  @override
  String get alertsUnavailableMessage =>
      'দামের সতর্কতার জন্য FuelWise কমিউনিটি ব্যাকএন্ড দরকার, যা এই বিল্ডে চালু নেই।';

  @override
  String get noAlertsTitle => 'এখনো কোনো দামের সতর্কতা নেই';

  @override
  String get noAlertsMessage =>
      'কাছাকাছি কমিউনিটি দাম আপনার সীমার নিচে নামলে জানতে একটি সতর্কতা তৈরি করুন।';

  @override
  String get alertsServerNote =>
      'নতুন কমিউনিটি দাম গৃহীত হলে সার্ভার সতর্কতাগুলো যাচাই করে। এই বিল্ডে এখনো পুশ নোটিফিকেশন চালু হয়নি।';

  @override
  String alertOnlyAt(String station) {
    return 'শুধু $station-এ';
  }

  @override
  String alertWithinKm(String km) {
    return 'সংরক্ষিত অবস্থান থেকে $km km-এর মধ্যে';
  }

  @override
  String get alertOn => 'সতর্কতা চালু';

  @override
  String get alertPaused => 'সতর্কতা বিরতিতে';

  @override
  String get deleteAlert => 'সতর্কতা মুছুন';

  @override
  String get alertDeleted => 'সতর্কতা মুছে ফেলা হয়েছে';

  @override
  String get couldNotLoadAlerts => 'সতর্কতা লোড করা যায়নি।';

  @override
  String get alertSaved => 'সতর্কতা সংরক্ষিত হয়েছে';

  @override
  String get newPriceAlert => 'নতুন দামের সতর্কতা';

  @override
  String get alertAtOrBelow => 'এই দাম বা তার কম হলে জানান';

  @override
  String alertRadius(int km) {
    return 'আমার বর্তমান অবস্থান থেকে $km km-এর মধ্যে';
  }

  @override
  String get saveAlert => 'সতর্কতা সংরক্ষণ করুন';

  @override
  String get badgeCheapest => 'সবচেয়ে সস্তা';

  @override
  String get badgeBestValue => 'সেরা মূল্য';

  @override
  String get badgeLeastDetour => 'সবচেয়ে কম ঘুরপথ';

  @override
  String get badgeMostReliable => 'সবচেয়ে নির্ভরযোগ্য';

  @override
  String get caveatClosed => 'এখন বন্ধ';

  @override
  String get caveatUnreachable => 'রেঞ্জের বাইরে হতে পারে';

  @override
  String get caveatOtherCurrency => 'অন্য মুদ্রা (রূপান্তর করা হয়নি)';

  @override
  String get caveatPriceUnknown => 'দাম জানা নেই';

  @override
  String get caveatStalePrice => 'দাম ৩ দিনের বেশি পুরোনো';

  @override
  String get onRoute => 'পথের উপরেই';

  @override
  String get explainNoPrice =>
      'এই স্টেশনের দাম জানা নেই, তাই খরচ তুলনা করা যায় না।';

  @override
  String explainUnitOnly(String price, String unit) {
    return 'প্রতি $unit $price। মোট ট্রিপ খরচ তুলনা করতে গ্যারেজে একটি গাড়ি যোগ করুন।';
  }

  @override
  String explainBuy(String amount, String unit, String price, String cost) {
    return '$amount $unit কিনুন × $price = $cost';
  }

  @override
  String explainDetour(
    String distance,
    String amount,
    String unit,
    String cost,
  ) {
    return 'ঘুরপথ $distance-এ লাগে $amount $unit = $cost';
  }

  @override
  String explainSaves(String amount) {
    return ' · নিকটতম স্টেশনের চেয়ে $amount সাশ্রয়';
  }

  @override
  String explainMore(String amount) {
    return ' · নিকটতম স্টেশনের চেয়ে $amount বেশি';
  }

  @override
  String explainTotal(String cost, String comparison) {
    return 'মোট $cost$comparison';
  }

  @override
  String get explainSourceGoogle => 'দামের উৎস: Google';

  @override
  String get explainSourceCommunity => 'দামের উৎস: কমিউনিটি';

  @override
  String explainUpdated(String time) {
    return ', হালনাগাদ $time';
  }

  @override
  String get trip => 'ট্রিপ';

  @override
  String tripTo(String destination) {
    return '$destination-এর পথে';
  }

  @override
  String get changeDestination => 'গন্তব্য বদলান';

  @override
  String get couldNotPlanTrip => 'এই ট্রিপের পরিকল্পনা করা যায়নি।';

  @override
  String get noTripYet => 'এখনো কোনো ট্রিপ নেই';

  @override
  String get noTripMessage => 'পথের স্টেশন খুঁজতে একটি গন্তব্য বেছে নিন।';

  @override
  String get chooseDestination => 'গন্তব্য বেছে নিন';

  @override
  String get findingAlongRoute => 'আপনার পথের স্টেশন খোঁজা হচ্ছে…';

  @override
  String stationsOnTheWay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'পথে $countটি স্টেশন',
    );
    return '$_temp0';
  }

  @override
  String comparingFuelPrices(String fuel) {
    return '$fuel-এর দাম তুলনা করা হচ্ছে';
  }

  @override
  String get detoursApproximate =>
      'রাউটিং সার্ভিস পাওয়া যাচ্ছে না — ঘুরপথ সরলরেখায় আনুমানিক।';

  @override
  String skippedForDetour(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'পথ থেকে দূরের আরও $countটি স্টেশন তুলনা করা হয়নি।',
    );
    return '$_temp0';
  }

  @override
  String get noStationsAlongRoute => 'এই পথে কোনো স্টেশন নেই';

  @override
  String get nothingWithin5km => 'পথের ৫ km-এর মধ্যে কিছু পাওয়া যায়নি।';

  @override
  String withoutComparablePrice(int count) {
    return 'তুলনাযোগ্য দাম ছাড়া ($count)';
  }

  @override
  String get comparingPricePerLitre => 'শুধু প্রতি লিটারের দাম তুলনা করা হচ্ছে';

  @override
  String get addVehicleForTrueCost =>
      'আসল ট্রিপ খরচ অনুযায়ী সাজাতে আপনার গাড়ি যোগ করুন।';

  @override
  String get add => 'যোগ করুন';

  @override
  String batteryNowToFull(
    String vehicle,
    int percent,
    String amount,
    String unit,
  ) {
    return '$vehicle · ব্যাটারি এখন $percent% → পূর্ণ ($amount $unit)';
  }

  @override
  String tankNowToFull(
    String vehicle,
    int percent,
    String amount,
    String unit,
  ) {
    return '$vehicle · ট্যাংক এখন $percent% → পূর্ণ ($amount $unit)';
  }

  @override
  String percentCharge(int percent) {
    return '$percent শতাংশ চার্জ';
  }

  @override
  String percentFuel(int percent) {
    return '$percent শতাংশ ফুয়েল';
  }

  @override
  String intoTheTrip(String detour, String distance) {
    return '$detour · ট্রিপের $distance পরে';
  }

  @override
  String get showOnMap => 'ম্যাপে দেখান';

  @override
  String get whereTo => 'কোথায় যাবেন?';

  @override
  String get searchFailed => 'খোঁজা যায়নি।';

  @override
  String get searching => 'খোঁজা হচ্ছে…';

  @override
  String get noPlacesFound => 'কোনো জায়গা পাওয়া যায়নি';

  @override
  String get tryAnotherName => 'অন্য নাম বা ঠিকানা দিয়ে চেষ্টা করুন।';

  @override
  String get destinationSearchHint =>
      'একটি গন্তব্য খুঁজুন। FuelWise আপনার পথের স্টেশনগুলো খুঁজে থামার আসল খরচ অনুযায়ী সাজায় — দাম এবং ঘুরপথে খরচ হওয়া ফুয়েল মিলিয়ে।';

  @override
  String get powerAny => 'যেকোনো';

  @override
  String get reset => 'রিসেট';

  @override
  String get minimumPower => 'সর্বনিম্ন পাওয়ার';

  @override
  String get connector => 'কানেক্টর';

  @override
  String get noConnectorDataNearby => 'কাছাকাছি কোনো কানেক্টরের তথ্য নেই।';

  @override
  String get onlyOperational => 'শুধু চালু চার্জার';

  @override
  String get onlyOperationalHelp => 'অকেজো বা অজানা অবস্থার চার্জার লুকান।';

  @override
  String get statusOperational => 'চালু';

  @override
  String get statusNotOperational => 'চালু নেই';

  @override
  String get statusUnknown => 'অবস্থা অজানা';

  @override
  String upToPower(String power) {
    return 'সর্বোচ্চ $power';
  }

  @override
  String get fastSuffix => ' · দ্রুত';

  @override
  String chargingPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি চার্জিং পয়েন্ট',
    );
    return '$_temp0';
  }

  @override
  String get connectors => 'কানেক্টর';

  @override
  String get noConnectorDetails => 'কানেক্টরের কোনো তথ্য জানানো হয়নি।';

  @override
  String get notOperationalLower => 'চালু নেই';

  @override
  String get cost => 'খরচ';

  @override
  String get noCostInfo =>
      'খরচের কোনো তথ্য জানানো হয়নি। অপারেটরের অ্যাপ বা চার্জারের ডিসপ্লে দেখুন।';

  @override
  String costAsListed(String cost) {
    return '\"$cost\" — কমিউনিটির দেওয়া তথ্য; FuelWise যাচাই করেনি।';
  }

  @override
  String lastVerified(String time) {
    return 'শেষ যাচাই $time';
  }

  @override
  String statusUpdated(String time) {
    return 'অবস্থা হালনাগাদ $time';
  }

  @override
  String get monthsShort =>
      'জানু,ফেব্রু,মার্চ,এপ্রিল,মে,জুন,জুলাই,আগস্ট,সেপ্টে,অক্টো,নভে,ডিসে';

  @override
  String get errorCareSave =>
      'রিমাইন্ডার সংরক্ষণ করা যায়নি। আবার চেষ্টা করুন।';

  @override
  String get careMenu => 'যত্ন ও রিমাইন্ডার';

  @override
  String careTitle(String vehicle) {
    return 'যত্ন · $vehicle';
  }

  @override
  String get careAddReminder => 'রিমাইন্ডার যোগ করুন';

  @override
  String get careEditReminder => 'রিমাইন্ডার সম্পাদনা';

  @override
  String get careEmptyTitle => 'এখনো কোনো রিমাইন্ডার নেই';

  @override
  String get careEmptyMessage =>
      'ট্যাক্স টোকেন, ফিটনেস, ইন্স্যুরেন্স বা সার্ভিসের তারিখ আর ভুলবেন না। এই গাড়ির জন্য প্রস্তাবিত রিমাইন্ডার দিয়ে শুরু করুন।';

  @override
  String get careAddSuggested => 'প্রস্তাবিত রিমাইন্ডার যোগ করুন';

  @override
  String careSuggestedAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি রিমাইন্ডার যোগ হয়েছে — তারিখ বসিয়ে দিন',
    );
    return '$_temp0';
  }

  @override
  String get careDisclaimer =>
      'প্রস্তাবিত সময়সীমা শুধু শুরু করার জন্য। আসল তারিখের জন্য আপনার কাগজপত্র (BRTA, ইন্স্যুরেন্স, সিলিন্ডার সার্টিফিকেট) দেখুন।';

  @override
  String careOdometerKnown(String km) {
    return 'ওডোমিটার $km (আপনার ইতিহাস থেকে)';
  }

  @override
  String careOdometerRate(String km) {
    return ' · দিনে প্রায় $km';
  }

  @override
  String get careNoOdometer =>
      'এখনো কোনো ওডোমিটার রিডিং নেই। কিমি অনুযায়ী সার্ভিস ট্র্যাক করতে ইতিহাসে পরের ফুয়েল এন্ট্রির সাথে রিডিং দিন।';

  @override
  String get careBandOverdue => 'মেয়াদ পেরিয়ে গেছে';

  @override
  String get careBandDueSoon => 'শীঘ্রই করতে হবে';

  @override
  String get careBandUpcoming => 'আসন্ন';

  @override
  String get careBandNeedsSetup => 'তারিখ দরকার';

  @override
  String get careBandDone => 'সম্পন্ন';

  @override
  String get careTypeTaxToken => 'ট্যাক্স টোকেন';

  @override
  String get careTypeFitness => 'ফিটনেস সার্টিফিকেট';

  @override
  String get careTypeInsurance => 'ইন্স্যুরেন্স';

  @override
  String get careTypeRoutePermit => 'রুট পারমিট';

  @override
  String get careTypeCngRetest => 'সিএনজি সিলিন্ডার রিটেস্ট';

  @override
  String get careTypeOilChange => 'ইঞ্জিন অয়েল পরিবর্তন';

  @override
  String get careTypeTyreRotation => 'টায়ার রোটেশন';

  @override
  String get careTypeCustom => 'নিজস্ব';

  @override
  String get careNeedsSetup => 'মেয়াদের তারিখ বা কিমি বসাতে ট্যাপ করুন';

  @override
  String get careNeedsOdometer =>
      'এটি ট্র্যাক করতে ইতিহাসে ওডোমিটার রিডিং যোগ করুন';

  @override
  String careDoneOn(String date) {
    return 'সম্পন্ন $date';
  }

  @override
  String careOverdueDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count দিন পেরিয়ে গেছে',
    );
    return '$_temp0';
  }

  @override
  String careOverdueKm(String km) {
    return '$km পেরিয়ে গেছে';
  }

  @override
  String get careDueToday => 'আজই শেষ দিন';

  @override
  String careDueInDays(int count, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count দিন বাকি · $date',
    );
    return '$_temp0';
  }

  @override
  String careInKm(String km) {
    return 'আরও $km';
  }

  @override
  String careEstimatedDate(String date) {
    return ' (≈ $date)';
  }

  @override
  String get careMarkDone => 'সম্পন্ন করেছি';

  @override
  String get careMarkedDone => 'সম্পন্ন হিসেবে চিহ্নিত';

  @override
  String careMarkedDoneNext(String when) {
    return 'সম্পন্ন · পরবর্তী $when';
  }

  @override
  String get careDeleted => 'রিমাইন্ডার মুছে ফেলা হয়েছে';

  @override
  String get careDoneDate => 'সম্পন্নের তারিখ';

  @override
  String get careOdometerNow => 'এখনকার ওডোমিটার (ঐচ্ছিক)';

  @override
  String get careTypeField => 'ধরন';

  @override
  String get careTitleField => 'নাম';

  @override
  String get careTitleRequired => 'একটি নাম লিখুন';

  @override
  String get careDueDate => 'মেয়াদের তারিখ';

  @override
  String get careNoDueDate => 'কোনো তারিখ নেই';

  @override
  String get careClearDate => 'তারিখ মুছুন';

  @override
  String get careDueKm => 'যে ওডোমিটারে করতে হবে';

  @override
  String get careRepeatMonths => 'প্রতি কত মাস পরপর';

  @override
  String get careRepeatKm => 'প্রতি কত কিমি পরপর';

  @override
  String get careRepeatHelp =>
      'সম্পন্ন চিহ্নিত করলে পরের তারিখ এভাবে ঠিক হবে। একবারের জন্য হলে খালি রাখুন।';

  @override
  String get careNotify => 'কখন মনে করাবে';

  @override
  String careNotifyDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count দিন আগে',
      zero: 'শুধু ওই দিন',
    );
    return '$_temp0';
  }

  @override
  String get careNote => 'নোট (ঐচ্ছিক)';

  @override
  String get careNeedDue => 'মেয়াদের তারিখ বা ওডোমিটার দিন';

  @override
  String careCurrentOdometer(String km) {
    return 'বর্তমান ওডোমিটার: $km';
  }

  @override
  String get careSaveReminder => 'রিমাইন্ডার সংরক্ষণ করুন';

  @override
  String careAttention(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি রিমাইন্ডারে মনোযোগ দরকার',
    );
    return '$_temp0';
  }

  @override
  String get careWholeNumber => 'একটি পূর্ণ সংখ্যা লিখুন';

  @override
  String careProgressSemantics(int percent) {
    return 'সময়সীমার $percent শতাংশ পার হয়েছে';
  }

  @override
  String get careOptions => 'রিমাইন্ডার অপশন';

  @override
  String careNoticeTitle(String reminder, String vehicle) {
    return '$reminder · $vehicle';
  }

  @override
  String get careNoticeEstimated => ' (আপনার চালানোর হিসাবে আনুমানিক)';

  @override
  String get careChannelName => 'গাড়ির যত্নের রিমাইন্ডার';

  @override
  String get careChannelDescription =>
      'আপনার গাড়ির কাগজপত্রের মেয়াদ ও সার্ভিসের রিমাইন্ডার';

  @override
  String get privacyTitle => 'গোপনীয়তা ও ডেটা';

  @override
  String get privacyDeviceTitle => 'এই ফোনে';

  @override
  String get privacyDeviceBody =>
      'আপনার গাড়ি, ফুয়েল নেওয়ার ইতিহাস, যত্নের রিমাইন্ডার, সংরক্ষিত স্টেশনের অবস্থান ও সেটিংস শুধু এই ফোনেই থাকে।';

  @override
  String get privacyDeleteDevice => 'এই ফোনের ডেটা মুছুন';

  @override
  String get privacyDeleteDeviceConfirmTitle => 'এই ফোনের সব ডেটা মুছবেন?';

  @override
  String get privacyDeleteDeviceConfirmBody =>
      'গাড়ি, ইতিহাস, রিমাইন্ডার (ও তাদের নোটিফিকেশন), সংরক্ষিত স্টেশনের অবস্থান ও সেটিংস মুছে যাবে। এটি আর ফেরানো যাবে না।';

  @override
  String get privacyDeviceDeleted => 'এই ফোনের ডেটা মুছে ফেলা হয়েছে';

  @override
  String get privacyCommunityTitle => 'কমিউনিটি (অনলাইন)';

  @override
  String get privacyCommunityBody =>
      'আপনি কমিউনিটি দাম, ভোট, দামের অ্যালার্ট বা AI সহকারী ব্যবহার করে থাকলে সেই ডেটা একটি নামহীন অ্যাকাউন্টে অনলাইনে থাকে।';

  @override
  String get privacyCommunityOff =>
      'এই সংস্করণে কমিউনিটি ফিচার বন্ধ, তাই অনলাইনে কিছুই রাখা হয়নি।';

  @override
  String get privacyDeleteCommunity => 'আমার অনলাইন ডেটা মুছুন';

  @override
  String get privacyDeleteCommunityConfirmTitle => 'আপনার অনলাইন ডেটা মুছবেন?';

  @override
  String get privacyDeleteCommunityConfirmBody =>
      'আপনার দামের রিপোর্ট, ভোট, দামের অ্যালার্ট, সহকারীর কথোপকথন ও নামহীন অ্যাকাউন্ট মুছে যাবে। অনেক রিপোর্ট থেকে হিসাব করা স্টেশনের দামে কোনো ব্যক্তিগত তথ্য নেই এবং তা ৭২ ঘণ্টার মধ্যে মেয়াদোত্তীর্ণ হয়। এটি আর ফেরানো যাবে না।';

  @override
  String privacyCommunityDeleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'অনলাইনে $countটি আইটেম মুছে ফেলা হয়েছে',
      zero: 'অনলাইনে কিছুই রাখা ছিল না',
    );
    return '$_temp0';
  }

  @override
  String get errorDataDeletion =>
      'আপনার অনলাইন ডেটা মোছা যায়নি। ইন্টারনেট সংযোগ দেখে আবার চেষ্টা করুন।';
}
