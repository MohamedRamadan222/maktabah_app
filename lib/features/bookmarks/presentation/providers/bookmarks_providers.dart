import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maktabah_app/core/storage/shared_prefs_provider.dart';

import '../../domain/entities/bookmark.dart';

class BookmarksNotifier extends Notifier<List<Bookmark>> {
  Future<void> _pendingWrite = Future.value();

  @override
  List<Bookmark> build() {
    final saved = ref.watch(sharedPrefsProvider).getStringList(bookmarksKey);
    final bookmarks = <Bookmark>[];

    for (final entry in saved ?? <String>[]) {
      try {
        final bookmark = Bookmark.fromJson(
          jsonDecode(entry) as Map<String, dynamic>,
        );
        if (bookmark.bookId.isEmpty ||
            bookmark.chapterIndex < 0 ||
            bookmark.chapterNumber < 1 ||
            bookmarks.any((item) => item.bookId == bookmark.bookId)) {
          continue;
        }
        bookmarks.add(bookmark);
      } on FormatException {
        continue;
      } on TypeError {
        continue;
      }
    }

    return bookmarks;
  }

  Future<void> save(Bookmark bookmark) {
    return _write(
      () => [
        bookmark,
        ...state.where((item) => item.bookId != bookmark.bookId),
      ],
    );
  }

  Future<void> unsave(String bookId) {
    return _write(() => state.where((item) => item.bookId != bookId).toList());
  }

  Future<void> _write(List<Bookmark> Function() update) {
    // Read the latest state after earlier bookmark writes finish.
    final write = _pendingWrite.then((_) async {
      final newBookmarks = update();
      final prefs = ref.read(sharedPrefsProvider);
      try {
        await prefs.setStringList(
          bookmarksKey,
          newBookmarks
              .map((bookmark) => jsonEncode(bookmark.toJson()))
              .toList(),
        );
      } catch (_) {
        // Restore the cache, which SharedPreferences updates before writing.
        try {
          await prefs.reloadCache();
        } catch (_) {
          // Keep provider state unchanged even if storage is unavailable.
        }
        rethrow;
      }
      if (ref.mounted) state = newBookmarks;
    });

    _pendingWrite = write.catchError((Object _) {});
    return write;
  }
}

final bookmarksProvider = NotifierProvider<BookmarksNotifier, List<Bookmark>>(
  BookmarksNotifier.new,
);
