import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomToast {
  /// Toast para acciones exitosas (ej: Registro completado)
  static void showSuccess({required String title, required String message}) {
    Get.snackbar(
      "",
      "",
      titleText: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF666666),
        ),
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white,
      borderRadius: 16,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 15,
          offset: const Offset(0, 5),
        )
      ],
      icon: const Icon(
        Icons.check_circle_rounded,
        color: Color(0xFFFFE500), // Tu amarillo característico
        size: 30,
      ),
      shouldIconPulse: false,
      borderWidth: 1,
      borderColor: const Color(0xFFF5F5F5),
      animationDuration: const Duration(milliseconds: 400),
      duration: const Duration(seconds: 3),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutCirc,
    );
  }

  /// Toast para errores (ej: Faltan datos, error de conexión)
  static void showError({required String title, required String message}) {
    Get.snackbar(
      "",
      "",
      titleText: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF666666),
        ),
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white,
      borderRadius: 16,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 15,
          offset: const Offset(0, 5),
        )
      ],
      icon: const Icon(
        Icons.error_outline_rounded,
        color: Color(0xFFFF4D4D), // Un rojo suave para errores
        size: 30,
      ),
      shouldIconPulse:
          true, // Un pequeño latido para llamar la atención del error
      borderWidth: 1,
      borderColor: const Color(0xFFF5F5F5),
      leftBarIndicatorColor:
          const Color(0xFFFF4D4D), // Una sutil línea roja a la izquierda
      animationDuration: const Duration(milliseconds: 400),
      duration: const Duration(seconds: 4),
    );
  }

  static void showProcessing({required String title, required String message}) {
    Get.snackbar(
      "",
      "",
      titleText: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF666666),
        ),
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white,
      borderRadius: 16,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 15,
          offset: const Offset(0, 5),
        )
      ],
      icon: const SizedBox(
        width: 30,
        height: 30,
        child: Center(
          child: CupertinoActivityIndicator(
            color: Color(0xFFFFE500),
            radius: 14,
          ),
        ),
      ),
      shouldIconPulse: false,
      borderWidth: 1,
      borderColor: const Color(0xFFF5F5F5),
      animationDuration: const Duration(milliseconds: 400),
    );
  }
}
