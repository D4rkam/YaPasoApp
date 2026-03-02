import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/data/models/user.dart';
import 'package:prueba_buffet/app/data/provider/users_provider.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class RegisterController extends GetxController {
  void goToLoginPage() {
    Get.toNamed("/login");
  }

  // final UsersProvider usersProvider = Get.find();
  final UsersProvider usersProvider = Get.put(UsersProvider());

  // Paso actual
  final PageController pageController = PageController();
  var currentStep = 0.obs;

  void onPageChanged(int index) {
    currentStep.value = index;
    print("Página actual: ${currentStep.value}");
  }

  void nextStep() {
    if (currentStep.value < 4) {
      currentStep.value++;
      pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      _finishRegister();
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
      pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      Get.back();
    }
  }

  // Datos del formulario
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  var age = 14.obs;
  var gender = ''.obs;
  var province = 'Buenos Aires'.obs;
  var emailController = TextEditingController();
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var fileNumberController = TextEditingController();

  void _finishRegister() async {
    // Aquí mapeas todos los datos al modelo User
    User user = User(
      username: usernameController.text,
      name: nameController.text,
      lastName: lastNameController.text,
      password: passwordController.text,
      fileNum: fileNumberController.text,
    );

    Response response = await usersProvider.create(user);
    if (response.statusCode == 201) {
      Get.offAllNamed('/login');
    }
  }

  var selectedProvince = ''.obs;
  var selectedLocalidad = ''.obs;
  var selectedEscuela = ''.obs;
  final legajoController = TextEditingController();

  // Listas de ejemplo (Podrías cargarlas desde tu UsersProvider en el futuro)
  final List<String> provinces = ["Buenos Aires", "Santa Fe", "Córdoba"];

  // Lógica de filtrado simple
  List<String> get localidades => selectedProvince.value == "Buenos Aires"
      ? ["La Plata", "Berisso", "Ensenada"]
      : [];

  List<String> get escuelas => selectedLocalidad.value == "La Plata"
      ? ["UTN FRLP", "Normal 1", "Albert Thomas"]
      : [];

  // Métodos para cambiar selecciones
  void updateProvince(String val) {
    selectedProvince.value = val;
    selectedLocalidad.value = ''; // Reset hijos
    selectedEscuela.value = '';
  }

  void updateLocalidad(String val) {
    selectedLocalidad.value = val;
    selectedEscuela.value = ''; // Reset hijos
  }

  void register(BuildContext context) async {
    String name = nameController.text.trim();
    String lastName = lastNameController.text.trim();
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    String fileNumber = fileNumberController.text.trim();

    if (isValidForm(
      name,
      lastName,
      username,
      password,
      confirmPassword,
      fileNumber,
    )) {
      ProgressDialog progressDialog = ProgressDialog(context: context);
      progressDialog.show(max: 100, msg: "Registrando Usuario");

      User user = User(
        name: name,
        lastName: lastName,
        username: username,
        password: password,
        fileNum: fileNumber,
      );

      Response response = await usersProvider.create(user);
      progressDialog.close();
      if (response.statusCode == 201) {
        goToLoginPage();
      } else {
        Get.snackbar("Registro", response.bodyString ?? "");
      }
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
