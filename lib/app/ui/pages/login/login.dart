import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/login_controller.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';
import 'package:prueba_buffet/app/ui/global_widgets/toggle_button.dart';

class LoginScreen extends GetView<LoginController> with ResponsiveMixin {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final colors = Theme.of(context).colorScheme;
    return GetBuilder<LoginController>(
      builder: (controller) => Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: setWidth(30)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: setHeight(20)),
                Padding(
                  padding: EdgeInsets.only(top: setHeight(20)),
                  child: Container(
                    height: setHeight(142),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/logo-sin.png"),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: setHeight(40)),
                SizedBox(
                  height: setHeight(40),
                  child: CustomToggleButton(
                    labels: const ['Registrarse', 'Iniciar Sesión'],
                    initialSelectedIndex: 1,
                    onToggle: (index) {
                      return controller.goToRegisterPage();
                    },
                  ),
                ),
                SizedBox(height: setHeight(20)),
                inputField(
                    label: "Username",
                    icon: Icons.person,
                    controllerTextField: controller.usernameController),
                SizedBox(height: setHeight(20)),
                inputField(
                    label: "Contraseña",
                    icon: Icons.lock,
                    isPassword: true,
                    controllerTextField: controller.passwordController),
                SizedBox(height: setHeight(20)),
                SizedBox(
                  width: double.infinity,
                  height: setHeight(60),
                  child: ElevatedButton(
                    onPressed: () => controller.login(),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                          const Color(0xFFFFE500)),
                      foregroundColor:
                          WidgetStateProperty.all<Color>(Colors.black),
                      textStyle: WidgetStateProperty.all<TextStyle>(
                        TextStyle(
                          fontSize: setSp(20),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(setHeight(10)),
                        ),
                      ),
                    ),
                    child: const Text('Iniciar Sesión'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget inputField({
    required String label,
    required IconData icon,
    TextInputType typeField = TextInputType.text,
    bool isPassword = false,
    required TextEditingController controllerTextField,
  }) {
    return SizedBox(
      width: double.infinity,
      height: setHeight(58),
      child: TextField(
        keyboardType: typeField,
        controller: controllerTextField,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: setSp(24)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(setHeight(10)),
            borderSide: BorderSide(
                color: const Color(0xFFC5C5C5), width: setWidth(3.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(setHeight(10)),
            borderSide: BorderSide(
                color: const Color(0xFFFFE500), width: setWidth(3.0)),
          ),
        ),
      ),
    );
  }
}
