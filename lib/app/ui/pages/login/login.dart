import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/login_controller.dart';
import 'package:prueba_buffet/app/ui/global_widgets/custom_input.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';

class LoginScreen extends GetView<LoginController> with ResponsiveMixin {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: GetBuilder<LoginController>(
        builder: (controller) => Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: setWidth(30)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: setHeight(40)),
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                text: "¡Bienvenido a ",
                                style: TextStyle(
                                  fontSize: setSp(28),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: "Ya Paso",
                                style: TextStyle(
                                  fontFamily: "Lobster",
                                  fontSize: setSp(28),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: "!",
                                style: TextStyle(
                                  fontSize: setSp(28),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ])),
                            SizedBox(height: setHeight(8)),
                            Text(
                              "Ingresa tus credenciales\npara continuar",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: setSp(16),
                                color: const Color(0xFFB3B3B3),
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: setHeight(50)),
                            Obx(() => CustomInput(
                                controller: controller.usernameController,
                                label: "Nombre de usuario",
                                errorText: controller.usernameError.value,
                                onChanged: (_) =>
                                    controller.usernameError.value = null)),
                            SizedBox(height: setHeight(20)),
                            Obx(() => CustomInput(
                                  controller: controller.passwordController,
                                  label: "Contraseña",
                                  isPassword: true,
                                  errorText: controller.passwordError.value,
                                  onChanged: (_) =>
                                      controller.passwordError.value = null,
                                )),
                            SizedBox(height: setHeight(40)),
                            ElevatedButton(
                              onPressed: () => controller.login(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFE500),
                                foregroundColor: Colors.black,
                                elevation: 0,
                                minimumSize:
                                    Size(double.infinity, setHeight(55)),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(setWidth(15)),
                                ),
                                textStyle: TextStyle(
                                  fontSize: setSp(18),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              child: const Text('Iniciar Sesión'),
                            ),
                            SizedBox(height: setHeight(30)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "¿No tienes cuenta? ",
                                  style: TextStyle(
                                    fontSize: setSp(14),
                                    color: const Color(0xFFB3B3B3),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => controller.goToRegisterPage(),
                                  child: Text(
                                    "Regístrate",
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
      ),
    );
  }
}
