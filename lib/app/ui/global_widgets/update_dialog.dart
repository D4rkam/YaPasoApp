import 'package:flutter/material.dart';
// Importá acá la ruta real de tu mixin
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';

class UpdateDialogWidget extends StatelessWidget with ResponsiveMixin {
  final String mensaje;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  UpdateDialogWidget({
    super.key,
    required this.mensaje,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(setWidth(20)),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(setWidth(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Se adapta al contenido
          children: [
            // 1. Ícono llamativo arriba
            Container(
              padding: EdgeInsets.all(setWidth(16)),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE500).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome_rounded,
                color: const Color(0xFFFFE500),
                size: setWidth(40),
              ),
            ),
            SizedBox(height: setHeight(20)),

            // 2. Título principal
            Text(
              "¡Nueva versión!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: setSp(24),
                fontWeight: FontWeight.bold,
                color: const Color(0xFF3F3F3F),
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: setHeight(12)),

            // 3. El mensaje dinámico
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: setSp(15),
                color: Colors.grey[700],
                height: 1.5,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: setHeight(28)),

            // 4. Botón principal (Actualizar)
            SizedBox(
              width: double.infinity,
              height: setHeight(55),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFE500),
                  foregroundColor: const Color(0xFF3F3F3F),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(setWidth(15)),
                  ),
                ),
                onPressed: onConfirm,
                child: Text(
                  "ACTUALIZAR AHORA",
                  style: TextStyle(
                    fontSize: setSp(16),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            SizedBox(height: setHeight(10)),

            // 5. Botón secundario (Cancelar)
            SizedBox(
              width: double.infinity,
              height: setHeight(50),
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[600],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(setWidth(15)),
                  ),
                ),
                onPressed: onCancel,
                child: Text(
                  "Dejar para más tarde",
                  style: TextStyle(
                    fontSize: setSp(15),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
