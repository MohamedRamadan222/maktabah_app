import 'package:maktabah_app/shared/books/domain/entities/chapter.dart';
import 'package:maktabah_app/shared/books/domain/entities/chapter_summary.dart';

abstract class ReaderRepository {
  Future<Chapter> getChapter(String bookId, int index);

  Future<List<ChapterSummary>> getChapterSummaries(String bookId);
}
