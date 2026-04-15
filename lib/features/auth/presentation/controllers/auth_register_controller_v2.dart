import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:prueba_buffet/core/presentation/widgets/custom_toast.dart';
import 'package:prueba_buffet/core/routes/routes.dart';
import 'package:prueba_buffet/features/analytics/domain/constants/analytics_constants.dart';
import 'package:prueba_buffet/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:prueba_buffet/features/auth/domain/entities/register_command.dart';
import 'package:prueba_buffet/features/auth/domain/usecases/check_session_use_case.dart';
import 'package:prueba_buffet/features/auth/domain/usecases/register_use_case.dart';

class AuthRegisterControllerV2 extends GetxController {
  final RegisterUseCase _registerUseCase;
  final GetSchoolsUseCase _getSchoolsUseCase;

  AuthRegisterControllerV2(this._registerUseCase, this._getSchoolsUseCase);

  final usernameController = TextEditingController();
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final emailController = TextEditingController();
  final fileNumberController = TextEditingController();

  TextEditingController get fileNumController => fileNumberController;

  final selectedSchoolId = RxnInt();
  final age = 14.obs;
  final gender = ''.obs;
  final province = 'Buenos Aires'.obs;
  final acceptedTerms = false.obs;

  final selectedProvince = ''.obs;
  final selectedLocalidad = ''.obs;
  final selectedEscuela = ''.obs;

  final currentStep = 0.obs;
  final pageController = PageController();
  late final FixedExtentScrollController scrollController;

  final schools = <Map<String, dynamic>>[].obs;

  final nameError = RxnString();
  final lastNameError = RxnString();
  final provinceError = RxnString();
  final localidadError = RxnString();
  final escuelaError = RxnString();
  final fileNumberError = RxnString();
  final emailError = RxnString();
  final usernameError = RxnString();
  final passwordError = RxnString();
  final confirmPasswordError = RxnString();
  RxnString get fileNumError => fileNumberError;
  RxnString get schoolError => escuelaError;
  final termsError = RxnString();

