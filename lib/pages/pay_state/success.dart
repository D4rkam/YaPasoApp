import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Realizado"),
      ),
      body: const Center(
        child: Text("El pago se realizo con éxito"),
      ),
    );
  }
}
