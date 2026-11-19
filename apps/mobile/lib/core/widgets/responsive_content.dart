import 'package:material_ui/material_ui.dart';

import '../theme/app_tokens.dart';

/// Centers [child] with a readable max width and a consistent page gutter.
class ResponsiveContent extends StatelessWidget {
  const ResponsiveContent({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Align(
    alignment: AlignmentDirectional.topCenter,
    child: ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: AppBreakpoints.maxContentWidth,
      ),
      child: Padding(padding: padding, child: child),
    ),
  );
}

/// Sliver variant of [ResponsiveContent].
class SliverResponsiveContent extends StatelessWidget {
  const SliverResponsiveContent({required this.sliver, super.key});

  final Widget sliver;

  @override
  Widget build(BuildContext context) => SliverLayoutBuilder(
    builder: (context, constraints) {
      final width = constraints.crossAxisExtent;
      final side =
          width > AppBreakpoints.maxContentWidth + 2 * AppSpacing.gutter
          ? (width - AppBreakpoints.maxContentWidth) / 2
          : AppSpacing.gutter;
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: side),
        sliver: sliver,
      );
    },
  );
}
