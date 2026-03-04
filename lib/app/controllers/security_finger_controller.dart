import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/app/controllers/balance_controller.dart';
import 'package:prueba_buffet/app/data/models/response_api.dart';
import 'package:prueba_buffet/app/data/models/user.dart';
import 'package:prueba_buffet/app/data/provider/users_provider.dart';

class SecurityFingerController extends GetxController {
  UsersProvider usersProvider = UsersProvider();
  final GetStorage _storage = GetStorage();

  void goToHomeScreen() => Get.offAllNamed('/home');

  /// Flujo normal: el usuario desbloqueó biometría → validar sesión
  Future<void> checkToken() async {
    ResponseApi response = await usersProvider.checkToken();

    // Reintentar una vez si falló (común al volver de background)
    if (!response.success) {
      print("checkToken falló, reintentando...");
      await Future.delayed(const Duration(milliseconds: 800));
      response = await usersProvider.checkToken();
    }

    if (response.success) {
      if (response.data != null) {
        try {
          final user = User.fromJson(response.data);
          _storage.write("user", user.toJson());
        } catch (e) {
          print("⚠️ SecurityFinger: Error sanitizando user data: $e");
          _storage.write("user", response.data);
        }
      }
      // Refrescar saldo desde el endpoint liviano (sin traer todo el usuario)
      if (Get.isRegistered<BalanceController>()) {
        Get.find<BalanceController>().fetchBalance();
      }
      goToHomeScreen();
    } else {
      print("checkToken falló definitivamente → Login");
      _storage.remove("user");
      Get.offNamedUntil('/login', (route) => false);
    }
  }
}
