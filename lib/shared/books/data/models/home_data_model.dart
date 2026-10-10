import 'package:maktabah_app/shared/books/data/models/book_model.dart';
import 'package:maktabah_app/shared/books/data/models/home_hero_model.dart';
import 'package:maktabah_app/shared/books/data/models/home_quote_model.dart';
import 'package:maktabah_app/shared/books/domain/entities/home_data.dart';

class HomeDataModel {
  final String welcomeTitle;
  final String welcomeSubtitle;
  final HomeQuoteModel quote;
  final HomeHeroModel hero;
  final List<BookModel> featuredBooks;

  const HomeDataModel({
    required this.welcomeTitle,
    required this.welcomeSubtitle,
    required this.quote,
    required this.hero,
    required this.featuredBooks,
  });

  factory HomeDataModel.fromJson(Map<String, dynamic> json) {
    return HomeDataModel(
      welcomeTitle: json['welcomeTitle'] as String,
      welcomeSubtitle: json['welcomeSubtitle'] as String,
      quote: HomeQuoteModel.fromJson(json['quote'] as Map<String, dynamic>),
      hero: HomeHeroModel.fromJson(json['hero'] as Map<String, dynamic>),
      featuredBooks: (json['featuredBooks'] as List<dynamic>)
          .map((e) => BookModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  HomeData toEntity() {
    return HomeData(
      welcomeTitle: welcomeTitle,
      welcomeSubtitle: welcomeSubtitle,
      quote: quote.toEntity(),
      hero: hero.toEntity(),
      featuredBooks: featuredBooks.map((b) => b.toEntity()).toList(),
    );
  }
}
