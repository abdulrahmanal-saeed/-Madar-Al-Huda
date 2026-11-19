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

  // Each save writes the schema marker *before* the value. If the marker
  // write fails, the value is never written, so a failed save leaves disk
  // unchanged and the caller's rollback keeps UI and disk consistent.
  // (A marker without a changed value is harmless: it only describes the
  // format of values already on disk.)

  Future<void> saveLanguage(AppLanguage language) async {
    await _ensureSchemaMarker();
    await _store.setString(languageKey, language.storageValue);
  }

  Future<void> saveTheme(AppThemePreference theme) async {
    await _ensureSchemaMarker();
    await _store.setString(themeKey, theme.storageValue);
  }

  Future<void> saveReduceMotion({required bool enabled}) async {
    await _ensureSchemaMarker();
    await _store.setBool(reduceMotionKey, value: enabled);
  }

  Future<void> _ensureSchemaMarker() async {
    if (_store.getString(schemaVersionKey) == schemaVersion) return;
    await _store.setString(schemaVersionKey, schemaVersion);
  }
}
