import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/models/user.dart';
import 'package:prueba_buffet/providers/users_provider.dart';

class RegisterController extends GetxController {
  void goToLoginPage() {
    Get.toNamed("/login");
  }

  UsersProvider usersProvider = UsersProvider();

  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController fileNumberController = TextEditingController();

  void register() async {
    String name = nameController.text.trim();
    String lastName = lastNameController.text.trim();
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    String fileNumber = fileNumberController.text.trim();

    if (isValidForm(
        name, lastName, username, password, confirmPassword, fileNumber)) {
      User user = User(
        name: name,
        lastName: lastName,
        username: username,
        password: password,
        fileNum: fileNumber,
      );

      Response response = await usersProvider.create(user);

      print("RESPONSE: ${response.body}");

      Get.snackbar("Formulario valido", "Ok paa enviar");
    }
  }

  bool isValidForm(
    String name,
    String lastName,
    String username,
    String password,
    String confirmPassword,
    String fileNumber,
  ) {
    if (name.isEmpty) {
      Get.snackbar("Formulario no valido", "Ingresa el nombre");
      return false;
    }
    if (lastName.isEmpty) {
      Get.snackbar("Formulario no valido", "Ingresa el apellido");
      return false;
    }
    if (username.isEmpty) {
      Get.snackbar("Formulario no valido", "Ingresa el nombre de usuario");
      return false;
    }
    if (password.isEmpty) {
      Get.snackbar("Formulario no valido", "Ingresa la contraseña");
      return false;
    }
    if (confirmPassword.isEmpty) {
      Get.snackbar(
          "Formulario no valido", "Ingresa la confirmacion de contraseña");
      return false;
    }
    if (fileNumber.isEmpty) {
      Get.snackbar("Formulario no valido", "Ingresa el numero de legajo");
      return false;
    }

    if (password != confirmPassword) {
      Get.snackbar("Formulario no valido",
          "La contraseña y la confirmacion no es igual");
      return false;
    }

    return true;
  }
}
