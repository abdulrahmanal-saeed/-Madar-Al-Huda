# Madar Al-Huda — mobile app (`apps/mobile`)

Flutter app for **مدار الهدى | Madar Al-Huda**. Android first; the iOS target is
kept buildable in structure but is not tested yet (P06-05).

> **Status:** Phase 0 skeleton (P00-06 / MHD-001). The app shell, navigation,
> bilingual UI, themes and local preferences work. **No religious content is
> shipped**: every content section shows a labelled status panel until its
> source rights, scholarly review or calculation validation are complete
> (see `plan/TRACKER.md`).

## Toolchain

| Tool | Version |
|---|---|
| Flutter | 3.50.0 (stable) — Dart 3.14.0 |
| Java (Gradle) | 17+ (CI uses Temurin 21) |
| Android Gradle Plugin / Gradle / Kotlin | 9.3.1 / 9.5.0 / 2.4.20 (Flutter template) |
| Android SDK | compileSdk 36, targetSdk 36, minSdk 24 |

Dependencies are pinned to exact versions and `pubspec.lock` is committed
(decision D-12). Upgrade them in a dedicated PR.

## Commands

```bash
flutter pub get --enforce-lockfile
```

```bash
flutter analyze --fatal-infos
```

```bash
dart format --output=none --set-exit-if-changed lib test
```

```bash
flutter test --coverage
```

```bash
flutter build apk --debug
```

```bash
./tool/policy_checks.sh
```

ARB edits regenerate `lib/core/localization/generated/` on `flutter pub get`
(or run `flutter gen-l10n`). The generated files are committed; CI fails if
they are stale.

## Structure

```
lib/
  main.dart                 Bootstraps preferences, registers font licence
  app/                      MadarApp, router (GoRouter), 5-tab shell, 404
  core/
    content/                ContentStatus — publication gates for sections
    localization/           ARB files (ar, en), generated code, locale rules
    routing/                Route paths and the AppSection catalog
    storage/                KeyValueStore boundary (+ shared_preferences impl)
    theme/                  Brand colours, tokens, light/dark ThemeData
    widgets/                Reusable UI: hub/detail scaffolds, cards, panels
  features/
    home/ quran/ worship/ prayer/ qibla/ adhkar/
    library/ hadith/ fiqh/ articles/ learning/ settings/
test/                       Unit + widget tests (see below)
tool/policy_checks.sh       No ads/tracking SDKs, permissions, pins, secrets
```

Each feature uses `presentation/` (screens), and where needed `domain/`
(models, repository contracts), `data/` (implementations) and
`application/` (Riverpod controllers).

### Navigation

`StatefulShellRoute.indexedStack` gives each tab its own navigation stack,
so switching tabs keeps your place. Re-selecting the active tab returns to its
root. Phones get a bottom `NavigationBar`; widths ≥ 600 dp get a
`NavigationRail`. Settings opens above the shell.

| Tab | Route | Sections |
|---|---|---|
| Home | `/home` | Greeting, today's date, quick access, status notices |
| Quran | `/quran` | `/read`, `/recitations`, `/tafsir` |
| Worship | `/worship` | `/prayer-times`, `/qibla`, `/adhkar` |
| Library | `/library` | `/hadith`, `/fiqh`, `/articles` |
| Learning | `/learning` | `/lessons`, `/prophet-stories` |
| — | `/settings` | Language, appearance, reduce motion, guest mode, licences |

### Content gating

`AppSection.status` (`lib/core/routing/app_sections.dart`) marks why each
section is empty (awaiting source verification, audio rights, scholarly or
editorial review, or calculation validation). `SectionDetailScaffold` renders
only the status panel while a section is gated, and
`test/core/content_gating_test.dart` fails if any section becomes `available`
without being added to its explicit allow-list in a reviewed PR.

### Localization

- Arabic (RTL) and English (LTR). All user-facing strings are in
  `lib/core/localization/arb/`; tests check both catalogs have the same keys.
- Default: follow the device language; Arabic devices get Arabic, all other
  languages fall back to English (D-13). The user can override in Settings;
  the choice is persisted.
- Android 13+ per-app language settings are declared (`locales_config.xml`).

### Local storage boundaries

| Data | Where | Status |
|---|---|---|
| Preferences (language, theme, reduce motion) | `KeyValueStore` → `shared_preferences` (allow-listed keys, schema version) | Implemented |
| Bookmarks, last-read position | `features/quran/domain/quran_storage_contracts.dart` interfaces → Drift/SQLite | Contracts only (P01-03) |
| Licensed offline content (Quran edition, tafsir, audio cache) | Versioned, checksummed datasets behind provider adapters | Not started (P00-07 → P01-01) |

Android auto-backup is disabled so preferences stay on the device, matching
the in-app privacy statement.

### Design system

Provisional tokens from `docs/BRAND.md` (`lib/core/theme/`). Final identity is
task P00-03. Contrast of every text/background pair in both themes is tested
against WCAG AA (4.5:1). Muted gold `#C7A86D` is decorative only on light
surfaces. UI font: IBM Plex Sans Arabic (SIL OFL 1.1, bundled with its licence),
which covers Arabic and Latin — **not** a Quran typeface. The launcher icon is a
provisional mark (orbit + open book), not an approved logo.

## Tests

| File | Covers |
|---|---|
| `test/app/navigation_test.dart` | 5 destinations, hubs, every section route in AR and EN, per-tab state retention, back navigation, quick access, settings, 404, navigation rail, no clock-like times on Home |
| `test/app/localization_and_theme_test.dart` | Device-language resolution, RTL/LTR mirroring, switching + persistence, 2× text scale, theme switching/persistence, reduce motion, save-failure message |
| `test/features/settings/settings_persistence_test.dart` | Repository round-trip, corrupt values, real `shared_preferences` adapter, allow-list, controller rollback |
| `test/features/settings/settings_concurrency_test.dart` | Deterministic interleavings of overlapping saves: serialization, coalescing, field-scoped rollback to the persisted value, superseded failures, schema-marker failure, UI == disk |
| `test/core/theme/app_theme_test.dart` | Brand colours, WCAG contrast, font family, component text sizes, reduce-motion transitions |
| `test/core/localization/locale_resolution_test.dart` | Locale rules, ARB key parity, translator descriptions |
| `test/core/content_gating_test.dart` | No ungated sections, route uniqueness, `AyahRef` validation |
