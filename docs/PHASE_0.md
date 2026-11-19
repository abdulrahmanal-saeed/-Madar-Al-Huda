# Phase 0 — foundation work plan

Status: **in progress**. This document is a task plan, not a claim that all engineering scaffolding has been built.

## Track A — product / UX
- [x] Confirm provisional AR/EN name and target countries.
- [x] Record product constraints: Android-first, iOS-ready, free, no ads.
- [x] Record initial reciters and tafsir candidates.
- [ ] Review accessibility contrast, final logo/trademark/app-store naming.
- [ ] Wireframe Home, Quran, Player, Prayer/Qibla, Library in RTL and LTR.
- [ ] Agree on MVP flow and navigation prototypes.

## Track B — data and source rights
- [x] Start source/rights register.
- [ ] Verify Quran edition, hash, attribution, ingestion and offline permissions.
- [ ] Confirm stream/reproduction terms for each of 3 reciters.
- [ ] Identify authorized digital editions for al-Tabari and Ibn Kathir.
- [ ] Select legally usable English meanings and hadith source.
- [ ] Confirm qualified fiqh review and article publication policy.

## Track C — engineering
- [x] Initialize repository README and documentation draft.
- [x] Scaffold Flutter project in apps/mobile with AR/EN localization. *(P00-06 PR, in review)*
- [x] Implement app shell and initial screen routes. *(P00-06 PR, in review)*
- [ ] Add Drift/SQLite versioned schema and source integrity fixture.
- [ ] Prototype prayer calculation and UAE/Egypt reference cases.
- [ ] Set up backend only after verifying current Supabase docs/changelog.
- [x] Add CI: format/analyze/test and secrets scan. *(P00-06 PR: `.github/workflows/mobile-ci.yml`; first CI run is on that PR)*
- [ ] Set up CMS roles/RLS design before any user data goes online.

## Gates for Phase 0 completion
1. Runnable Android debug build and both locales verified on-device or emulator.
2. Signed-off wireframes and brand tokens.
3. Verified provenance and permissions for MVP Quran text and one tafsir/audio path.
4. Machine-checkable Quran source integrity fixture.
5. Prayer calculation smoke test for Dubai, Abu Dhabi, Cairo and Alexandria using matching official parameters and DST scenarios.
6. No credentials in source control; permissions reviewed.
7. Documented remaining legal, scholarly and engineering blockers.

## Definition of done for individual tasks
Implementation + tests + documentation + reviewer sign-off; open GitHub PR, do not merge with failing checks.
