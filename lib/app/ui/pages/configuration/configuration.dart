import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_auth/local_auth.dart'; // <-- IMPORTANTE
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';
import 'package:prueba_buffet/app/controllers/home_controller.dart';
import 'package:prueba_buffet/app/controllers/main_shell_controller.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';
import 'package:prueba_buffet/app/ui/pages/terminos_condiciones/terminos_condiciones.dart';

import 'package:prueba_buffet/utils/logger.dart';

class ConfiguracionContent extends StatefulWidget {
  const ConfiguracionContent({super.key});

  @override
  State<ConfiguracionContent> createState() => _ConfiguracionContentState();
}

class _ConfiguracionContentState extends State<ConfiguracionContent>
    with ResponsiveMixin {
  final GetStorage _storage = GetStorage();
  final LocalAuthentication _auth = LocalAuthentication();

  late bool useBiometrics;
  late bool requireBiometricsForPay;
  bool notifyOrders = true;
  bool notifyPromos = false;
  bool darkMode = false;

  @override
  void initState() {
    super.initState();
    useBiometrics = _storage.read<bool>('useBiometrics') ?? false;
    requireBiometricsForPay =
        _storage.read<bool>('requireBiometricsForPay') ?? true;
  }

  Future<bool> _authenticateUser(String reason) async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await _auth.isDeviceSupported();

      if (canAuthenticate) {
        return await _auth.authenticate(
          localizedReason: reason,
          options: const AuthenticationOptions(
            biometricOnly: true,
            stickyAuth: true,
          ),
          authMessages: const [
            AndroidAuthMessages(
              signInTitle: 'Seguridad',
              biometricHint: 'Colocá tu dedo para confirmar',
              biometricNotRecognized: 'Huella no reconocida',
              biometricRequiredTitle: 'Se requiere huella',
              cancelButton: 'Cancelar',
            ),
            IOSAuthMessages(cancelButton: 'Cancelar'),
          ],
        );
      }
      return true;
    } catch (e) {
      logger.e("Error autenticando: $e");
      return false;
    }
  }

  Future<void> _toggleBiometrics(bool val) async {
    if (val == false) {
      bool isAuthorized = await _authenticateUser(
          'Verificá tu identidad para desactivar el inicio de sesión seguro');

      if (isAuthorized) {
        setState(() => useBiometrics = val);
        _storage.write('useBiometrics', val);
      } else {
        setState(() {});
      }
    } else {
      setState(() => useBiometrics = val);
      _storage.write('useBiometrics', val);
    }
  }

  Future<void> _toggleBiometricsForPay(bool val) async {
    if (val == false) {
      bool isAuthorized = await _authenticateUser(
          'Verificá tu identidad para desactivar la seguridad de pagos');

      if (isAuthorized) {
        setState(() => requireBiometricsForPay = val);
        _storage.write('requireBiometricsForPay', val);
      } else {
        setState(() {});
      }
    } else {
      setState(() => requireBiometricsForPay = val);
      _storage.write('requireBiometricsForPay', val);
    }
  }

  @override
  Widget build(BuildContext context) {
    final MainShellController shellController = Get.find<MainShellController>();

    return Container(
      color: const Color(0xFFF9F9F9),
      child: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          shellController.updateScrollDirection(notification.direction);
          return true;
        },
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // HEADER AMARILLO
                    Container(
                      width: double.infinity,
                      height: setHeight(120),
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
                          child: Text(
                            'Configuración',
                            style: TextStyle(
                              fontSize: setSp(25),
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: setHeight(30)),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: setWidth(24)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ---> SECCIÓN SEGURIDAD <---
                          _buildSectionTitle("Seguridad y Pagos"),
                          _buildCard(
                            children: [
                              _buildSwitchRow(
                                title: "Ingreso con Huella / FaceID",
                                icon: Icons.fingerprint,
                                value: useBiometrics,
                                onChanged: _toggleBiometrics,
                              ),
                              _buildDivider(),
                              _buildSwitchRow(
                                title: "Pedir huella al comprar",
                                icon: Icons.lock_outline,
                                value: requireBiometricsForPay,
                                onChanged: _toggleBiometricsForPay,
                              ),
                            ],
                          ),

                          SizedBox(height: setHeight(30)),

                          // SECCIÓN NOTIFICACIONES
                          _buildSectionTitle("Notificaciones"),
                          _buildCard(
                            children: [
                              _buildSwitchRow(
                                title: "Estado de mis pedidos",
                                icon: Icons.fastfood_outlined,
                                value: false,
                                enabled: false,
                                onChanged: null,
                              ),
                              _buildDivider(),
                              _buildSwitchRow(
                                title: "Ofertas del buffet",
                                icon: Icons.local_offer_outlined,
                                value: false,
                                enabled: false,
                                onChanged: null,
                              ),
                            ],
                          ),

                          SizedBox(height: setHeight(30)),

                          // SECCIÓN APARIENCIA
                          _buildSectionTitle("Apariencia"),
                          _buildCard(
                            children: [
                              _buildSwitchRow(
                                title: "Modo Oscuro",
                                icon: Icons.dark_mode_outlined,
                                value: false,
                                enabled: false,
                                onChanged: null,
                              ),
                            ],
                          ),

                          SizedBox(height: setHeight(30)),

                          // SECCIÓN CUENTA
                          _buildSectionTitle("Cuenta"),
                          _buildCard(
                            children: [
                              _buildActionRow(
                                title: "Términos y Condiciones",
                                icon: Icons.description_outlined,
                                onTap: () {
                                  Get.to(
                                      () => const TerminosYCondicionesScreen());
                                },
                              ),
                              _buildDivider(),
                              _buildActionRow(
                                title: "Eliminar mi cuenta",
                                icon: Icons.delete_outline,
                                isDestructive: true,
                                onTap: () {
                                  Get.defaultDialog(
                                    radius: 10,
                                    title: "¿Estás seguro?",
                                    middleText:
                                        "Esta acción es irreversible. Perderás tu saldo actual y tu historial de pedidos.",
                                    textConfirm: "Sí, eliminar",
                                    textCancel: "Cancelar",
                                    confirmTextColor: Colors.white,
                                    buttonColor: Colors.redAccent,
                                    cancelTextColor: Colors.black,
                                    onConfirm: () {
                                      Get.back();
                                      Get.find<HomeController>()
                                          .deleteAccount();
                                    },
                                  );
                                },
                              ),
                            ],
                          ),

                          // Usamos Spacer o padding dinámico en lugar de height fijo excesivo
                          SizedBox(height: setHeight(60)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // WIDGETS REUTILIZABLES
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: setHeight(12), left: setWidth(5)),
      child: Text(
        title,
        style: TextStyle(
          fontSize: setSp(18),
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
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
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchRow({
    required String title,
    required IconData icon,
    required bool value,
    required ValueChanged<bool>? onChanged,
    bool enabled = true,
  }) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.4,
      child: IgnorePointer(
        ignoring: !enabled,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: setWidth(16), vertical: setHeight(8)),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF999999), size: setSp(22)),
              SizedBox(width: setWidth(12)),
              Expanded(
                // 👈 Expanded previene overflow si el texto es muy largo
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: setSp(15),
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: Colors.black,
                activeTrackColor: const Color(0xFFFFE500),
                inactiveThumbColor: Colors.grey.shade400,
                inactiveTrackColor: Colors.grey.shade200,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionRow({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? Colors.redAccent : Colors.black87;
    final iconColor =
        isDestructive ? Colors.redAccent : const Color(0xFF999999);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: setWidth(16), vertical: setHeight(18)),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: setSp(22)),
            SizedBox(width: setWidth(12)),
            Expanded(
              // 👈 Expanded previene overflow
              child: Text(
                title,
                style: TextStyle(
                  fontSize: setSp(15),
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (!isDestructive)
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: setSp(16),
                color: const Color(0xFF999999),
              ),
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
      indent: setWidth(50),
      endIndent: setWidth(20),
    );
  }
}
