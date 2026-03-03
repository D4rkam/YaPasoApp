import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/register_controller.dart';
import 'package:prueba_buffet/app/ui/global_widgets/custom_input.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';

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
          Obx(() => CustomInput(
                controller: controller.nameController,
                label: "Nombre",
                errorText: controller.nameError.value,
                onChanged: (_) => controller.nameError.value = null,
              )),

          SizedBox(height: setHeight(25)),

          // Campo Apellido (Sin foco en tu imagen)
          Obx(() => CustomInput(
                controller: controller.lastNameController,
                label: "Apellido",
                errorText: controller.lastNameError.value,
                onChanged: (_) => controller.lastNameError.value = null,
              )),

          SizedBox(height: setHeight(30)),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "¿Ya tienes cuenta? ",
                style: TextStyle(
                  fontSize: setSp(14),
                  color: const Color(0xFFB3B3B3),
                ),
              ),
              GestureDetector(
                onTap: controller.goToLoginPage,
                child: Text(
                  "Inicia Sesión",
                  style: TextStyle(
                    fontSize: setSp(14),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Step2Age extends GetView<RegisterController> with ResponsiveMixin {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
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
                    controller: controller.scrollController,
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
                          final isSelected =
                              controller.age.value == (12 + index);
                          return Center(
                            child: Text(
                              "${12 + index}",
                              style: TextStyle(
                                fontSize: isSelected ? setSp(38) : setSp(24),
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
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
          ),
        ),
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
                errorText: controller.provinceError.value,
              )),

          SizedBox(height: setHeight(20)),

          // Localidad - Solo se activa si hay Provincia
          Obx(() => CustomDropdown(
                label: "Localidad",
                value: controller.selectedLocalidad.value,
                items: controller.localidades,
                enabled: controller.selectedProvince.value.isNotEmpty,
                onChanged: (val) => controller.updateLocalidad(val!),
                errorText: controller.localidadError.value,
              )),

          SizedBox(height: setHeight(20)),

          // Escuela - Solo se activa si hay Localidad
          Obx(() => CustomDropdown(
                label: "Escuela",
                value: controller.selectedEscuela.value,
                items: controller.escuelas,
                enabled: controller.selectedLocalidad.value.isNotEmpty,
                onChanged: (val) {
                  controller.selectedEscuela.value = val!;
                  controller.escuelaError.value = null;
                },
                errorText: controller.escuelaError.value,
              )),

          SizedBox(height: setHeight(20)),

          // N° Legajo (Corregido a Input)
          Obx(() => CustomInput(
                controller: controller.fileNumberController,
                label: "N° Legajo",
                keyboardType: TextInputType.number,
                errorText: controller.fileNumberError.value,
                onChanged: (_) => controller.fileNumberError.value = null,
                // Solo habilitado si seleccionó la escuela
              )),
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
      child: Column(children: [
        Text("Último Paso",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text("Ingresa tus datos de acceso",
            style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 30),
        Obx(() => CustomInput(
              controller: controller.emailController,
              label: "Email",
              keyboardType: TextInputType.emailAddress,
              errorText: controller.emailError.value,
              onChanged: (_) => controller.emailError.value = null,
            )),
        const SizedBox(height: 15),
        Obx(() => CustomInput(
              controller: controller.usernameController,
              label: "Nombre de usuario",
              errorText: controller.usernameError.value,
              onChanged: (_) => controller.usernameError.value = null,
            )),
        const SizedBox(height: 15),
        Obx(() => CustomInput(
            controller: controller.passwordController,
            label: "Contraseña",
            isPassword: true,
            errorText: controller.passwordError.value,
            onChanged: (_) => controller.passwordError.value = null)),
        const SizedBox(height: 15),
        Obx(() => CustomInput(
            controller: controller.confirmPasswordController,
            label: "Confirmar contraseña",
            isPassword: true,
            errorText: controller.confirmPasswordError.value,
            onChanged: (_) => controller.confirmPasswordError.value = null)),
      ]),
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
  final String? errorText;

  CustomDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.enabled = true,
    this.errorText,
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
                errorText: errorText,
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
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(setHeight(10)),
                  borderSide: const BorderSide(color: Colors.red, width: 1.5),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(setHeight(10)),
                  borderSide: const BorderSide(color: Colors.red, width: 2),
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
