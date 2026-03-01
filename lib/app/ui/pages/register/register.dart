import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/register_controller.dart';
import 'package:prueba_buffet/app/ui/global_widgets/toggle_button.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';

class RegisterScreen extends GetView<RegisterController> with ResponsiveMixin {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final colors = Theme.of(context).colorScheme;
    return GetBuilder<RegisterController>(
      builder: (controller) => Scaffold(
        backgroundColor: Colors.white,
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
                    height: MediaQuery.of(context).size.height * 0.175,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/logo-sin.png"),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: setHeight(20)),
                SizedBox(
                  height: setHeight(40),
                  child: CustomToggleButton(
                    labels: const ['Registrarse', 'Iniciar Sesión'],
                    initialSelectedIndex: 0,
                    onToggle: (index) {
                      return controller.goToLoginPage();
                    },
                  ),
                ),
                SizedBox(height: setHeight(20)),
                inputField(
                    label: "Nombre",
                    icon: Icons.person,
                    textController: controller.nameController),
                SizedBox(height: setHeight(20)),
                inputField(
                    label: "Apellido",
                    icon: Icons.person_outline,
                    textController: controller.lastNameController),
                SizedBox(height: setHeight(20)),
                inputField(
                    label: "Nombre de Usuario",
                    icon: Icons.person_outline,
                    textController: controller.usernameController),
                SizedBox(height: setHeight(20)),
                inputField(
                    label: "Contraseña",
                    icon: Icons.lock,
                    isPassword: true,
                    textController: controller.passwordController),
                SizedBox(height: setHeight(20)),
                inputField(
                    label: "Confirmar Contraseña",
                    icon: Icons.lock,
                    isPassword: true,
                    textController: controller.confirmPasswordController),
                SizedBox(height: setHeight(20)),
                inputField(
                    label: "N° Legajo",
                    icon: Icons.badge,
                    textController: controller.fileNumberController),
                SizedBox(height: setHeight(20)),
                SizedBox(
                  width: double.infinity,
                  height: setHeight(60),
                  child: ElevatedButton(
                    onPressed: () => controller.register(context),
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
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: const Text('Registrarme'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget inputField(
      {required String label,
      required IconData icon,
      bool isPassword = false,
      required TextEditingController textController,
      TextInputType typeField = TextInputType.text}) {
    return SizedBox(
      width: double.infinity,
      height: setHeight(58),
      child: TextField(
        keyboardType: typeField,
        controller: textController,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFC5C5C5), width: 3.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFFFE500), width: 3.0),
          ),
        ),
      ),
    );
  }
}
