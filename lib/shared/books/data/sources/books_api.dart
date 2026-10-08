import 'package:dio/dio.dart';
import 'package:maktabah_app/core/network/api_constants.dart';
import 'package:maktabah_app/shared/books/data/models/book_page_model.dart';
import 'package:maktabah_app/shared/books/data/models/category_model.dart';

class BooksApi {
  final Dio _dio;

  const BooksApi(this._dio);

  Future<BookPageModel> fetchBooks({
    String q = '',
    String category = 'all',
    String sort = 'catalog',
    int page = 1,
    int limit = 12,
  }) async {
    final response = await _dio.get(
      '${ApiConstants.apiPrefix}/books',
      queryParameters: {
        'q': q,
        'category': category,
        'page': page,
        'limit': limit,
        'sort': sort,
      },
    );

    final data = response.data as Map<String, dynamic>;
    return BookPageModel.fromEnvelope(data);
  }

  Future<List<CategoryModel>> fetchCategories() async {
    final response = await _dio.get('${ApiConstants.apiPrefix}/categories');

    final data = response.data as Map<String, dynamic>;
    final list = data['data'] as List;
    return list
        .map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
