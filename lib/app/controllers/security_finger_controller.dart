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
    // 1. Hacemos la llamada. El BaseProvider se encarga de refrescar si hace falta.
    ResponseApi response = await usersProvider.checkToken();

    // 2. Si fue un éxito, avanzamos.
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

      // Refrescar saldo
      if (Get.isRegistered<BalanceController>()) {
        Get.find<BalanceController>().fetchBalance();
      }
      goToHomeScreen();
    } else {
      // 3. Si falló, es porque el interceptor dijo "basta" (ej: Refresh Token expirado).
      // El BaseProvider ya limpió el CookieJar y el Storage interno.
      // Solo aseguramos la limpieza local y mandamos al Login.
      print("checkToken falló definitivamente → Redirigiendo a Login");
      _storage.remove("user");
      Get.offNamedUntil('/login', (route) => false);
    }
  }
}
