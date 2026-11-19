import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/routing/app_sections.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/brand_colors.dart';
import '../../../core/widgets/icon_badge.dart';
import '../../../core/widgets/orbit_motif.dart';
import '../../../core/widgets/responsive_content.dart';
import '../../../core/widgets/settings_button.dart';

/// Home tab: greeting, today's date, shortcuts and honest status notices.
///
/// Shows no prayer times, verses or hadith until those features are
/// verified; the shortcuts lead to the (gated) section screens.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.clock = DateTime.now});

  /// Injected for deterministic tests.
  final DateTime Function() clock;

  static const List<AppSection> quickAccess = [
    AppSection.prayerTimes,
    AppSection.qibla,
    AppSection.mushaf,
    AppSection.adhkar,
    AppSection.hadith,
    AppSection.lessons,
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text(l10n.appTitle),
            actions: const [SettingsButton()],
          ),
          SliverResponsiveContent(
            sliver: SliverList.list(
              children: [
                const SizedBox(height: AppSpacing.sm),
                _HeroCard(today: clock()),
                const SizedBox(height: AppSpacing.xl),
                Semantics(
                  header: true,
                  child: Text(
                    l10n.homeQuickAccess,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                const _QuickAccessGrid(sections: quickAccess),
                const SizedBox(height: AppSpacing.xl),
                _NoticeCard(
                  icon: Icons.verified_user_outlined,
                  title: l10n.homePreviewTitle,
                  body: l10n.homePreviewBody,
                ),
                const SizedBox(height: AppSpacing.md),
                _NoticeCard(
                  icon: Icons.favorite_outline,
                  title: l10n.homePromiseTitle,
                  body: l10n.homePromiseBody,
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.today});

  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final date = DateFormat.yMMMMEEEEd(locale).format(today);

    const onHero = BrandColors.ivory;
    final gradient = isDark
        ? const [Color(0xFF173F39), Color(0xFF0F2A25)]
        : const [BrandColors.primaryGreen, BrandColors.heroGreenEnd];

    return ClipRRect(
      borderRadius: AppRadii.xlAll,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
            colors: gradient,
          ),
        ),
        child: Stack(
          children: [
            const Positioned.fill(
              child: OrbitMotif(color: BrandColors.mutedGold),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.homeGreeting,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: onHero,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l10n.appTagline,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: onHero.withValues(alpha: 0.85),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Container(height: 1, width: 48, color: BrandColors.mutedGold),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    l10n.homeTodayLabel,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: BrandColors.goldBright,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    date,
                    key: const ValueKey('home-today-date'),
                    style: theme.textTheme.titleMedium?.copyWith(color: onHero),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAccessGrid extends StatelessWidget {
  const _QuickAccessGrid({required this.sections});

  final List<AppSection> sections;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final columns = constraints.maxWidth >= AppBreakpoints.medium - 40
          ? 3
          : 2;
      final rows = <Widget>[];
      for (var i = 0; i < sections.length; i += columns) {
        final rowItems = sections.skip(i).take(columns).toList();
        rows.add(
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var j = 0; j < columns; j++) ...[
                  if (j > 0) const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: j < rowItems.length
                        ? _QuickAccessTile(section: rowItems[j])
                        : const SizedBox.shrink(),
                  ),
                ],
              ],
            ),
          ),
        );
      }
      return Column(
        children: [
          for (var r = 0; r < rows.length; r++) ...[
            if (r > 0) const SizedBox(height: AppSpacing.md),
            rows[r],
          ],
        ],
      );
    },
  );
}

class _QuickAccessTile extends StatelessWidget {
  const _QuickAccessTile({required this.section});

  final AppSection section;

  static Key keyFor(AppSection s) => ValueKey('quick-access-$s');

  @override
  Widget build(BuildContext context) {
    final title = section.title(context.l10n);
    return Card(
      key: keyFor(section),
      child: Semantics(
        button: true,
        label: title,
        excludeSemantics: true,
        child: InkWell(
          onTap: () => context.go(section.path),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconBadge(icon: section.icon, size: 40),
                const SizedBox(height: AppSpacing.md),
                Text(title, style: Theme.of(context).textTheme.titleSmall),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: scheme.secondary),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleSmall),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    body,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
