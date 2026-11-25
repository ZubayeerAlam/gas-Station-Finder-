import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gas_station_finder/core/error/app_failure.dart';
import 'package:gas_station_finder/core/error/result.dart';
import 'package:gas_station_finder/core/theme/app_theme.dart';
import 'package:gas_station_finder/features/along_route/domain/along_route_models.dart';
import 'package:gas_station_finder/features/along_route/domain/along_route_planner.dart';
import 'package:gas_station_finder/features/along_route/presentation/along_route_providers.dart';
import 'package:gas_station_finder/features/assistant/data/firebase_assistant_api.dart';
import 'package:gas_station_finder/features/assistant/data/unavailable_assistant_api.dart';
import 'package:gas_station_finder/features/assistant/domain/assistant_models.dart';
import 'package:gas_station_finder/features/assistant/presentation/assistant_controller.dart';
import 'package:gas_station_finder/features/assistant/presentation/assistant_screen.dart';
import 'package:gas_station_finder/features/assistant/presentation/assistant_tools.dart';
import 'package:gas_station_finder/features/garage/domain/vehicle_profile.dart';
import 'package:gas_station_finder/features/ranking/domain/ranking_models.dart';
import 'package:gas_station_finder/features/ranking/domain/trip_cost_engine.dart';
import 'package:gas_station_finder/l10n/l10n.dart';

import '../along_route/along_route_fakes.dart';

AssistantToolRunner runner({VehicleProfile? vehicle = car, FakePlaces? places}) => AssistantToolRunner(
      vehicle: () async => vehicle,
      fillLevel: () => 0.25,
      origin: () async => straightRoute.first,
      places: places ?? FakePlaces(suggestions: const [PlaceSuggestion(placeId: 'p1', primaryText: 'Potsdam')]),
      planner: AlongRoutePlanner(routes: FakeRoutes(), detours: FakeDetours(), places: FakePlaces(), quotes: FakeQuotes()),
      now: () => DateTime(2026, 11, 25),
    );

const planCall = ClientToolCall(
  id: 't2',
  name: 'plan_route_stops',
  input: {'destination': 'Potsdam', 'strategy': 'cheapest_total'},
);

/// Scripted server: asks for the vehicle + a plan, then shows [cardIds] (or
/// the plan's ids reversed plus a bogus one when null).
class FakeAssistantApi implements AssistantApi {
  FakeAssistantApi({this.cardIds, this.failToolResults = false, this.demo = false});

  final List<String>? cardIds;
  final bool failToolResults;
  final bool demo;
  final sentMessages = <(String?, String)>[];
  final sentResults = <List<ToolOutput>>[];

  @override
  bool get isAvailable => true;

  @override
  Future<Result<AssistantTurn>> sendMessage(String? sessionId, String text) async {
    sentMessages.add((sessionId, text));
    return const Ok(AssistantTurn(
      sessionId: 'sess1',
      needsClientTools: true,
      toolCalls: [ClientToolCall(id: 't1', name: 'get_vehicle', input: {}), planCall],
    ));
  }

  @override
  Future<Result<AssistantTurn>> sendToolResults(String sessionId, List<ToolOutput> results) async {
    sentResults.add(results);
    if (failToolResults) return const Err(ServerFailure('The assistant is unavailable right now.'));
    final plan = results.firstWhere((r) => r.toolUseId == 't2').output as Map<String, Object?>;
    final ids = [for (final s in plan['stations'] as List) (s as Map)['id'] as String];
    return Ok(AssistantTurn(
      sessionId: sessionId,
      needsClientTools: false,
      reply: 'Here are the best stops.',
      cards: cardIds ?? [...ids.reversed, 'bogus'],
      demo: demo,
    ));
  }
}

