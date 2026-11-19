# Independent review

Reviewers should post actionable findings with file paths, severity and suggested fix. No tests or runtime validation are claimed for documentation-only changes.

## P00-11 / MHD-008 review checklist (dev update channel)

Status: **awaiting review.** Stacked on PR #5 → #4; merge those first.

- [ ] `.github/workflows/dev-release.yml` runs only after a **successful** `Mobile CI` for a **push** to `main` (never for PRs), or on manual dispatch; no CI checks are duplicated.
- [ ] Signing secrets are only read from `secrets.*`; the keystore is written to `$RUNNER_TEMP` and removed; nothing key-related is committed (gitleaks green).
- [ ] A dev build without signing variables fails (`build.gradle.kts`); local and CI debug builds are unchanged.
- [ ] Published APK: app id `…madaralhuda.dev`, versionName `x.y.z-dev.N`, **no permissions** in the merged manifest.
- [ ] Release cleanup only deletes `vX.Y.Z-dev.N` tags, keeps 10.
- [ ] Owner has added the 3 secrets; first run after merge publishes a prerelease; Obtainium installs and later updates it in place.

---

## P00-09 / MHD-007 review checklist (QA rules & DoD)

Status: **awaiting review.** Stacked on PR #4; review and merge #4 first.

- [ ] `plan/DEFINITION_OF_DONE.md` matches `plan/WORKFLOW.md`, `TEST_STRATEGY.md` and `docs/CONTENT_GOVERNANCE.md` (no contradictions).
- [ ] The religious-content gate (§2.3) is strict enough, and the scholarly/language review requirements are correct.
- [ ] §3 only *references* the existing CI jobs (no duplicated checks); job names match `.github/workflows/mobile-ci.yml`.
- [ ] `.github/pull_request_template.md` renders on a new PR and is practical to fill in.
- [ ] `docs/QA_CHECKLIST.md` steps are executable on an emulator; Phase 0 gate 1 sign-off table is usable.
- [ ] Owner action noted: branch protection on `main` requiring the three CI checks + 1 review.

### Findings
_None recorded yet._

---

## P00-06 / MHD-001 review checklist (Flutter skeleton)

Status: **awaiting independent review.** Implementation notes: [IMPLEMENTATION.md](IMPLEMENTATION.md).

### Must verify
- [ ] Mobile CI is green on the PR (secrets & policy, analyze/test, Android debug build).
- [ ] `flutter analyze --fatal-infos` and `flutter test` pass locally (`apps/mobile`).
- [ ] Debug APK installs and opens on an emulator/device **in Arabic and English** (Phase 0 gate 1 — not yet done by the coding agent).
- [ ] No religious text anywhere: no verses, hadith, tafsir, rulings, adhkar or prayer times (grep ARB files; open every section).
- [ ] Every section screen shows a gated status panel; `test/core/content_gating_test.dart` allow-list is empty.
- [ ] Arabic copy reads naturally and is accurate (language review), especially status messages.
- [ ] No network/location permission in `android/app/src/main/AndroidManifest.xml`; no login required.
- [ ] No API keys, keystores, ad/analytics SDKs (`tool/policy_checks.sh`, gitleaks).
- [ ] Dependencies pinned exactly; `pubspec.lock` committed.

### Should review
- [ ] Provisional brand items are clearly labelled provisional (icon, font, palette, app ID).
- [ ] Decisions D-12…D-16 in `plan/DECISIONS.md` are acceptable to the owner.
- [ ] Storage contracts in `features/quran/domain/quran_storage_contracts.dart` fit the data model (edition-aware references).
- [ ] TalkBack spot-check of navigation and Settings.

### Findings
| # | Severity | Source | Finding | Status |
|---|---|---|---|---|
| 1 | **Blocking** | ChatGPT review ([comment](https://github.com/abdulrahmanal-saeed/madar-al-huda/pull/4#issuecomment-7008108058)) | `SettingsController` overlapping async writes: whole-object rollback loses successful changes; same-field writes can persist out of order; schema-marker failure after a value write causes a UI/disk mismatch | **Fixed, awaiting re-review.** Serialized and coalesced writes, field-scoped rollback to the last persisted value, marker written first. 12 deterministic regression tests; the old code fails the review-scenario test. See IMPLEMENTATION.md |
| 2 | Info | ChatGPT review | Device/emulator, TalkBack, final Arabic copy and final brand still open | Open (documented) |

---

## Foundation review checklist
- [ ] Product choices accurately recorded.
- [ ] Content sources and licenses marked pending until verified.
- [ ] Architecture separates immutable Quran text from mutable data, audio and translations.
- [ ] Guest-mode privacy and fiqh editorial gating represented.
- [ ] PR contains only planned documentation changes and no credentials.
