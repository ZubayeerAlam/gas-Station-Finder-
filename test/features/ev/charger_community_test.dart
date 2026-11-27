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

import '../../helpers/fake_community_repository.dart';

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
    Locale locale = const Locale('en'),
    double textScale = 1,
  }) async {
    final repo = FakeCommunityRepository(reliability: reliability);
    await tester.pumpWidget(ProviderScope(
      overrides: [
        firebaseStatusProvider.overrideWithValue(const FirebaseStatus(FirebaseMode.emulator, ready: true)),
        communityRepositoryProvider.overrideWithValue(repo),
      ],
      retry: (_, _) => null,
      child: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
        child: MaterialApp(
          theme: AppTheme.light(),
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: ChargePointSheet(point: charger, onDirections: () {})),
        ),
      ),
    ));
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
}
