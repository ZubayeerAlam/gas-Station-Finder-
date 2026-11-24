import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart' hide GeoPoint;
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/error/app_failure.dart';
import '../../../core/error/result.dart';
import '../../../core/location/geo_point.dart';
import '../domain/community_models.dart';
import '../domain/community_repository.dart';

/// Firestore-backed community data. Signs in anonymously on first use: the
/// security rules require an authenticated uid for every read and write.
class FirestoreCommunityRepository implements CommunityRepository {
  FirestoreCommunityRepository(this._db, this._auth);

  final FirebaseFirestore _db;
  final FirebaseAuth _auth;
  Future<String>? _signingIn;

  @override
  bool get isAvailable => true;

  Future<String> _uid() {
    final current = _auth.currentUser?.uid;
    if (current != null) return Future.value(current);
    // One sign-in shared by concurrent callers.
    return _signingIn ??= _auth.signInAnonymously().then((c) => c.user!.uid).whenComplete(() => _signingIn = null);
  }

  /// Waits for sign-in, then follows the query. Errors become [AppFailure]s.
  Stream<T> _signedIn<T>(Stream<T> Function(String uid) build) => Stream.fromFuture(_uid())
      .asyncExpand(build)
      .handleError((Object e, StackTrace st) => Error.throwWithStackTrace(mapFirebaseError(e), st));

  DocumentReference<Map<String, dynamic>> _station(String id) => _db.collection('stations').doc(id);

  @override
  Stream<List<CommunityPrice>> watchPrices(String stationId) => _signedIn(
        (_) => _station(stationId).collection('prices').snapshots().map(
              (s) => [for (final d in s.docs) ?parseCommunityPrice(d.data())]
                ..sort((a, b) => a.fuelType.compareTo(b.fuelType)),
            ),
      );

  @override
  Stream<List<PriceHistoryDay>> watchHistory(String stationId, String fuelType, {int days = 30}) {
    final from = DateTime.now().toUtc().subtract(Duration(days: days - 1));
    return _signedIn(
      (_) => _station(stationId)
          .collection('priceHistory')
          .where('fuelType', isEqualTo: fuelType)
          .where('day', isGreaterThanOrEqualTo: dayKey(from))
          .orderBy('day')
          .snapshots()
          .map((s) => [for (final d in s.docs) ?parseHistoryDay(d.data())]),
    );
  }

  @override
  Stream<StationReliability?> watchReliability(String stationId) =>
      _signedIn((_) => _station(stationId).snapshots().map((s) => s.exists ? parseReliability(s.data()!) : null));

  @override
  Future<Result<String>> submitReport(PriceReportDraft d) => _guard(() async {
        final uid = await _uid();
        final ref = _db.collection('priceReports').doc();
        await ref.set({
          'uid': uid,
          'stationId': d.stationId,
          if (d.stationName != null && d.stationName!.isNotEmpty)
            'stationName': d.stationName!.length > 120 ? d.stationName!.substring(0, 120) : d.stationName,
          'stationLat': d.stationLocation.latitude,
          'stationLng': d.stationLocation.longitude,
          'fuelType': d.fuelType,
          'price': d.price,
          'currency': d.currencyCode,
          'reportedAt': FieldValue.serverTimestamp(),
        });
        return ref.id;
      });

  @override
  Stream<ReportStatus> watchReportStatus(String reportId) => _signedIn(
        (_) => _db.collection('priceReports').doc(reportId).snapshots().map(
              (s) => (status: s.data()?['status'] as String?, reason: s.data()?['reason'] as String?),
            ),
      );

  @override
  Stream<StationVote?> watchMyVote(String stationId) => _signedIn(
        (uid) => _station(stationId).collection('verifications').doc(uid).snapshots().map(
              (s) => s.exists
                  ? StationVote(open: s.data()!['open'] as bool?, fuelAvailable: s.data()!['fuelAvailable'] as bool?)
                  : null,
            ),
      );

  @override
  Future<Result<void>> vote(String stationId, StationVote vote) => _guard(() async {
        final uid = await _uid();
        await _station(stationId).collection('verifications').doc(uid).set({
          if (vote.open != null) 'open': vote.open,
          if (vote.fuelAvailable != null) 'fuelAvailable': vote.fuelAvailable,
          'at': FieldValue.serverTimestamp(),
        });
      });

  CollectionReference<Map<String, dynamic>> _rules(String uid) =>
      _db.collection('users').doc(uid).collection('alertRules');

  @override
  Stream<List<PriceAlertRule>> watchAlertRules() => _signedIn(
        (uid) => _rules(uid).snapshots().map(
              (s) => [for (final d in s.docs) ?parseAlertRule(d.id, d.data())]
                ..sort((a, b) => a.maxPrice.compareTo(b.maxPrice)),
            ),
      );

