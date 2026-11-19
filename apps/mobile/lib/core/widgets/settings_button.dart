import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../localization/l10n_extension.dart';
import '../routing/app_routes.dart';

/// App-bar action that opens Settings above the tab shell.
class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  static const Key buttonKey = ValueKey('settings-button');

  @override
  Widget build(BuildContext context) => IconButton(
    key: buttonKey,
    tooltip: context.l10n.openSettings,
    icon: const Icon(Icons.settings_outlined),
    onPressed: () => context.push(AppRoutes.settings),
  );
}
