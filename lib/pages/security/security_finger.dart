import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:prueba_buffet/pages/security/security_finger_controller.dart';

class SecurityFinger extends StatefulWidget {
  const SecurityFinger({super.key});

  @override
  State<SecurityFinger> createState() => _SecurityFingerState();
}

class _SecurityFingerState extends State<SecurityFinger> {
  final LocalAuthentication auth = LocalAuthentication();
  final SecurityFingerController securityFingerController =
      Get.put(SecurityFingerController());

  Future<void> _authenticate() async {
    try {
      final isAuthenticated = await auth.authenticate(
        localizedReason: 'Escanee su huella digital',
        options: const AuthenticationOptions(
          biometricOnly: false,
        ),
      );
      if (isAuthenticated) {
        securityFingerController.goToHomeScreen();
      }
    } catch (e) {
      // Handle authentication errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Authentication failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
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
