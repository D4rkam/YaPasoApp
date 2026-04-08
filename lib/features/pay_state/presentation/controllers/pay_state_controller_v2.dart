import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/features/balance/presentation/controllers/balance_controller_v2.dart';
import 'package:prueba_buffet/features/home/presentation/controllers/home_controller_v2.dart';
import 'package:prueba_buffet/features/shell/presentation/controllers/main_shell_controller_v2.dart';
import 'package:prueba_buffet/features/cart/presentation/controllers/shopping_cart_controller_v2.dart';
import 'package:prueba_buffet/core/presentation/widgets/custom_toast.dart';
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
      if (Get.isRegistered<MainShellControllerV2>()) {
        Get.find<MainShellControllerV2>().goToOrdersTab();
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
    if (Get.isRegistered<ShoppingCartControllerV2>()) {
      Get.find<ShoppingCartControllerV2>().clearCart();
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

    // Soporta el controller V2
    if (Get.isRegistered<OrderControllerV2>()) {
      await Get.find<OrderControllerV2>().fetchInitialOrders();
    }

    if (Get.isRegistered<BalanceControllerV2>()) {
      final balanceCtrl = Get.find<BalanceControllerV2>();
      await balanceCtrl.fetchBalance();
      await balanceCtrl.getMyInitialTransactions();
    }

    if (Get.isRegistered<HomeControllerV2>()) {
      await Get.find<HomeControllerV2>().getTopSellingProducts();
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
      if (pendingAmount != null && Get.isRegistered<BalanceControllerV2>()) {
        final balanceCtrl = Get.find<BalanceControllerV2>();
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

    if (Get.isRegistered<HomeControllerV2>()) {
      await Get.find<HomeControllerV2>().getTopSellingProducts();
    }

    goToHomeScreen();
    CustomToast.showError(
      title: "Error en el pago",
      message: "No se pudo completar el pago. Por favor, inténtalo de nuevo.",
    );
  }
}
