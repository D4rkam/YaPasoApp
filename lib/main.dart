import 'package:flutter/material.dart';
import 'package:prueba_buffet/screens/pedido.dart';
// import 'package:prueba_buffet/screens/register.dart';

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
          colorSchemeSeed: const Color(0xFFFFE500),
          useMaterial3: true,
          brightness: Brightness.light),
      home: const PedidoScreen(),
    );
  }
}
