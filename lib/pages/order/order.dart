import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/pages/order/order_controller.dart';

class Order extends StatelessWidget {
  Order({super.key});

  final OrderController orderController = Get.put(OrderController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFE500),
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Mis Pedidos',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: const Color(0xFFFFE500),
              height: 100,
              width: double.infinity,
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFF2D303E),
                    ),
                    child: const Text(
                      "Activos",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 25),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFFFFE500),
                    ),
                    child: const Text(
                      "Vencidos",
                      style: TextStyle(
                          color: Color(0xFF414141),
                          fontWeight: FontWeight.w500,
                          fontSize: 25),
                    ),
                  )
                ],
              )),
            ),
            (orderController.formattedDateTime.isNotEmpty)
                ? CustomExpandablePanel(orderController: orderController)
                : Container()
          ],
        ),
      ),
    );
  }
}

class TicketCard extends StatelessWidget {
  const TicketCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Detalles del ticket
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Lugar de retiro',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Color(0xFF7A7878)),
                  ),
                  Text(
                    'Horario',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Color(0xFF7A7878)),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Buffet',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    '09:30',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Método de Pago',
                style: TextStyle(
                    fontWeight: FontWeight.w500, color: Color(0xFF7A7878)),
              ),
              SizedBox(height: 4),
              Text(
                'Transferencia',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
        ),
        // Línea punteada
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Divider(
            color: Colors.grey[400],
            height: 1,
            thickness: 2,
            endIndent: 8,
            indent: 8,
          ),
        ),
        // Información adicional
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Fecha',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xFF7A7878)),
              ),
              Text(
                'Lugar',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xFF7A7878)),
              ),
              Text(
                'Hora',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xFF7A7878)),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('26 / 11 / 2024',
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF2E313F),
                      fontWeight: FontWeight.bold)),
              Text('Buffet',
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF2E313F),
                      fontWeight: FontWeight.bold)),
              Text('9:30',
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF2E313F),
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        // Código de barras
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              SizedBox(
                height: 60,
                child: Image.asset(
                    "assets/images/codigo_barra.png"), // Aquí puedes usar un paquete de código de barras
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomExpandablePanel extends StatefulWidget {
  const CustomExpandablePanel({super.key, required this.orderController});

  final OrderController orderController;

  @override
  _CustomExpandablePanelState createState() => _CustomExpandablePanelState();
}

class _CustomExpandablePanelState extends State<CustomExpandablePanel>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado (siempre visible)
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => Text(
                      widget.orderController.formattedDateTime.value,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 113, 255, 118),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Activo',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Contenido expandible con animación de tamaño
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: AnimatedOpacity(
              opacity: isExpanded ? 1 : 0,
              duration: const Duration(milliseconds: 600),
              child: isExpanded
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: TicketCard(),
                      ))
                  : Container(),
            ),
          ),
        ],
      ),
    );
  }
}
