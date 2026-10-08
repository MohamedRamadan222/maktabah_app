import 'package:maktabah_app/shared/books/domain/entities/chapter_summary.dart';

class ChapterSummaryModel {
  final int index;
  final int number;
  final String title;
  final int paragraphCount;

  const ChapterSummaryModel({
    required this.index,
    required this.number,
    required this.title,
    required this.paragraphCount,
  });

  factory ChapterSummaryModel.fromJson(Map<String, dynamic> json) {
    return ChapterSummaryModel(
      index: json['index'] as int,
      number: json['number'] as int,
      title: json['title'] as String,
      paragraphCount: json['paragraphCount'] as int,
    );
  }

  ChapterSummary toEntity() {
    return ChapterSummary(
      index: index,
      number: number,
      title: title,
      paragraphCount: paragraphCount,
    );
  }
}
