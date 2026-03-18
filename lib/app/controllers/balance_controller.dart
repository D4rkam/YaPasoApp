import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/app/data/models/payment_response.dart';
import 'package:prueba_buffet/app/data/models/user.dart';
import 'package:prueba_buffet/app/data/provider/users_provider.dart';
import 'package:prueba_buffet/app/data/provider/wallet_provider.dart';
import 'package:prueba_buffet/app/ui/global_widgets/custom_toast.dart';
import 'package:prueba_buffet/app/ui/pages/load_balance/load_balance.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:prueba_buffet/utils/logger.dart';

class BalanceController extends GetxController {
  final WalletProvider _walletProvider = WalletProvider();
  final UsersProvider _usersProvider = UsersProvider();
  final User userSession = User.safeFromStorage();
  late Rx<double> balance;
  late int fileNum;
  var transactions = <Map<String, dynamic>>[].obs;

  var isLoading = false.obs;
  var isFetchingMore = false.obs;

  String? nextCursor;

  @override
  void onInit() async {
    balance = (userSession.balance ?? 0.0).obs;
    fileNum = int.tryParse(userSession.fileNum) ?? 0;
    await getMyInitialTransactions();
    super.onInit();
  }

  /// Actualiza el saldo leyendo los datos ya guardados en storage.
  /// Llamar después de que checkToken o login escriban datos frescos.
  void refreshFromStorage() {
    try {
      final userData = GetStorage().read("user");
      if (userData != null) {
        final user = User.fromJson(userData);
        logger.i(
            "BalanceController.refreshFromStorage → balance: ${user.balance}");
        if (user.balance != null) {
          balance.value = user.balance!;
        }
        fileNum = int.tryParse(user.fileNum) ?? 0;
      }
    } catch (e) {
      logger.e("⚠️ BalanceController.refreshFromStorage CRASH: $e");
    }
  }

  Future<void> fetchBalance() async {
    try {
      final result = await _usersProvider.getBalance();
      if (result.containsKey('balance')) {
        balance.value = double.tryParse(result['balance'].toString()) ?? 0.0;
        logger.i("BalanceController.fetchBalance → balance: ${balance.value}");
      }
    } catch (e) {
      logger.e("Error obteniendo saldo fresco: $e");
    }
  }

  updateBalance(double newBalance) {
    balance.value = (balance.value) + newBalance;
  }

  /// Muestra un diálogo para que el usuario ingrese el monto a cargar
  /// y opcionalmente una descripción. Luego llama al endpoint y abre
  /// el link de Mercado Pago.
  void goToLoadBalanceScreen() {
    // Abrimos la nueva vista en lugar del modal viejo
    Get.to(() => LoadBalanceScreen());
  }

  Future<void> confirmLoadBalance(String amountText) async {
    final amount = double.tryParse(amountText.replaceAll(',', '.'));
    if (amount == null || amount <= 0) {
      CustomToast.showError(
          title: "Error", message: "Ingresa un monto válido para cargar");
      return;
    }
    if (amount < 500) {
      CustomToast.showError(
          title: "Error", message: "La carga mínima es de \$500");
      return;
    }

    isLoading.value = true;
    try {
      final response = await _walletProvider.loadBalance(
          amount: amount,
          description: "Carga de saldo desde la app - ${userSession.name}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final paymentResponse = PaymentResponse.fromJson(response.data);
        final initPoint = paymentResponse.preference.initPoint;
        // final sandboxInitPoint = paymentResponse.preference.sandoxInitPoint;

        // Guardar el monto para actualizarlo localmente cuando vuelva de Mercado Pago
        GetStorage().write("pending_load_amount", amount);

        Get.back(); // Cerrar el diálogo

        if (initPoint.isNotEmpty) {
          await _launchMercadoPago(initPoint);
        } else {
          CustomToast.showError(
              title: 'Error',
              message: "No se pudo obtener el link de Mercado Pago");
        }
      } else {
        final msg = response.data?['detail'] ?? 'Error al iniciar la carga';
        CustomToast.showError(
            title: 'Error', message: "Error al iniciar Mercado Pago");
      }
    } catch (e) {
      CustomToast.showError(
          title: 'Error', message: "No se pudo conectar con el servidor");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _launchMercadoPago(String initPoint) async {
    final uri = Uri.parse(initPoint);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      CustomToast.showError(
          title: 'Error', message: "No se pudo abrir el link de Mercado Pago");
    }
  }

  Future<void> getMyInitialTransactions() async {
    isLoading.value = true;
    try {
      logger.i("[BALANCE CONTROLLER] Obteniendo transacciones iniciales...");
      final response = await _walletProvider.getTransactions();

      if (response.statusCode == 200) {
        transactions.assignAll(
            List<Map<String, dynamic>>.from(response.data['transactions']));
        nextCursor = response.data['next_cursor'];
      }
    } catch (e) {
      CustomToast.showError(
          title: 'Error', message: "No se pudieron cargar las transacciones");
    }
    isLoading.value = false;
  }

  Future<void> getMoreTransactions() async {
    if (nextCursor == null || isFetchingMore.value) return;

    isFetchingMore.value = true;
    try {
      final response =
          await _walletProvider.getTransactions(cursor: nextCursor!);
      if (response.statusCode == 200) {
        final newTransactions =
            List<Map<String, dynamic>>.from(response.data['transactions']);
        transactions.addAll(newTransactions);
        nextCursor = response.data['next_cursor'];
      }
    } catch (e) {
      CustomToast.showError(
          title: 'Error', message: "No se pudieron cargar más transacciones");
    }
    isFetchingMore.value = false;
  }
}
