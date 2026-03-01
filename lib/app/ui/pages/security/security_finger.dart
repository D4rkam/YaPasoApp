import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:prueba_buffet/app/controllers/security_finger_controller.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';

class SecurityFinger extends StatefulWidget {
  const SecurityFinger({super.key});

  @override
  State<SecurityFinger> createState() => _SecurityFingerState();
}

class _SecurityFingerState extends State<SecurityFinger> with ResponsiveMixin {
  final LocalAuthentication auth = LocalAuthentication();
  final SecurityFingerController securityFingerController = Get.find();

  Future<void> _authenticate() async {
    try {
      final isAuthenticated = await auth.authenticate(
        localizedReason: ' ',
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            biometricHint: "",
            signInTitle: 'Desbloquea Ya Paso para poder usarlo',
            cancelButton: 'Cancelar',
          ),
        ],
        options: const AuthenticationOptions(
          biometricOnly: false,
        ),
      );

      if (isAuthenticated) {
        securityFingerController.checkToken();
      }
    } catch (e) {
      // Manejo de errores de autenticación
      Get.snackbar("Error", e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: setHeight(100)),
              child: Image.asset("assets/images/bloqueo.png",
                  width: setWidth(250), height: setHeight(250)),
            ),
            Text(
              "Desbloquea",
              style: TextStyle(
                  fontSize: setSp(35),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF3F3F3F)),
            ),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: "para usar",
                  style: TextStyle(
                    fontSize: setSp(30),
                    color: const Color(0xFF808080),
                  ),
                ),
                TextSpan(
                  text: " Ya Paso",
                  style: TextStyle(
                    fontSize: setSp(30),
                    fontFamily: "Lobster",
                    color: const Color(0xFF808080),
                  ),
                ),
              ]),
            ),
            Padding(
              padding: EdgeInsets.only(top: setHeight(150)),
              child: SizedBox(
                height: setHeight(60),
                width: MediaQuery.of(context).size.width * 0.8,
                child: ElevatedButton(
                  onPressed: _authenticate,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFE500),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      )),
                  child: Text(
                    'Desbloquear',
                    style: TextStyle(
                        fontSize: setSp(30),
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
