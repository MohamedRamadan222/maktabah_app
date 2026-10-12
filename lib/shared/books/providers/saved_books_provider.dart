import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maktabah_app/core/storage/shared_prefs_provider.dart';

class SavedBooksNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    final books = ref.watch(sharedPrefsProvider).getStringList(savedBooksKey);
    return (books ?? []).toSet();
  }

  void save(String bookId) {
    state = {...state, bookId};
  }

  void unsave(String bookId) {
    state = state.where((id) => id != bookId).toSet();
  }
}

final savedBooksProvider = NotifierProvider<SavedBooksNotifier, Set<String>>(
  SavedBooksNotifier.new,
);
