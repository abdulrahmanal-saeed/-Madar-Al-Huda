import 'package:material_ui/material_ui.dart';

import '../content/content_status.dart';
import '../localization/l10n_extension.dart';
import '../routing/app_sections.dart';
import '../theme/app_tokens.dart';

/// Neutral, clearly-labelled empty state for a gated section.
///
/// This is the only thing a gated section may render in place of content.
/// It never shows sample verses, hadith, rulings or prayer times.
class ContentStatusPanel extends StatelessWidget {
  const ContentStatusPanel({required this.status, super.key});

  final ContentStatus status;

  static const Key panelKey = ValueKey('content-status-panel');

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Semantics(
      key: panelKey,
      container: true,
      liveRegion: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.surfaceContainerLow,
          borderRadius: AppRadii.lgAll,
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: scheme.secondaryContainer,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  status.icon,
                  size: 22,
                  color: scheme.onSecondaryContainer,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(status.title(l10n), style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              Text(
                status.body(l10n),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
