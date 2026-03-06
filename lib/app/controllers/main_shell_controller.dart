import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class MainShellController extends GetxController {
  /// Índice visual del bottom bar: 0=Más(drawer), 1=Inicio, 2=Pedidos
  var tabIndex = 1.obs;

  /// Controla expand/collapse de la barra flotante al scrollear
  var isExpanded = true.obs;

  /// Mapea el tab visual → página del IndexedStack.
  /// Tab 0 (Más) abre drawer, no es página.
  /// Tab 1 (Inicio) → page 0
  /// Tab 2 (Pedidos) → page 1
  int get pageIndex => tabIndex.value >= 2 ? 1 : 0;

  void updateScrollDirection(ScrollDirection direction) {
    if (direction == ScrollDirection.reverse && isExpanded.value) {
      isExpanded.value = false;
    } else if (direction == ScrollDirection.forward && !isExpanded.value) {
      isExpanded.value = true;
    }
  }
}
