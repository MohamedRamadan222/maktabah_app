import 'package:maktabah_app/shared/books/domain/entities/book.dart';

class BookPage {
  final List<Book> books;
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const BookPage({
    required this.books,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });
}
