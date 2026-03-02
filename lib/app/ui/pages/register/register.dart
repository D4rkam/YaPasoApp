import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/register_controller.dart';
import 'package:prueba_buffet/app/ui/global_widgets/custom_input.dart';
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

class RegisterPage extends GetView<RegisterController> with ResponsiveMixin {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _buildProgressBar(),
              Expanded(
                child: PageView(
                  onPageChanged: controller.onPageChanged,
                  controller: controller.pageController,
                  physics:
                      const NeverScrollableScrollPhysics(), // Bloqueamos el swipe manual
                  children: [
                    SingleChildScrollView(child: Step1Name()),
                    Step2Age(),
                    Step4Location(),
                    SingleChildScrollView(child: Step5Credentials()),
                  ],
                ),
              ),
              Obx(
                () => RegisterNavigation(
                  onBack: controller.previousStep,
                  onNext: controller.nextStep,
                  nextLabel: controller.currentStep.value == 4
                      ? "Finalizar"
                      : "Continuar",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Row(
            children: List.generate(
                4,
                (index) => Expanded(
                      child: Container(
                        height: setHeight(8),
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: index <= controller.currentStep.value
                              ? const Color(0xFFFFE500)
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    )),
          ),
        ));
  }
}

class Step1Name extends GetView<RegisterController> with ResponsiveMixin {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: setWidth(30)),
      child: Column(
        children: [
          SizedBox(height: setHeight(40)),
          Text(
            "Regístrate",
            style: TextStyle(
              fontSize: setSp(28),
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: setHeight(8)),
          Text(
            "Ingresa tu nombre y apellido\npara continuar",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: setSp(16),
              color: const Color(0xFFB3B3B3),
              height: 1.2,
            ),
          ),
          SizedBox(height: setHeight(50)),

          // Campo Nombre (En foco en tu imagen)
          CustomInput(
            controller: controller.nameController,
            label: "Nombre",
          ),

          SizedBox(height: setHeight(25)),

          // Campo Apellido (Sin foco en tu imagen)
          CustomInput(
            controller: controller.lastNameController,
            label: "Apellido",
          ),
        ],
      ),
    );
  }
}

