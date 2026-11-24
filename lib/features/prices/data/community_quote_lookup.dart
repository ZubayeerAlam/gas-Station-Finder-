import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../along_route/data/places_quote_lookup.dart';
import '../../along_route/domain/along_route_repositories.dart';
import '../../ranking/domain/ranking_models.dart';
import '../../stations/domain/entities/station.dart';
import '../domain/community_models.dart';
import '../domain/community_repository.dart';
import '../presentation/community_providers.dart';

/// Google prices first; a *fresh* community consensus for the exact same fuel
/// fills the gap when Google has none. Community reliability is attached to
/// every stop it is known for. Community failures never break planning.
class CombinedQuoteLookup implements StationQuoteLookup {
  CombinedQuoteLookup(this.google, this.community, {DateTime Function()? clock, this.timeout = const Duration(seconds: 5)})
      : _clock = clock ?? DateTime.now;

  final StationQuoteLookup google;
  final CommunityRepository community;
  final Duration timeout;
  final DateTime Function() _clock;

  @override
  Future<Map<String, StationQuote>> quotes(List<String> stationIds, {String? fuelType}) async {
    final g = await google.quotes(stationIds, fuelType: fuelType);
    if (!community.isAvailable) return g;
    // No fuel type = EV planning → community per-kWh price.
    final communityFuel = fuelType ?? 'EV_KWH';
    final extra = await Future.wait(stationIds.map((id) => _community(id, communityFuel)));
    final now = _clock();
    return {
      for (var i = 0; i < stationIds.length; i++)
        stationIds[i]: ?merge(g[stationIds[i]], extra[i].prices, extra[i].reliability, communityFuel, now),
    };
  }

  Future<({List<CommunityPrice> prices, StationReliability? reliability})> _community(String id, String fuel) async {
    Future<T?> first<T>(Stream<T> s) => s.first.timeout(timeout).then<T?>((v) => v).catchError((Object _) => null);
    final r = await Future.wait([first(community.watchPrices(id)), first(community.watchReliability(id))]);
    return (prices: (r[0] as List<CommunityPrice>?) ?? const <CommunityPrice>[], reliability: r[1] as StationReliability?);
  }

  /// Pure merge rule (unit-tested).
  static StationQuote? merge(
    StationQuote? google,
    List<CommunityPrice> community,
    StationReliability? reliability,
    String fuelType,
    DateTime now,
  ) {
    var price = google?.price;
    PriceSource? source = price == null ? null : PriceSource.google;
    if (price == null) {
      final c = community.where((p) => p.fuelType == fuelType && p.isFresh(now)).firstOrNull;
      if (c != null) {
        price = FuelPrice(fuelType: c.fuelType, amount: c.price, currencyCode: c.currencyCode, updatedAt: c.lastReportAt);
        source = PriceSource.community;
      }
    }
    final rel = reliability?.score;
    if (google == null && price == null && rel == null) return null;
    return StationQuote(price: price, openNow: google?.openNow, priceSource: source, reliability: rel);
  }
}

final stationQuoteLookupProvider = Provider<StationQuoteLookup>(
  (ref) => CombinedQuoteLookup(ref.watch(placesQuoteLookupProvider), ref.watch(communityRepositoryProvider)),
);
