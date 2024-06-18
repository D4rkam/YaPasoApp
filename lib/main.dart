import 'package:flutter/material.dart';
// import 'package:prueba_buffet/screens/home.dart';
import 'package:prueba_buffet/screens/register.dart';

// import 'screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Entre clases',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFAD246)),
        useMaterial3: true,
      ),
      home: const RegisterScreen(),
    );
  }
}
