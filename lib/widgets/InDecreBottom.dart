import 'package:flutter/material.dart';

class IncrementDecrementButton extends StatefulWidget {
  final int initialValue;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final Color? containerColor; // Color del contenedor
  final Color? iconColor; // Color de los íconos
  final Color? textColor; // Color del texto

  const IncrementDecrementButton({
    super.key,
    this.initialValue = 0, // Valor inicial
    required this.onChanged, // Callback para notificar cambios
    this.min = 0,           // Valor mínimo permitido
    this.max = 100,         // Valor máximo permitido
    this.containerColor = Colors.yellow, // Color predeterminado del contenedor
    this.iconColor = Colors.black,       // Color predeterminado de los íconos
    this.textColor = Colors.black,       // Color predeterminado del texto
  });

  @override
  _IncrementDecrementButtonState createState() => _IncrementDecrementButtonState();
}

class _IncrementDecrementButtonState extends State<IncrementDecrementButton> {
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialValue;
  }

  void _increment() {
    if (_quantity < widget.max) {
      setState(() {
        _quantity++;
      });
      widget.onChanged(_quantity); // Notifica el cambio
    }
  }

  void _decrement() {
    if (_quantity > widget.min) {
      setState(() {
        _quantity--;
      });
      widget.onChanged(_quantity); // Notifica el cambio
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 106,
      height: 33,
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0), // Espaciado interno ajustado
      margin: const EdgeInsets.only(right: 15.0, bottom: 20.0),// Espaciado externo
      decoration: BoxDecoration(
        color: Colors.yellow, // Fondo amarillo
        borderRadius: BorderRadius.circular(5.0), // Bordes redondeados
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Sombra sutil
            blurRadius: 6.0,
            offset: Offset(0, 3), // Dirección de la sombra
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Ajusta el tamaño al contenido
        crossAxisAlignment: CrossAxisAlignment.center, // Centra los elementos verticalmente
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: _decrement,
            color: Colors.black,
          ),
          Text(
            '$_quantity',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _increment,
            color: Colors.black,
          ),
        ],
      ),
    );

  }
}
