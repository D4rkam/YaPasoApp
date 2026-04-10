import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:prueba_buffet/core/data/services/push_notification_service.dart';
import 'package:prueba_buffet/core/presentation/widgets/custom_input.dart';
import 'package:prueba_buffet/core/presentation/widgets/custom_toast.dart';
import 'package:prueba_buffet/core/presentation/widgets/mixins/responsive_mixin.dart';
import 'package:prueba_buffet/core/routes/routes.dart';
import 'package:prueba_buffet/features/cart/presentation/controllers/shopping_cart_controller_v2.dart';
import 'package:prueba_buffet/features/auth/presentation/controllers/auth_login_controller_v2.dart';

class LoginV2Page extends GetView<AuthLoginControllerV2> with ResponsiveMixin {
  const LoginV2Page({super.key});

  String _resolveRegisterRoute() => Routes.REGISTER;

  Future<void> _onSubmit(AuthLoginControllerV2 controller) async {
    final success = await controller.submit();
    if (!success) {
      final error = controller.authError.value;
      if (error != null && error.isNotEmpty) {
        CustomToast.showError(title: 'Error de autenticacion', message: error);
      }
      return;
    }

    if (!Get.isRegistered<ShoppingCartControllerV2>()) {
      Get.put<ShoppingCartControllerV2>(ShoppingCartControllerV2(),
          permanent: true);
    }

    try {
      await PushNotificationService.initializeApp();
    } catch (_) {
      // La inicializacion de push no debe bloquear el acceso al home.
    }

    Get.offNamedUntil(Routes.HOME, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: setWidth(30)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: setHeight(40)),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Bienvenido a ',
                                  style: TextStyle(
                                    fontSize: setSp(28),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Ya Paso',
                                  style: TextStyle(
                                    fontFamily: 'Lobster',
                                    fontSize: setSp(28),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: setHeight(8)),
                          Text(
                            'Ingresa tus credenciales para continuar',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: setSp(16),
                              color: const Color(0xFFB3B3B3),
                            ),
                          ),
                          SizedBox(height: setHeight(50)),
                          Obx(
                            () => CustomInput(
                              controller: controller.usernameController,
                              label: 'Nombre de usuario',
                              errorText: controller.usernameError.value,
                              onChanged: (_) =>
                                  controller.usernameError.value = null,
                            ),
                          ),
                          SizedBox(height: setHeight(20)),
                          Obx(
                            () => CustomInput(
                              controller: controller.passwordController,
                              label: 'Contrasena',
                              isPassword: true,
                              errorText: controller.passwordError.value,
                              onChanged: (_) =>
                                  controller.passwordError.value = null,
                            ),
                          ),
                          SizedBox(height: setHeight(40)),
                          Obx(
                            () => SizedBox(
                              width: double.infinity,
                              height: setHeight(55),
                              child: ElevatedButton(
                                onPressed: controller.isLoading.value
                                    ? null
                                    : () => _onSubmit(controller),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFFE500),
                                  foregroundColor: Colors.black,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(setWidth(15)),
                                  ),
                                ),
                                child: controller.isLoading.value
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: Colors.black,
                                        ),
                                      )
                                    : Text(
                                        'Iniciar Sesion',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          SizedBox(height: setHeight(24)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'No tienes cuenta? ',
                                style: TextStyle(
                                  fontSize: setSp(14),
                                  color: const Color(0xFFB3B3B3),
                                ),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    Get.toNamed(_resolveRegisterRoute()),
                                child: Text(
                                  'Registrate',
                                  style: TextStyle(
                                    fontSize: setSp(14),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: setHeight(30)),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
