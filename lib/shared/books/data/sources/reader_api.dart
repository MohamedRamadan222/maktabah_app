import 'package:dio/dio.dart';
import 'package:maktabah_app/shared/books/data/models/chapter_summary_model.dart';

import '../../../../core/network/api_constants.dart';
import '../models/chapter_model.dart';

class ReaderApi {
  final Dio _dio;

  const ReaderApi(this._dio);

  Future<ChapterModel> fetchChapter(String bookId, int index) async {
    final response = await _dio.get(
      '${ApiConstants.apiPrefix}/books/$bookId/chapters/$index',
    );
    final data = response.data as Map<String, dynamic>;
    final chapter = data['data'] as Map<String, dynamic>;
    return ChapterModel.fromJson(chapter);
  }

  Future<List<ChapterSummaryModel>> fetchChapterSummaries(String bookId) async {
    final response = await _dio.get('${ApiConstants.apiPrefix}/books/$bookId');
    final data = response.data as Map<String, dynamic>;
    final book = data['data'] as Map<String, dynamic>;
    final list = book['chapters'] as List<dynamic>;
    return list
        .map((e) => ChapterSummaryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
