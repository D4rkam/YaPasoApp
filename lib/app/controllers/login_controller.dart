import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/app/controllers/shopping_cart_controller.dart';
import 'package:prueba_buffet/app/data/models/response_api.dart';
import 'package:prueba_buffet/app/data/provider/users_provider.dart';

class LoginController extends GetxController {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  UsersProvider usersProvider = UsersProvider();

  // Cuando se llama a este metodo,
  //se dirige a la ruta /register y carga esa vista
  void goToRegisterPage() {
    Get.toNamed("/register");
  }

  void login() async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    if (isValidForm(username, password)) {
      ResponseApi response = await usersProvider.login(username, password);

      if (response.success) {
        GetStorage().write("user",
            response.data); //Datos del usuario almacenados de manera local

        goToHomePage();
      } else {
        Get.snackbar("Credenciales", "Las credenciales no son validas");
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
    if (username.isEmpty) {
      Get.snackbar("Formulario no valido", "Debes ingresar el username");
      return false;
    }
    if (password.isEmpty) {
      Get.snackbar("Formulario no valido", "Debes ingresar el password");
      return false;
    }

    return true;
  }
}
