import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/core/presentation/widgets/mixins/responsive_mixin.dart';
import 'package:prueba_buffet/core/routes/routes.dart';

class IntroV2Page extends StatelessWidget with ResponsiveMixin {
  IntroV2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: setWidth(24)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: setHeight(40)),
                          Text(
                            "Comprar",
                            style: TextStyle(
                                fontSize: setSp(40),
                                fontWeight: FontWeight.bold,
                                height: 0.9),
                          ),
                          Text(
                            "¡Antes que nadie!",
                            style: TextStyle(
                              fontSize: setSp(33),
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFFFE500),
                            ),
                          ),
                          SizedBox(height: setHeight(10)),
                          _buildSubText("Promociones anticipadas."),
                          _buildSubText("Pedidos sin espera."),
                          _buildSubText("Pagos flexibles."),
                          _buildSubText("Retiro rápido."),
                        ],
                      ),
                      Container(
                        height: constraints.maxHeight * 0.4,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                "assets/images/intro/img_intro_screen.webp"),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: setHeight(30)),
                        child: SizedBox(
                          width: double.infinity,
                          height: setHeight(65),
                          child: ElevatedButton(
                            onPressed: () => Get.toNamed(Routes.LOGIN),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFE500),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(setWidth(15)),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Comenzar',
                                  style: TextStyle(
                                      fontSize: setSp(28),
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: setWidth(20)),
                                Icon(
                                  Icons.arrow_right_alt_rounded,
                                  size: setSp(40),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSubText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: setSp(14),
        fontWeight: FontWeight.w500,
        color: const Color(0xFF808080),
      ),
    );
  }
}
