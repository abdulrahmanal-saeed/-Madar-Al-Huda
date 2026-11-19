import 'package:material_ui/material_ui.dart';

import 'app_locales.dart';

extension L10nContext on BuildContext {
  /// Shorthand for `AppLocalizations.of(context)`.
  AppLocalizations get l10n => AppLocalizations.of(this);
}
