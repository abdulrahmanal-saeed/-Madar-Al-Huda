# Data model v0.2 — conceptual schema / P00-05

**Concrete review contract:** [architecture/ERD.md](architecture/ERD.md) and [architecture/SCHEMA_BLUEPRINT.sql](architecture/SCHEMA_BLUEPRINT.sql). The original model below remains the phase-wide domain inventory; the blueprint represents only baseline high-risk entities.

Schema is provisional; actual SQL migrations must be tested and include RLS/indexes.

## Quran (immutable source versioning)
- `quran_editions(id, riwayah, source_id, version, checksum)`
- `surahs(edition_id, surah_number, name_ar, name_en, ayah_count)` UNIQUE(edition_id,surah_number)
- `ayahs(edition_id, surah_number, ayah_number, text_uthmani, juz, hizb, page)` PK(edition_id,surah_number,ayah_number)
- `translations(id, edition_id, source_id, language, version)`
- `translation_entries(translation_id, surah_number, ayah_number, text)`
- `tafsir_books(id, source_id, author, edition, language)`
- `tafsir_entries(id, tafsir_book_id, start_ayah, end_ayah, text, source_location)`
- `reciters(id, name_ar, name_en)`, `recitation_editions(id, reciter_id, riwayah, provider_id)`
- `audio_assets(id, recitation_edition_id, surah_number, stream_url, expires_at, cache_policy)`
- `audio_segments(audio_asset_id, surah_number, ayah_number, start_ms, end_ms)` optional.

## Hadith and four-school fiqh
- `hadith_collections`, `hadiths`, `hadith_versions`, `hadith_references`, `hadith_gradings`
- `fiqh_topics`, `fiqh_issues`, `fiqh_opinions(issue_id, madhhab, opinion_kind, ruling, conditions, review_status)`
- `fiqh_evidences(opinion_id, citation_id)`, `fiqh_coverage(issue_id, madhhab, reviewed_status)`
- Each madhhab may have multiple narrations/opinions. Missing data is **unknown**, never consensus.

## Library and learning
- `adhkar_categories`, `adhkar`, `duas`, `articles`, `prophet_stories`
- `courses`, `modules`, `lessons`, `quizzes`, `quiz_questions`, `content_translations`

## Provenance, rights and editorial
- `sources(id, title, author, edition, publisher, url, checked_at)`
- `source_licenses(source_id, rights_status, attribution, cache_rules, reproduction_rules, review_date)`
- `content_citations(content_type, content_id, source_id, locator)`
- `content_revisions`, `content_reviews`, `publication_events`, `editorial_users`
- Publication requires source rights **and** scholarly review where applicable, with separate language review for translated originals.

## User state
- `profiles(user_id)`, `preferences(user_id,...)`, `bookmarks(user_id,...)`
- `reading_positions(user_id, edition_id, surah_number, ayah_number)`, `khatmah_plans`, `lesson_progress`
- `reminder_rules` with user local times / location preference; avoid retaining precise travel/location histories.

## Data safety and correctness
- Composite FKs ensure an ayah belongs to the indicated edition and surah.
- Source integrity checked by SHA-256 over canonical dataset version; verify number of surahs/verses per edition.
- Version mapping needed before transferring bookmarks between different numbering systems/editions.
- Guest data remains local until explicit opt-in to sign-in/sync.
- RLS for all exposed tables, policies scoped by ownership/status; security-definer reviewed or avoided.
