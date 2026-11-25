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
}
