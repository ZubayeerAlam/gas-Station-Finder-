import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gas_station_finder/core/config/app_config.dart' show FirebaseMode;
import 'package:gas_station_finder/core/firebase/firebase_bootstrap.dart';
import 'package:gas_station_finder/core/location/geo_point.dart';
import 'package:gas_station_finder/core/theme/app_theme.dart';
import 'package:gas_station_finder/features/ev/domain/charge_point.dart';
import 'package:gas_station_finder/features/ev/presentation/widgets/charge_point_sheet.dart';
import 'package:gas_station_finder/features/prices/domain/community_models.dart';
import 'package:gas_station_finder/features/prices/presentation/community_providers.dart';
import 'package:gas_station_finder/l10n/app_localizations.dart';

import 'package:gas_station_finder/core/error/result.dart';
import 'package:gas_station_finder/features/along_route/presentation/along_route_providers.dart' show nowProvider;
import 'package:gas_station_finder/features/garage/data/drift_garage_repository.dart';
import 'package:gas_station_finder/features/prices/presentation/report_price_screen.dart';
import 'package:gas_station_finder/features/stations/data/stations_providers.dart';
import 'package:gas_station_finder/features/stations/domain/entities/station.dart';
import 'package:gas_station_finder/features/stations/domain/repositories/stations_repository.dart';

import '../../helpers/fake_community_repository.dart';
import '../../helpers/fake_garage_repository.dart';

final now = DateTime(2026, 11, 27, 12);

CommunityPrice kwh(double price) => CommunityPrice(
  fuelType: 'EV_KWH',
  price: price,
  currencyCode: 'BDT',
  reportCount: 3,
  confidence: 0.8,
  lastReportAt: now.subtract(const Duration(hours: 2)),
  expiresAt: now.add(const Duration(hours: 70)),
);

class _NoPlaces implements StationsRepository {
  int calls = 0;
  @override
  Future<Result<List<Station>>> nearbyStations(GeoPoint center, {double radiusMeters = 5000}) async {
    calls++;
    return const Ok([]);
  }

  @override
  Future<Result<StationDetails>> stationDetails(String stationId) async {
    calls++;
    throw StateError('no Places lookup for a charger');
  }
}

const charger = ChargePoint(
  id: 'ocm:42',
  name: 'Gulshan DC',
  location: GeoPoint(latitude: 23.79, longitude: 90.41),
  connectors: [ChargeConnector(type: 'CCS2', powerKw: 60)],
  isOperational: true,
);

void main() {
  Future<FakeCommunityRepository> pump(
    WidgetTester tester, {
    Map<String, StationReliability> reliability = const {},
    Map<String, List<CommunityPrice>> prices = const {},
    Locale locale = const Locale('en'),
    double textScale = 1,
  }) async {
    final repo = FakeCommunityRepository(reliability: reliability, prices: prices);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          firebaseStatusProvider.overrideWithValue(const FirebaseStatus(FirebaseMode.emulator, ready: true)),
          communityRepositoryProvider.overrideWithValue(repo),
          nowProvider.overrideWithValue(() => now),
        ],
        retry: (_, _) => null,
        child: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
          child: MaterialApp(
            theme: AppTheme.light(),
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: ChargePointSheet(point: charger, onDirections: () {}),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.byKey(const Key('chargerVoteBroken')), 200);
    await tester.pumpAndSettle();
    return repo;
  }

  testWidgets('no reports yet → vote working, then change to not working (one vote per user)', (tester) async {
    final repo = await pump(tester);
    expect(find.text('No driver reports yet.'), findsOneWidget);
    await tester.tap(find.byKey(const Key('chargerVoteWorking')));
    await tester.pumpAndSettle();
    expect(repo.votes['ocm:42'], const StationVote(open: true));
    expect(find.text('Thanks for confirming!'), findsOneWidget);
    expect(tester.widget<ChoiceChip>(find.byKey(const Key('chargerVoteWorking'))).selected, isTrue);

    await tester.tap(find.byKey(const Key('chargerVoteBroken')));
    await tester.pumpAndSettle();
    expect(repo.votes['ocm:42'], const StationVote(open: false));
    expect(tester.widget<ChoiceChip>(find.byKey(const Key('chargerVoteBroken'))).selected, isTrue);
  });

  testWidgets('counts from the shared aggregate', (tester) async {
    await pump(tester, reliability: {'ocm:42': const StationReliability(openVotes: 1, closedVotes: 3)});
    expect(find.text('Drivers in the last 30 days: 1 working, 3 not working'), findsOneWidget);
  });

  testWidgets('Bengali at 200 % text meets accessibility guidelines', (tester) async {
    final handle = tester.ensureSemantics();
    await pump(
      tester,
      reliability: {'ocm:42': const StationReliability(openVotes: 2)},
      locale: const Locale('bn'),
      textScale: 2,
    );
    final bn = lookupAppLocalizations(const Locale('bn'));
    expect(find.text(bn.chargerVoteBroken), findsOneWidget);
    expect(tester.takeException(), isNull);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    handle.dispose();
  });

  testWidgets('community price per kWh is shown, with the wrong-price flag', (tester) async {
    await pump(
      tester,
      prices: {
        'ocm:42': [kwh(25)],
      },
    );
    await tester.scrollUntilVisible(find.text('BDT 25.00'), -200);
    expect(find.byKey(const Key('chargerNoPrices')), findsNothing);
    expect(find.byKey(const Key('flagPrice')), findsOneWidget);
  });

  testWidgets('no price yet → says so and offers a report', (tester) async {
    await pump(tester);
    await tester.scrollUntilVisible(find.byKey(const Key('chargerReportPrice')), -200);
    expect(find.byKey(const Key('chargerNoPrices')), findsOneWidget);
  });

  testWidgets('report screen in charger mode: kWh only, no Places lookup, ocm id sent', (tester) async {
    final repo = FakeCommunityRepository(
      prices: {
        'ocm:42': [kwh(25)],
      },
    );
    final places = _NoPlaces();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          communityRepositoryProvider.overrideWithValue(repo),
          stationsRepositoryProvider.overrideWithValue(places),
          garageRepositoryProvider.overrideWithValue(FakeGarageRepository()),
          nowProvider.overrideWithValue(() => now),
        ],
        retry: (_, _) => null,
        child: MaterialApp(
          theme: AppTheme.light(),
          home: ReportPriceScreen(
            station: Station(id: charger.id, name: charger.name, location: charger.location),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(DropdownButtonFormField<String>), findsNothing);
    expect(find.text('Gulshan DC'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('price')), '24.5');
    await tester.tap(find.text('Send report'));
    await tester.pumpAndSettle();
    final d = repo.reports.single;
    expect((d.stationId, d.fuelType, d.price, d.currencyCode), ('ocm:42', 'EV_KWH', 24.5, 'BDT'));
    expect(d.stationLocation, charger.location);
    expect(places.calls, 0);
    expect(isChargerId('ocm:42'), isTrue);
    expect(isChargerId('ChIJ123'), isFalse);
  });
}
