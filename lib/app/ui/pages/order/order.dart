import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/order_controller.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';

class Order extends StatelessWidget with ResponsiveMixin {
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
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: setSp(30),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Mis Pedidos',
          style: TextStyle(fontSize: setSp(25), fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: const Color(0xFFFFE500),
              height: setHeight(100),
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
                    child: Text(
                      "Activos",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: setSp(25)),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFFFFE500),
                    ),
                    child: Text(
                      "Vencidos",
                      style: TextStyle(
                          color: const Color(0xFF414141),
                          fontWeight: FontWeight.w500,
                          fontSize: setSp(25)),
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

class TicketCard extends StatelessWidget with ResponsiveMixin {
  const TicketCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Detalles del ticket
        Padding(
          padding: EdgeInsets.all(setWidth(16.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
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
              SizedBox(height: setHeight(4)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Buffet',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: setSp(18)),
                  ),
                  Text(
                    '09:30',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: setSp(18)),
                  ),
                ],
              ),
              SizedBox(height: setHeight(16)),
              const Text(
                'Método de Pago',
                style: TextStyle(
                    fontWeight: FontWeight.w500, color: Color(0xFF7A7878)),
              ),
              SizedBox(height: setHeight(4)),
              Text(
                'Transferencia',
                style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: setSp(18)),
              ),
            ],
          ),
        ),
        // Línea punteada
        Padding(
          padding: EdgeInsets.symmetric(horizontal: setWidth(16)),
          child: Divider(
            color: Colors.grey[400],
            height: setHeight(1),
            thickness: setHeight(2),
            endIndent: setWidth(8),
            indent: setWidth(8),
          ),
        ),
        // Información adicional
        Padding(
          padding: EdgeInsets.all(setWidth(16.0)),
          child: const Row(
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
        Padding(
          padding: EdgeInsets.all(setWidth(8.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('26 / 11 / 2024',
                  style: TextStyle(
                      fontSize: setSp(16),
                      color: const Color(0xFF2E313F),
                      fontWeight: FontWeight.bold)),
              Text('Buffet',
                  style: TextStyle(
                      fontSize: setSp(16),
                      color: const Color(0xFF2E313F),
                      fontWeight: FontWeight.bold)),
              Text('9:30',
                  style: TextStyle(
                      fontSize: setSp(16),
                      color: const Color(0xFF2E313F),
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        // Código de barras
        Padding(
          padding: EdgeInsets.symmetric(vertical: setHeight(16)),
          child: Column(
            children: [
              SizedBox(
                height: setHeight(60),
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
    with SingleTickerProviderStateMixin, ResponsiveMixin {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(setWidth(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: setWidth(10),
            spreadRadius: setWidth(2),
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
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              padding: EdgeInsets.all(setWidth(16)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => Text(
                      widget.orderController.formattedDateTime.value,
                      style: TextStyle(
                          fontSize: setSp(18), fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: setWidth(12), vertical: setHeight(6)),
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
                  ? Padding(
                      padding: EdgeInsets.all(setWidth(16)),
                      child: const Center(
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
