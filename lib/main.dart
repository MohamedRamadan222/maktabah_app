import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maktabah_app/core/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/storage/shared_prefs_provider.dart';
import 'features/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(
      allowList: {savedBooksKey, bookmarksKey},
    ),
  );

  runApp(
    ProviderScope(
      overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
      retry: ((retryCount, error) => null),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maktabah App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Tajawal',
        scaffoldBackgroundColor: AppColors.pageColor,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.pageColor,
          scrolledUnderElevation: 0,
        ),
      ),
      home: MainScreen(),
    );
  }
}
