import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'key_value_store.dart';

/// The preferences store. Must be overridden at the app root (see main.dart),
/// because the real store is created asynchronously before `runApp`.
final keyValueStoreProvider = Provider<KeyValueStore>(
  (ref) => throw UnimplementedError(
    'keyValueStoreProvider must be overridden in ProviderScope.',
  ),
);
