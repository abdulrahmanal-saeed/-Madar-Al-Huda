import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/storage_providers.dart';
import '../data/settings_repository.dart';
import '../domain/app_settings.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(keyValueStoreProvider)),
);

final settingsControllerProvider =
    NotifierProvider<SettingsController, AppSettings>(SettingsController.new);

/// The independently persisted fields of [AppSettings].
enum _Field {
  language,
  theme,
  reduceMotion;

  /// Returns [into] with this field's value taken from [from].
  AppSettings copy({required AppSettings from, required AppSettings into}) =>
      switch (this) {
        language => into.copyWith(language: from.language),
        theme => into.copyWith(theme: from.theme),
        reduceMotion => into.copyWith(reduceMotion: from.reduceMotion),
      };
}

/// Holds the current [AppSettings] and persists every change.
///
/// Concurrency model (see PR #4 review):
/// * **Optimistic UI** — [state] reflects the newest request immediately.
/// * **Serialized writes** — saves run one at a time, in request order, so
///   disk can never end up with an older value written after a newer one.
/// * **Coalescing** — a queued save that has been superseded by a newer
///   request for the *same* field is skipped; the newest value wins.
/// * **Field-scoped rollback** — if the newest save for a field fails, only
///   that field reverts, to its last *persisted* value. Other fields (and any
///   successful changes) are untouched. A failure of a save that was already
///   superseded changes nothing and does not surface an error, because the
///   user's latest choice is still being saved.
///
/// The returned future completes when the request is settled: normally if it
/// was saved or superseded, with an error if it was the latest request for
/// its field and could not be saved (the UI shows a message).
class SettingsController extends Notifier<AppSettings> {
  /// What is known to be on disk (initially: what was loaded).
  late AppSettings _persisted;

  /// Latest request revision per field; used to detect superseded saves.
  final Map<_Field, int> _latestRevision = {};
  int _revision = 0;

  /// Tail of the serialized write queue.
  Future<void> _queue = Future<void>.value();

  SettingsRepository get _repository => ref.read(settingsRepositoryProvider);

  @override
  AppSettings build() {
    final loaded = ref.watch(settingsRepositoryProvider).load();
    _persisted = loaded;
    _latestRevision.clear();
    _queue = Future<void>.value();
    return loaded;
  }

  Future<void> setLanguage(AppLanguage language) => _request(
    _Field.language,
    state.copyWith(language: language),
    () => _repository.saveLanguage(language),
  );

  Future<void> setTheme(AppThemePreference theme) => _request(
    _Field.theme,
    state.copyWith(theme: theme),
    () => _repository.saveTheme(theme),
  );

  Future<void> setReduceMotion({required bool enabled}) => _request(
    _Field.reduceMotion,
    state.copyWith(reduceMotion: enabled),
    () => _repository.saveReduceMotion(enabled: enabled),
  );

  Future<void> _request(
    _Field field,
    AppSettings requested,
    Future<void> Function() save,
  ) {
    // Already showing this value: either it is persisted, or the newest
    // queued save for this field writes exactly this value.
    if (requested == state) return Future<void>.value();

    final revision = ++_revision;
    _latestRevision[field] = revision;
    state = requested;

    final settled = Completer<void>();
    _queue = _queue.then((_) async {
      if (!ref.mounted || _latestRevision[field] != revision) {
        settled.complete(); // Superseded before it started: coalesced.
        return;
      }
      try {
        await save();
        _persisted = field.copy(from: requested, into: _persisted);
        settled.complete();
      } catch (error, stack) {
        final isLatest = _latestRevision[field] == revision;
        if (isLatest && ref.mounted) {
          state = field.copy(from: _persisted, into: state);
          settled.completeError(error, stack);
        } else {
          settled.complete(); // A newer request for this field will save.
        }
      }
    });
    return settled.future;
  }
}
