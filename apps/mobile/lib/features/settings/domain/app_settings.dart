import 'package:material_ui/material_ui.dart' show Locale, ThemeMode;

import '../../../core/localization/app_locales.dart';

/// The user's language choice. [system] follows the device language.
enum AppLanguage {
  system('system'),
  arabic('ar'),
  english('en');

  const AppLanguage(this.storageValue);

  /// Stable value written to storage. Never rename existing values.
  final String storageValue;

  static AppLanguage fromStorage(String? value) => AppLanguage.values
      .firstWhere((l) => l.storageValue == value, orElse: () => system);

  /// The explicit locale, or `null` to follow the device.
  Locale? get locale => switch (this) {
    AppLanguage.system => null,
    AppLanguage.arabic => AppLocales.arabic,
    AppLanguage.english => AppLocales.english,
  };
}

/// The user's theme choice.
enum AppThemePreference {
  system('system', ThemeMode.system),
  light('light', ThemeMode.light),
  dark('dark', ThemeMode.dark);

  const AppThemePreference(this.storageValue, this.themeMode);

  final String storageValue;
  final ThemeMode themeMode;

  static AppThemePreference fromStorage(String? value) => AppThemePreference
      .values
      .firstWhere((t) => t.storageValue == value, orElse: () => system);
}

/// Local, device-only user preferences. Guest-first: no account involved.
final class AppSettings {
  const AppSettings({
    this.language = AppLanguage.system,
    this.theme = AppThemePreference.system,
    this.reduceMotion = false,
  });

  final AppLanguage language;
  final AppThemePreference theme;
  final bool reduceMotion;

  AppSettings copyWith({
    AppLanguage? language,
    AppThemePreference? theme,
    bool? reduceMotion,
  }) => AppSettings(
    language: language ?? this.language,
    theme: theme ?? this.theme,
    reduceMotion: reduceMotion ?? this.reduceMotion,
  );

  @override
  bool operator ==(Object other) =>
      other is AppSettings &&
      other.language == language &&
      other.theme == theme &&
      other.reduceMotion == reduceMotion;

  @override
  int get hashCode => Object.hash(language, theme, reduceMotion);

  @override
  String toString() =>
      'AppSettings(language: $language, theme: $theme, '
      'reduceMotion: $reduceMotion)';
}
