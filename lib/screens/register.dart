import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            'ENTRE CLASES',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFamily: 'Comic Sans MS',
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Registrate',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              labelText: 'Nombre',
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.yellow),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              labelText: 'Apellido',
              prefixIcon: const Icon(Icons.person_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Contraseña',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: const Icon(Icons.visibility_off),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              labelText: 'Nro de Legajo',
              prefixIcon: const Icon(Icons.badge),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Registrarme'),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text(
                '¿Ya tienes una cuenta? Registrate',
                style: TextStyle(color: Colors.yellow),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

Widget shoppingCart() {
  return Stack(
    children: [
      IconButton(
        onPressed: () {},
        icon: const Icon(Icons.shopping_cart),
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.white),
            padding:
                MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 20))),
      ),
      const Positioned(
        right: 1,
        top: 1,
        child: CircleAvatar(
          backgroundColor: Colors.black,
          radius: 11,
          child: Text("1",
              style: TextStyle(
                color: Colors.white,
              )),
        ),
      )
    ],
  );
}
