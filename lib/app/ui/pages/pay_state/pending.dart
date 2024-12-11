import 'package:flutter/material.dart';

class PendingScreen extends StatelessWidget {
  const PendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pendiente"),
      ),
      body: const Center(
        child: Text("El pago se encuentra pendiente"),
      ),
    );
  }
}
