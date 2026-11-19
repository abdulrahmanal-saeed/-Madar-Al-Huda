# Technical architecture (proposed; mobile shell implemented in P00-06)

## Monorepo
`apps/mobile` Flutter + Dart; `apps/admin` Next.js CMS; `backend` protected provider API; `supabase` schema/migrations; `docs` and `AI_BRIDGE`.

## Mobile module boundaries
- `core`: localization, typography, routing, persistence, logging, dependency injection.
- `quran`: surahs/ayahs, search, bookmarks, reading position, translations, tafsir.
- `recitation`: provider adapters, playback, playlist, timing metadata, lawful cache.
- `worship`: location choice, calculation settings, prayer times, Qibla, local reminders.
- `library`: hadith, fiqh, supplications and citations.
- `learning`: courses, articles, stories and quizzes.
- `account`: guest data, optional auth and explicit sync.

### Implemented in P00-06 (`apps/mobile`)
- Feature-first layout: `lib/app` (root widget, GoRouter, tab shell), `lib/core` (theme, localization, routing catalog, storage, content gates, shared widgets), `lib/features/<feature>/{presentation,domain,data,application}`.
- State: Riverpod `Notifier` for settings; storage injected via `keyValueStoreProvider` (overridden at start-up and in tests).
- Navigation: `StatefulShellRoute.indexedStack` with five branches (Home, Quran, Worship, Library, Learning); Settings on the root navigator.
- Content gating: `AppSection.status` (`ContentStatus`) — gated sections render only a status panel; a test fails if any section becomes `available` without an explicit, reviewed allow-list entry.
- Storage: preferences via `KeyValueStore` (allow-listed keys, schema version). Quran bookmark/last-read **contracts only** (`AyahRef` always carries an edition id); Drift is deferred to P01-03.
- No permissions in the main Android manifest; enforced by `apps/mobile/tool/policy_checks.sh` in CI.
- Details: [`apps/mobile/README.md`](../apps/mobile/README.md).

## Offline-first boundaries
- Ship a checked, immutable source Quran text dataset and metadata under a validated applicable license.
- Local Drift/SQLite stores reading position, settings, bookmarks and licensed cacheable content.
- Network sync is optional; never block prayer calculations because a backend is unavailable.
- Audio URLs and expiration rules are controlled by provider-specific adapters; streaming does not imply downloadable.
- Search index may strip/normalize only **derived** tokens; immutable Quran display text is retained.

## Backend and CMS
- Supabase Postgres/Auth/Storage is proposed; select exact version after docs/changelog review.
- Only publication-approved rows are publicly readable; drafts/reviews stay server-side.
- Enable RLS on exposed tables. User data policies check `auth.uid() = user_id`; role authorization uses server-controlled claims/role tables, never editable user metadata.
- Do not expose service-role credentials in Flutter, Next.js public bundles, or GitHub. Use environment secrets in deployment.
- Review actions write immutable audit events; withdrawals propagate to client content indices.

## Prayer/location
- Resolve location with user permission; always offer manual city.
- Calculate times locally with configurable method, Asr school, latitude handling and manual adjustment.
- Test Dubai, Abu Dhabi, Cairo and Alexandria against matching calculation parameters and official references.
- Time-zone and DST changes trigger recomputation; high-latitude behavior is explicit.
- Qibla compass requires calibration guidance and must disclose unreliable sensor readings.

## Operations
- Unit tests for source integrity, prayer math scenarios, bilingual layouts and RLS.
- CI: format, analyze, unit tests, secret scanning and content attribution checks.
- Do not automatically release religious content after AI drafting; scholarly and language approvals are separate.
