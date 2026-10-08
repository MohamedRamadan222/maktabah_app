import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maktabah_app/core/network/dio_provider.dart';
import 'package:maktabah_app/shared/books/data/repositories/books_repository_impl.dart';
import 'package:maktabah_app/shared/books/data/sources/books_api.dart';
import 'package:maktabah_app/shared/books/domain/entities/book_page.dart';
import 'package:maktabah_app/shared/books/domain/entities/category.dart';
import 'package:maktabah_app/shared/books/domain/repositories/books_repository.dart';

final booksApiProvider = Provider<BooksApi>((ref) {
  final dio = ref.watch(dioProvider);
  return BooksApi(dio);
});

final booksRepositoryProvider = Provider<BooksRepository>((ref) {
  final api = ref.watch(booksApiProvider);
  return BooksRepositoryImpl(api);
});

final catalogProvider = FutureProvider<BookPage>((ref) {
  final repository = ref.watch(booksRepositoryProvider);
  return repository.getBooks(limit: 12);
});

final categoriesProvider = FutureProvider<List<Category>>((ref) {
  final repository = ref.watch(booksRepositoryProvider);
  return repository.getCategories();
});
