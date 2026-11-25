import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'l10n.dart';

/// App-bar menu to pick the app language (device default, English, Bengali).
class LanguageMenuButton extends ConsumerWidget {
  const LanguageMenuButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return PopupMenuButton<String>(
      tooltip: l.language,
      icon: const Icon(Icons.translate_rounded),
      // Read lazily: the preference lives in the local database.
      itemBuilder: (_) {
        final current = ref.read(localePreferenceProvider).value ?? 'system';
        return [
          for (final (code, label) in [('system', l.languageSystem), ('en', l.languageEnglish), ('bn', l.languageBengali)])
            CheckedPopupMenuItem(value: code, checked: code == current, child: Text(label)),
        ];
      },
      onSelected: (code) => saveLocalePreference(ref, code == 'system' ? null : code),
    );
  }
}
