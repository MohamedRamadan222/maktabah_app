import 'package:dio/dio.dart';
import 'package:maktabah_app/shared/books/data/sources/reader_api.dart';
import 'package:maktabah_app/shared/books/domain/entities/chapter.dart';
import 'package:maktabah_app/shared/books/domain/entities/chapter_summary.dart';
import 'package:maktabah_app/shared/books/domain/repositories/reader_repository.dart';
import 'package:maktabah_app/core/error/dio_error_mapper.dart';
import 'package:maktabah_app/core/error/failure.dart';

class ReaderRepositoryImpl implements ReaderRepository {
  final ReaderApi _api;

  const ReaderRepositoryImpl(this._api);

  @override
  Future<Chapter> getChapter(String bookId, int index) async {
    try {
      final chapter = await _api.fetchChapter(bookId, index);
      return chapter.toEntity();
    } on DioException catch (e) {
      throw mapDioError(e);
    } catch (_) {
      throw const AppFailure(message: 'تعذّر قراءة البيانات');
    }
  }

  @override
  Future<List<ChapterSummary>> getChapterSummaries(String bookId) async {
    try {
      final summaries = await _api.fetchChapterSummaries(bookId);
      return summaries.map((m) => m.toEntity()).toList();
    } on DioException catch (e) {
      throw mapDioError(e);
    } catch (_) {
      throw const AppFailure(message: 'تعذّر قراءة البيانات');
    }
  }
}