  final formError = RxnString();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController = FixedExtentScrollController(initialItem: age.value - 12);
    _loadSchools();
  }

  Future<void> _loadSchools() async {
    try {
      schools.assignAll(await _getSchoolsUseCase());
    } catch (_) {
      formError.value = 'No se pudieron cargar las escuelas';
    }
  }

  void goToLoginPage() {
    Get.toNamed(_resolveLoginRoute());
  }

  String _resolveLoginRoute() => Routes.LOGIN;

  void onPageChanged(int index) {
    currentStep.value = index;
  }

  void nextStep() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!validateCurrentStep()) return;

    if (currentStep.value < 3) {
      currentStep.value++;
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishRegister();
    }
  }

  void previousStep() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (currentStep.value > 0) {
      currentStep.value--;
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.back();
    }
  }

  bool validateCurrentStep() {
    var isValid = true;
    switch (currentStep.value) {
      case 0:
        if (nameController.text.trim().isEmpty) {
          nameError.value = 'Ingresa tu nombre';
          isValid = false;
        } else {
          nameError.value = null;
        }
        if (lastNameController.text.trim().isEmpty) {
          lastNameError.value = 'Ingresa tu apellido';
          isValid = false;
        } else {
          lastNameError.value = null;
        }
        break;

      case 2:
        if (selectedProvince.value.isEmpty) {
          provinceError.value = 'Selecciona una provincia';
          isValid = false;
        } else {
          provinceError.value = null;
        }
        if (selectedLocalidad.value.isEmpty) {
          localidadError.value = 'Selecciona una localidad';
          isValid = false;
        } else {
          localidadError.value = null;
        }
        if (selectedEscuela.value.isEmpty || selectedSchoolId.value == null) {
          escuelaError.value = 'Selecciona una escuela';
          isValid = false;
        } else {
          escuelaError.value = null;
        }
        if (fileNumberController.text.trim().isEmpty) {
          fileNumberError.value = 'Ingresa tu número de legajo';
          isValid = false;
        } else {
          fileNumberError.value = null;
        }
        break;

      case 3:
        if (emailController.text.trim().isEmpty ||
            !GetUtils.isEmail(emailController.text.trim())) {
          emailError.value = 'Ingresa un email válido';
          isValid = false;
        } else {
          emailError.value = null;
        }
        if (usernameController.text.trim().isEmpty) {
          usernameError.value = 'Ingresa un nombre de usuario';
          isValid = false;
        } else {
          usernameError.value = null;
        }

        final password = passwordController.text.trim();
        if (password.isEmpty) {
          passwordError.value = 'Ingresa una contraseña';
          isValid = false;
        } else if (password.length < 8) {
          passwordError.value = 'Debe tener al menos 8 caracteres';
          isValid = false;
        } else if (!password.contains(RegExp(r'[0-9]'))) {
          passwordError.value = 'Debe contener al menos un número';
          isValid = false;
        } else {
          passwordError.value = null;
        }

        if (confirmPasswordController.text.trim().isEmpty) {
          confirmPasswordError.value = 'Confirma tu contraseña';
          isValid = false;
        } else {
          confirmPasswordError.value = null;
        }

        if (password.isNotEmpty &&
            password != confirmPasswordController.text.trim()) {
          confirmPasswordError.value = 'Las contraseñas no coinciden';
          isValid = false;
        }

        if (!acceptedTerms.value) {
          termsError.value = 'Debes aceptar los términos y condiciones';
          isValid = false;
        }
        break;
    }

    return isValid;
  }

  void selectSchool(int? schoolId) {
    selectedSchoolId.value = schoolId;
    escuelaError.value = null;
  }

  void selectEscuela(String name) {
    selectedEscuela.value = name;
    escuelaError.value = null;
    final school = schools.firstWhereOrNull((s) => s['name'] == name);
    if (school == null) {
      selectedSchoolId.value = null;
      return;
    }
    final rawId = school['id'];
    if (rawId is int) {
      selectedSchoolId.value = rawId;
    } else {
      selectedSchoolId.value = int.tryParse(rawId.toString());
    }
  }

  final List<String> provinces = ['Buenos Aires'];

  List<String> get localidades =>
      selectedProvince.value == 'Buenos Aires' ? ['Berisso'] : [];

  List<String> get escuelas => selectedLocalidad.value == 'Berisso'
      ? schools.map<String>((e) => (e['name'] ?? '').toString()).toList()
      : [];

  void updateProvince(String value) {
    selectedProvince.value = value;
    provinceError.value = null;
    selectedLocalidad.value = '';
    selectedEscuela.value = '';
    selectedSchoolId.value = null;
  }

  void updateLocalidad(String value) {
    selectedLocalidad.value = value;
    localidadError.value = null;
    selectedEscuela.value = '';
    selectedSchoolId.value = null;
  }

  void clearErrorFields() {
    nameError.value = null;
    lastNameError.value = null;
    provinceError.value = null;
    localidadError.value = null;
    escuelaError.value = null;
    fileNumberError.value = null;
    emailError.value = null;
    usernameError.value = null;
    passwordError.value = null;
    confirmPasswordError.value = null;
    termsError.value = null;
  }

  bool validateForm() {
    formError.value = null;
    clearErrorFields();

    var valid = true;

    if (nameController.text.trim().isEmpty) {
      nameError.value = 'Ingresa tu nombre';
      valid = false;
    }

    if (lastNameController.text.trim().isEmpty) {
      lastNameError.value = 'Ingresa tu apellido';
      valid = false;
    }

    if (emailController.text.trim().isEmpty ||
        !GetUtils.isEmail(emailController.text.trim())) {
      emailError.value = 'Ingresa un email valido';
      valid = false;
    }

    if (usernameController.text.trim().isEmpty) {
      usernameError.value = 'Ingresa un nombre de usuario';
      valid = false;
    }

    if (fileNumberController.text.trim().isEmpty) {
      fileNumberError.value = 'Ingresa tu numero de legajo';
      valid = false;
    }

    final password = passwordController.text.trim();
    if (password.isEmpty) {
      passwordError.value = 'Ingresa una contrasena';
      valid = false;
    } else if (password.length < 8) {
      passwordError.value = 'Debe tener al menos 8 caracteres';
      valid = false;
    } else if (!password.contains(RegExp(r'[0-9]'))) {
      passwordError.value = 'Debe contener al menos un numero';
      valid = false;
    }

    if (confirmPasswordController.text.trim().isEmpty) {
      confirmPasswordError.value = 'Confirma tu contrasena';
      valid = false;
    }

    if (password.isNotEmpty &&
        password != confirmPasswordController.text.trim()) {
      confirmPasswordError.value = 'Las contrasenas no coinciden';
      valid = false;
    }

    if (selectedSchoolId.value == null) {
      escuelaError.value = 'Selecciona una escuela';
      valid = false;
    }

    if (!acceptedTerms.value) {
      termsError.value = 'Debes aceptar terminos y condiciones';
      valid = false;
    }

    return valid;
  }

  Future<bool> submit() async {
    if (!validateForm()) return false;
    final stopwatch = Stopwatch()..start();

    isLoading.value = true;
    final result = await _registerUseCase(
      RegisterCommand(
        username: usernameController.text.trim(),
        name: nameController.text.trim(),
        lastName: lastNameController.text.trim(),
        password: passwordController.text.trim(),
        email: emailController.text.trim(),
        fileNum: fileNumberController.text.trim(),
        age: age.value,
        schoolId: selectedSchoolId.value,
      ),
    );
    isLoading.value = false;

    if (result.isSuccess) {
      stopwatch.stop();
      _trackViewRegister(stopwatch);
      return true;
    }

    formError.value = result.failure?.message;
    return false;
  }

  Future<void> _finishRegister() async {
    if (!validateCurrentStep()) return;

    final success = await submit();
    if (success) {
      CustomToast.showSuccess(
        title: 'Registro exitoso',
        message: 'Tu cuenta ha sido creada correctamente.',
      );
      Get.offAllNamed(_resolveLoginRoute());
      return;
    }

    CustomToast.showError(
      title: 'Error',
      message: formError.value ?? 'Error al registrar',
    );
  }

  void _trackViewRegister(Stopwatch stopwatch) {
    Get.find<AnalyticsRepository>().capture(
      eventName: AnalyticsEvents.viewRegister,
      properties: <String, Object>{
        AnalyticsProperties.loadingTimeMs: stopwatch.elapsedMilliseconds,
      },
    );
  }

  @override
  void onClose() {
    pageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
