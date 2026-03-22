import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateRequiredView extends StatelessWidget {
  const UpdateRequiredView({super.key});

  // 👇 REEMPLAZÁ ESTO CON LA URL REAL DE TU APP EN LA PLAY STORE 👇
  static const String _landingPage = 'https://yapaso.app';

  Future<void> _launchStore() async {
    final Uri url = Uri.parse(_landingPage);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      Get.snackbar(
        '¡Ups!',
        'No pudimos abrir el navegador. Buscá "Ya Paso" manualmente.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Usamos WillPopScope para bloquear el botón "Atrás" de Android
    // En GetX 5.0+ se usa PopScope, pero WillPopScope sigue funcionando
    return WillPopScope(
      onWillPop: () async => false, // Bloquea el retroceso
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. EL LOGO MINIMALISTA ARRIBA
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Ya Paso",
                    style: TextStyle(
                      fontFamily: 'Lobster', // Tu fuente de logo
                      fontSize: 28.sp,
                      color: const Color(0xFFFFE500), // Tu amarillo
                    ),
                  ),
                ),
                SizedBox(height: 40.h),

                // 2. ILUSTRACIÓN SIMPÁTICA CENTRAL
                // Como no tengo tu SVG, uso un ícono grande, pero acá iría
                // un SvgPicture.asset('assets/images/update_robot.svg')
                Container(
                  height: 220.h,
                  width: 220.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE500).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons
                          .system_update_alt_rounded, // O Icons.construction_rounded
                      size: 130.h,
                      color: const Color(0xFFFFE500),
                    ),
                  ),
                ),
                SizedBox(height: 50.h),

                // 3. TÍTULO CON ONDA
                Text(
                  "¡Pausa en el Buffet!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily:
                        'Lobster', // Usamos Lobster para darle onda universitaria
                    fontSize: 36.sp,
                    color: const Color(0xFF3F3F3F), // Gris oscuro
                    height: 1.1,
                  ),
                ),
                SizedBox(height: 20.h),

                // 4. EXPLICACIÓN CORTA Y CLARA (Simulando la voz de un compañero)
                Text(
                  "Metimos unos cambios re grosos en el sistema para que tus pedidos salgan volando.\n\nPara seguir pidiendo tus empanadas y cafés sin filas, necesitás actualizar la app a la última versión.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                    height: 1.5,
                    fontFamily: 'Poppins', // O tu sans-serif por defecto
                  ),
                ),
                const Spacer(), // Empuja el botón hacia abajo

                // 5. BOTÓN GIGANTE LLAMATIVO (Única Acción)
                SizedBox(
                  width: double.infinity,
                  height: 60.h,
                  child: ElevatedButton(
                    onPressed: _launchStore,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFFFE500), // Amarillo vibrante
                      foregroundColor: const Color(
                          0xFF3F3F3F), // Texto oscuro para contraste
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                    ),
                    child: Text(
                      "ACTUALIZAR EN LA TIENDA",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30.h), // Espacio final
              ],
            ),
          ),
        ),
      ),
    );
  }
}
