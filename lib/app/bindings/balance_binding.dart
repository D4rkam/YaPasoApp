import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/balance_controller.dart';

class BalanceBinding implements Bindings {
  @override
  void dependencies() {
    // BalanceController ya está registrado como permanente en InitialBinding.
    // Solo refrescamos el saldo al entrar a la pantalla.
    if (Get.isRegistered<BalanceController>()) {
      Get.find<BalanceController>().fetchBalance();
    }
  }
}
