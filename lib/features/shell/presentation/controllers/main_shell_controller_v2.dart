import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/features/orders/presentation/controllers/order_controller_v2.dart';
import 'package:prueba_buffet/features/category/presentation/controllers/category_controller_v2.dart';
import 'package:prueba_buffet/features/balance/presentation/controllers/balance_controller_v2.dart';

class MainShellControllerV2 extends GetxController {
  /// Índice visual del bottom bar: 0=Más(drawer), 1=Inicio, 2=Pedidos
  var tabIndex = 0.obs;
  var pageIndex = 0.obs;

  /// Controla expand/collapse de la barra flotante al scrollear
  var isExpanded = true.obs;

  /// Mapea el tab visual → página del IndexedStack.
  /// Tab 0 (Más) abre drawer, no es página.
  /// Tab 1 (Inicio) → page 0
  /// Tab 2 (Pedidos) → page 1
  /// page 2 → MyBalance
  /// page 3 → Category

  var selectedCategory = "".obs;

  void goToHome() {
    tabIndex.value = 0;
    pageIndex.value = 0;
    isExpanded.value = true;
  }

  void goToOrdersTab() {
    tabIndex.value = 0;
    pageIndex.value = 1;
    if (Get.isRegistered<OrderControllerV2>()) {
      Get.find<OrderControllerV2>().fetchInitialOrders();
    }
  }

  void goToBalance() {
    tabIndex.value = 0;
    pageIndex.value = 2;
    try {
      Get.find<BalanceControllerV2>().fetchBalance();
    } catch (_) {}
  }

  void goToCategory(String category) {
    tabIndex.value = 0;
    selectedCategory.value = category;
    pageIndex.value = 3;
    if (Get.isRegistered<CategoryControllerV2>()) {
      Get.find<CategoryControllerV2>().getProducts(category);
    }
  }

  void goToPerfil() {
    tabIndex.value = 1;
    pageIndex.value = 4;
  }

  void goToConfiguracion() {
    tabIndex.value = 2;
    pageIndex.value = 5;
  }

  void goToHelp() {
    tabIndex.value = 3;
    pageIndex.value = 6;
  }

  /// Guarda la última dirección procesada para evitar asignaciones redundantes.
  ScrollDirection _lastDirection = ScrollDirection.idle;

  void updateScrollDirection(ScrollDirection direction) {
    if (direction == _lastDirection || direction == ScrollDirection.idle) return;

    _lastDirection = direction;

    if (direction == ScrollDirection.reverse && isExpanded.value) {
      isExpanded.value = false;
    } else if (direction == ScrollDirection.forward && !isExpanded.value) {
      isExpanded.value = true;
    }
  }
}

