import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/home_controller.dart';
import 'package:prueba_buffet/app/controllers/main_shell_controller.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';

class PerfilContent extends StatelessWidget with ResponsiveMixin {
  const PerfilContent({super.key});

  @override
  Widget build(BuildContext context) {
    final MainShellController shellController = Get.find<MainShellController>();
    final HomeController homeController = Get.find<HomeController>();

    return Container(
      color: const Color(0xFFF9F9F9),
      child: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          shellController.updateScrollDirection(notification.direction);
          return true;
        },
        child: GetBuilder<HomeController>(
          id: 'profile_info',
          builder: (_) {
            return LayoutBuilder(builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.topCenter,
                          children: [
                            Container(
                              width: double.infinity,
                              height: setHeight(150),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFE500),
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(30),
                                ),
                              ),
                              child: SafeArea(
                                bottom: false,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: setWidth(24), top: setHeight(20)),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: setHeight(-50),
                              child: Container(
                                width: setHeight(100),
                                height: setHeight(100),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.white, width: setWidth(5)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    )
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image(
                                    fit: BoxFit.cover,
                                    image: CachedNetworkImageProvider(
                                      'https://ui-avatars.com/api/?name=${homeController.userSession.name}+${homeController.userSession.lastName}&background=000&color=fff',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: setHeight(60)),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: setWidth(24)),
                          child: Text(
                            "${homeController.userSession.name} ${homeController.userSession.lastName}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: setSp(20),
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        SizedBox(height: setHeight(4)),
                        GestureDetector(
                          onTap: () => _mostrarModalEdicionEmail(
                              context, homeController),
                          child: Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: setWidth(24)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    "${homeController.userSession.email}",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: setSp(14),
                                        color: const Color(0xFF999999),
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                SizedBox(width: setWidth(6)),
                                Icon(Icons.edit_rounded,
                                    size: setSp(14),
                                    color: const Color(0xFF999999)),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: setHeight(35)),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: setWidth(24)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Cuenta",
                                      style: TextStyle(
                                          fontSize: setSp(22),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                  TextButton.icon(
                                    onPressed: () => _mostrarModalEdicion(
                                        context, homeController),
                                    icon: Icon(Icons.edit_rounded,
                                        size: setSp(16), color: Colors.blue),
                                    label: Text("Editar",
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: setSp(14))),
                                  )
                                ],
                              ),
                              SizedBox(height: setHeight(8)),
                              _buildCard(
                                children: [
                                  _buildRowItem("Número De Legajo",
                                      "${homeController.userSession.fileNum}",
                                      isBoldValue: true),
                                  _buildDivider(),
                                  _buildRowItem("Edad",
                                      "${homeController.userSession.age ?? '-'} años",
                                      isBoldValue: true),
                                  _buildDivider(),
                                  _buildRowItem("Turno",
                                      "${homeController.userSession.turn ?? 'Sin Seleccionar'}",
                                      isBoldValue: true),
                                  _buildDivider(),
                                  _buildRowItem("Año",
                                      "${homeController.userSession.curse_year ?? '-'}",
                                      isBoldValue: true),
                                  _buildDivider(),
                                  _buildRowItem("División",
                                      "${homeController.userSession.curse_division ?? '-'}",
                                      isBoldValue: true),
                                ],
                              ),
                              SizedBox(height: setHeight(35)),
                              Text("Seguridad",
                                  style: TextStyle(
                                      fontSize: setSp(22),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              SizedBox(height: setHeight(16)),
                              _buildCard(
                                children: [
                                  _buildActionRow("Cambiar Contraseña",
                                      onTap: () => _mostrarModalCambioPassword(
                                          context, homeController)),
                                ],
                              ),
                              SizedBox(height: setHeight(120)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
          },
        ),
      ),
    );
  }

