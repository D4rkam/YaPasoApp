import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/balance_controller.dart';
import 'package:prueba_buffet/app/controllers/security_finger_controller.dart';
import 'package:prueba_buffet/app/controllers/shopping_cart_controller.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(BalanceController(), permanent: true);
    Get.lazyPut<ShoppingCartController>(() => ShoppingCartController(),
        fenix: true);
    Get.lazyPut<SecurityFingerController>(() => SecurityFingerController());
  }
}
