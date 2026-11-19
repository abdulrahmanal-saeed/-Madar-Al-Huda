# Brand system — مدار الهدى | Madar Al-Huda
Status: provisional identity; production logo, typography licenses, and trademark/store availability require approval.

## Naming
- Arabic: مدار الهدى
- English: Madar Al-Huda (transliterated brand; not a literal translation)
- Product tagline AR: القرآن والعلم والعبادة في مكان واحد
- Product tagline EN: Quran, Knowledge & Worship in One Place
- Repository slug recommended for a future rename: `madar-al-huda`.
- Android applicationId **candidate**: `com.abdulrahmanalsaeed.madaralhuda`. Confirm namespace ownership before first store release; do not change once published.

## Visual identity
- Primary: deep green `#173F39`
- Accent: muted gold `#C7A86D`
- Warm background: ivory `#F8F5ED`
- Supporting dark ink: `#263B38`
- Tone: calm, legible, scholarly, contemporary; sparing Islamic geometry, not ornamental clutter.
- Logo direction: open book + gentle circular orbital motif; must remain recognizable at small launcher-icon sizes; avoid depicting the sacred text inside decorative icons.
- Arabic UI font candidate: IBM Plex Sans Arabic; English UI: Inter. Verify redistribution and embedding licenses.
- Quran text needs an approved Uthmani typeface and correct glyph/diacritic support; UI font is not a substitute.

## Design constraints
- Both RTL and LTR layouts at launch; icons with semantic direction must mirror.
- Support font scaling, accessible contrast, screen readers, reduced animation, dark mode.
- Treat Arabic Quran text as immutable content; do not normalize or modify stored source text for display.
- Design tabs: Home, Quran, Worship, Library, Learn; Qibla and search accessible via Home/Worship.
- No ads, intrusive pop-ups, manipulative streaks, or obligatory sign-up.

## Launch surface checklist
- App icon, adaptive Android launcher icon, splash, wordmark, light/dark palettes.
- 5 core screen wireframes per locale, text truncation check, contrast test.
