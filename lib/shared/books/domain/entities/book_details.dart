import 'package:maktabah_app/shared/books/domain/entities/book.dart';
import 'package:maktabah_app/shared/books/domain/entities/chapter_summary.dart';

class BookDetails {
  final Book book;
  final List<ChapterSummary> chapters;
  final String notice;

  const BookDetails({
    required this.book,
    required this.chapters,
    required this.notice,
  });
}
