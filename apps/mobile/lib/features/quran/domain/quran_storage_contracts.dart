/// Storage boundaries for Quran user data.
///
/// These are contracts only. Implementations are deliberately deferred to
/// P01-03 (Drift/SQLite), which depends on a verified, immutable Quran
/// edition (P01-01, blocked by P00-07). Defining them now fixes the shape
/// that UI and tests will depend on:
///
/// * References always carry the **edition** they point into, so bookmarks
///   can be mapped safely if numbering differs between editions.
/// * Quran text itself is never stored in user data — only references.
library;

/// Number of surahs in the mushaf; a structural constant, not content.
const int surahCount = 114;

/// A reference to one ayah within a specific Quran edition.
final class AyahRef {
  AyahRef({required this.editionId, required this.surah, required this.ayah}) {
    if (editionId.isEmpty) {
      throw ArgumentError.value(editionId, 'editionId', 'must not be empty');
    }
    if (surah < 1 || surah > surahCount) {
      throw RangeError.range(surah, 1, surahCount, 'surah');
    }
    // Upper bound depends on the edition's verified metadata; checked by the
    // repository implementation against the edition dataset.
    if (ayah < 1) throw RangeError.value(ayah, 'ayah', 'must be >= 1');
  }

  final String editionId;
  final int surah;
  final int ayah;

  @override
  bool operator ==(Object other) =>
      other is AyahRef &&
      other.editionId == editionId &&
      other.surah == surah &&
      other.ayah == ayah;

  @override
  int get hashCode => Object.hash(editionId, surah, ayah);

  @override
  String toString() => 'AyahRef($editionId $surah:$ayah)';
}

/// The user's last reading position. Stored on-device for guests.
final class ReadingPosition {
  const ReadingPosition({required this.ref, required this.updatedAt});

  final AyahRef ref;
  final DateTime updatedAt;
}

/// A user bookmark. [note] is user-authored text, never religious content.
final class QuranBookmark {
  const QuranBookmark({
    required this.id,
    required this.ref,
    required this.createdAt,
    this.note,
  });

  final String id;
  final AyahRef ref;
  final DateTime createdAt;
  final String? note;
}

/// Persists the last-read position (P01-03).
abstract interface class ReadingPositionRepository {
  Future<ReadingPosition?> lastRead();
  Future<void> saveLastRead(AyahRef ref);
}

/// Persists bookmarks (P01-03).
abstract interface class BookmarkRepository {
  Stream<List<QuranBookmark>> watchAll();
  Future<QuranBookmark> add(AyahRef ref, {String? note});
  Future<void> remove(String id);
}
