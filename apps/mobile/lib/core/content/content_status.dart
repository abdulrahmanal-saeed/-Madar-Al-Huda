/// Publication gate for a content section.
///
/// Every section that would show religious or calculated content starts
/// gated. A section may only move to [available] when the corresponding
/// tracker task in `plan/TRACKER.md` is DONE with evidence (source rights,
/// scholarly review, or calculation fixtures). See plan/RISKS_AND_BLOCKERS.md.
enum ContentStatus {
  /// Source edition and redistribution rights not yet verified (R-01).
  awaitingSourceVerification,

  /// Streaming/caching rights for recitations not yet confirmed (R-01, O-03).
  awaitingAudioRights,

  /// Requires approval by a qualified scholarly reviewer (R-02).
  awaitingScholarlyReview,

  /// Requires source and editorial (language) review before publishing.
  awaitingEditorialReview,

  /// Calculation must match official UAE/Egypt references first (R-04).
  awaitingCalculationValidation,

  /// No content dependency; the feature itself is not built yet.
  inDevelopment,

  /// Verified and publishable.
  available;

  bool get isGated => this != available;
}
