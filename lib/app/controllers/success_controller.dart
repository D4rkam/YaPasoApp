import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/app/controllers/balance_controller.dart';
import 'package:prueba_buffet/app/controllers/main_shell_controller.dart';
import 'package:prueba_buffet/app/controllers/shopping_cart_controller.dart';

class SuccessController extends GetxController {
  void goToHomeScreen() =>
      Get.offNamedUntil("/home", (route) => route.settings.name != "/success");

  void goToOrderScreen() {
    if (Get.isRegistered<MainShellController>()) {
      Get.find<MainShellController>().goToOrdersTab();
      Get.offAllNamed("/home");
    } else {
      Get.offAllNamed("/home");
    }
  }

  static const String paymentBalance = "CARGA_SALDO";

  String paymentId = "";
  String externalReference = "";
  bool isPaymentForBalance = false;
  String paymentStatus = "";

  @override
  void onInit() {
    super.onInit();
    paymentId = Get.parameters['payment_id'] ?? "";
    paymentStatus = Get.parameters['status'] ?? "";
    externalReference =
        Get.parameters['external_reference']?.split("|")[0] ?? "";
    isPaymentForBalance = externalReference == paymentBalance;

    if (isPaymentForBalance) {
      print("Pago de carga de saldo detectado (status: $paymentStatus)");
      if (paymentStatus == "approved") {
        _applyLocalBalanceLoad();
      } else {
        // Pago no aprobado → limpiar monto pendiente
        GetStorage().remove("pending_load_amount");
      }
    } else {
      // ---> NUEVO: El backend ya creó el pedido por Webhook.
      // Solo limpiamos la memoria del celular.
      print("Pago de compra detectado → Limpiando carrito local");
      _cleanCartAfterPurchase();
    }
  }

  /// Limpia los datos de la compra local y redirige a la pantalla de pedidos
  void _cleanCartAfterPurchase() {
    // Vaciamos el carrito de la UI
    if (Get.isRegistered<ShoppingCartController>()) {
      Get.find<ShoppingCartController>().clearCart();
    }

    // Limpiamos todo el rastro en GetStorage
    GetStorage().remove("cart_items");
    GetStorage().remove("order_datetime");
    GetStorage().remove("pending_cart_total");
    GetStorage().remove("order");

    // Mostramos un mensaje amable y navegamos
    Get.snackbar(
        "¡Pago Exitoso!", "Tu pedido ya se está preparando en el buffet",
        snackPosition: SnackPosition.TOP);

    goToOrderScreen();
  }

  /// Aplica la carga de saldo localmente sin llamar al servidor.
  void _applyLocalBalanceLoad() {
    try {
      final pendingAmount = GetStorage().read("pending_load_amount");
      if (pendingAmount != null && Get.isRegistered<BalanceController>()) {
        final balanceCtrl = Get.find<BalanceController>();
        final double amount = (pendingAmount as num).toDouble();

        balanceCtrl.balance.value += amount;

        GetStorage().remove("pending_load_amount");
        print("SuccessController: saldo actualizado localmente +$amount");
      }
    } catch (e) {
      print("⚠️ SuccessController._applyLocalBalanceLoad CRASH: $e");
    }
  }
}