class Step2Age extends GetView<RegisterController> with ResponsiveMixin {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: setHeight(40)),
        Text(
          "¿Cuál es tu edad?",
          style: TextStyle(
            fontSize: setSp(26),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const Spacer(),
        // Contenedor de la Ruleta
        Center(
          child: Container(
            height: setHeight(320),
            width: setWidth(140),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F8), // Fondo gris muy claro
              borderRadius: BorderRadius.circular(setWidth(40)),
            ),
            child: ListWheelScrollView.useDelegate(
              itemExtent: 70, // Espacio vertical entre números
              perspective: 0.005,
              diameterRatio: 1.5,
              onSelectedItemChanged: (index) {
                controller.age.value = 12 + index;
              },
              physics: const FixedExtentScrollPhysics(),
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: 10,
                builder: (context, index) {
                  return Obx(() {
                    final isSelected = controller.age.value == (12 + index);
                    return Center(
                      child: Text(
                        "${12 + index}",
                        style: TextStyle(
                          fontSize: isSelected ? setSp(38) : setSp(24),
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? Colors.black
                              : const Color(0xFFCCCCCC),
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

// class Step3Gender extends GetView<RegisterController> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text("¿Cuál es tu género?",
//             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//         const SizedBox(height: 40),
//         _genderOption("Hombre", Icons.male),
//         _genderOption("Mujer", Icons.female),
//         _genderOption("Otro", Icons.circle_outlined),
//       ],
//     );
//   }

//   Widget _genderOption(String label, IconData icon) {
//     return Obx(() {
//       final isSelected = controller.gender.value == label;
//       return GestureDetector(
//         onTap: () => controller.gender.value = label,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
//           padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//           decoration: BoxDecoration(
//             color:
//                 isSelected ? const Color(0xFF2D2E37) : const Color(0xFFF5F5F5),
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: Row(
//             children: [
//               Icon(icon,
//                   color: isSelected ? Colors.white : Colors.grey, size: 28),
//               const SizedBox(width: 20),
//               Text(label,
//                   style: TextStyle(
//                       color: isSelected ? Colors.white : Colors.black54,
//                       fontSize: 18,
//                       fontWeight:
//                           isSelected ? FontWeight.bold : FontWeight.normal)),
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }

class Step4Location extends GetView<RegisterController> with ResponsiveMixin {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: setWidth(30)),
      child: Column(
        children: [
          SizedBox(height: setHeight(40)),
          Text(
            "¿Cuál es tu ubicación?",
            style: TextStyle(fontSize: setSp(26), fontWeight: FontWeight.bold),
          ),
          SizedBox(height: setHeight(40)),

          // Provincia
          Obx(() => CustomDropdown(
                label: "Provincia",
                value: controller.selectedProvince.value,
                items: controller.provinces,
                onChanged: (val) => controller.updateProvince(val!),
              )),

          SizedBox(height: setHeight(20)),

          // Localidad - Solo se activa si hay Provincia
          Obx(() => CustomDropdown(
                label: "Localidad",
                value: controller.selectedLocalidad.value,
                items: controller.localidades,
                enabled: controller.selectedProvince.value.isNotEmpty,
                onChanged: (val) => controller.updateLocalidad(val!),
              )),

          SizedBox(height: setHeight(20)),

          // Escuela - Solo se activa si hay Localidad
          Obx(() => CustomDropdown(
                label: "Escuela",
                value: controller.selectedEscuela.value,
                items: controller.escuelas,
                enabled: controller.selectedLocalidad.value.isNotEmpty,
                onChanged: (val) => controller.selectedEscuela.value = val!,
              )),

          SizedBox(height: setHeight(20)),

          // N° Legajo (Corregido a Input)
          CustomInput(
            controller: controller.legajoController,
            label: "N° Legajo",
            keyboardType: TextInputType.number,
            // Solo habilitado si seleccionó la escuela
          ),
        ],
      ),
    );
  }
}

class Step5Credentials extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text("Último Paso",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text("Ingresa tus datos de acceso",
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 30),
          CustomInput(
            controller: controller.emailController,
            label: "Correo electrónico",
          ),
          const SizedBox(height: 15),
          CustomInput(
            controller: controller.usernameController,
            label: "Nombre de usuario",
          ),
          const SizedBox(height: 15),
          CustomInput(
              controller: controller.passwordController,
              label: "Contraseña",
              isPassword: true),
          const SizedBox(height: 15),
          CustomInput(
              controller: controller.confirmPasswordController,
              label: "Confirmar contraseña",
              isPassword: true),
        ],
      ),
    );
  }
}

class RegisterNavigation extends StatelessWidget with ResponsiveMixin {
  final VoidCallback onBack;
  final VoidCallback onNext;
  final String nextLabel;

  RegisterNavigation({
    super.key,
    required this.onBack,
    required this.onNext,
    this.nextLabel = "Continuar",
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: setWidth(30), vertical: setHeight(20)),
      child: Row(
        children: [
          // Botón Atrás (Cuadrado con borde suave)
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: setHeight(55),
              height: setHeight(55),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(setWidth(15)),
                  border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ]),
              child: const Icon(Icons.arrow_back_ios_new,
                  color: Colors.black, size: 20),
            ),
          ),
          SizedBox(width: setWidth(20)),
          // Botón Continuar/Finalizar
          Expanded(
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFE500),
                foregroundColor: Colors.black,
                elevation: 0,
                minimumSize: Size(double.infinity, setHeight(55)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(setWidth(15)),
                ),
                textStyle: TextStyle(
                  fontSize: setSp(18),
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Text(nextLabel),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDropdown extends StatelessWidget with ResponsiveMixin {
  final String label;
  final String value;
  final List<String> items;
  final Function(String?) onChanged;
  final bool enabled;

  CustomDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: IgnorePointer(
        ignoring: !enabled,
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: value.isEmpty ? null : value,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(
                  color:
                      value.isNotEmpty ? Colors.black : const Color(0xFFB3B3B3),
                  fontSize: setSp(16),
                  fontWeight:
                      value.isNotEmpty ? FontWeight.bold : FontWeight.normal,
                ),
                floatingLabelStyle: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: setWidth(15), vertical: setHeight(15)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(setHeight(10)),
                  borderSide: BorderSide(
                      color: value.isNotEmpty
                          ? Colors.black
                          : const Color(0xFFE0E0E0),
                      width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(setHeight(10)),
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(setHeight(10))),
              ),
              icon: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: Colors.black),
              items: items.map((String item) {
                return DropdownMenuItem(
                    value: item,
                    child: Text(item, style: TextStyle(fontSize: setSp(16))));
              }).toList(),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
