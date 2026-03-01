import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';

class CustomBottomBar extends StatelessWidget with ResponsiveMixin {
  final RxInt currentIndex; // Usamos RxInt por GetX

  const CustomBottomBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: setHeight(80),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(setHeight(20)),
          topRight: Radius.circular(setHeight(20)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: setHeight(10),
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(context, 0, Icons.menu, 'Más'),
          _buildNavItem(context, 1, Icons.home, 'Inicio'),
          _buildNavItem(context, 2, Icons.notifications, 'Notificaciones',
              badgeCount: 1),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, int index, IconData icon, String label,
      {int badgeCount = 0}) {
    return Obx(() {
      final bool isSelected = currentIndex.value == index;
      final Color color = isSelected ? const Color(0xFFFFE500) : Colors.grey;

      return GestureDetector(
        onTap: () {
          currentIndex.value = index;
          switch (index) {
            case 0:
              Scaffold.of(context).openDrawer();
              // Get.toNamed('/settings'); // Ejemplo de navegación
              break;
            case 1:
              print("Ir al Inicio");
              // Ya lo maneja el Obx del body en el Scaffold
              break;
            case 2:
              print("Ver Notificaciones");
              // Aquí podrías llamar a un método de tu UsersProvider para marcar como leídas
              break;
          }
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            // INDICADOR SUPERIOR CON SOMBRA
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: setHeight(4),
              width: setWidth(50),
              decoration: BoxDecoration(
                color:
                    isSelected ? const Color(0xFFFFE500) : Colors.transparent,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(setHeight(5)),
                  bottomRight: Radius.circular(setHeight(5)),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFFFFE500).withOpacity(0.5),
                          blurRadius: setHeight(8),
                          offset: const Offset(0, 2),
                        )
                      ]
                    : [],
              ),
            ),
            const Spacer(),
            // ICONO CON NOTIFICACIÓN (STACK)
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, color: color, size: 30),
                if (badgeCount > 0)
                  Positioned(
                    right: setWidth(-5),
                    top: setHeight(-5),
                    child: Container(
                      padding: EdgeInsets.all(setHeight(4)),
                      decoration: const BoxDecoration(
                          color: Color(0xFFFFE500), shape: BoxShape.circle),
                      constraints: BoxConstraints(
                          minWidth: setWidth(16), minHeight: setHeight(16)),
                      child: Text(
                        '$badgeCount',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: setSp(10),
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: setHeight(4)),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: setSp(12),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            SizedBox(height: setHeight(8)),
          ],
        ),
      );
    });
  }
}
