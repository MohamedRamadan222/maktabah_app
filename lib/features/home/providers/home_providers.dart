import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeCategoryNotifier extends Notifier<String> {
  @override
  String build() {
    return 'all';
  }

  void selectCategory(String category) {
    state = category;
  }
}

final homeCategoryProvider = NotifierProvider<HomeCategoryNotifier, String>(
  HomeCategoryNotifier.new,
);