void main() {
  group('protocol parsing', () {
    test('AssistantTurn.fromMap handles platform maps', () {
      final t = AssistantTurn.fromMap(deepStringKeys(<Object?, Object?>{
        'sessionId': 's',
        'status': 'needs_client_tools',
        'cards': ['a', 3],
        'clientToolCalls': [
          <Object?, Object?>{'id': 't', 'name': 'plan_route_stops', 'input': <Object?, Object?>{'destination': 'X'}},
          <Object?, Object?>{'name': 'missing id'},
        ],
        'demo': true,
      }) as Map<String, Object?>);
      expect(t.needsClientTools, isTrue);
      expect(t.cards, ['a']);
      expect(t.toolCalls.single.input, {'destination': 'X'});
      expect(t.demo, isTrue);
      expect(() => AssistantTurn.fromMap({'status': 'done'}), throwsFormatException);
    });

    test('callable errors map to user-facing failures', () {
      expect(mapFunctionsError('resource-exhausted', 'Limit reached'), isA<ServerFailure>());
      expect(mapFunctionsError('resource-exhausted', 'Limit reached').message, 'Limit reached');
      expect(mapFunctionsError('deadline-exceeded', null), isA<TimeoutFailure>());
      expect(mapFunctionsError('unavailable', null), isA<NetworkFailure>());
      // Internal details are never shown.
      expect(mapFunctionsError('internal', 'stack trace…').message, isNot(contains('stack')));
    });
  });

  group('client tools', () {
    test('get_vehicle', () async {
      final r = await runner().run(const ClientToolCall(id: 't', name: 'get_vehicle', input: {}));
      expect((r.output as Map)['vehicle'], containsPair('energy_type', 'fuel'));
      final none = await runner(vehicle: null).run(const ClientToolCall(id: 't', name: 'get_vehicle', input: {}));
      expect((none.output as Map)['vehicle'], isNull);
    });

    test('plan_route_stops matches the ranking engine exactly', () async {
      final r = await runner().run(planCall);
      expect(r.isError, isFalse);
      final trip = r.trip!;
      final expected = const TripCostEngine().rank(
        offers: offersFromPlan(trip.plan),
        vehicle: car,
        fill: const FillToLevel(currentLevel: 0.25),
        strategy: RankingStrategy.cheapestTotal,
        now: DateTime(2026, 11, 25),
      );
      final out = r.output as Map<String, Object?>;
      final stations = (out['stations'] as List).cast<Map<String, Object?>>();
      expect([for (final s in stations.where((s) => s['rank'] != null)) s['id']],
          [for (final s in expected.ranked) s.offer.stationId]);
      expect(stations.first['rank'], 1);
      expect(stations.first['total_cost'], startsWith('EUR '));
      expect(stations.first['price_source'], 'google');
      expect(out['destination'], 'Potsdam-ish');
    });

    test('same figures as the trip screen for the hand-computed plan', () {
      final ranking = const TripCostEngine().rank(
        offers: offersFromPlan(widgetPlan),
        vehicle: car,
        fill: const FillToLevel(currentLevel: 0.25),
        now: DateTime(2026, 11, 25),
      );
      final out = AssistantToolRunner.planJson(PlannedTrip(plan: widgetPlan, ranking: ranking, unit: 'L'));
      final stations = (out['stations'] as List).cast<Map<String, Object?>>();
      // Same totals the along-route widget test asserts.
      expect(stations.map((s) => s['total_cost']), ['EUR 60.62', 'EUR 63.77', null]);
      expect(stations.last['rank'], isNull);
      expect(stations.last['caveats'], contains('No price available'));
    });

    test('tool errors are reported, never invented', () async {
      final none = await runner(places: FakePlaces()).run(planCall);
      expect(none.isError, isTrue);
      expect((none.output as Map)['error'], contains('No place found'));
      final bad = await runner().run(const ClientToolCall(id: 't', name: 'plan_route_stops', input: {}));
      expect(bad.isError, isTrue);
      final unknown = await runner().run(const ClientToolCall(id: 't', name: 'rm_rf', input: {}));
      expect(unknown.isError, isTrue);
    });
  });

  group('controller', () {
    ProviderContainer container(FakeAssistantApi api) {
      final c = ProviderContainer(overrides: [
        assistantApiProvider.overrideWithValue(api),
        assistantToolRunnerProvider.overrideWithValue(runner()),
      ]);
      addTearDown(c.dispose);
      return c;
    }

    test('runs client tools, sends results in order, resolves cards from the app ranking', () async {
      final api = FakeAssistantApi();
      final c = container(api);
      await c.read(assistantControllerProvider.notifier).send('  Fuel on my way to Potsdam?  ');
      final s = c.read(assistantControllerProvider);
      expect(api.sentMessages.single, (null, 'Fuel on my way to Potsdam?'));
      expect(api.sentResults.single.map((r) => r.toolUseId), ['t1', 't2']);
      expect(s.sending, isFalse);
      expect(s.sessionId, 'sess1');
      expect(s.messages.map((m) => m.fromUser), [true, false]);
      final reply = s.messages.last;
      expect(reply.text, 'Here are the best stops.');
      // Unknown id dropped; order is the server's; numbers come from the snapshot.
      final planIds = [
        for (final s in (api.sentResults.single[1].output as Map)['stations'] as List) (s as Map)['id'],
      ];
      expect(reply.cards.map((c) => c.ranked.offer.stationId), planIds.reversed);
      final top = reply.cards.firstWhere((c) => c.rank == 1);
      expect(top.ranked, top.trip.ranking.ranked.first);
    });

    test('a failure during tool results resets the session', () async {
      final api = FakeAssistantApi(failToolResults: true);
      final c = container(api);
      await c.read(assistantControllerProvider.notifier).send('hi');
      final s = c.read(assistantControllerProvider);
      expect(s.messages.last.isError, isTrue);
      expect(s.sessionId, isNull);
      expect(s.sending, isFalse);
    });

    test('cardsFor ignores ids that are not in the trip', () {
      final ranking = const TripCostEngine().rank(offers: offersFromPlan(widgetPlan), now: DateTime(2026, 11, 25));
      final trip = PlannedTrip(plan: widgetPlan, ranking: ranking, unit: 'L');
      expect(cardsFor(['x', 'np', 'near'], trip).map((c) => c.stop.station.id), ['np', 'near']);
      expect(cardsFor(['near'], null), isEmpty);
    });
  });

  group('screen', () {
    Future<void> pump(WidgetTester tester, AssistantApi api) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.5;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(ProviderScope(
        overrides: [
          assistantApiProvider.overrideWithValue(api),
          assistantToolRunnerProvider.overrideWithValue(runner()),
        ],
        retry: (_, _) => null,
        child: MaterialApp(theme: AppTheme.light(), home: const AssistantScreen()),
      ));
      await tester.pumpAndSettle();
    }

    testWidgets('unavailable without the server', (tester) async {
      await pump(tester, const UnavailableAssistantApi('off'));
      expect(find.text('Assistant not available'), findsOneWidget);
      expect(find.byKey(const Key('assistantInput')), findsNothing);
    });

    testWidgets('chat shows the reply, demo label and ranked station cards', (tester) async {
      await pump(tester, FakeAssistantApi(cardIds: ['c', 'a'], demo: true));
      expect(find.text('Plan smarter stops'), findsOneWidget);
      await tester.enterText(find.byKey(const Key('assistantInput')), 'Fuel to Potsdam?');
      await tester.tap(find.byTooltip('Send'));
      await tester.pumpAndSettle();
      expect(find.text('Fuel to Potsdam?'), findsOneWidget);
      expect(find.text('Here are the best stops.'), findsOneWidget);
      expect(find.text('Offline demo — not Claude'), findsOneWidget);
      expect(find.text('C'), findsOneWidget);
      expect(find.text('A'), findsOneWidget);
      expect(tester.getTopLeft(find.text('C')).dy, lessThan(tester.getTopLeft(find.text('A')).dy));
      expect(find.byTooltip('New chat'), findsOneWidget);
      await tester.tap(find.byTooltip('New chat'));
      await tester.pumpAndSettle();
      expect(find.text('Plan smarter stops'), findsOneWidget);
    });

    testWidgets('suggestion chip sends a message', (tester) async {
      final api = FakeAssistantApi();
      await pump(tester, api);
      await tester.tap(find.text(assistantSuggestions(kEnglish).first));
      await tester.pumpAndSettle();
      expect(api.sentMessages.single.$2, assistantSuggestions(kEnglish).first);
    });
  });
}
