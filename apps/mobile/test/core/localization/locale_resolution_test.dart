import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:madar_al_huda/core/localization/app_locales.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  group('AppLocales.resolveDeviceLocale', () {
    test('Arabic device (any region) resolves to Arabic', () {
      expect(
        AppLocales.resolveDeviceLocale(const [Locale('ar', 'EG')]),
        AppLocales.arabic,
      );
      expect(
        AppLocales.resolveDeviceLocale(const [Locale('ar', 'AE')]),
        AppLocales.arabic,
      );
    });

    test('English device resolves to English', () {
      expect(
        AppLocales.resolveDeviceLocale(const [Locale('en', 'GB')]),
        AppLocales.english,
      );
    });

    test('first supported language in the preference list wins', () {
      expect(
        AppLocales.resolveDeviceLocale(const [
          Locale('fr'),
          Locale('ar'),
          Locale('en'),
        ]),
        AppLocales.arabic,
      );
    });

    test('unsupported or empty lists fall back to English', () {
      expect(
        AppLocales.resolveDeviceLocale(const [Locale('fr'), Locale('ur')]),
        AppLocales.fallback,
      );
      expect(AppLocales.resolveDeviceLocale(const []), AppLocales.fallback);
      expect(AppLocales.resolveDeviceLocale(null), AppLocales.fallback);
    });

    test('supports exactly Arabic and English', () {
      expect(AppLocales.supported.map((l) => l.languageCode).toSet(), {
        'ar',
        'en',
      });
    });
  });

  group('ARB catalogs', () {
    Map<String, dynamic> load(String name) =>
        jsonDecode(File('lib/core/localization/arb/$name').readAsStringSync())
            as Map<String, dynamic>;

    Set<String> messageKeys(Map<String, dynamic> arb) =>
        arb.keys.where((k) => !k.startsWith('@')).toSet();

    test('Arabic and English define the same message keys', () {
      final en = messageKeys(load('app_en.arb'));
      final ar = messageKeys(load('app_ar.arb'));
      expect(ar.difference(en), isEmpty, reason: 'keys only in Arabic');
      expect(en.difference(ar), isEmpty, reason: 'keys missing in Arabic');
    });

    test('no message is empty, and Arabic messages contain Arabic', () {
      final ar = load('app_ar.arb');
      final arabicLetters = RegExp(r'[؀-ۿ]');
      // Language names are intentionally shown in their own language.
      const nativeNames = {'languageEnglish'};
      for (final key in messageKeys(ar)) {
        final value = ar[key] as String;
        expect(value.trim(), isNotEmpty, reason: key);
        if (!nativeNames.contains(key)) {
          expect(value, contains(arabicLetters), reason: key);
        }
      }
    });

    test('every English message has a description for translators', () {
      final en = load('app_en.arb');
      for (final key in messageKeys(en)) {
        final meta = en['@$key'] as Map<String, dynamic>?;
        expect(meta?['description'], isA<String>(), reason: key);
      }
    });
  });
}
