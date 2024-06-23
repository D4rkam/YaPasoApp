import 'package:flutter/material.dart';
import 'package:prueba_buffet/config/theme/app_theme.dart';
import 'package:prueba_buffet/screens/intro.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ya paso',
      debugShowCheckedModeBanner: false,
      theme: AppTheme(enableDarkMode: false).theme(),
      home: const IntroScreen(),
    );
  }
}
