import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/pages/register/register_controller.dart';
import 'package:prueba_buffet/widgets/toggle_button.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final RegisterController controller = Get.put(RegisterController());

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
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 40,
                child: CustomToggleButton(
                  labels: const ['Registrarse', 'Iniciar Sesión'],
                  initialSelectedIndex: 0,
                  onToggle: (index) {
                    return controller.goToLoginPage();
                  },
                ),
              ),
              const SizedBox(height: 20),
              inputField(
                  label: "Nombre",
                  icon: Icons.person,
                  textController: controller.nameController),
              const SizedBox(height: 20),
              inputField(
                  label: "Apellido",
                  icon: Icons.person_outline,
                  textController: controller.lastNameController),
              const SizedBox(height: 20),
              inputField(
                  label: "Nombre de Usuario",
                  icon: Icons.person_outline,
                  textController: controller.usernameController),
              const SizedBox(height: 20),
              inputField(
                  label: "Contraseña",
                  icon: Icons.lock,
                  isPassword: true,
                  textController: controller.passwordController),
              const SizedBox(height: 20),
              inputField(
                  label: "Confirmar Contraseña",
                  icon: Icons.lock,
                  isPassword: true,
                  textController: controller.confirmPasswordController),
              const SizedBox(height: 20),
              inputField(
                  label: "N° Legajo",
                  icon: Icons.badge,
                  textController: controller.fileNumberController),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () => controller.register(context),
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(const Color(0xFFFFE500)),
                    foregroundColor:
                        WidgetStateProperty.all<Color>(Colors.black),
                    textStyle: WidgetStateProperty.all<TextStyle>(
                      const TextStyle(
                        fontSize: 20,
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
      height: 58,
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
