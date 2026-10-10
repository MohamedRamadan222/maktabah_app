import 'package:maktabah_app/shared/books/domain/entities/book.dart';

class HomeHero {
  final String eyebrow;
  final String title;
  final String actionLabel;
  final List<Book> books;

  const HomeHero({
    required this.eyebrow,
    required this.title,
    required this.actionLabel,
    required this.books,
  });
}