  @override
  Future<Result<void>> saveAlertRule(PriceAlertRule rule) => _guard(() async {
        final uid = await _uid();
        await _rules(uid).doc(rule.id).set(alertRuleToMap(rule, uid));
      });

  @override
  Future<Result<void>> deleteAlertRule(String id) => _guard(() async {
        final uid = await _uid();
        await _rules(uid).doc(id).delete();
      });

  @override
  String newId() => _db.collection('_').doc().id;

  Future<Result<T>> _guard<T>(Future<T> Function() body) async {
    try {
      return Ok(await body());
    } catch (e) {
      return Err(mapFirebaseError(e));
    }
  }
}

/// Maps Firebase errors to user-presentable failures (no internals leaked).
AppFailure mapFirebaseError(Object e) => switch (e) {
      AppFailure() => e,
      FirebaseAuthException(code: 'operation-not-allowed' || 'admin-restricted-operation') =>
        const ConfigFailure('Community features need anonymous sign-in enabled in Firebase.'),
      FirebaseAuthException(code: 'network-request-failed') => const NetworkFailure(),
      FirebaseException(code: 'permission-denied') =>
        const ServerFailure('That change was not allowed. Check the values and try again.', statusCode: 403),
      FirebaseException(code: 'unavailable') => const NetworkFailure(),
      FirebaseException(code: 'deadline-exceeded') => const TimeoutFailure(),
      _ => const UnknownFailure(),
    };

// ---------- pure mapping (unit-tested) ----------

DateTime? _time(Object? v) => switch (v) {
      Timestamp() => v.toDate(),
      DateTime() => v,
      _ => null,
    };

double? _num(Object? v) => v is num && v.isFinite ? v.toDouble() : null;

/// UTC day key used by the backend (`2026-11-25`).
String dayKey(DateTime t) => t.toUtc().toIso8601String().substring(0, 10);

CommunityPrice? parseCommunityPrice(Map<String, dynamic> m) {
  final price = _num(m['price']);
  final last = _time(m['lastReportAt']);
  final expires = _time(m['expiresAt']);
  if (m case {'fuelType': final String fuel, 'currency': final String currency}
      when price != null && last != null && expires != null) {
    return CommunityPrice(
      fuelType: fuel,
      price: price,
      currencyCode: currency,
      reportCount: (m['reportCount'] as num?)?.toInt() ?? 1,
      confidence: (_num(m['confidence']) ?? 0).clamp(0.0, 1.0),
      lastReportAt: last,
      expiresAt: expires,
    );
  }
  return null;
}

PriceHistoryDay? parseHistoryDay(Map<String, dynamic> m) {
  final close = _num(m['close']);
  if (m case {'day': final String day, 'fuelType': final String fuel, 'currency': final String currency}
      when close != null) {
    final date = DateTime.tryParse('${day}T00:00:00Z');
    if (date == null) return null;
    return PriceHistoryDay(
      day: date,
      fuelType: fuel,
      currencyCode: currency,
      close: close,
      min: _num(m['min']) ?? close,
      max: _num(m['max']) ?? close,
      samples: (m['samples'] as num?)?.toInt() ?? 1,
    );
  }
  return null;
}

StationReliability parseReliability(Map<String, dynamic> m) => StationReliability(
      score: _num(m['reliability'])?.clamp(0.0, 1.0),
      openVotes: (m['openVotes'] as num?)?.toInt() ?? 0,
      closedVotes: (m['closedVotes'] as num?)?.toInt() ?? 0,
      outOfStockVotes: (m['outOfStockVotes'] as num?)?.toInt() ?? 0,
    );

PriceAlertRule? parseAlertRule(String id, Map<String, dynamic> m) {
  final max = _num(m['maxPrice']), lat = _num(m['lat']), lng = _num(m['lng']), radius = _num(m['radiusKm']);
  if (m case {'fuelType': final String fuel, 'currency': final String currency}
      when max != null && lat != null && lng != null && radius != null) {
    return PriceAlertRule(
      id: id,
      fuelType: fuel,
      currencyCode: currency,
      maxPrice: max,
      center: GeoPoint(latitude: lat, longitude: lng),
      radiusKm: radius,
      enabled: m['enabled'] as bool? ?? true,
      stationId: m['stationId'] as String?,
      stationName: m['stationName'] as String?,
    );
  }
  return null;
}

/// Exactly the keys the security rules allow.
Map<String, Object> alertRuleToMap(PriceAlertRule r, String uid) => {
      'uid': uid,
      'fuelType': r.fuelType,
      'currency': r.currencyCode,
      'maxPrice': r.maxPrice,
      'lat': r.center.latitude,
      'lng': r.center.longitude,
      'radiusKm': r.radiusKm,
      'enabled': r.enabled,
      if (r.stationId != null) 'stationId': r.stationId!,
      if (r.stationName != null) 'stationName': r.stationName!,
    };
