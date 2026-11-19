import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:madar_al_huda/core/storage/key_value_store.dart';
import 'package:madar_al_huda/core/storage/storage_providers.dart';
import 'package:madar_al_huda/features/settings/application/settings_controller.dart';
import 'package:madar_al_huda/features/settings/data/settings_repository.dart';
import 'package:madar_al_huda/features/settings/domain/app_settings.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

/// A store whose writes always fail, to test error handling.
final class _FailingStore extends InMemoryKeyValueStore {
  @override
  Future<void> setString(String key, String value) =>
      Future.error(StateError('disk full'));
}

void main() {
  group('SettingsRepository', () {
    test('defaults when nothing is stored', () {
      expect(
        SettingsRepository(InMemoryKeyValueStore()).load(),
        const AppSettings(),
      );
    });

    test('round-trips every setting', () async {
      final store = InMemoryKeyValueStore();
      final repo = SettingsRepository(store);
      await repo.saveLanguage(AppLanguage.arabic);
      await repo.saveTheme(AppThemePreference.dark);
      await repo.saveReduceMotion(enabled: true);

      expect(
        SettingsRepository(store).load(),
        const AppSettings(
          language: AppLanguage.arabic,
          theme: AppThemePreference.dark,
          reduceMotion: true,
        ),
      );
      expect(
        store.values[SettingsRepository.schemaVersionKey],
        SettingsRepository.schemaVersion,
      );
    });

    test('corrupt or unknown values fall back to defaults', () {
      final store = InMemoryKeyValueStore({
        SettingsRepository.languageKey: 'klingon',
        SettingsRepository.themeKey: 42,
        SettingsRepository.reduceMotionKey: 'yes',
      });
      expect(SettingsRepository(store).load(), const AppSettings());
    });

    test('storage values are stable (never rename without migration)', () {
      expect(AppLanguage.values.map((e) => e.storageValue), [
        'system',
        'ar',
        'en',
      ]);
      expect(AppThemePreference.values.map((e) => e.storageValue), [
        'system',
        'light',
        'dark',
      ]);
    });
  });

  group('SharedPreferencesKeyValueStore', () {
    setUp(() {
      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.empty();
    });

    test('persists across store instances', () async {
      final first = await SharedPreferencesKeyValueStore.create(
        allowList: SettingsRepository.keys,
      );
      await SettingsRepository(first).saveLanguage(AppLanguage.english);
      await SettingsRepository(first).saveReduceMotion(enabled: true);

      final second = await SharedPreferencesKeyValueStore.create(
        allowList: SettingsRepository.keys,
      );
      final loaded = SettingsRepository(second).load();
      expect(loaded.language, AppLanguage.english);
      expect(loaded.reduceMotion, isTrue);
    });

    test('mistyped stored values read as null instead of throwing', () async {
      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.withData({
            SettingsRepository.languageKey: 7,
            SettingsRepository.reduceMotionKey: 'true',
          });
      final store = await SharedPreferencesKeyValueStore.create(
        allowList: SettingsRepository.keys,
      );
      expect(SettingsRepository(store).load(), const AppSettings());
    });

    test('rejects keys outside the allow-list', () async {
      final store = await SharedPreferencesKeyValueStore.create(
        allowList: SettingsRepository.keys,
      );
      expect(() => store.setString('tracking.id', 'x'), throwsArgumentError);
    });
  });

  group('SettingsController', () {
    ProviderContainer containerWith(KeyValueStore store) {
      final container = ProviderContainer(
        overrides: [keyValueStoreProvider.overrideWithValue(store)],
      );
      addTearDown(container.dispose);
      return container;
    }

    test('loads persisted settings on start', () {
      final store = InMemoryKeyValueStore({
        SettingsRepository.themeKey: 'light',
      });
      final container = containerWith(store);
      expect(
        container.read(settingsControllerProvider).theme,
        AppThemePreference.light,
      );
    });

    test('updates state and persists', () async {
      final store = InMemoryKeyValueStore();
      final container = containerWith(store);
      final controller = container.read(settingsControllerProvider.notifier);

      await controller.setLanguage(AppLanguage.arabic);
      await controller.setTheme(AppThemePreference.dark);
      await controller.setReduceMotion(enabled: true);

      expect(
        container.read(settingsControllerProvider),
        const AppSettings(
          language: AppLanguage.arabic,
          theme: AppThemePreference.dark,
          reduceMotion: true,
        ),
      );
      expect(store.values[SettingsRepository.languageKey], 'ar');
      expect(store.values[SettingsRepository.themeKey], 'dark');
      expect(store.values[SettingsRepository.reduceMotionKey], true);
    });

    test('reverts state and rethrows when saving fails', () async {
      final container = containerWith(_FailingStore());
      final controller = container.read(settingsControllerProvider.notifier);

      await expectLater(
        controller.setLanguage(AppLanguage.arabic),
        throwsStateError,
      );
      expect(
        container.read(settingsControllerProvider).language,
        AppLanguage.system,
      );
    });
  });
}
