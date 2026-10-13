import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maktabah_app/core/storage/shared_prefs_provider.dart';

class SavedBooksNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    final books = ref.watch(sharedPrefsProvider).getStringList(savedBooksKey);
    return (books ?? []).toSet();
  }

  void save(String bookId) {
    final newBooks = {...state, bookId};
    state = newBooks;
    ref
        .read(sharedPrefsProvider)
        .setStringList(savedBooksKey, newBooks.toList());
  }

  void unsave(String bookId) {
    final newBooks = state.where((id) => id != bookId).toSet();
    state = newBooks;
    ref
        .read(sharedPrefsProvider)
        .setStringList(savedBooksKey, newBooks.toList());
  }
}

final savedBooksProvider = NotifierProvider<SavedBooksNotifier, Set<String>>(
  SavedBooksNotifier.new,
);
