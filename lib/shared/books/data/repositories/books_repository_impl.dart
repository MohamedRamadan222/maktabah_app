import 'package:dio/dio.dart';
import 'package:maktabah_app/core/error/failure.dart';
import 'package:maktabah_app/shared/books/data/sources/books_api.dart';
import 'package:maktabah_app/shared/books/domain/entities/book_details.dart';
import 'package:maktabah_app/shared/books/domain/repositories/books_repository.dart';
import 'package:maktabah_app/shared/books/domain/entities/book_page.dart';
import 'package:maktabah_app/shared/books/domain/entities/category.dart';

class BooksRepositoryImpl implements BooksRepository {
  final BooksApi _api;

  const BooksRepositoryImpl(this._api);

  @override
  Future<BookPage> getBooks({
    String q = '',
    String category = 'all',
    String sort = 'catalog',
    int page = 1,
    int limit = 12,
  }) async {
    try {
      final model = await _api.fetchBooks(
        q: q,
        category: category,
        sort: sort,
        page: page,
        limit: limit,
      );
      return model.toEntity();
    } on DioException catch (e) {
      throw _mapDioError(e);
    } catch (_) {
      throw const AppFailure(message: 'تعذّر قراءة البيانات');
    }
  }

  @override
  Future<BookDetails> getBookDetails(String id) async {
    try {
      final bookDetails = await _api.fetchBookDetails(id);
      return bookDetails.toEntity();
    } on DioException catch (e) {
      throw _mapDioError(e);
    } catch (_) {
      throw const AppFailure(message: 'تعذّر قراءة البيانات');
    }
  }

  @override
  Future<List<Category>> getCategories() async {
    try {
      final models = await _api.fetchCategories();
      return models.map((m) => m.toEntity()).toList();
    } on DioException catch (e) {
      throw _mapDioError(e);
    } catch (_) {
      throw const AppFailure(message: 'تعذّر قراءة البيانات');
    }
  }

  AppFailure _mapDioError(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic> && data['error'] is Map<String, dynamic>) {
      final error = data['error'] as Map<String, dynamic>;
      return AppFailure(
        message: error['message'] as String,
        code: error['code'] as String?,
        statusCode: e.response?.statusCode,
      );
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return const AppFailure(message: 'انتهت مهلة الاتصال');
    }

    return const AppFailure(message: 'تعذّر الاتصال بالخادم');
  }
}
