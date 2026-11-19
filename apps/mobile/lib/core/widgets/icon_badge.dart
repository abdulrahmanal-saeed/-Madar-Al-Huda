import 'package:material_ui/material_ui.dart';

import '../theme/app_tokens.dart';

/// Rounded, tinted square holding an icon. Used by cards and tiles.
class IconBadge extends StatelessWidget {
  const IconBadge({required this.icon, super.key, this.size = 48});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: AppRadii.mdAll,
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: size * 0.5, color: scheme.onPrimaryContainer),
    );
  }
}
