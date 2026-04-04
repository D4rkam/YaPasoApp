import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/balance_controller.dart';
import 'package:prueba_buffet/app/controllers/category_controller.dart';
import 'package:prueba_buffet/features/orders/presentation/controllers/order_controller_v2.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/features/category/presentation/controllers/category_controller_v2.dart';

class MainShellControllerV2 extends GetxController {
  var tabIndex = 0.obs;
  var pageIndex = 0.obs;

  var isExpanded = true.obs;
  var selectedCategory = "".obs;

  void goToHome() {
    tabIndex.value = 0;
    pageIndex.value = 0;
    isExpanded.value = true;
  }

  void goToOrdersTab() {
    tabIndex.value = 0;
    pageIndex.value = 1;
    final enableOrdersV2 =
        GetStorage().read<bool>('enable_orders_v2') ?? false;
    if (enableOrdersV2) {
      if (Get.isRegistered<OrderControllerV2>()) {
        Get.find<OrderControllerV2>().fetchInitialOrders();
      }
    } else {
      // Legacy compatibility
      /* if (Get.isRegistered<OrderController>()) {
        Get.find<OrderController>().fetchInitialOrders();
      } */
    }
  }

  void goToBalance() {
    tabIndex.value = 0;
    pageIndex.value = 2;
    try {
      Get.find<BalanceController>().fetchBalance();
    } catch (_) {}
  }

  void goToCategory(String category) {
    tabIndex.value = 0;
    selectedCategory.value = category;
    pageIndex.value = 3;
    final enableCategoryV2 =
        GetStorage().read<bool>('enable_category_v2') ?? false;
    if (enableCategoryV2) {
      if (Get.isRegistered<CategoryControllerV2>()) {
        Get.find<CategoryControllerV2>().getProducts(category);
      }
    } else {
      try {
        Get.find<CategoryController>().getProducts(category);
      } catch (_) {}
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

  ScrollDirection _lastDirection = ScrollDirection.idle;

  void updateScrollDirection(ScrollDirection direction) {
    if (direction == _lastDirection || direction == ScrollDirection.idle)
      return;

    _lastDirection = direction;

    if (direction == ScrollDirection.reverse && isExpanded.value) {
      isExpanded.value = false;
    } else if (direction == ScrollDirection.forward && !isExpanded.value) {
      isExpanded.value = true;
    }
  }
}
