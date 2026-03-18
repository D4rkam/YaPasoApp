import 'package:flutter/material.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';

class BannerCard extends StatelessWidget with ResponsiveMixin {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final bool isNew;

  const BannerCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    this.isNew = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // Margen vertical para que la sombra no se corte con el carrusel
      margin: EdgeInsets.symmetric(vertical: setHeight(8)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Fondo decorativo derecho (Círculo suave)
          Positioned(
            right: setWidth(-20),
            top: setHeight(-20),
            child: Container(
              width: setWidth(140),
              height: setHeight(140),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconColor.withOpacity(
                    0.1), // Toma el color del ícono y lo hace súper transparente
              ),
            ),
          ),

          // Ícono decorativo
          Positioned(
            right: setWidth(15),
            bottom: setHeight(15),
            child: Icon(
              icon,
              size: setSp(75),
              color: iconColor.withOpacity(0.3), // Ícono grande pero sutil
            ),
          ),

          // Contenido Principal (Textos)
          Padding(
            padding: EdgeInsets.all(setWidth(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Etiqueta "¡Nuevo!" opcional
                if (isNew) ...[
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: setWidth(10), vertical: setHeight(4)),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE500),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'TIP', // Cambié "Nuevo" por "TIP" que tiene más sentido aquí
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: setSp(10),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: setHeight(8)),
                ],

                // Título
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: setSp(20),
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                SizedBox(height: setHeight(6)),

                // Subtítulo
                SizedBox(
                  width:
                      setWidth(220), // Limita el ancho para no pisar el ícono
                  child: Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: const Color(0xFF666666),
                      fontSize: setSp(13),
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
