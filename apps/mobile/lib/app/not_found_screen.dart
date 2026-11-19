import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../core/localization/l10n_extension.dart';
import '../core/routing/app_routes.dart';
import '../core/theme/app_tokens.dart';
import '../core/widgets/responsive_content.dart';

/// Shown for unknown routes (e.g. a stale deep link).
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: Center(
        child: ResponsiveContent(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.travel_explore_outlined,
                size: 48,
                color: theme.colorScheme.secondary,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n.notFoundTitle,
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.notFoundBody,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: () => context.go(AppRoutes.home),
                child: Text(l10n.notFoundAction),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
