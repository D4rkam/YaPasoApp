import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:prueba_buffet/app/controllers/security_finger_controller.dart';
import 'package:local_auth_android/local_auth_android.dart';

class SecurityFinger extends StatefulWidget {
  const SecurityFinger({super.key});

  @override
  State<SecurityFinger> createState() => _SecurityFingerState();
}

class _SecurityFingerState extends State<SecurityFinger> {
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
              padding: const EdgeInsets.only(top: 100),
              child: Image.asset("assets/images/bloqueo.png"),
            ),
            const Text(
              "Desbloquea",
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3F3F3F)),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 86),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "para usar",
                    style: TextStyle(
                      fontSize: 30,
                      color: Color(0xFF808080),
                    ),
                  ),
                  Text("Ya Paso",
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: "Lobster",
                        color: Color(0xFF808080),
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 150),
              child: SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width * 0.8,
                child: ElevatedButton(
                  onPressed: _authenticate,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFE500),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      )),
                  child: const Text(
                    'Desbloquear',
                    style: TextStyle(
                        fontSize: 30,
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
