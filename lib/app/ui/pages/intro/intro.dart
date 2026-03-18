import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';

class IntroScreen extends StatelessWidget with ResponsiveMixin {
  IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Moví el fondo aquí por limpieza
      body: SafeArea(
        child: LayoutBuilder(
          // Usamos LayoutBuilder para conocer el espacio real
          builder: (context, constraints) {
            return SingleChildScrollView(
              // 👈 Evita el crash en pantallas muy chicas
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      constraints.maxHeight, // Asegura que ocupe todo el alto
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: setWidth(24)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, // 👈 Separa arriba/medio/abajo
                    children: [
                      // --- SECCIÓN TEXTOS (ARRIBA) ---
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

                      // --- SECCIÓN IMAGEN (MEDIO) ---
                      // Usamos un Container con alto basado en porcentaje para que sea flexible
                      Container(
                        height: constraints.maxHeight *
                            0.4, // 👈 Ocupa el 40% del alto disponible
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                "assets/images/intro/img_intro_screen.png"),
                            fit: BoxFit
                                .contain, // 👈 'contain' es mejor para que no se corte la imagen
                          ),
                        ),
                      ),

                      // --- SECCIÓN BOTÓN (ABAJO) ---
                      Padding(
                        padding: EdgeInsets.only(bottom: setHeight(30)),
                        child: SizedBox(
                          width: double.infinity,
                          height: setHeight(65),
                          child: ElevatedButton(
                            onPressed: () => Get.toNamed('/login'),
                            style: ElevatedButton.styleFrom(
                              // Usar styleFrom es más moderno que ButtonStyle
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

// Widget auxiliar para no repetir código de estilo
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
