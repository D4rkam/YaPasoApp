import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/models/user.dart';

class paymentController extends GetxController {
  User userSession = User.fromJson(GetStorage().read("user") ?? {});

  // Método para redirigir a la pantalla de login
  void goToLogin() {
    Get.toNamed("/login");
  }

  // Método para cerrar sesión
  void signOut() {
    GetStorage().remove("user");
    Get.offNamedUntil("/", (route) => false);
  }

  // Método para redirigir a la pantalla del carrito (como ejemplo adicional)
  void goToCart() {
    Get.toNamed("/cart");
  }
}
