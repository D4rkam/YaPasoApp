import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateRequiredView extends StatelessWidget {
  const UpdateRequiredView({super.key});

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
                // 1. ILUSTRACIÓN SIMPÁTICA CENTRAL
                Container(
                  height: 200.h,
                  width: 200.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE500).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.system_update_alt_rounded,
                      size: 100.h,
                      color: const Color(0xFFFFE500),
                    ),
                  ),
                ),
                SizedBox(height: 50.h),

                // 2. TÍTULO CON ONDA
                Text(
                  "¡Es hora de actualizar!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Lobster',
                    fontSize: 36.sp,
                    color: const Color(0xFF3F3F3F),
                    height: 1.1,
                  ),
                ),
                SizedBox(height: 20.h),

                // 3. EXPLICACIÓN CORTA Y CLARA
                Text(
                  "Mejoramos la app de Ya Paso para que el sistema sea más rápido y seguro.\nDescargá la nueva versión ahora para poder seguir haciendo tus pedidos sin problemas.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
                const Spacer(), // Empuja el botón hacia abajo

                // 4. BOTÓN GIGANTE LLAMATIVO
                SizedBox(
                  width: double.infinity,
                  height: 60.h,
                  child: ElevatedButton(
                    onPressed: _launchStore,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFE500),
                      foregroundColor: const Color(0xFF3F3F3F),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                    ),
                    child: Text(
                      "ACTUALIZAR AHORA",
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
