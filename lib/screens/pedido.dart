import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PedidoScreen extends StatefulWidget {
  const PedidoScreen({super.key});

  @override
  State<PedidoScreen> createState() => _PedidoScreenState();
}

class _PedidoScreenState extends State<PedidoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _precioController = TextEditingController();

  Future<void> _submitPedido() async {
    final String nombre = _nombreController.text;
    final String descripcion = _descripcionController.text;
    final double precio = double.parse(_precioController.text);

    final response = await http.post(
      Uri.parse('http://192.168.16.114:8000/pedido'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'nombre': nombre,
        'descripcion': descripcion,
        'precio': precio,
      }),
    );

    if (response.statusCode == 200) {
      // Pedido creado exitosamente
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pedido enviado exitosamente')),
      );
    } else {
      // Error al crear el pedido
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al enviar el pedido')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nombreController,
                decoration:
                    const InputDecoration(labelText: 'Nombre del Producto'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre del producto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la descripción';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _precioController,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el precio';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor ingrese un precio válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _submitPedido();
                  }
                },
                child: const Text('Enviar Pedido'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
