import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/app_failure.dart';
import '../../../core/error/result.dart';
import '../../../core/location/location_controller.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/state_views.dart';
import '../data/places_place_search_repository.dart';
import '../domain/along_route_models.dart';
import 'along_route_providers.dart';

String newSessionToken([Random? random]) {
  final r = random ?? Random.secure();
  return List.generate(32, (_) => r.nextInt(16).toRadixString(16)).join();
}

/// "Where to?" — Places Autocomplete with debounce and one billing session.
class DestinationSearchScreen extends ConsumerStatefulWidget {
  const DestinationSearchScreen({super.key, this.debounce = const Duration(milliseconds: 350)});

  final Duration debounce;

  @override
  ConsumerState<DestinationSearchScreen> createState() => _DestinationSearchScreenState();
}

class _DestinationSearchScreenState extends ConsumerState<DestinationSearchScreen> {
  final _query = TextEditingController();
  String _session = newSessionToken();
  Timer? _timer;
  AsyncValue<List<PlaceSuggestion>> _results = const AsyncData([]);
  int _requestId = 0;
  bool _resolving = false;

  @override
  void dispose() {
    _timer?.cancel();
    _query.dispose();
    super.dispose();
  }

  void _onChanged(String text) {
    _timer?.cancel();
    if (text.trim().length < 2) {
      setState(() => _results = const AsyncData([]));
      return;
    }
    _timer = Timer(widget.debounce, () => _search(text));
  }

  Future<void> _search(String text) async {
    final id = ++_requestId;
    setState(() => _results = const AsyncLoading());
    final near = ref.read(locationControllerProvider).value;
    final result = await ref.read(placeSearchRepositoryProvider).autocomplete(text, near: near, sessionToken: _session);
    if (!mounted || id != _requestId) return; // a newer query superseded this one
    setState(() => _results = result.when(ok: AsyncData.new, err: (f) => AsyncError(f, StackTrace.current)));
  }

  Future<void> _select(PlaceSuggestion s) async {
    setState(() => _resolving = true);
    final result = await ref.read(placeSearchRepositoryProvider).resolve(s.placeId, sessionToken: _session);
    _session = newSessionToken(); // session ends with the details call
    if (!mounted) return;
    setState(() => _resolving = false);
    switch (result) {
      case Ok(:final value):
        _start(value);
      case Err(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failure.message)));
    }
  }

  void _start(Destination d) {
    unawaited(ref.read(alongRouteControllerProvider.notifier).plan(d));
    context.pushReplacement(AppRoutes.planRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          key: const Key('destination'),
          controller: _query,
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(hintText: 'Where to?', border: InputBorder.none, filled: false),
          onChanged: _onChanged,
          onSubmitted: (t) {
            _timer?.cancel();
            if (t.trim().length >= 2) _search(t);
          },
        ),
        bottom: _resolving
            ? const PreferredSize(preferredSize: Size.fromHeight(4), child: LinearProgressIndicator())
            : null,
      ),
      body: switch (_results) {
        AsyncError(:final error) => AppErrorView(
          message: error is AppFailure ? error.message : 'Search failed.',
          onRetry: () => _search(_query.text),
        ),
        AsyncLoading() => const AppLoading(label: 'Searching…'),
        AsyncData(:final value) when value.isEmpty && _query.text.trim().length >= 2 => const AppEmptyView(
          title: 'No places found',
          message: 'Try another name or address.',
        ),
        AsyncData(:final value) when value.isEmpty => const _SearchHint(),
        AsyncData(:final value) => ListView.separated(
          itemCount: value.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final s = value[i];
            return ListTile(
              leading: const Icon(Icons.place_outlined),
              title: Text(s.primaryText),
              subtitle: s.secondaryText == null ? null : Text(s.secondaryText!),
              enabled: !_resolving,
              onTap: () => _select(s),
            );
          },
        ),
      },
    );
  }
}

class _SearchHint extends StatelessWidget {
  const _SearchHint();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Text(
        'Search a destination. FuelWise finds stations along your route and ranks them by the true cost '
        'of stopping — price plus the fuel used by the detour.',
        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
      ),
    );
  }
}
