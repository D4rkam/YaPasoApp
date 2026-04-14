import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WebResponsiveWrapper extends StatelessWidget {
  final Widget child;

  const WebResponsiveWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Verificamos si estamos en la Web
    if (kIsWeb) {
      double screenWidth = MediaQuery.of(context).size.width;
      // 2. Si es más ancho que un celular (600px), mostramos el mensaje
      if (screenWidth > 600) {
        return const _LargeScreenPlaceholder();
      }
    }

    // 3. Si es celular (o web en ventana chica), dejamos pasar
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: child,
    );
  }
}

class _LargeScreenPlaceholder extends StatelessWidget {
  const _LargeScreenPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.phonelink_erase_rounded,
              size: 100,
              color: Color(0xFFFFE500),
            ),
            const SizedBox(height: 30),
            const Text(
              "¡Ups! Pantalla muy grande",
              style: TextStyle(
                fontSize: 35,
                fontFamily: "Lobster",
                color: Color(0xFF3F3F3F),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Ya Paso está diseñada exclusivamente para tu celular.\n\nAchicá la ventana de tu navegador para simular un teléfono,\no ingresá directamente desde tu dispositivo móvil.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
