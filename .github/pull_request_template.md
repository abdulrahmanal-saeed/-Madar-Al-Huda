<!--
Madar Al-Huda PR template (P00-09). Definition of Done: plan/DEFINITION_OF_DONE.md
Delete sections that don't apply, but don't delete a checklist item just to avoid it:
mark it "N/A" with a reason. Never claim a check ran unless it did.
-->

## Task
- **Tracker ID:** `P0X-NN` <!-- from plan/TRACKER.md; one task per PR where possible -->
- **Issue / AI_BRIDGE ID:** <!-- e.g. #2, MHD-001 -->
- **Tracker status in this PR:** <!-- TODO → IN_PROGRESS / REVIEW. Never DONE before merge. -->
- **Dependencies:** <!-- all DONE? If not, link the decision that allows proceeding (e.g. D-16) -->

## Summary
<!-- What changed and why, in a few lines. -->

## Type of change
- [ ] App code (`apps/mobile`)
- [ ] Religious content or source data
- [ ] Calculation (prayer times / Qibla)
- [ ] CI / tooling
- [ ] Documentation / plan only

## Evidence (commands actually run)
<!-- Paste results. "Not run" + reason is acceptable; claiming an unrun check is not. -->
| Check | Result |
|---|---|
| CI run on head SHA (link) | |
| `flutter analyze --fatal-infos` | |
| `flutter test` (count) | |
| `flutter build apk --debug` | |
| Other (`policy_checks.sh`, gitleaks, …) | |

## Screenshots (UI changes)
<!-- AR/EN × light/dark for every changed screen. -->

## Manual QA (docs/QA_CHECKLIST.md)
<!-- List the sections run, with device/emulator and the results table, or "Not run" + reason. -->

## Definition of Done
- [ ] Acceptance criteria for the task are met, with evidence above.
- [ ] Tests added or updated for new behaviour, in both Arabic (RTL) and English (LTR) where UI or text changed.
- [ ] No hard-coded user-facing strings; ARB keys exist in both languages.
- [ ] No new permission, network access, ads, analytics or tracking SDK — or an approved decision ID is linked: <!-- D-xx -->
- [ ] Dependencies pinned exactly; lockfile changes reviewed.
- [ ] No secrets, keystores or personal data committed.
- [ ] `plan/TRACKER.md` updated; `AI_BRIDGE/IMPLEMENTATION.md` updated; `plan/DECISIONS.md` updated if a decision changed.
- [ ] Known limitations and unverified items are listed below.

## Religious content gate
<!-- Required if the PR adds or changes any Quran, tafsir, translation, hadith, fiqh,
     adhkar, story or quote content, or ungates a section. Otherwise tick the first box only. -->
- [ ] **This PR contains no religious content and ungates no section.**
- [ ] Source, edition, rights and attribution recorded in `docs/CONTENT_SOURCES.md`: <!-- link -->
- [ ] Offline/caching/redistribution scope confirmed in writing: <!-- reference -->
- [ ] Integrity verified (Quran checksum and counts / hadith grading with grader): <!-- evidence -->
- [ ] Qualified scholarly review (name, date) where required: <!-- reference -->
- [ ] Language review per language: <!-- AR / EN reviewer -->

## Risks, limitations, blockers
<!-- Link RISKS_AND_BLOCKERS.md IDs where relevant. -->

## Reviewer notes
<!-- Anything the reviewer must verify by hand (e.g. on-device RTL check). -->
