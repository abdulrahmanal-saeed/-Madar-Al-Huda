# Implementation log

Implementation updates must include: task ID, branch, changed files, commands/tests actually run, known limitations and PR link.

---

## 2026-11-19 — P00-06 / MHD-001: Flutter Android skeleton + AR/EN localization

| Field | Value |
|---|---|
| Task | `P00-06` (tracker) / `MHD-001` / [Issue #2](https://github.com/abdulrahmanal-saeed/madar-al-huda/issues/2) |
| Status | `REVIEW` — PR open, not merged |
| Branch | `claude/serene-galileo-f2ia01` (session-assigned branch; `plan/WORKFLOW.md` suggests `phase-00/p00-06-…`) |
| Agent | Claude Code (coding agent) |
| PR | See the PR opened from this branch (link recorded in the PR body and the tracker after creation) |

### Dependency note
`P00-06` depends on `P00-03` (final identity) and `P00-05` (ERD/architecture approval), both still `TODO`. Per the owner's instruction, the skeleton was built on the **provisional** tokens in `docs/BRAND.md` and the **proposed** architecture in `docs/ARCHITECTURE.md` (decision D-16). Colours, font, launcher icon and app ID are isolated in `lib/core/theme/`, `android/app/src/main/res/` and `build.gradle.kts`, so finalising P00-03/P00-05 does not require restructuring.

### Summary
- New Flutter app in `apps/mobile` (Flutter 3.50.0 stable, Dart 3.14.0), feature-first structure, Riverpod 3 + go_router 18, exact-pinned dependencies, committed `pubspec.lock`.
- Five-tab shell (Home, Quran, Worship, Library, Learning) using `StatefulShellRoute.indexedStack` (per-tab stacks retained; re-tap returns to root); `NavigationRail` at ≥ 600 dp.
- Section screens: Read the Quran, Recitations, Tafsir, Prayer Times, Qibla, Adhkar & Dua, Hadith, Comparative Fiqh, Articles, Lessons & Quizzes, Stories of the Prophets, plus Settings and a 404 page.
- **No religious content.** Every section is gated by `ContentStatus` and shows a neutral, labelled status panel (awaiting source verification / audio rights / scholarly review / editorial review / calculation validation / in development). A test fails if any section becomes ungated without an explicit allow-list change. Home shows only greeting, tagline, today's Gregorian date (device clock, `intl`), shortcuts and two notices.
- Arabic (RTL) + English (LTR) via ARB/gen-l10n; follows device language (Arabic → Arabic, anything else → English, D-13); override in Settings; persisted.
- Light/Dark/System theme, "Reduce motion" (disables page transitions and sets `disableAnimations`), all persisted locally via `shared_preferences` behind a `KeyValueStore` interface with an allow-list and schema version. Corrupt values fall back to defaults; save failures roll back and show a localized message.
- Storage contracts for Quran bookmarks / last-read (`AyahRef` always carries an edition id) — interfaces only; Drift deferred to P01-03.
- Design system: brand colours as Material 3 `ColorScheme`s (light/dark), spacing/radius/breakpoint tokens, reusable widgets (`HubScaffold`, `SectionCard`, `SectionDetailScaffold`, `ContentStatusPanel`, `StatusPill`, `IconBadge`, `OrbitMotif`, `ResponsiveContent`). IBM Plex Sans Arabic bundled (OFL 1.1, licence shown on the licences page).
- Android: app ID `com.abdulrahmanalsaeed.madaralhuda` (candidate, O-08 open), localized launcher label, `supportsRtl`, Android 13 per-app language config, locale filter (ar/en), brand splash colours, provisional adaptive + legacy icons, `allowBackup=false`, **no permissions** in the main manifest. iOS: same bundle ID, display name, `CFBundleLocalizations` ar/en, provisional icons (not built/tested).
- CI (`.github/workflows/mobile-ci.yml`): gitleaks (checksum-verified binary, full history), policy checks, `pub get --enforce-lockfile`, stale-l10n check, `dart format`, `flutter analyze --fatal-infos`, `flutter test --coverage`, debug APK build + artifact. Actions pinned by SHA. Dependabot for pub/gradle/actions.

### Changed files
- `apps/mobile/**` — new Flutter project (lib, test, android, ios, assets, tool, pubspec, l10n.yaml, analysis_options.yaml, README).
- `.github/workflows/mobile-ci.yml`, `.github/dependabot.yml` — new.
- `docs/screenshots/p00-06/*.png` — 5 reference screenshots (AR/EN, light/dark).
- `plan/TRACKER.md` (P00-06 → REVIEW), `plan/DECISIONS.md` (D-12…D-16), `plan/CHANGELOG.md`, `docs/PHASE_0.md`, `docs/ARCHITECTURE.md`, `README.md`.
- `AI_BRIDGE/TASKS.md`, `AI_BRIDGE/IMPLEMENTATION.md`, `AI_BRIDGE/REVIEW.md`.

### Commands actually executed (in the cloud container, Linux x64)
Toolchain installed for this session: Flutter 3.50.0 stable (`flutter_linux_3.50.0-stable.tar.xz`), Android cmdline-tools, `platforms;android-36`, `build-tools;36.0.0`, `ndk;28.2.13676358` (CMake 3.22.1 auto-installed by Gradle), OpenJDK 21.0.13, Gradle 9.5.0 wrapper.

All run from `apps/mobile/`:

| Command | Result |
|---|---|
| `flutter pub get --enforce-lockfile` | OK |
| `flutter gen-l10n` then compare generated files | Unchanged (stable output) |
| `dart format --output=none --set-exit-if-changed lib test` | 0 changed |
| `flutter analyze --fatal-infos` | **No issues found** |
| `flutter test --coverage` | **81 tests, all passed**; line coverage 97.3 % (928/954, incl. generated l10n) |
| `flutter build apk --debug` | **Built** `build/app/outputs/flutter-apk/app-debug.apk` (first attempts hit HTTP 429 from Maven Central; succeeded on retry) |
| `aapt2 dump badging app-debug.apk` | package `com.abdulrahmanalsaeed.madaralhuda`, versionName 0.1.0, minSdk 24, targetSdk 36, labels en "Madar Al-Huda" / ar "مدار الهدى", locales en+ar. Permissions: `INTERNET` comes only from the debug manifest (Flutter tooling); main manifest has none |
| `./tool/policy_checks.sh` | Passed; negative test (ads SDK, location permission, `^` version, tracked `.jks`) → all four reported, exit 1 |
| `gitleaks dir .` and `gitleaks git .` (v8.30.1, checksum verified) | No leaks found |

Visual check: screens were rendered through a temporary golden test with the real fonts loaded (AR/EN × light/dark × Home/Worship/Prayer Times/Settings). It found and fixed one bug (component text styles had no font size → tiny app-bar titles; now covered by a regression test). The temporary test was removed; 5 screenshots are kept in `docs/screenshots/p00-06/`.

### Not verified / remaining issues
- **No emulator or physical device run.** Acceptance asks for both locales verified on-device or emulator (Phase 0 gate 1) — still needed. Widget tests cover RTL/LTR, mirroring, persistence and text scaling.
- GitHub Actions has not run yet; the first run will be on this PR.
- iOS not built (no macOS); structure only.
- Screen-reader (TalkBack) pass not performed; semantics labels are set on cards and headers.
- Brand assets, font choice, icon and app ID are provisional (P00-03, O-01, O-08).
- `material_ui` (decoupled Material) is new in Flutter 3.4x; generated `app_localizations.dart` still imports deprecated `flutter_localizations` delegates (excluded from analysis; the app uses `material_ui`'s delegates).

### Suggested next task
`P00-09` — QA rules & Definition of Done (PR template, DoD checklist, CI as required check, review checklist), building directly on this CI. Then `P00-10` — prayer fixtures for Dubai, Abu Dhabi, Cairo, Alexandria; this needs **official published reference timetables** (UAE: IACAD/Awqaf; Egypt: Egyptian General Authority of Survey) with documented parameters before any expected values are written. Both formally depend on `P00-05` (architecture approval).

---

## 2026-11-19 — Foundation
- Established initial repository documentation and Phase 0 planning branch.
