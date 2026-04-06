import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/app/controllers/balance_controller.dart';
import 'package:prueba_buffet/app/controllers/category_controller.dart';
import 'package:prueba_buffet/app/controllers/main_shell_controller.dart';
import 'package:prueba_buffet/app/controllers/security_finger_controller.dart';
import 'package:prueba_buffet/app/controllers/shopping_cart_controller.dart';
import 'package:prueba_buffet/app/data/provider/users_provider.dart';
import 'package:prueba_buffet/app/controllers/home_controller.dart';
import 'package:prueba_buffet/features/home/presentation/bindings/home_binding_v2.dart';
import 'package:prueba_buffet/features/shell/presentation/controllers/main_shell_controller_v2.dart';

class MainShellBindingV2 implements Bindings {
  @override
  void dependencies() {
    // 1. Controlador principal del esqueleto
    //    Registramos bajo AMBAS claves para que Get.find<MainShellController>()
    //    y Get.find<MainShellControllerV2>() devuelvan la misma instancia.
    final shellV2 = MainShellControllerV2();
    Get.put<MainShellControllerV2>(shellV2);
    Get.put<MainShellController>(shellV2);

    // 2. Provider compartido
    Get.lazyPut<UsersProvider>(() => UsersProvider(), fenix: true);

    // 3. Home
    final enableHomeV2 = GetStorage().read<bool>('enable_home_v2') ?? false;
    if (enableHomeV2) {
      HomeBindingV2().dependencies();
    } else {
      Get.put<HomeController>(HomeController(), permanent: true);
    }

    // 4. Categoría
    final enableCategoryV2 = GetStorage().read<bool>('enable_category_v2') ?? false;
    if (!enableCategoryV2) {
      Get.lazyPut<CategoryController>(() => CategoryController(), fenix: true);
    }

    // Orders se inyecta via feature flag a través de OrderV2Content y OrderContent condicionales

    // 5. Otros auxiliares legacy
    if (!Get.isRegistered<BalanceController>()) {
      Get.put(BalanceController(), permanent: true); // Sigue siendo legacy shared hasta q todos usen V2
    }
    if (!Get.isRegistered<ShoppingCartController>()) {
      Get.lazyPut<ShoppingCartController>(() => ShoppingCartController(),
          fenix: true);
    }
    if (!Get.isRegistered<SecurityFingerController>()) {
      Get.lazyPut<SecurityFingerController>(() => SecurityFingerController());
    }
  }
}
