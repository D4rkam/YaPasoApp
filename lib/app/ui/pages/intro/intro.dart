import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';

class IntroScreen extends StatelessWidget with ResponsiveMixin {
  IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: setWidth(24)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Comprar",
                    style: TextStyle(
                        fontSize: setSp(50),
                        fontWeight: FontWeight.bold,
                        height: 0.7),
                  ),
                  Text(
                    "¡Antes que nadie!",
                    style: TextStyle(
                      fontSize: setSp(43),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFFE500),
                    ),
                  ),
                  Text(
                    "Promociones anticipadas.",
                    style: TextStyle(
                      fontSize: setSp(23),
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF808080),
                    ),
                  ),
                  Text(
                    "Pedidos sin espera.",
                    style: TextStyle(
                      fontSize: setSp(23),
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF808080),
                    ),
                  ),
                  Text(
                    "Pagos flexibles.",
                    style: TextStyle(
                      fontSize: setSp(23),
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF808080),
                    ),
                  ),
                  Text(
                    "Retiro rápido.",
                    style: TextStyle(
                      fontSize: setSp(23),
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF808080),
                    ),
                  ),
                  Container(
                    height: setHeight(420),
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
                    height: setHeight(65),
                    child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed('/login');
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                            const Color(0xFFFFE500)),
                        foregroundColor:
                            WidgetStateProperty.all<Color>(Colors.black),
                        textStyle: WidgetStateProperty.all<TextStyle>(
                          TextStyle(
                            fontSize: setSp(26),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(setHeight(10)),
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Comenzar',
                            style: TextStyle(
                                fontSize: setSp(35),
                                fontWeight: FontWeight.w400),
                          ),
                          Icon(
                            Icons.arrow_right_alt_rounded,
                            size: setSp(60),
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
