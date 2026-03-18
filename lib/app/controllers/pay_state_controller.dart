import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/app/controllers/balance_controller.dart';
import 'package:prueba_buffet/app/controllers/home_controller.dart';
import 'package:prueba_buffet/app/controllers/main_shell_controller.dart';
import 'package:prueba_buffet/app/controllers/order_controller.dart';
import 'package:prueba_buffet/app/controllers/shopping_cart_controller.dart';
import 'package:prueba_buffet/app/ui/global_widgets/custom_toast.dart';

class PayStateController extends GetxController {
  void goToHomeScreen() =>
      Get.offNamedUntil("/home", (route) => route.settings.name != "/success");

  void goToOrderScreen() {
    // 1. Primero volvemos al Home destruyendo la vista de Success
    Get.offAllNamed("/home");

    // 2. Le damos a Flutter un micro-instante para renderizar el Shell
    Future.delayed(const Duration(milliseconds: 50), () {
      // 3. Ahora sí, con el Shell vivo, le decimos que vaya a la pestaña de Pedidos
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

    // Aquí adentro, Flutter ya terminó de dibujar la pantalla,
    // así que es 100% seguro mostrar Snackbars y hacer limpiezas.
    if (isPaymentForBalance) {
      print("Pago de carga de saldo detectado (status: $paymentStatus)");
      if (paymentStatus == "approved") {
        _applyLocalBalanceLoad();
      } else {
        _failurePayment();
        GetStorage().remove("pending_load_amount");
      }
    } else {
      print("Pago de compra detectado → Limpiando carrito y refrescando datos");
      _cleanCartAndRefreshData();
    }
  }

  /// Limpia los datos de la compra, pide info fresca al servidor y redirige
  void _cleanCartAndRefreshData() async {
    // 1. Vaciamos el carrito de la UI inmediatamente
    if (Get.isRegistered<ShoppingCartController>()) {
      Get.find<ShoppingCartController>().clearCart();
    }

    // 2. Limpiamos GetStorage
    GetStorage().remove("cart_items");
    GetStorage().remove("order_datetime");
    GetStorage().remove("pending_cart_total");
    GetStorage().remove("order");

    // Mostramos un mensaje temporal mientras sincronizamos
    // Get.snackbar(
    //   "Procesando...",
    //   "Sincronizando tu pedido con el buffet",
    //   snackPosition: SnackPosition.TOP,
    //   duration: const Duration(seconds: 2),
    //   backgroundColor: Colors.white,
    //   colorText: Colors.black87,
    // );
    CustomToast.showProcessing(
      title: "Procesando...",
      message: "Sincronizando tu pedido con el buffet",
    );

    // ---> 3. LA MAGIA ANTICOLISIONES <---
    // Esperamos 2.5 segundos para darle tiempo a Mercado Pago y a tu Backend
    // de procesar el Webhook y guardar la orden en la base de datos.
    await Future.delayed(const Duration(milliseconds: 2600));

    // 4. Ahora sí, hacemos los FETCH seguros
    if (Get.isRegistered<OrderController>()) {
      await Get.find<OrderController>().fetchInitialOrders();
    }

    if (Get.isRegistered<BalanceController>()) {
      final balanceCtrl = Get.find<BalanceController>();
      await balanceCtrl.fetchBalance();
      await balanceCtrl.getMyInitialTransactions();
    }

    // Refrescar productos para actualizar stock localmente
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

  /// Aplica la carga de saldo optimista y luego pide al servidor por seguridad.
  void _applyLocalBalanceLoad() async {
    try {
      final pendingAmount = GetStorage().read("pending_load_amount");
      if (pendingAmount != null && Get.isRegistered<BalanceController>()) {
        final balanceCtrl = Get.find<BalanceController>();
        final double amount = (pendingAmount as num).toDouble();

        // Actualización optimista inmediata
        balanceCtrl.balance.value += amount;

        // Limpiamos el storage
        GetStorage().remove("pending_load_amount");
        print("SuccessController: saldo actualizado optimista +$amount");

        // Pedimos datos frescos para confirmar en background
        await balanceCtrl.fetchBalance();
        await balanceCtrl.getMyInitialTransactions();
        CustomToast.showProcessing(
          title: "Procesando...",
          message: "Sincronizando tu saldo",
        );
        await Future.delayed(const Duration(milliseconds: 2600));

        goToHomeScreen(); // Lo regresamos al Home
        if (Get.isSnackbarOpen) {
          Get.closeAllSnackbars();
        }

        CustomToast.showSuccess(
            title: "¡Carga Exitosa!",
            message: "Tu saldo ya está disponible en tu billetera.");
      }
    } catch (e) {
      print("⚠️ SuccessController._applyLocalBalanceLoad CRASH: $e");
    }
  }

  void _failurePayment() async {
    await Future.delayed(const Duration(milliseconds: 2600));

    // Refrescar productos para actualizar stock localmente
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
