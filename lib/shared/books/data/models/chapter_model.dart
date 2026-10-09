import 'package:maktabah_app/shared/books/domain/entities/chapter.dart';

class ChapterModel {
  final int index;
  final int number;
  final int chapterCount;
  final int? previousChapterIndex;
  final int? nextChapterIndex;
  final String bookId;
  final String title;
  final List<String> paragraphs;

  const ChapterModel({
    required this.index,
    required this.number,
    required this.chapterCount,
    required this.bookId,
    required this.title,
    required this.paragraphs,
    required this.previousChapterIndex,
    required this.nextChapterIndex,
  });

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    return ChapterModel(
      index: json['index'] as int,
      number: json['number'] as int,
      chapterCount: json['chapterCount'] as int,
      bookId: json['bookId'] as String,
      title: json['title'] as String,
      paragraphs: List<String>.from(json['paragraphs'] as List<dynamic>),
      previousChapterIndex: json['previousChapterIndex'] as int?,
      nextChapterIndex: json['nextChapterIndex'] as int?,
    );
  }

  Chapter toEntity() {
    return Chapter(
      index: index,
      number: number,
      chapterCount: chapterCount,
      bookId: bookId,
      title: title,
      paragraphs: paragraphs,
      previousChapterIndex: previousChapterIndex,
      nextChapterIndex: nextChapterIndex,
    );
  }
}
