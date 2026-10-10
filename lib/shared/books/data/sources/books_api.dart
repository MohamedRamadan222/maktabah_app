import 'package:dio/dio.dart';
import 'package:maktabah_app/core/network/api_constants.dart';
import 'package:maktabah_app/shared/books/data/models/book_details_model.dart';
import 'package:maktabah_app/shared/books/data/models/book_page_model.dart';
import 'package:maktabah_app/shared/books/data/models/category_model.dart';
import 'package:maktabah_app/shared/books/data/models/home_data_model.dart';

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

  Future<BookDetailsModel> fetchBookDetails(String id) async {
    final response = await _dio.get('${ApiConstants.apiPrefix}/books/$id');
    final data = response.data as Map<String, dynamic>;
    final book = data['data'] as Map<String, dynamic>;
    return BookDetailsModel.fromJson(book);
  }

  Future<List<CategoryModel>> fetchCategories() async {
    final response = await _dio.get('${ApiConstants.apiPrefix}/categories');

    final data = response.data as Map<String, dynamic>;
    final list = data['data'] as List;
    return list
        .map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<HomeDataModel> fetchHome() async {
    final response = await _dio.get('${ApiConstants.apiPrefix}/home');
    final json = response.data as Map<String, dynamic>;
    final data = json['data'] as Map<String, dynamic>;
    return HomeDataModel.fromJson(data);
  }


}
