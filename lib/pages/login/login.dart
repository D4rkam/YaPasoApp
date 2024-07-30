import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/pages/login/login_controller.dart';
import 'package:prueba_buffet/widgets/toggle_button.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  //Enlace con el controlador
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    // final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.175,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/logo-sin.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 40,
                child: CustomToggleButton(
                  labels: const ['Registrarse', 'Iniciar Sesión'],
                  initialSelectedIndex: 1,
                  onToggle: (index) {
                    return controller.goToRegisterPage();
                  },
                ),
              ),
              const SizedBox(height: 20),
              inputField(
                  label: "Username",
                  icon: Icons.person,
                  controllerTextField: controller.usernameController),
              const SizedBox(height: 20),
              inputField(
                  label: "Contraseña",
                  icon: Icons.lock,
                  isPassword: true,
                  controllerTextField: controller.passwordController),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () => controller.login(),
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(const Color(0xFFFFE500)),
                    foregroundColor:
                        WidgetStateProperty.all<Color>(Colors.black),
                    textStyle: WidgetStateProperty.all<TextStyle>(
                      const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
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
      height: 58,
      child: TextField(
        keyboardType: typeField,
        controller: controllerTextField,
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
