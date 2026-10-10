import 'package:maktabah_app/shared/books/data/models/book_model.dart';
import 'package:maktabah_app/shared/books/domain/entities/home_hero.dart';

class HomeHeroModel {
  final String eyebrow;
  final String title;
  final String actionLabel;
  final List<BookModel> books;

  const HomeHeroModel({
    required this.eyebrow,
    required this.title,
    required this.actionLabel,
    required this.books,
  });

  factory HomeHeroModel.fromJson(Map<String, dynamic> json) {
    return HomeHeroModel(
      eyebrow: json['eyebrow'] as String,
      title: json['title'] as String,
      actionLabel: json['actionLabel'] as String,
      books: (json['books'] as List<dynamic>)
          .map((e) => BookModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  HomeHero toEntity() {
    return HomeHero(
      eyebrow: eyebrow,
      title: title,
      actionLabel: actionLabel,
      books: books.map((b) => b.toEntity()).toList(),
    );
  }
}
