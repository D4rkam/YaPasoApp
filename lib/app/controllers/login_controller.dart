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

  // bool validateCurrentStep() {
  //   bool isValid = true;
  //   switch (currentStep.value) {
  //     case 0: // Nombre y Apellido
  //       if (nameController.text.trim().isEmpty) {
  //         nameError.value = "Ingresa tu nombre";
  //         isValid = false;
  //       } else {
  //         nameError.value = null;
  //       }
  //       if (lastNameController.text.trim().isEmpty) {
  //         lastNameError.value = "Ingresa tu apellido";
  //         isValid = false;
  //       } else {
  //         lastNameError.value = null;
  //       }
  //       break;

  //     case 2: // Ubicación
  //       if (selectedProvince.value.isEmpty) {
  //         provinceError.value = "Selecciona una provincia";
  //         isValid = false;
  //       } else {
  //         provinceError.value = null;
  //       }
  //       if (selectedLocalidad.value.isEmpty) {
  //         localidadError.value = "Selecciona una localidad";
  //         isValid = false;
  //       } else {
  //         localidadError.value = null;
  //       }
  //       if (selectedEscuela.value.isEmpty) {
  //         escuelaError.value = "Selecciona una escuela";
  //         isValid = false;
  //       } else {
  //         escuelaError.value = null;
  //       }
  //       if (fileNumberController.text.trim().isEmpty) {
  //         fileNumberError.value = "Ingresa tu número de legajo";
  //         isValid = false;
  //       } else {
  //         fileNumberError.value = null;
  //       }
  //       break;

  //     case 3: // Credenciales
  //       if (emailController.text.trim().isEmpty ||
  //           !GetUtils.isEmail(emailController.text.trim())) {
  //         emailError.value = "Ingresa un email válido";
  //         isValid = false;
  //       } else {
  //         emailError.value = null;
  //       }
  //       if (usernameController.text.trim().isEmpty) {
  //         usernameError.value = "Ingresa un nombre de usuario";
  //         isValid = false;
  //       } else {
  //         usernameError.value = null;
  //       }

  //       String password = passwordController.text.trim();
  //       if (password.isEmpty) {
  //         passwordError.value = "Ingresa una contraseña";
  //         isValid = false;
  //       } else if (password.length < 8) {
  //         passwordError.value = "Debe tener al menos 8 caracteres";
  //         isValid = false;
  //       } else if (!password.contains(RegExp(r'[0-9]'))) {
  //         passwordError.value = "Debe contener al menos un número";
  //         isValid = false;
  //       } else {
  //         passwordError.value = null;
  //       }

  //       if (confirmPasswordController.text.trim().isEmpty) {
  //         confirmPasswordError.value = "Confirma tu contraseña";
  //         isValid = false;
  //       } else {
  //         confirmPasswordError.value = null;
  //       }
  //       if (passwordController.text.trim().isNotEmpty &&
  //           passwordController.text.trim() !=
  //               confirmPasswordController.text.trim()) {
  //         confirmPasswordError.value = "Las contraseñas no coinciden";
  //         isValid = false;
  //       }
  //       if (!acceptedTerms.value) {
  //         termsError.value = "Debes aceptar los términos y condiciones";
  //         isValid = false;
  //       }
  //       break;
  //   }
  //   return isValid;
  // }
}
