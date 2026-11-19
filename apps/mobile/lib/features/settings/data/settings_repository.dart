import '../../../core/storage/key_value_store.dart';
import '../domain/app_settings.dart';

/// Reads and writes [AppSettings] in the local [KeyValueStore].
///
/// Keys are namespaced and versioned via [schemaVersionKey] so later phases
/// can migrate stored values without guessing their format.
class SettingsRepository {
  SettingsRepository(this._store);

  final KeyValueStore _store;

  static const String schemaVersionKey = 'settings.schemaVersion';
  static const String languageKey = 'settings.language';
  static const String themeKey = 'settings.theme';
  static const String reduceMotionKey = 'settings.reduceMotion';

  /// Current on-disk format. Increment together with a migration.
  static const String schemaVersion = '1';

  /// Every key this repository may touch (used as the store allow-list).
  static const Set<String> keys = {
    schemaVersionKey,
    languageKey,
    themeKey,
    reduceMotionKey,
  };

  /// Loads settings. Missing or unrecognised values fall back to defaults,
  /// so a corrupted entry can never prevent the app from starting.
  AppSettings load() => AppSettings(
    language: AppLanguage.fromStorage(_store.getString(languageKey)),
    theme: AppThemePreference.fromStorage(_store.getString(themeKey)),
    reduceMotion: _store.getBool(reduceMotionKey) ?? false,
  );

  Future<void> saveLanguage(AppLanguage language) async {
    await _store.setString(languageKey, language.storageValue);
    await _markSchema();
  }

  Future<void> saveTheme(AppThemePreference theme) async {
    await _store.setString(themeKey, theme.storageValue);
    await _markSchema();
  }

  Future<void> saveReduceMotion({required bool enabled}) async {
    await _store.setBool(reduceMotionKey, value: enabled);
    await _markSchema();
  }

  Future<void> _markSchema() =>
      _store.setString(schemaVersionKey, schemaVersion);
}
