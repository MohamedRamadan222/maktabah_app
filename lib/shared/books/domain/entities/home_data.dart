import 'package:maktabah_app/shared/books/domain/entities/book.dart';
import 'package:maktabah_app/shared/books/domain/entities/home_hero.dart';
import 'package:maktabah_app/shared/books/domain/entities/home_quote.dart';

class HomeData {
  final String welcomeTitle;
  final String welcomeSubtitle;
  final HomeQuote quote;
  final HomeHero hero;
  final List<Book> featuredBooks;

  const HomeData({
    required this.welcomeTitle,
    required this.welcomeSubtitle,
    required this.quote,
    required this.hero,
    required this.featuredBooks,
  });
}
