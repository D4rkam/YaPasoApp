import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/app/controllers/main_shell_controller.dart';
import 'package:prueba_buffet/features/orders/presentation/controllers/order_controller_v2.dart';
import 'package:prueba_buffet/features/category/presentation/controllers/category_controller_v2.dart';

/// Extiende el MainShellController legacy para que cualquier
/// Get.find<MainShellController>() en la app resuelva a esta instancia.
/// Solo sobreescribimos los métodos que difieren en la lógica V2.
class MainShellControllerV2 extends MainShellController {
  @override
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
      // Delegar al comportamiento legacy del padre
      super.goToOrdersTab();
    }
  }

  @override
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
      // Delegar al comportamiento legacy del padre
      super.goToCategory(category);
    }
  }
}
