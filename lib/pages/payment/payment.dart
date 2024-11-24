import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/pages/payment/payment_controller.dart';

class paymentScreen extends StatelessWidget {
  paymentScreen({super.key});

  final paymentController controller = Get.put(paymentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icono de confirmación
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFffbe00),
                  shape: BoxShape.circle,

                ),
                padding: const EdgeInsets.all(30),
                child: const Icon(
                  Icons.check_rounded,
                  size: 100,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              // Texto de confirmación
              const Text(
                '¡Compra realizada con exito!',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Puedes seguir la entrega en la sección "Mis pedidos"',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff999999),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 200),
              // Botón "Mis pedidos"
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFE500),
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 70),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  // Navegar a la sección de "Mis pedidos"
                },
                child: const Text(
                  'Mis pedidos',
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Botón "Volver"
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  'Volver',
                  style: TextStyle(
                    fontSize: 30,
                    color: const Color(0xff999999),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}