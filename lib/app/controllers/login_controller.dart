import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/app/controllers/shopping_cart_controller.dart';
import 'package:prueba_buffet/app/data/models/response_api.dart';
import 'package:prueba_buffet/app/data/models/user.dart';
import 'package:prueba_buffet/app/data/provider/users_provider.dart';
import 'package:prueba_buffet/app/ui/global_widgets/custom_toast.dart';

class LoginController extends GetxController {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var usernameError = RxnString();
  var passwordError = RxnString();

  UsersProvider usersProvider = UsersProvider();

  void goToRegisterPage() {
    Get.toNamed("/register");
  }

  void login() async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    if (isValidForm(username, password)) {
      ResponseApi response = await usersProvider.login(username, password);

      if (response.success) {
        // Sanitizar: parsear y re-serializar para garantizar tipos correctos
        try {
          final user = User.fromJson(response.data);
          GetStorage().write("user", user.toJson());
        } catch (e) {
          GetStorage().write("user", response.data);
        }

        goToHomePage();
      } else {
        CustomToast.showError(
            title: 'Error de autenticación',
            message: "No se pudo iniciar sesión con esas credenciales");
      }
    }
  }

  void goToHomePage() {
    if (!Get.isRegistered<ShoppingCartController>()) {
      Get.put<ShoppingCartController>(ShoppingCartController(),
          permanent: true);
    }
    Get.offNamedUntil("/home", (route) => false);
  }

  bool isValidForm(String username, String password) {
    bool isValid = true;
    if (username.isEmpty) {
      // CustomToast.showError(
      //     title: "Formulario no válido", message: "Debes ingresar el username");
      usernameError.value = "Ingresa tu nombre de usuario";
      isValid = false;
    }
    if (password.isEmpty) {
      passwordError.value = "Ingresa tu contraseña";
      isValid = false;
    }

    return isValid;
  }
}
