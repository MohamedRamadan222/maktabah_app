import 'package:maktabah_app/shared/books/data/models/chapter_summary_model.dart';
import 'package:maktabah_app/shared/books/domain/entities/book_details.dart';

import 'book_model.dart';

class BookDetailsModel {
  final BookModel book;
  final List<ChapterSummaryModel> chapters;
  final String notice;

  const BookDetailsModel({
    required this.book,
    required this.chapters,
    required this.notice,
  });

  factory BookDetailsModel.fromJson(Map<String, dynamic> json) {
    return BookDetailsModel(
      book: BookModel.fromJson(json),
      chapters: (json['chapters'] as List<dynamic>)
          .map((e) => ChapterSummaryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      notice: json['notice'] as String,
    );
  }

  BookDetails toEntity() {
    return BookDetails(
      book: book.toEntity(),
      chapters: chapters.map((c) => c.toEntity()).toList(),
      notice: notice,
    );
  }
}
