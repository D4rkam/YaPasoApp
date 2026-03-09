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
      final selectedIndex = controller.tabIndex.value;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        margin: EdgeInsets.only(
          bottom: setHeight(20),
          left: isExpanded ? setWidth(20) : setWidth(60),
          right: isExpanded ? setWidth(20) : setWidth(60),
        ),
        height: isExpanded ? setHeight(80) : setHeight(60),
        decoration: BoxDecoration(
          color: const Color(0xFF2D303E),
          borderRadius: BorderRadius.circular(setHeight(isExpanded ? 25 : 40)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          _buildNavItem(
              context, 0, Icons.menu, 'Más', isExpanded, selectedIndex),
          _buildNavItem(
              context, 1, Icons.home, 'Inicio', isExpanded, selectedIndex),
          _buildNavItem(context, 2, Icons.assignment_rounded, 'Pedidos',
              isExpanded, selectedIndex),
        ]),
      );
    });
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon,
      String label, bool isExpanded, int selectedIndex,
      {int badgeCount = 0}) {
    final bool isSelected = selectedIndex == index;
    const Color activeColor = Color(0xFFFFE500);
    const Color inactiveColor = Colors.white70;
    final Color itemColor = isSelected ? activeColor : inactiveColor;

    return GestureDetector(
      onTap: () {
        if (index == 0) {
          Scaffold.of(context).openDrawer();
        } else {
          controller.tabIndex.value = index;
        }
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: isExpanded ? setWidth(70) : setWidth(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: itemColor,
              size: isExpanded ? 28 : 24,
            ),
            if (isExpanded) ...[
              SizedBox(height: setHeight(4)),
              Text(
                label,
                style: TextStyle(
                  color: itemColor,
                  fontSize: setSp(11),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
