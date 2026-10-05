import 'package:flutter/material.dart';

import 'features/home/presentation/views/main_screen.dart';

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
        scaffoldBackgroundColor: Color(0xfff3f7fb),
        appBarTheme: AppBarTheme(backgroundColor: Color(0xfff3f7fb)),
      ),
      home: MainScreen(),
    );
  }
}
