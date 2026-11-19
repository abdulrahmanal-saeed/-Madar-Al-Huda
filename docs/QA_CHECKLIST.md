# Manual QA checklist — Madar Al-Huda (P00-09)

Checks that automated tests in `.github/workflows/mobile-ci.yml` can't cover. Run the
sections that match the change and paste the results table into the PR.
Definitions of severity and "done": [../plan/DEFINITION_OF_DONE.md](../plan/DEFINITION_OF_DONE.md).

## How to record

Copy this into the PR and fill it in:

```markdown
| Section | Device / emulator (model, Android version) | Locale | Theme | Result | Notes |
|---|---|---|---|---|---|
| A. Install & launch | Pixel 7 emulator, Android 15 | ar | light | Pass | |
```

Results are **Pass**, **Fail** (with an issue or finding), or **Not run** (with a reason).
Never mark a row Pass without running it.

## Environment

- Install the **debug APK artifact from the CI run on the PR's head SHA** (`madar-al-huda-debug-apk`), or build it with `flutter build apk --debug` from that commit.
- Minimum matrix for Phase 0: one emulator or device at API 24–26 (minSdk range) and one at API 34+. Phase 05 extends this (P05-03).
- Run every section in **Arabic and English** unless marked otherwise.

## A. Install and launch
- [ ] The app installs and launches with **no permission prompt** and **without network** (airplane mode).
- [ ] The launcher label is "مدار الهدى" with the device set to Arabic and "Madar Al-Huda" with it set to English.
- [ ] The splash screen colour matches the theme (ivory in light mode, dark in dark mode); there is no white flash in dark mode.
- [ ] A cold start lands on Home; nothing crashes after 3 relaunches.

## B. Language and direction
- [ ] With "Device language" selected, an Arabic device shows Arabic RTL and an English device English LTR. Any other device language (e.g. French) shows English.
- [ ] Switching language in Settings updates every visible screen immediately, without a restart.
- [ ] The choice survives a force-stop and relaunch.
- [ ] RTL: the first tab is on the right; back arrows and chevrons point the correct way; text is right-aligned; no mixed-direction punctuation glitches in Arabic strings.
- [ ] Android 13+: Settings → Apps → Madar Al-Huda → Language lists Arabic and English only.
- [ ] Arabic copy reads naturally. Note any phrase that needs language review.

## C. Navigation
- [ ] All five tabs open. Each hub lists its sections, and each section opens.
- [ ] In a tab, open a section, switch tabs, then come back: the section is still open.
- [ ] Re-tapping the active tab returns to its root.
- [ ] The system back button pops one level, and on a tab root exits as expected.
- [ ] Settings opens above the tabs, and back returns to the same tab.
- [ ] Rotate to landscape and back: no layout breakage or lost state.
- [ ] Tablet or ≥ 600 dp width: the navigation rail is shown and works.

## D. Theme, motion and text size
- [ ] Light, Dark and System all apply immediately and persist across relaunch.
- [ ] System mode follows the device's dark-mode toggle while the app is open.
- [ ] "Reduce motion" removes page transition animations and persists.
- [ ] Device font size set to the largest and display size to the largest: no clipped or overlapping text on Home, the hubs, a section, or Settings.

## E. Accessibility (TalkBack)
- [ ] Every tab, card, quick-access tile, and Settings control is announced with a meaningful label in the current language.
- [ ] Section headers are announced as headings; the status panel text is read.
- [ ] Focus order follows the reading direction (right-to-left in Arabic).
- [ ] Every interactive element can be reached and activated with TalkBack gestures alone.

## F. Content integrity (every PR until content is approved)
- [ ] No Quran verse, hadith, tafsir, ruling, dhikr text, story or prayer time appears anywhere.
- [ ] Every content section shows its status panel (awaiting source, audio rights, scholarly review, editorial review, calculation validation, or in development).
- [ ] From the PR that first publishes a content type onward, use the religious-content checklist in the DoD §2.3 instead.

## G. Privacy and permissions
- [ ] Settings → Apps → Madar Al-Huda → Permissions shows **no permissions** (Phase 0).
- [ ] No account or sign-in prompt anywhere.
- [ ] Optional, debug build: with a proxy or network inspector, launching and navigating makes no network requests.

## H. Persistence robustness
- [ ] Change language, theme and reduce motion quickly several times, then force-stop. On relaunch the last choices are shown.
- [ ] Clear app storage: the app starts with defaults (device language, system theme).

## Phase 0 gate 1 sign-off

| Item | Arabic | English |
|---|---|---|
| Sections A–D pass on emulator or device | ☐ | ☐ |
| Tester / date | | |
