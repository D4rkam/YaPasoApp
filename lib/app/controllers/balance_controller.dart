import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/app/data/models/payment_response.dart';
import 'package:prueba_buffet/app/data/models/user.dart';
import 'package:prueba_buffet/app/data/provider/users_provider.dart';
import 'package:prueba_buffet/app/data/provider/wallet_provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
        print(
            "BalanceController.refreshFromStorage → balance: ${user.balance}");
        if (user.balance != null) {
          balance.value = user.balance!;
        }
        fileNum = int.tryParse(user.fileNum) ?? 0;
      }
    } catch (e) {
      print("⚠️ BalanceController.refreshFromStorage CRASH: $e");
    }
  }

  Future<void> fetchBalance() async {
    try {
      final result = await _usersProvider.getBalance();
      if (result.containsKey('balance')) {
        balance.value = double.tryParse(result['balance'].toString()) ?? 0.0;
        print("BalanceController.fetchBalance → balance: ${balance.value}");
      }
    } catch (e) {
      print("Error obteniendo saldo fresco: $e");
    }
  }

  updateBalance(double newBalance) {
    balance.value = (balance.value) + newBalance;
  }

  /// Muestra un diálogo para que el usuario ingrese el monto a cargar
  /// y opcionalmente una descripción. Luego llama al endpoint y abre
  /// el link de Mercado Pago.
  void showLoadBalanceDialog() {
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Cargar Saldo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Ingresa el monto que deseas cargar en tu billetera.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Monto (\$)',
                prefixIcon: const Icon(Icons.attach_money),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Descripción (opcional)',
                prefixIcon: const Icon(Icons.note_outlined),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          Obx(() => ElevatedButton(
                onPressed: isLoading.value
                    ? null
                    : () => _confirmLoadBalance(
                          amountController.text.trim(),
                          descriptionController.text.trim(),
                        ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFE500),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: isLoading.value
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.black))
                    : const Text('Continuar',
                        style: TextStyle(fontWeight: FontWeight.bold)),
              )),
        ],
      ),
    );
  }

  Future<void> _confirmLoadBalance(
      String amountText, String description) async {
    final amount = double.tryParse(amountText.replaceAll(',', '.'));
    if (amount == null || amount <= 0) {
      Get.snackbar('Error', 'Ingresa un monto válido',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      final response = await _walletProvider.loadBalance(
          amount: amount, description: description);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final paymentResponse = PaymentResponse.fromJson(response.body);
        final initPoint = paymentResponse.preference.initPoint;
        // final sandboxInitPoint = paymentResponse.preference.sandoxInitPoint;

        // Guardar el monto para actualizarlo localmente cuando vuelva de Mercado Pago
        GetStorage().write("pending_load_amount", amount);

        Get.back(); // Cerrar el diálogo

        if (initPoint.isNotEmpty) {
          await _launchMercadoPago(initPoint);
        } else {
          Get.snackbar('Error', 'No se recibió el link de pago',
              backgroundColor: Colors.redAccent, colorText: Colors.white);
        }
      } else {
        final msg = response.body?['detail'] ?? 'Error al iniciar la carga';
        Get.snackbar('Error', msg,
            backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'No se pudo conectar con el servidor',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _launchMercadoPago(String initPoint) async {
    final uri = Uri.parse(initPoint);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'No se pudo abrir Mercado Pago',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  Future<void> getMyInitialTransactions() async {
    isLoading.value = true;
    try {
      print("[BALANCE CONTROLLER] Obteniendo transacciones iniciales...");
      final response = await _walletProvider.getTransactions();

      if (response.statusCode == 200) {
        transactions.assignAll(
            List<Map<String, dynamic>>.from(response.body['transactions']));
        nextCursor = response.body['next_cursor'];
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          backgroundColor: Colors.redAccent, colorText: Colors.white);
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
            List<Map<String, dynamic>>.from(response.body['transactions']);
        transactions.addAll(newTransactions);
        nextCursor = response.body['next_cursor'];
      }
    } catch (e) {
      Get.snackbar('Error', 'No se pudieron obtener más transacciones',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
    isFetchingMore.value = false;
  }
}
