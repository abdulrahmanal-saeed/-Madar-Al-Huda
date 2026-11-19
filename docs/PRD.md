# Product Requirements Document — Madar Al-Huda
Version: 0.1 | Phase: 0 | Date: 2026-11-19

## Vision
A reliable, free, bilingual Islamic companion for Quran reading/listening, worship, sourced religious learning, and respectfully presented comparative Sunni fiqh.

## Confirmed decisions
- Platform: Android first, iOS-ready Flutter architecture.
- Languages: Arabic and English from first public release.
- Business: free forever, no advertising or paid tiers.
- No account required for essential reading, audio, prayer times, and Qibla.
- First validation locations: United Arab Emirates and Egypt.
- Initial reciter candidates (distribution rights pending): Maher Al-Muaiqly, Mahmoud Ali Al-Banna, Islam Sobhi.
- Initial tafsir candidates (edition/rights pending): Jami' al-Bayan by al-Tabari, Tafsir al-Qur'an al-'Azim by Ibn Kathir.
- Fiqh: four Sunni madhhabs (Hanafi, Maliki, Shafi'i, Hanbali) with documented differences and editorial review.

## Users and scenarios
1. Reader: continue last verse; follow Quran in Arabic, English meaning, and sourced tafsir offline where permitted.
2. Listener: select approved recitation, play/pause/background and continue; honor audio caching conditions.
3. Worshipper: locate prayer times from authorized location or manually selected city, view Qibla, choose method and reminders.
4. Learner: browse categorized hadith, dhikr, lessons, articles and prophetic stories, with citations and clear provenance.
5. Fiqh researcher: compare reviewed madhhab positions, evidences, caveats and sources; no automated personal fatwa.
6. Editor/reviewer: submit, verify, review, approve or withdraw content in audited CMS.

## MVP (first usable Android release)
- Bilingual app shell, guest mode, accessibility.
- Verified Quran text; 114 surahs and indexed ayahs; search, bookmarks, last read.
- Legal English meaning of verses and at least one legally available tafsir selection.
- At least one legally licensed streamable recitation; background audio.
- Prayer times, configurable calculation methods, Qibla, manual-city fallback.
- Basic settings, attribution, privacy notice, graceful offline/error states.

## Later increments
- P1: more reciters, licensed download options, expanded adhkar/du'a, smart reminders, Khatmah tracking.
- P2: sourced hadith library, comparative fiqh with review system and coverage indicators.
- P3: curated/original courses, quizzes, prophet stories, articles, editorial CMS and push content.
- P4: extended learning and accessibility, iOS packaging subject to platform QA.

## Non-goals
- No AI-generated fatwas or unsourced legal conclusions.
- No rehosting restricted audio, translations, or protected editions.
- No forced account, ad tracking, or sale of user location data.
- No assumption one prayer calculation method fits all cities.

## Acceptance — Phase 0
- Reviewed source register for each launch-required content provider (availability, license, attribution, storage rules).
- Architecture and data schema agreed; all source/permission unknowns listed as blockers.
- Bilingual home/Quran/prayer wireframes with RTL/LTR behavior.
- Engineering roadmap and acceptance tests defined; CI and runnable Flutter scaffold in follow-up engineering task.
