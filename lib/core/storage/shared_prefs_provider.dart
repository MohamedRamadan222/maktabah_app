import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_preferences/shared_preferences.dart';

const savedBooksKey = 'maktabah.saved';

final sharedPrefsProvider = Provider<SharedPreferencesWithCache>((ref) {
  throw UnimplementedError('sharedPrefsProvider must be overridden in main');
});
