import 'package:cloud_firestore/cloud_firestore.dart' hide GeoPoint;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase/firebase_bootstrap.dart';
import '../data/firestore_community_repository.dart';
import '../data/unavailable_community_repository.dart';
import '../domain/community_models.dart';
import '../domain/community_repository.dart';

final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  final status = ref.watch(firebaseStatusProvider);
  if (!status.ready) return UnavailableCommunityRepository(status.problem ?? 'Community features are not set up yet.');
  return FirestoreCommunityRepository(FirebaseFirestore.instance, FirebaseAuth.instance);
});

final communityPricesProvider = StreamProvider.family<List<CommunityPrice>, String>(
  (ref, stationId) => ref.watch(communityRepositoryProvider).watchPrices(stationId),
);

typedef HistoryKey = ({String stationId, String fuelType, int days});

final priceHistoryProvider = StreamProvider.family<List<PriceHistoryDay>, HistoryKey>(
  (ref, k) => ref.watch(communityRepositoryProvider).watchHistory(k.stationId, k.fuelType, days: k.days),
);

final stationReliabilityProvider = StreamProvider.family<StationReliability?, String>(
  (ref, stationId) => ref.watch(communityRepositoryProvider).watchReliability(stationId),
);

final myVoteProvider = StreamProvider.family<StationVote?, String>(
  (ref, stationId) => ref.watch(communityRepositoryProvider).watchMyVote(stationId),
);

final myPriceFlagsProvider = StreamProvider.family<Set<String>, String>(
  (ref, stationId) => ref.watch(communityRepositoryProvider).watchMyFlags(stationId),
);

final alertRulesProvider = StreamProvider<List<PriceAlertRule>>(
  (ref) => ref.watch(communityRepositoryProvider).watchAlertRules(),
);

final reportStatusProvider = StreamProvider.family<ReportStatus, String>(
  (ref, reportId) => ref.watch(communityRepositoryProvider).watchReportStatus(reportId),
);
