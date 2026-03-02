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

  // Lista responsiva para almacenar las escuelas que vienen del backend
  var schools = <Map<String, dynamic>>[].obs;

  // Paso actual
  final PageController pageController = PageController();

  // Controlador para el selector de edad
  late final FixedExtentScrollController scrollController;

  @override
  void onInit() async {
    super.onInit();

    // Inicializar scrollController con la edad por defecto (14)
    // El listado empieza en 12, así que 14 es el índice 2 (14-12 = 2)
    scrollController = FixedExtentScrollController(initialItem: age.value - 12);

    // Cargamos las escuelas y actualizamos la lista observable
    var loadedSchools = await usersProvider.getSchools();
    schools.assignAll(loadedSchools);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  var currentStep = 0.obs;

  void onPageChanged(int index) {
    currentStep.value = index;
    print("Página actual: ${currentStep.value}");
  }

  void nextStep() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (currentStep.value < 3) {
      currentStep.value++;
      pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      _finishRegister();
    }
  }

  bool validateCurrentStep() {
    switch (currentStep.value) {
      case 0: // Nombre y Apellido
        if (nameController.text.trim().isEmpty) {
          Get.snackbar("Atención", "Por favor ingresa tu nombre",
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM);
          return false;
        }
        if (lastNameController.text.trim().isEmpty) {
          Get.snackbar("Atención", "Por favor ingresa tu apellido",
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM);
          return false;
        }
        break;

      case 2: // Ubicación
        if (selectedProvince.value.isEmpty) {
          Get.snackbar("Atención", "Selecciona una provincia",
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM);
          return false;
        }
        if (selectedLocalidad.value.isEmpty) {
          Get.snackbar("Atención", "Selecciona una localidad",
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM);
          return false;
        }
        if (selectedEscuela.value.isEmpty) {
          Get.snackbar("Atención", "Selecciona una escuela",
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM);
          return false;
        }
        if (fileNumberController.text.trim().isEmpty) {
          Get.snackbar("Atención", "Ingresa tu número de legajo",
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM);
          return false;
        }
        break;

      case 3: // Credenciales
        if (emailController.text.trim().isEmpty ||
            !GetUtils.isEmail(emailController.text.trim())) {
          Get.snackbar("Atención", "Ingresa un email válido",
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM);
          return false;
        }
        if (usernameController.text.trim().isEmpty) {
          Get.snackbar("Atención", "Ingresa un nombre de usuario",
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM);
          return false;
        }
        if (passwordController.text.trim().isEmpty) {
          Get.snackbar("Atención", "Ingresa una contraseña",
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM);
          return false;
        }
        if (confirmPasswordController.text.trim().isEmpty) {
          Get.snackbar("Atención", "Confirma tu contraseña",
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM);
          return false;
        }
        if (passwordController.text.trim() !=
            confirmPasswordController.text.trim()) {
          Get.snackbar("Atención", "Las contraseñas no coinciden",
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM);
          return false;
        }
        break;
    }
    return true;
  }

  void previousStep() {
    FocusManager.instance.primaryFocus?.unfocus();
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

  var selectedProvince = ''.obs;
  var selectedLocalidad = ''.obs;
  var selectedEscuela = ''.obs;
  // removed legajoController in favor of fileNumberController

  void _finishRegister() async {
    if (!validateCurrentStep()) return;

    var school =
        schools.firstWhereOrNull((s) => s['name'] == selectedEscuela.value);

    if (school == null) {
      Get.snackbar("Error", "Escuela no válida");
      return;
    }

    var schoolId = school['id'].toString();

    // Aquí mapeas todos los datos al modelo User
    User user = User(
      username: usernameController.text.trim(),
      name: nameController.text.trim(),
      lastName: lastNameController.text.trim(),
      password: passwordController.text.trim(),
      fileNum: fileNumberController.text.trim(),
      email: emailController.text.trim(),
      schoolId: int.tryParse(schoolId),
    );

    print("Usuario a registrar: ${user.toJson()}");

    ProgressDialog progressDialog = ProgressDialog(context: Get.context!);
    progressDialog.show(max: 100, msg: "Registrando Usuario");

    Response response = await usersProvider.create(user);
    progressDialog.close();

    if (response.statusCode == 201) {
      Get.offAllNamed('/login');
    } else {
      Get.snackbar("Error", response.body['detail'] ?? "Error al registrar");
    }
  }

  // Listas de ejemplo (Podrías cargarlas desde tu UsersProvider en el futuro)
  final List<String> provinces = ["Buenos Aires"];

  // Lógica de filtrado simple
  List<String> get localidades =>
      selectedProvince.value == "Buenos Aires" ? ["Berisso"] : [];

  List<String> get escuelas => selectedLocalidad.value == "Berisso"
      ? schools.map<String>((e) => e['name'].toString()).toList()
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
}