  void _mostrarModalEdicion(BuildContext context, HomeController controller) {
    final ageCtrl = TextEditingController(
        text: controller.userSession.age?.toString() ?? '');
    final yearCtrl = TextEditingController(
        text: controller.userSession.curse_year?.toString() ?? '');
    final divCtrl = TextEditingController(
        text: controller.userSession.curse_division ?? '');
    String selectedTurn = controller.userSession.turn ?? 'MAÑANA';

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(
          left: setWidth(24),
          right: setWidth(24),
          top: setWidth(24),
          bottom: MediaQuery.of(context).viewInsets.bottom + setWidth(24),
        ),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10)))),
              SizedBox(height: setHeight(20)),
              Text("Editar información",
                  style: TextStyle(
                      fontSize: setSp(20), fontWeight: FontWeight.bold)),
              SizedBox(height: setHeight(20)),
              TextField(
                  controller: ageCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Edad",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)))),
              SizedBox(height: setHeight(16)),
              TextField(
                  controller: yearCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Año de cursada (ej: 4)",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)))),
              SizedBox(height: setHeight(16)),
              TextField(
                  controller: divCtrl,
                  decoration: InputDecoration(
                      labelText: "División (ej: 3ra)",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)))),
              SizedBox(height: setHeight(16)),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: ['MAÑANA', 'TARDE', 'NOCHE']
                        .contains(selectedTurn.toUpperCase())
                    ? selectedTurn.toUpperCase()
                    : 'MAÑANA',
                decoration: InputDecoration(
                    labelText: "Turno",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
                items: ['MAÑANA', 'TARDE', 'NOCHE']
                    .map((String value) => DropdownMenuItem<String>(
                        value: value, child: Text(value)))
                    .toList(),
                onChanged: (newValue) => selectedTurn = newValue!,
              ),
              SizedBox(height: setHeight(24)),
              Obx(() => SizedBox(
                    width: double.infinity,
                    height: setHeight(50),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFE500),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      onPressed: controller.isUpdatingProfile.value
                          ? null
                          : () {
                              Map<String, dynamic> newData = {
                                "age": int.tryParse(ageCtrl.text) ??
                                    controller.userSession.age,
                                "curse_year": int.tryParse(yearCtrl.text) ??
                                    controller.userSession.curse_year,
                                "curse_division": divCtrl.text,
                                "turn": selectedTurn,
                              };
                              controller.updateProfile(newData);
                            },
                      child: controller.isUpdatingProfile.value
                          ? const CircularProgressIndicator(color: Colors.black)
                          : Text("Guardar Cambios",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: setSp(16),
                                  fontWeight: FontWeight.bold)),
                    ),
                  )),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _mostrarModalEdicionEmail(
      BuildContext context, HomeController controller) {
    final emailCtrl =
        TextEditingController(text: controller.userSession.email ?? '');

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(
          left: setWidth(24),
          right: setWidth(24),
          top: setWidth(24),
          bottom: MediaQuery.of(context).viewInsets.bottom + setWidth(24),
        ),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10)))),
              SizedBox(height: setHeight(20)),
              Text("Actualizar Email",
                  style: TextStyle(
                      fontSize: setSp(20), fontWeight: FontWeight.bold)),
              SizedBox(height: setHeight(20)),
              TextField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    labelText: "Nuevo Correo Electrónico",
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
              ),
              SizedBox(height: setHeight(24)),
              Obx(() => SizedBox(
                    width: double.infinity,
                    height: setHeight(50),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFE500),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      onPressed: controller.isUpdatingEmail.value
                          ? null
                          : () => controller.updateEmail(emailCtrl.text.trim()),
                      child: controller.isUpdatingEmail.value
                          ? const CircularProgressIndicator(color: Colors.black)
                          : Text("Guardar Email",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: setSp(16),
                                  fontWeight: FontWeight.bold)),
                    ),
                  )),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _mostrarModalCambioPassword(
      BuildContext context, HomeController controller) {
    final currentPassCtrl = TextEditingController();
    final newPassCtrl = TextEditingController();

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(
          left: setWidth(24),
          right: setWidth(24),
          top: setWidth(24),
          bottom: MediaQuery.of(context).viewInsets.bottom + setWidth(24),
        ),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10)))),
              SizedBox(height: setHeight(20)),
              Text("Cambiar Contraseña",
                  style: TextStyle(
                      fontSize: setSp(20), fontWeight: FontWeight.bold)),
              SizedBox(height: setHeight(20)),
              TextField(
                controller: currentPassCtrl,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: "Contraseña Actual",
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
              ),
              SizedBox(height: setHeight(16)),
              TextField(
                controller: newPassCtrl,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: "Nueva Contraseña",
                    prefixIcon: const Icon(Icons.lock_reset),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
              ),
              SizedBox(height: setHeight(24)),
              Obx(() => SizedBox(
                    width: double.infinity,
                    height: setHeight(50),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFE500),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      onPressed: controller.isUpdatingPassword.value
                          ? null
                          : () => controller.updatePassword(
                              currentPassCtrl.text, newPassCtrl.text),
                      child: controller.isUpdatingPassword.value
                          ? const CircularProgressIndicator(color: Colors.black)
                          : Text("Actualizar Contraseña",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: setSp(16),
                                  fontWeight: FontWeight.bold)),
                    ),
                  )),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildRowItem(String title, String value, {bool isBoldValue = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: setWidth(20), vertical: setHeight(18)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 2,
            child: Text(title,
                style: TextStyle(
                    fontSize: setSp(15),
                    color: const Color(0xFF999999),
                    fontWeight: FontWeight.w500)),
          ),
          SizedBox(width: setWidth(10)),
          Flexible(
            flex: 3,
            child: Text(value,
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontSize: setSp(15),
                    color: Colors.black,
                    fontWeight:
                        isBoldValue ? FontWeight.bold : FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow(String title,
      {required VoidCallback onTap, bool showArrow = true}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: setWidth(20), vertical: setHeight(18)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(title,
                  style: TextStyle(
                      fontSize: setSp(15),
                      color: const Color(0xFF999999),
                      fontWeight: FontWeight.w500)),
            ),
            if (showArrow)
              Icon(Icons.arrow_forward_ios_rounded,
                  size: setSp(16), color: const Color(0xFF999999)),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
        height: 1,
        thickness: 1,
        color: const Color(0xFFF0F0F0),
        indent: setWidth(20),
        endIndent: setWidth(20));
  }
}
