import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/app/controllers/balance_controller.dart';
import 'package:prueba_buffet/app/controllers/home_controller.dart';
import 'package:prueba_buffet/app/controllers/main_shell_controller.dart';
import 'package:prueba_buffet/app/controllers/shopping_cart_controller.dart';
import 'package:prueba_buffet/app/ui/global_widgets/custom_toast.dart';
import 'package:prueba_buffet/features/orders/presentation/controllers/order_controller_v2.dart';
import 'package:prueba_buffet/utils/logger.dart';

/// Controller V2 para manejar el estado post-pago (success/failure/pending).
/// Soporta tanto OrderController legacy como OrderControllerV2.
class PayStateControllerV2 extends GetxController {
  void goToHomeScreen() =>
      Get.offNamedUntil("/home", (route) => route.settings.name != "/success");

  void goToOrderScreen() {
    Get.offAllNamed("/home");

    Future.delayed(const Duration(milliseconds: 50), () {
      if (Get.isRegistered<MainShellController>()) {
        Get.find<MainShellController>().goToOrdersTab();
      }
    });
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
  }

  @override
  void onReady() {
    super.onReady();

    if (isPaymentForBalance) {
      logger.i("Pago de carga de saldo detectado (status: $paymentStatus)");
      if (paymentStatus == "approved") {
        _applyLocalBalanceLoad();
      } else {
        _failurePayment();
        GetStorage().remove("pending_load_amount");
      }
    } else {
      logger.i(
          "Pago de compra detectado → Limpiando carrito y refrescando datos");
      _cleanCartAndRefreshData();
    }
  }

  void _cleanCartAndRefreshData() async {
    if (Get.isRegistered<ShoppingCartController>()) {
      Get.find<ShoppingCartController>().clearCart();
    }

    GetStorage().remove("cart_items");
    GetStorage().remove("order_datetime");
    GetStorage().remove("pending_cart_total");
    GetStorage().remove("order");

    CustomToast.showProcessing(
      title: "Procesando...",
      message: "Sincronizando tu pedido con el buffet",
    );

    await Future.delayed(const Duration(milliseconds: 2600));

    // Soporta tanto el controller V2 como el legacy
    if (Get.isRegistered<OrderControllerV2>()) {
      await Get.find<OrderControllerV2>().fetchInitialOrders();
    }

    if (Get.isRegistered<BalanceController>()) {
      final balanceCtrl = Get.find<BalanceController>();
      await balanceCtrl.fetchBalance();
      await balanceCtrl.getMyInitialTransactions();
    }

    if (Get.isRegistered<HomeController>()) {
      await Get.find<HomeController>().getProducts();
    }

    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }

    CustomToast.showSuccess(
        title: "¡Pago Exitoso!", message: "Tu pedido ya está en fila");

    goToOrderScreen();
  }

  void _applyLocalBalanceLoad() async {
    try {
      final pendingAmount = GetStorage().read("pending_load_amount");
      if (pendingAmount != null && Get.isRegistered<BalanceController>()) {
        final balanceCtrl = Get.find<BalanceController>();
        final double amount = (pendingAmount as num).toDouble();

        balanceCtrl.balance.value += amount;

        GetStorage().remove("pending_load_amount");
        logger.i("PayStateControllerV2: saldo actualizado optimista +$amount");

        await balanceCtrl.fetchBalance();
        await balanceCtrl.getMyInitialTransactions();
        CustomToast.showProcessing(
          title: "Procesando...",
          message: "Sincronizando tu saldo",
        );
        await Future.delayed(const Duration(milliseconds: 2600));

        goToHomeScreen();
        if (Get.isSnackbarOpen) {
          Get.closeAllSnackbars();
        }

        CustomToast.showSuccess(
            title: "¡Carga Exitosa!",
            message: "Tu saldo ya está disponible en tu billetera.");
      }
    } catch (e) {
      logger.e("PayStateControllerV2._applyLocalBalanceLoad CRASH: $e");
    }
  }

  void _failurePayment() async {
    await Future.delayed(const Duration(milliseconds: 2600));

    if (Get.isRegistered<HomeController>()) {
      await Get.find<HomeController>().getProducts();
    }

    goToHomeScreen();
    CustomToast.showError(
      title: "Error en el pago",
      message: "No se pudo completar el pago. Por favor, inténtalo de nuevo.",
    );
  }
}
