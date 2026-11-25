import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../../l10n/l10n.dart';

/// Centered loading indicator with optional label.
class AppLoading extends StatelessWidget {
  const AppLoading({super.key, this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Semantics(
        liveRegion: true,
        label: label ?? context.l10n.loading,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            if (label != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(label!, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ],
        ),
      ),
    );
  }
}

/// Generic message view: icon, title, body and up to two actions.
class AppMessageView extends StatelessWidget {
  const AppMessageView({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.primaryLabel,
    this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? primaryLabel;
  final VoidCallback? onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 56, color: theme.colorScheme.primary),
              const SizedBox(height: AppSpacing.md),
              Text(title, style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
              if (message != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  message!,
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
              ],
              if (primaryLabel != null) ...[
                const SizedBox(height: AppSpacing.lg),
                FilledButton(onPressed: onPrimary, child: Text(primaryLabel!)),
              ],
              if (secondaryLabel != null) ...[
                const SizedBox(height: AppSpacing.sm),
                TextButton(onPressed: onSecondary, child: Text(secondaryLabel!)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class AppErrorView extends StatelessWidget {
  const AppErrorView({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => AppMessageView(
        icon: Icons.cloud_off_rounded,
        title: context.l10n.somethingWentWrong,
        message: message,
        primaryLabel: onRetry == null ? null : context.l10n.tryAgain,
        onPrimary: onRetry,
      );
}

class AppEmptyView extends StatelessWidget {
  const AppEmptyView({super.key, required this.title, this.message, this.icon = Icons.search_off_rounded});

  final String title;
  final String? message;
  final IconData icon;

  @override
  Widget build(BuildContext context) => AppMessageView(icon: icon, title: title, message: message);
}
