import 'package:material_ui/material_ui.dart';

import '../content/content_status.dart';
import '../localization/l10n_extension.dart';
import '../routing/app_sections.dart';
import '../theme/app_tokens.dart';

/// Compact label showing why a section has no content yet.
class StatusPill extends StatelessWidget {
  const StatusPill({required this.status, super.key});

  final ContentStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final style = Theme.of(context).textTheme.labelSmall?.copyWith(
      color: scheme.onSecondaryContainer,
      fontWeight: FontWeight.w600,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: const BorderRadius.all(Radius.circular(100)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(status.icon, size: 14, color: scheme.onSecondaryContainer),
            const SizedBox(width: AppSpacing.xs),
            Flexible(
              child: Text(
                status.title(context.l10n),
                style: style,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
