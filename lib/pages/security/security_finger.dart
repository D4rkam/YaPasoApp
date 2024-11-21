import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class SecurityFinger extends StatefulWidget {
  const SecurityFinger({super.key});

  @override
  State<SecurityFinger> createState() => _SecurityFingerState();
}

class _SecurityFingerState extends State<SecurityFinger> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isAuthenticating = false;

  Future<void> _authenticate() async {
    setState(() {
      _isAuthenticating = true;
    });
    try {
      final isAuthenticated = await auth.authenticate(
        localizedReason: 'Escanee su huella digital',
        options: const AuthenticationOptions(
          biometricOnly: false,
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
      if (isAuthenticated) {
        // Navigate to the next screen or perform other actions
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      setState(() {
        _isAuthenticating = false;
      });
      // Handle authentication errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Authentication failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_isAuthenticating)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _authenticate,
                child: const Text('Desbloquear'),
              ),
          ],
        ),
      ),
    );
  }
}
