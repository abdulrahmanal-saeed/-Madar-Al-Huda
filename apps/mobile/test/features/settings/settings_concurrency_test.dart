import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:madar_al_huda/core/storage/key_value_store.dart';
import 'package:madar_al_huda/core/storage/storage_providers.dart';
import 'package:madar_al_huda/features/settings/application/settings_controller.dart';
import 'package:madar_al_huda/features/settings/data/settings_repository.dart';
import 'package:madar_al_huda/features/settings/domain/app_settings.dart';

/// A write the test completes explicitly, in any order it chooses.
final class PendingWrite {
  PendingWrite(this.key, this.value);

  final String key;
  final Object value;
  final Completer<void> _completer = Completer<void>();

  void succeed() => _completer.complete();
  void fail() => _completer.completeError(StateError('write failed: $key'));
}

/// Deterministic store: every write stays pending until the test settles it.
/// A value reaches [disk] only if its write succeeds.
final class ControlledStore implements KeyValueStore {
  ControlledStore([Map<String, Object>? initial]) : disk = {...?initial};

  final Map<String, Object> disk;
  final List<PendingWrite> pending = [];

  /// The pending write for [key] (fails the test if there is none).
  PendingWrite writeFor(String key) => pending.singleWhere((w) => w.key == key);

  /// Every write ever issued, as "key=value", in issue order.
  final List<String> issued = [];

  Future<void> _write(String key, Object value) {
    final write = PendingWrite(key, value);
    pending.add(write);
    issued.add('$key=$value');
    return write._completer.future.then(
      (_) {
        disk[key] = value;
        pending.remove(write);
      },
      onError: (Object e) {
        pending.remove(write);
        throw e;
      },
    );
  }

  @override
  String? getString(String key) {
    final v = disk[key];
    return v is String ? v : null;
  }

  @override
  bool? getBool(String key) {
    final v = disk[key];
    return v is bool ? v : null;
  }

  @override
  Future<void> setString(String key, String value) => _write(key, value);

  @override
  Future<void> setBool(String key, {required bool value}) => _write(key, value);

  @override
  Future<void> remove(String key) async => disk.remove(key);
}

/// Initial disk with the schema marker present, so only value writes are
/// issued (keeps the interleavings readable).
Map<String, Object> markedDisk([Map<String, Object> extra = const {}]) => {
  SettingsRepository.schemaVersionKey: SettingsRepository.schemaVersion,
  ...extra,
};

/// Lets queued microtasks (the serialized write chain) run.
Future<void> flush() => Future<void>.delayed(Duration.zero);

