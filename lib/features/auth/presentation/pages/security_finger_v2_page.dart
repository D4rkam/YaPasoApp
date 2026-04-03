import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:prueba_buffet/app/routes/routes.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';
import 'package:prueba_buffet/features/auth/presentation/controllers/auth_security_gate_controller_v2.dart';
import 'package:prueba_buffet/utils/logger.dart';

class SecurityFingerV2Page extends StatefulWidget {
  const SecurityFingerV2Page({super.key});

  @override
  State<SecurityFingerV2Page> createState() => _SecurityFingerV2PageState();
}

class _SecurityFingerV2PageState extends State<SecurityFingerV2Page>
    with ResponsiveMixin {
  final LocalAuthentication _auth = LocalAuthentication();
  final AuthSecurityGateControllerV2 _controller =
      Get.find<AuthSecurityGateControllerV2>();

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await _controller.loadGateConfig();
    if (!_controller.requiresBiometric.value) {
      await _validateSessionAndNavigate();
    }
  }

  String _resolveLoginRoute() {
    final enableAuthV2Login =
        GetStorage().read<bool>('enable_auth_v2_login') ?? false;
    return enableAuthV2Login ? Routes.LOGIN_V2 : Routes.LOGIN;
  }

  Future<void> _validateSessionAndNavigate() async {
    final destination = await _controller.validateSession();
    if (!mounted) return;

    if (destination == AuthGateDestination.home) {
      Get.offAllNamed(Routes.HOME);
      return;
    }

    Get.offNamedUntil(_resolveLoginRoute(), (route) => false);
  }

  Future<void> _authenticate() async {
    try {
      final isAuthenticated = await _auth.authenticate(
        localizedReason: ' ',
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            biometricHint: '',
            signInTitle: 'Desbloquea Ya Paso para poder usarlo',
            cancelButton: 'Cancelar',
          ),
        ],
        options: const AuthenticationOptions(
          biometricOnly: false,
        ),
      );

      if (isAuthenticated) {
        await _validateSessionAndNavigate();
      }
    } catch (e) {
      logger.e(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                  minWidth: constraints.maxWidth,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: <Widget>[
                      const Spacer(flex: 2),
                      Image.asset(
                        'assets/images/bloqueo.webp',
                        width: setWidth(250),
                        height: setHeight(250),
                      ),
                      SizedBox(height: setHeight(20)),
                      Text(
                        'Desbloquea',
                        style: TextStyle(
                          fontSize: setSp(35),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF3F3F3F),
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'para usar',
                              style: TextStyle(
                                fontSize: setSp(30),
                                color: const Color(0xFF808080),
                              ),
                            ),
                            TextSpan(
                              text: ' Ya Paso',
                              style: TextStyle(
                                fontSize: setSp(30),
                                fontFamily: 'Lobster',
                                color: const Color(0xFF808080),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(flex: 3),
                      Padding(
                        padding: EdgeInsets.only(bottom: setHeight(40)),
                        child: SizedBox(
                          height: setHeight(60),
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Obx(
                            () => ElevatedButton(
                              onPressed: _controller.isLoading.value
                                  ? null
                                  : (_controller.requiresBiometric.value
                                      ? _authenticate
                                      : _validateSessionAndNavigate),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFE500),
                                disabledBackgroundColor:
                                    const Color(0xFFFFE500).withOpacity(0.7),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: _controller.isLoading.value
                                  ? SizedBox(
                                      height: setHeight(25),
                                      width: setHeight(25),
                                      child: const CircularProgressIndicator(
                                        color: Colors.black,
                                        strokeWidth: 3,
                                      ),
                                    )
                                  : Text(
                                      _controller.requiresBiometric.value
                                          ? 'Desbloquear'
                                          : 'Continuar',
                                      style: TextStyle(
                                        fontSize: setSp(30),
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
