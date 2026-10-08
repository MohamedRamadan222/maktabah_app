import 'package:maktabah_app/shared/books/domain/entities/book.dart';

class BookModel {
  final String id;
  final String title;
  final String author;
  final String categoryId;
  final String categoryName;
  final String language;
  final String description;
  final String tagline;
  final String coverUrl;
  final String coverBackgroundColor;
  final String direction;
  final String contentType;
  final double rating;
  final int pageCount;
  final int coverWidth;
  final int coverHeight;
  final int chapterCount;
  final bool isFictional;

  const BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.categoryId,
    required this.categoryName,
    required this.language,
    required this.description,
    required this.tagline,
    required this.coverUrl,
    required this.coverBackgroundColor,
    required this.direction,
    required this.contentType,
    required this.rating,
    required this.pageCount,
    required this.coverWidth,
    required this.coverHeight,
    required this.chapterCount,
    required this.isFictional,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      language: json['language'] as String,
      description: json['description'] as String,
      tagline: json['tagline'] as String,
      coverUrl: json['coverUrl'] as String,
      coverBackgroundColor: json['coverBackgroundColor'] as String,
      direction: json['direction'] as String,
      contentType: json['contentType'] as String,
      rating: (json['rating'] as num).toDouble(),
      pageCount: json['pageCount'] as int,
      coverWidth: json['coverWidth'] as int,
      coverHeight: json['coverHeight'] as int,
      chapterCount: json['chapterCount'] as int,
      isFictional: json['isFictional'] as bool,
    );
  }

  Book toEntity() {
    return Book(
      id: id,
      title: title,
      author: author,
      categoryId: categoryId,
      categoryName: categoryName,
      language: language,
      description: description,
      tagline: tagline,
      coverUrl: coverUrl,
      coverBackgroundColor: coverBackgroundColor,
      direction: direction,
      contentType: contentType,
      rating: rating,
      pageCount: pageCount,
      coverWidth: coverWidth,
      coverHeight: coverHeight,
      chapterCount: chapterCount,
      isFictional: isFictional,
    );
  }
}
