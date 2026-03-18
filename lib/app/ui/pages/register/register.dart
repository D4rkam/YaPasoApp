import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/register_controller.dart';
import 'package:prueba_buffet/app/ui/global_widgets/custom_input.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';
import 'package:prueba_buffet/app/ui/pages/terminos_condiciones/terminos_condiciones.dart';

class RegisterPage extends GetView<RegisterController> with ResponsiveMixin {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: [
                _buildProgressBar(),
                Expanded(
                  child: PageView(
                    onPageChanged: controller.onPageChanged,
                    controller: controller.pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      SingleChildScrollView(child: Step1Name()),
                      Step2Age(),
                      SingleChildScrollView(child: Step4Location()),
                      SingleChildScrollView(child: Step5Credentials()),
                    ],
                  ),
                ),
                // SafeArea local para el botón de abajo por si el cel no tiene bordes rectos
                SafeArea(
                  top: false,
                  child: Obx(
                    () => RegisterNavigation(
                      onBack: controller.previousStep,
                      onNext: controller.nextStep,
                      nextLabel: controller.currentStep.value ==
                              3 // Era 4, pero la lista tiene 4 items (0,1,2,3)
                          ? "Finalizar"
                          : "Continuar",
                    ),
                  ),
                )
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Obx(() => Padding(
          padding: EdgeInsets.symmetric(
              vertical: setHeight(20), horizontal: setWidth(30)),
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

          Obx(() => CustomInput(
                controller: controller.nameController,
                label: "Nombre",
                errorText: controller.nameError.value,
                onChanged: (_) => controller.nameError.value = null,
              )),

          SizedBox(height: setHeight(25)),

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
          SizedBox(height: setHeight(20)), // Espacio extra inferior
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
              Center(
                child: Container(
                  height: setHeight(320),
                  width: setWidth(140),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F8F8),
                    borderRadius: BorderRadius.circular(setWidth(40)),
                  ),
                  child: ListWheelScrollView.useDelegate(
                    controller: controller.scrollController,
                    itemExtent: 70,
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

class Step4Location extends GetView<RegisterController> with ResponsiveMixin {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: setWidth(30)),
      child: Column(
        children: [
          SizedBox(height: setHeight(40)),
          Text(
            "¿Cuál es tu ubicación?",
            style: TextStyle(fontSize: setSp(26), fontWeight: FontWeight.bold),
          ),
          SizedBox(height: setHeight(40)),
          Obx(() => CustomDropdown(
                label: "Provincia",
                value: controller.selectedProvince.value,
                items: controller.provinces,
                onChanged: (val) => controller.updateProvince(val!),
                errorText: controller.provinceError.value,
              )),
          SizedBox(height: setHeight(20)),
          Obx(() => CustomDropdown(
                label: "Localidad",
                value: controller.selectedLocalidad.value,
                items: controller.localidades,
                enabled: controller.selectedProvince.value.isNotEmpty,
                onChanged: (val) => controller.updateLocalidad(val!),
                errorText: controller.localidadError.value,
              )),
          SizedBox(height: setHeight(20)),
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
          Obx(() => CustomInput(
                controller: controller.fileNumberController,
                label: "N° Legajo",
                keyboardType: TextInputType.number,
                errorText: controller.fileNumberError.value,
                onChanged: (_) => controller.fileNumberError.value = null,
              )),
          SizedBox(height: setHeight(20)),
        ],
      ),
    );
  }
}

class Step5Credentials extends GetView<RegisterController>
    with ResponsiveMixin {
  const Step5Credentials({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(setWidth(20)),
      child: Column(
        children: [
          Text("Último Paso",
              style:
                  TextStyle(fontSize: setSp(24), fontWeight: FontWeight.bold)),
          Text("Ingresa tus datos de acceso",
              style: TextStyle(color: Colors.grey, fontSize: setSp(14))),
          SizedBox(height: setHeight(30)),
          Obx(() => CustomInput(
                controller: controller.emailController,
                label: "Email",
                keyboardType: TextInputType.emailAddress,
                errorText: controller.emailError.value,
                onChanged: (_) => controller.emailError.value = null,
              )),
          SizedBox(height: setHeight(15)),
          Obx(() => CustomInput(
                controller: controller.usernameController,
                label: "Nombre de usuario",
                errorText: controller.usernameError.value,
                onChanged: (_) => controller.usernameError.value = null,
              )),
          SizedBox(height: setHeight(15)),
          Obx(() => CustomInput(
              controller: controller.passwordController,
              label: "Contraseña",
              isPassword: true,
              errorText: controller.passwordError.value,
              onChanged: (_) => controller.passwordError.value = null)),
          SizedBox(height: setHeight(15)),
          Obx(() => CustomInput(
              controller: controller.confirmPasswordController,
              label: "Confirmar contraseña",
              isPassword: true,
              errorText: controller.confirmPasswordError.value,
              onChanged: (_) => controller.confirmPasswordError.value = null)),
          SizedBox(height: setHeight(25)),
          Obx(() => Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: setHeight(24),
                    width: setWidth(24),
                    child: Checkbox(
                      value: controller.acceptedTerms.value,
                      onChanged: (value) {
                        controller.acceptedTerms.value = value ?? false;
                        controller.termsError.value = null;
                      },
                      activeColor: const Color(0xFFFFE500),
                      checkColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  SizedBox(width: setWidth(12)),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: "He leído y acepto los ",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: setSp(14),
                        ),
                        children: [
                          TextSpan(
                            text: "Términos y Condiciones",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                fontSize: setSp(14)),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.to(
                                    () => const TerminosYCondicionesScreen());
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
          Obx(() => controller.termsError.value != null
              ? Padding(
                  padding: EdgeInsets.only(top: setHeight(8)),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      controller.termsError.value!,
                      style: TextStyle(color: Colors.red, fontSize: setSp(12)),
                    ),
                  ),
                )
              : const SizedBox.shrink()),
          SizedBox(height: setHeight(20)),
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
          horizontal: setWidth(30),
          vertical: setHeight(10)), // Bajé el margen vertical para teclados
      child: Row(
        children: [
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
    super.key,
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
              isExpanded: true, // 👈 Evita que el texto largo rompa el dropdown
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
