import 'package:flutter/material.dart';
import 'package:maktabah_app/core/theme/app_colors.dart';

import 'features/main_screen.dart';

void main() {
  runApp(const MyApp());
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
