import 'package:flutter/material.dart';

class NavBarWidget extends StatelessWidget {
  const NavBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      useLegacyColorScheme: false,
      iconSize: 28,
      selectedFontSize: 16,
      unselectedFontSize: 16,
      selectedItemColor: const Color(0xFFFFE500),
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      currentIndex: 1,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notificaciones',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.more_horiz),
          label: 'Más',
        ),
      ],
    );
  }
}
