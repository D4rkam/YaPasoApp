import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/app/controllers/balance_controller.dart';
import 'package:prueba_buffet/app/data/models/response_api.dart';
import 'package:prueba_buffet/app/data/models/user.dart';
import 'package:prueba_buffet/app/data/provider/users_provider.dart';
import 'package:prueba_buffet/utils/logger.dart';

class SecurityFingerController extends GetxController {
  UsersProvider usersProvider = UsersProvider();
  final GetStorage _storage = GetStorage();

  // 1. Agregamos la variable reactiva
  var isLoading = false.obs;

  void goToHomeScreen() =>
      Future.delayed(const Duration(milliseconds: 100), () {
        Get.offAllNamed('/home');
      });

  Future<void> checkToken() async {
    isLoading.value = true;

    try {
      ResponseApi response = await usersProvider.checkToken();

      if (response.success) {
        if (response.data != null) {
          try {
            final user = User.fromJson(response.data);
            _storage.write("user", user.toJson());
          } catch (e) {
            logger.e("SecurityFinger: Error sanitizando user data: $e");
            _storage.write("user", response.data);
          }
        }

        if (Get.isRegistered<BalanceController>()) {
          Get.find<BalanceController>().fetchBalance();
        }

        // NO APAGAMOS EL SPINNER ACÁ.
        // Dejamos que siga girando mientras el Future.delayed hace su cuenta regresiva.
        goToHomeScreen();
      } else {
        // SI FALLA, ACÁ SÍ LO APAGAMOS
        isLoading.value = false;

        logger.i("checkToken falló definitivamente → Redirigiendo a Login");
        _storage.remove("user");
        Get.offNamedUntil('/login', (route) => false);
      }
    } catch (e) {
      // SI HAY ERROR (Ej: sin internet), TAMBIÉN LO APAGAMOS
      isLoading.value = false;
      logger.e("Error en checkToken: $e");
    }
  }
}
