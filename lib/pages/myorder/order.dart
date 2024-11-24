import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/pages/myorder/order_controller.dart';

class orderScreen extends StatelessWidget {
  orderScreen({super.key});

  final orderController controller = Get.put(orderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffffe500),
        title: const Text(
          'Mis pedidos',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black, size: 35),
          onPressed: () {},
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tabs "Activos" y "Vencidos"
          Container(
            color: const Color(0xffffe500),
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff2d303e),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                  ),
                  child: const Text(
                    'Activos',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Vencidos',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff2d303e),
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Contenedor A
          Center(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 10, left: 30, right: 30),
              padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
              decoration: BoxDecoration(
                color: const Color(0xfffaf9f9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fecha y estado "Activo"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '29 Abril 2024',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                        decoration: BoxDecoration(
                          color: const Color(0xff75f94c),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'Activo',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Contenedor B
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 25),
                    decoration: BoxDecoration(
                      color: const Color(0xfff3f0f0),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                      ),
                      //border: Border(
                        //bottom: BorderSide(
                          //width: 3,
                          //color: Colors.black,
                          //style: BorderStyle.solid,
                        //),
                      //),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Lugar de retiro y horario
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Lugar de retiro',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Horario',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Buffet',
                              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 23),
                            ),
                            Text(
                              '09:30',
                              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 23),
                            ),
                          ],
                        ),
                        //linea divisora
                        //const Divider(height: 20, thickness: 1),
                        const SizedBox(height: 45),
                        // Método de pago
                        const Text(
                          'Método de Pago',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Transferencia',
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 23),),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          //container divisor BC
          Center(
            child: Container(
              height: 60,
              width: 304,
              decoration: BoxDecoration(
                color: const Color(0xfff3f0f0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Primer elemento blanco con bordes redondeados
                  Container(
                    width: 30,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                  ),
                  // Segundo elemento: texto centrado
                  Expanded(
                    child: Text(
                      "- - - - - - - - - - - - - - - - - - - -",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  // Tercer elemento blanco con bordes redondeados
                  Container(
                    width: 30,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Contenedor C
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 60),
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 30),
            decoration: BoxDecoration(
              color: const Color(0xfff3f0f0),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Fecha, Lugar, Hora
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Fecha',
                          style: TextStyle(fontWeight: FontWeight.w500, color: const Color(0xff797878)),
                        ),
                        SizedBox(height: 4),
                        Text('30 Abril 2024',
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: const Color(0xff2e313f)),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Lugar',
                          style: TextStyle(fontWeight: FontWeight.w500, color: const Color(0xff797878)),
                        ),
                        SizedBox(height: 4),
                        Text('Buffet',
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: const Color(0xff2e313f)),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Hora',
                          style: TextStyle(fontWeight: FontWeight.w500, color: const Color(0xff797878)),
                        ),
                        SizedBox(height: 4),
                        Text('9:30',
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: const Color(0xff2e313f)),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Imagen de código de barras
                Image.asset(
                  'assets/images/pedido/barra.png',
                  width: 130,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