void main() {
  late ControlledStore store;
  late ProviderContainer container;

  SettingsController controller() =>
      container.read(settingsControllerProvider.notifier);
  AppSettings state() => container.read(settingsControllerProvider);

  void open(Map<String, Object> disk) {
    store = ControlledStore(disk);
    container = ProviderContainer(
      overrides: [keyValueStoreProvider.overrideWithValue(store)],
    );
    addTearDown(container.dispose);
    state(); // build
  }

  /// Captures the outcome of a request future without failing the test.
  Future<Object?> outcome(Future<void> f) =>
      f.then<Object?>((_) => 'ok', onError: (Object e) => e);

  test('review scenario: failed theme save does not roll back a '
      'successful language change', () async {
    open(markedDisk());

    final theme = outcome(controller().setTheme(AppThemePreference.dark));
    final language = outcome(controller().setLanguage(AppLanguage.arabic));
    await flush();
    expect(state().theme, AppThemePreference.dark);
    expect(state().language, AppLanguage.arabic);

    // Settled by key, so this test also describes the failure on an
    // implementation that does not serialize writes.
    store.writeFor(SettingsRepository.themeKey).fail();
    await flush();
    expect(await theme, isA<StateError>());
    expect(state().theme, AppThemePreference.system, reason: 'theme reverted');
    expect(
      state().language,
      AppLanguage.arabic,
      reason: 'successful language change must survive the theme rollback',
    );

    store.writeFor(SettingsRepository.languageKey).succeed();
    expect(await language, 'ok');
    expect(state().language, AppLanguage.arabic);
    expect(store.disk[SettingsRepository.languageKey], 'ar');
    expect(store.disk.containsKey(SettingsRepository.themeKey), isFalse);
  });

  test(
    'language failure while a theme change succeeds keeps the theme',
    () async {
      open(markedDisk());

      final language = outcome(controller().setLanguage(AppLanguage.english));
      final theme = outcome(controller().setTheme(AppThemePreference.light));
      await flush();

      store.pending.single.fail(); // language
      await flush();
      store.pending.single.succeed(); // theme

      expect(await language, isA<StateError>());
      expect(await theme, 'ok');
      expect(state(), const AppSettings(theme: AppThemePreference.light));
      expect(store.disk[SettingsRepository.themeKey], 'light');
    },
  );

  test('writes are serialized: never more than one in flight', () async {
    open(markedDisk());

    final all = [
      controller().setTheme(AppThemePreference.dark),
      controller().setLanguage(AppLanguage.arabic),
      controller().setReduceMotion(enabled: true),
    ];
    for (var i = 0; i < all.length; i++) {
      await flush();
      expect(store.pending, hasLength(1));
      store.pending.single.succeed();
    }
    await Future.wait(all);

    expect(store.issued, [
      '${SettingsRepository.themeKey}=dark',
      '${SettingsRepository.languageKey}=ar',
      '${SettingsRepository.reduceMotionKey}=true',
    ]);
    expect(SettingsRepository(store).load(), state());
  });

  test(
    'rapid changes to one setting persist the last value, in order',
    () async {
      open(markedDisk());

      // dark goes in flight; light and system queue behind it.
      final f1 = controller().setTheme(AppThemePreference.dark);
      await flush();
      final f2 = controller().setTheme(AppThemePreference.light);
      final f3 = controller().setTheme(AppThemePreference.system);
      expect(state().theme, AppThemePreference.system);

      store.pending.single.succeed(); // dark
      await flush();
      // light was superseded before it started → coalesced (never written).
      store.pending.single.succeed(); // system
      await Future.wait([f1, f2, f3]);

      expect(store.issued, [
        '${SettingsRepository.themeKey}=dark',
        '${SettingsRepository.themeKey}=system',
      ]);
      expect(store.disk[SettingsRepository.themeKey], 'system');
      expect(state().theme, AppThemePreference.system);
    },
  );

  test('superseded in-flight failure neither reverts nor reports', () async {
    open(markedDisk());

    final first = outcome(controller().setTheme(AppThemePreference.dark));
    await flush();
    final second = outcome(controller().setTheme(AppThemePreference.light));

    store.pending.single.fail(); // dark fails, but light is newer
    await flush();
    expect(state().theme, AppThemePreference.light, reason: 'no revert');
    expect(await first, 'ok', reason: 'superseded: no error surfaced');

    store.pending.single.succeed(); // light
    expect(await second, 'ok');
    expect(store.disk[SettingsRepository.themeKey], 'light');
  });

  test('latest failure reverts to the last persisted value, not the '
      'initial one', () async {
    open(markedDisk());

    final ok = controller().setTheme(AppThemePreference.dark);
    await flush();
    store.pending.single.succeed();
    await ok;

    final failed = outcome(controller().setTheme(AppThemePreference.light));
    await flush();
    store.pending.single.fail();

    expect(await failed, isA<StateError>());
    expect(state().theme, AppThemePreference.dark);
    expect(store.disk[SettingsRepository.themeKey], 'dark');
  });

  test('rapid toggles ending in a failure revert to what is on disk', () async {
    open(markedDisk({SettingsRepository.reduceMotionKey: false}));

    final a = outcome(controller().setReduceMotion(enabled: true));
    await flush();
    final b = outcome(controller().setReduceMotion(enabled: false));
    final c = outcome(controller().setReduceMotion(enabled: true));

    store.pending.single.succeed(); // true written
    await flush();
    store.pending.single.fail(); // latest (true) fails — b was coalesced

    expect(await a, 'ok');
    expect(await b, 'ok');
    expect(await c, isA<StateError>());
    // Disk holds true from the first write; UI must match disk.
    expect(store.disk[SettingsRepository.reduceMotionKey], true);
    expect(state().reduceMotion, true);
  });

  group('schema marker', () {
    test('marker failure leaves value and UI unchanged', () async {
      open({}); // no marker yet

      final f = outcome(controller().setLanguage(AppLanguage.arabic));
      await flush();
      expect(store.pending.single.key, SettingsRepository.schemaVersionKey);
      store.pending.single.fail();

      expect(await f, isA<StateError>());
      expect(store.pending, isEmpty, reason: 'value write never issued');
      expect(store.disk.containsKey(SettingsRepository.languageKey), isFalse);
      expect(state().language, AppLanguage.system);
    });

    test('marker is written once, before the first value', () async {
      open({});

      final f1 = controller().setLanguage(AppLanguage.arabic);
      await flush();
      store.pending.single.succeed(); // marker
      await flush();
      store.pending.single.succeed(); // language
      await f1;

      final f2 = controller().setTheme(AppThemePreference.dark);
      await flush();
      store.pending.single.succeed();
      await f2;

      expect(store.issued, [
        '${SettingsRepository.schemaVersionKey}='
            '${SettingsRepository.schemaVersion}',
        '${SettingsRepository.languageKey}=ar',
        '${SettingsRepository.themeKey}=dark',
      ]);
    });
  });

  test('re-selecting the current value issues no write', () async {
    open(markedDisk({SettingsRepository.themeKey: 'dark'}));
    await controller().setTheme(AppThemePreference.dark);
    await flush();
    expect(store.issued, isEmpty);
  });

  test('UI state always equals disk once all writes settle', () async {
    open(markedDisk());
    // A fixed pseudo-random schedule of requests and outcomes.
    const requests = [
      AppThemePreference.dark,
      AppThemePreference.light,
      AppThemePreference.dark,
      AppThemePreference.system,
      AppThemePreference.light,
    ];
    const succeed = [true, false, true, false, true, false, true];
    var outcomeIndex = 0;
    final futures = <Future<Object?>>[];
    for (final theme in requests) {
      futures.add(outcome(controller().setTheme(theme)));
      await flush();
      if (store.pending.isNotEmpty) {
        succeed[outcomeIndex++ % succeed.length]
            ? store.pending.single.succeed()
            : store.pending.single.fail();
        await flush();
      }
    }
    while (store.pending.isNotEmpty) {
      succeed[outcomeIndex++ % succeed.length]
          ? store.pending.single.succeed()
          : store.pending.single.fail();
      await flush();
    }
    await Future.wait(futures);
    expect(
      state().theme,
      AppThemePreference.fromStorage(
        store.disk[SettingsRepository.themeKey] as String?,
      ),
    );
  });
}
