import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:prueba_buffet/core/models/user.dart';
import 'package:prueba_buffet/features/analytics/domain/repositories/analytics_repository.dart';

import 'package:prueba_buffet/features/auth/domain/entities/login_credentials.dart';
import 'package:prueba_buffet/features/auth/domain/usecases/login_use_case.dart';

class AuthLoginControllerV2 extends GetxController {
  final LoginUseCase _loginUseCase;

  AuthLoginControllerV2(this._loginUseCase);

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final usernameError = RxnString();
  final passwordError = RxnString();
  final authError = RxnString();
  final isLoading = false.obs;

  bool validateForm() {
    usernameError.value = null;
    passwordError.value = null;

    var valid = true;
    if (usernameController.text.trim().isEmpty) {
      usernameError.value = 'Ingresa tu nombre de usuario';
      valid = false;
    }
    if (passwordController.text.trim().isEmpty) {
      passwordError.value = 'Ingresa tu contrasena';
      valid = false;
    }
    return valid;
  }

  Future<bool> submit() async {
    authError.value = null;
    if (!validateForm()) return false;

    isLoading.value = true;
    final result = await _loginUseCase(
      LoginCredentials(
        username: usernameController.text.trim(),
        password: passwordController.text.trim(),
      ),
    );
    isLoading.value = false;

    if (result.isSuccess) {
      final user = User.safeFromStorage();
      if (user.id != null) {
        await Get.find<AnalyticsRepository>().identify(
          userId: user.id.toString(),
          userProperties: <String, Object>{
            'email': user.email,
            'name': user.name,
            'last_name': user.lastName,
            'username': user.username,
            'age': user.age,
            'file_num': user.fileNum,
            'school_id': user.schoolId ?? 0,
            'curse_year': user.curse_year ?? 0,
            'curse_division': user.curse_division ?? 'N/A',
            'turn': user.turn ?? 'N/A',
            'current_balance': user.balance ?? 0.0,
            'has_balance': (user.balance ?? 0.0) > 0,
            'total_orders_count': user.orders?.length ?? 0,
            'is_identified': true,
          },
        );
      }
      return true;
    }

    authError.value = result.failure?.message;
    return false;
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
