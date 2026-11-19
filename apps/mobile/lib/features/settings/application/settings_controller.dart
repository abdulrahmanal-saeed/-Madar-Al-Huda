import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/storage_providers.dart';
import '../data/settings_repository.dart';
import '../domain/app_settings.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(keyValueStoreProvider)),
);

final settingsControllerProvider =
    NotifierProvider<SettingsController, AppSettings>(SettingsController.new);

/// Holds the current [AppSettings] and persists every change.
///
/// Updates are optimistic: the UI changes immediately, and if persisting
/// fails the previous value is restored and the error is rethrown so the UI
/// can tell the user.
class SettingsController extends Notifier<AppSettings> {
  SettingsRepository get _repository => ref.read(settingsRepositoryProvider);

  @override
  AppSettings build() => ref.watch(settingsRepositoryProvider).load();

  Future<void> setLanguage(AppLanguage language) => _update(
    state.copyWith(language: language),
    () => _repository.saveLanguage(language),
  );

  Future<void> setTheme(AppThemePreference theme) =>
      _update(state.copyWith(theme: theme), () => _repository.saveTheme(theme));

  Future<void> setReduceMotion({required bool enabled}) => _update(
    state.copyWith(reduceMotion: enabled),
    () => _repository.saveReduceMotion(enabled: enabled),
  );

  Future<void> _update(AppSettings next, Future<void> Function() save) async {
    if (next == state) return;
    final previous = state;
    state = next;
    try {
      await save();
    } catch (_) {
      state = previous;
      rethrow;
    }
  }
}
