import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maktabah_app/core/network/dio_provider.dart';
import 'package:maktabah_app/shared/books/data/repositories/reader_repository_impl.dart';
import 'package:maktabah_app/shared/books/data/sources/reader_api.dart';
import 'package:maktabah_app/shared/books/domain/repositories/reader_repository.dart';

import '../domain/entities/chapter.dart';
import '../domain/entities/chapter_summary.dart';

final readerApiProvider = Provider<ReaderApi>((ref) {
  final dio = ref.watch(dioProvider);
  return ReaderApi(dio);
});

final readerRepositoryProvider = Provider<ReaderRepository>((ref) {
  final api = ref.watch(readerApiProvider);
  return ReaderRepositoryImpl(api);
});

final chapterSummariesProvider =
    FutureProvider.family<List<ChapterSummary>, String>((ref, bookId) {
      final repository = ref.watch(readerRepositoryProvider);
      return repository.getChapterSummaries(bookId);
    });
final chapterProvider =
    FutureProvider.family<Chapter, ({String bookId, int index})>((ref, key) {
      final repository = ref.watch(readerRepositoryProvider);
      return repository.getChapter(key.bookId, key.index);
    });
