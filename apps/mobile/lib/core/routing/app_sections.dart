import 'package:material_ui/material_ui.dart';

import '../content/content_status.dart';
import '../localization/app_locales.dart';
import 'app_routes.dart';

/// Catalog of content sections reachable from the tab hubs and Home.
///
/// [status] is the publication gate. All sections are gated in Phase 0:
/// changing one to [ContentStatus.available] requires the matching tracker
/// task to be DONE with evidence (and is enforced by tests).
enum AppSection {
  mushaf(
    AppRoutes.mushaf,
    Icons.menu_book_outlined,
    ContentStatus.awaitingSourceVerification,
  ),
  recitations(
    AppRoutes.recitations,
    Icons.headphones_outlined,
    ContentStatus.awaitingAudioRights,
  ),
  tafsir(
    AppRoutes.tafsir,
    Icons.auto_stories_outlined,
    ContentStatus.awaitingSourceVerification,
  ),
  prayerTimes(
    AppRoutes.prayerTimes,
    Icons.schedule_outlined,
    ContentStatus.awaitingCalculationValidation,
  ),
  qibla(AppRoutes.qibla, Icons.explore_outlined, ContentStatus.inDevelopment),
  adhkar(
    AppRoutes.adhkar,
    Icons.wb_twilight_outlined,
    ContentStatus.awaitingSourceVerification,
  ),
  hadith(
    AppRoutes.hadith,
    Icons.format_quote_outlined,
    ContentStatus.awaitingSourceVerification,
  ),
  fiqh(
    AppRoutes.fiqh,
    Icons.balance_outlined,
    ContentStatus.awaitingScholarlyReview,
  ),
  articles(
    AppRoutes.articles,
    Icons.article_outlined,
    ContentStatus.awaitingEditorialReview,
  ),
  lessons(
    AppRoutes.lessons,
    Icons.school_outlined,
    ContentStatus.awaitingEditorialReview,
  ),
  stories(
    AppRoutes.stories,
    Icons.history_edu_outlined,
    ContentStatus.awaitingScholarlyReview,
  );

  const AppSection(this.path, this.icon, this.status);

  final String path;
  final IconData icon;
  final ContentStatus status;

  String title(AppLocalizations l10n) => switch (this) {
    mushaf => l10n.sectionMushafTitle,
    recitations => l10n.sectionRecitationsTitle,
    tafsir => l10n.sectionTafsirTitle,
    prayerTimes => l10n.sectionPrayerTimesTitle,
    qibla => l10n.sectionQiblaTitle,
    adhkar => l10n.sectionAdhkarTitle,
    hadith => l10n.sectionHadithTitle,
    fiqh => l10n.sectionFiqhTitle,
    articles => l10n.sectionArticlesTitle,
    lessons => l10n.sectionLessonsTitle,
    stories => l10n.sectionStoriesTitle,
  };

  String subtitle(AppLocalizations l10n) => switch (this) {
    mushaf => l10n.sectionMushafSubtitle,
    recitations => l10n.sectionRecitationsSubtitle,
    tafsir => l10n.sectionTafsirSubtitle,
    prayerTimes => l10n.sectionPrayerTimesSubtitle,
    qibla => l10n.sectionQiblaSubtitle,
    adhkar => l10n.sectionAdhkarSubtitle,
    hadith => l10n.sectionHadithSubtitle,
    fiqh => l10n.sectionFiqhSubtitle,
    articles => l10n.sectionArticlesSubtitle,
    lessons => l10n.sectionLessonsSubtitle,
    stories => l10n.sectionStoriesSubtitle,
  };
}

/// Localized label and description for a [ContentStatus].
extension ContentStatusText on ContentStatus {
  String title(AppLocalizations l10n) => switch (this) {
    ContentStatus.awaitingSourceVerification => l10n.statusAwaitingSourceTitle,
    ContentStatus.awaitingAudioRights => l10n.statusAwaitingAudioTitle,
    ContentStatus.awaitingScholarlyReview => l10n.statusAwaitingScholarlyTitle,
    ContentStatus.awaitingEditorialReview => l10n.statusAwaitingEditorialTitle,
    ContentStatus.awaitingCalculationValidation =>
      l10n.statusAwaitingValidationTitle,
    ContentStatus.inDevelopment ||
    ContentStatus.available => l10n.statusInDevelopmentTitle,
  };

  String body(AppLocalizations l10n) => switch (this) {
    ContentStatus.awaitingSourceVerification => l10n.statusAwaitingSourceBody,
    ContentStatus.awaitingAudioRights => l10n.statusAwaitingAudioBody,
    ContentStatus.awaitingScholarlyReview => l10n.statusAwaitingScholarlyBody,
    ContentStatus.awaitingEditorialReview => l10n.statusAwaitingEditorialBody,
    ContentStatus.awaitingCalculationValidation =>
      l10n.statusAwaitingValidationBody,
    ContentStatus.inDevelopment ||
    ContentStatus.available => l10n.statusInDevelopmentBody,
  };

  IconData get icon => switch (this) {
    ContentStatus.awaitingSourceVerification => Icons.verified_user_outlined,
    ContentStatus.awaitingAudioRights => Icons.headphones_outlined,
    ContentStatus.awaitingScholarlyReview => Icons.gavel_outlined,
    ContentStatus.awaitingEditorialReview => Icons.translate_outlined,
    ContentStatus.awaitingCalculationValidation =>
      Icons.travel_explore_outlined,
    ContentStatus.inDevelopment ||
    ContentStatus.available => Icons.hourglass_top_outlined,
  };
}
