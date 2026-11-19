import 'dart:ui' show Locale;

import 'generated/app_localizations.dart';

export 'generated/app_localizations.dart';

/// Supported UI languages. Arabic is listed first as the primary language.
abstract final class AppLocales {
  static const Locale arabic = Locale('ar');
  static const Locale english = Locale('en');

  /// Used when the device language is neither Arabic nor English.
  static const Locale fallback = english;

  static const List<Locale> supported = AppLocalizations.supportedLocales;

  /// Picks the UI locale when the user follows the device language.
  ///
  /// Walks the device's preferred languages in order and returns the first
  /// supported one, matching on language code only (e.g. `ar-EG` → `ar`).
  static Locale resolveDeviceLocale(List<Locale>? deviceLocales) {
    for (final device in deviceLocales ?? const <Locale>[]) {
      for (final candidate in supported) {
        if (candidate.languageCode == device.languageCode) return candidate;
      }
    }
    return fallback;
  }
}
