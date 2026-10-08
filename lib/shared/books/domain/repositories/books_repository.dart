import 'package:maktabah_app/shared/books/domain/entities/book_page.dart';
import 'package:maktabah_app/shared/books/domain/entities/category.dart';

abstract class BooksRepository {
  Future<BookPage> getBooks({
    String q = '',
    String category = 'all',
    String sort = 'catalog',
    int page = 1,
    int limit = 12,
  });

  Future<List<Category>> getCategories();
}
