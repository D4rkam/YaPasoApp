import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/pages/intro/intro_controller.dart';

class IntroScreen extends StatelessWidget {
  IntroScreen({super.key});

  final IntroController controller = Get.put(IntroController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Comprar",
                    style: TextStyle(
                        fontSize: 50, fontWeight: FontWeight.bold, height: 0.7),
                  ),
                  const Text(
                    "¡Antes que nadie!",
                    style: TextStyle(
                      fontSize: 43,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFE500),
                    ),
                  ),
                  const Text(
                    "Promociones anticipadas.",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF808080),
                    ),
                  ),
                  const Text(
                    "Pedidos sin espera.",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF808080),
                    ),
                  ),
                  const Text(
                    "Pagos flexibles.",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF808080),
                    ),
                  ),
                  const Text(
                    "Retiro rápido.",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF808080),
                    ),
                  ),
                  Container(
                    height: 420,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            "assets/images/intro/img_intro_screen.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 65,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.goToLogin();
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                            const Color(0xFFFFE500)),
                        foregroundColor:
                            WidgetStateProperty.all<Color>(Colors.black),
                        textStyle: WidgetStateProperty.all<TextStyle>(
                          const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Comenzar',
                            style: TextStyle(
                                fontSize: 35, fontWeight: FontWeight.w400),
                          ),
                          Icon(
                            Icons.arrow_right_alt_rounded,
                            size: 60,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
