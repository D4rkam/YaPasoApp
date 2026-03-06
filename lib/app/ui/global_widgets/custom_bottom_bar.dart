import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/main_shell_controller.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';

class FloatingBottomBar extends StatelessWidget with ResponsiveMixin {
  final MainShellController controller;

  const FloatingBottomBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isExpanded = controller.isExpanded.value;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        // Al achicarse, aumentamos el margen lateral para que se vea como una "pastilla" pequeña
        margin: EdgeInsets.only(
          bottom: setHeight(20),
          left: isExpanded ? setWidth(20) : setWidth(60),
          right: isExpanded ? setWidth(20) : setWidth(60),
        ),
        height: isExpanded ? setHeight(80) : setHeight(60),
        decoration: BoxDecoration(
          color: const Color(
              0xFF2D303E), // Te sugiero un color oscuro para que contraste flotando
          borderRadius: BorderRadius.circular(setHeight(isExpanded ? 25 : 40)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: setHeight(20),
              offset: const Offset(0, 10),
            ),
          ],
        ),
        // Envolvemos los íconos para que no desborden al achicarse
        child: ClipRRect(
          borderRadius: BorderRadius.circular(setHeight(isExpanded ? 25 : 40)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(context, 0, Icons.menu, 'Más', isExpanded),
              _buildNavItem(context, 1, Icons.home, 'Inicio', isExpanded),
              _buildNavItem(
                  context, 2, Icons.assignment_rounded, 'Pedidos', isExpanded),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon,
      String label, bool isExpanded,
      {int badgeCount = 0}) {
    return Obx(() {
      final bool isSelected = controller.tabIndex.value == index;
      final Color activeColor = const Color(0xFFFFE500);
      final Color inactiveColor = Colors.white70;

      return GestureDetector(
        onTap: () {
          if (index == 0) {
            Scaffold.of(context).openDrawer();
          } else {
            controller.tabIndex.value = index;
          }
        },
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isExpanded ? setWidth(70) : setWidth(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ICONO CON NOTIFICACIÓN
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedTheme(
                    data: ThemeData(
                      iconTheme: IconThemeData(
                        color: isSelected ? activeColor : inactiveColor,
                        size: isExpanded
                            ? 28
                            : 24, // El ícono se achica un poquito
                      ),
                    ),
                    child: Icon(icon),
                  ),
                  if (badgeCount > 0)
                    Positioned(
                      right: setWidth(-4),
                      top: setHeight(-4),
                      child: Container(
                        padding: EdgeInsets.all(setHeight(4)),
                        decoration: BoxDecoration(
                          color: activeColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: const Color(0xFF2D303E),
                              width: 2), // Borde para que resalte
                        ),
                        constraints: BoxConstraints(
                            minWidth: setWidth(18), minHeight: setHeight(18)),
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

              // TEXTO QUE DESAPARECE SUAVEMENTE
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: isExpanded
                    ? Column(
                        children: [
                          SizedBox(height: setHeight(4)),
                          Text(
                            label,
                            style: TextStyle(
                              color: isSelected ? activeColor : inactiveColor,
                              fontSize: setSp(11),
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      )
                    : const SizedBox
                        .shrink(), // Desaparece el texto si está encogido
              ),
            ],
          ),
        ),
      );
    });
  }
}
