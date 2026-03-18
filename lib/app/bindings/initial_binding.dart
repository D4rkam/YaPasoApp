import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/balance_controller.dart';
import 'package:prueba_buffet/app/controllers/security_finger_controller.dart';
import 'package:prueba_buffet/app/controllers/shopping_cart_controller.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    // Permanente: Sobrevive a toda la app. Mantiene tu saldo siempre arriba.
    Get.put(BalanceController(), permanent: true);

    // Fenix: Se destruye si no se usa, pero si lo volvés a llamar, se recrea.
    Get.lazyPut<ShoppingCartController>(() => ShoppingCartController(),
        fenix: true);
    Get.lazyPut<SecurityFingerController>(() => SecurityFingerController());
  }
}
