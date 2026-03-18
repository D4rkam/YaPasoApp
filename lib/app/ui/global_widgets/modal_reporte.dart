import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/data/provider/users_provider.dart';

class ModalReporte extends StatefulWidget {
  const ModalReporte({super.key});

  @override
  State<ModalReporte> createState() => _ModalReporteState();
}

class _ModalReporteState extends State<ModalReporte> {
  final TextEditingController _reporteController = TextEditingController();
  final UsersProvider _usersProvider = Get.find<UsersProvider>();

  String? _temaSeleccionado;
  bool _isLoading = false;

  final List<String> _temas = [
    'Problema con mi pedido',
    'Error con Mercado Pago / Saldo',
    'Falla en la aplicación',
    'Sugerencia de mejora',
    'Otro inconveniente'
  ];

  void _enviarReporte() async {
    if (_temaSeleccionado == null || _reporteController.text.trim().isEmpty) {
      Get.snackbar("Atención", "Por favor, completá todos los campos.",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    setState(() => _isLoading = true);
    // Simulación de envío al backend
    _usersProvider.sendReporte(
      subject: _temaSeleccionado!,
      description: _reporteController.text.trim(),
    );
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);

    Get.back();
    Get.snackbar("¡Enviado!", "Gracias por tu reporte, Thomas.",
        backgroundColor: const Color(0xFF6BBA4A), colorText: Colors.white);
  }

  @override
  void dispose() {
    _reporteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        // Decoración blanca del modal
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        // Usamos IntrinsicHeight para que el modal no intente ocupar toda la pantalla
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min, // CLAVE: Solo ocupa lo que necesita
            children: [
              // Barra de arrastre (Píldora)
              const SizedBox(height: 12),
              Container(
                width: 45,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 25),

              // Contenido con Padding lateral
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Reportar un problema",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Elegí un tema y contanos qué pasó.",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),

                    // Selector de Tema
                    _buildSelector(),

                    const SizedBox(height: 15),

                    // Campo de Texto
                    _buildTextArea(),

                    const SizedBox(height: 25),

                    // Botón Enviar (Sin espacios extra debajo)
                    _buildSubmitButton(),

                    // Este es el único respiro final. Si quieres que pegue
                    // literal al teclado, ponlo en 0 o 5.
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGETS INTERNOS PARA MANTENER EL BUILD LIMPIO ---

  Widget _buildSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint:
              const Text("Seleccioná un tema", style: TextStyle(fontSize: 15)),
          value: _temaSeleccionado,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          items: _temas
              .map((t) => DropdownMenuItem(value: t, child: Text(t)))
              .toList(),
          onChanged: (val) => setState(() => _temaSeleccionado = val),
        ),
      ),
    );
  }

  Widget _buildTextArea() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: TextField(
        controller: _reporteController,
        maxLines: 4,
        style: const TextStyle(fontSize: 15),
        decoration: const InputDecoration(
          hintText: "Ej: No puedo ver mi último pedido...",
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _enviarReporte,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFE500),
          foregroundColor: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                    color: Colors.black, strokeWidth: 2))
            : const Text("Enviar reporte",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
