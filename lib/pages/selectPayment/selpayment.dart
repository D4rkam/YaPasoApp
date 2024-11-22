import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/pages/selectPayment/selpayment_controller.dart';

class SelpaymentScreen extends StatelessWidget {
  SelpaymentScreen({super.key});

  final SelpaymentController controller = Get.put(SelpaymentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Pago',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Botones superiores
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    padding: const EdgeInsets.only(left: 10, right: 120, bottom: 10, top: 10),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // Acción pendiente
                  },
                  child: const Text(
                    "Horario de Retiro",
                    style: TextStyle(color: Colors.grey, fontSize: 22),
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE500),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 4),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.access_time, color: Colors.black),
                    onPressed: () {
                      // Acción pendiente
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            // Título Método de pago
            const Text(
              "Método de Pago",
              style: TextStyle(fontSize: 27, color: Colors.black, fontWeight: FontWeight.w600),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 30),
            // Cajas con sombreado
            Column(
              children: [
                _buildPaymentOption(
                  context,
                  image: "assets/images/pago/celu.png", // Imagen subida
                  title: "Transferencia",
                  isSelected: true,
                ),
                const SizedBox(height: 20),
                _buildPaymentOption(
                  context,
                  image: "assets/images/pago/dinero.png", // Imagen subida
                  title: "Efectivo",
                  isSelected: false,
                ),
              ],
            ),
            const Spacer(),
            // Botón Confirmar pedido
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFE500),
                padding: const EdgeInsets.symmetric(vertical: 21, horizontal: 25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {
                // Acción pendiente
              },
              child: const Text(
                "Confirmar pedido",
                style: TextStyle(fontSize: 30, color: Colors.black),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(BuildContext context,
      {required String image,
        required String title,
        required bool isSelected}) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF2c2f3d) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            image,
            height: 70,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
          GestureDetector(
            onTap: () {
              // Acción pendiente
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.yellow : Colors.white,
                border: Border.all(color: const Color(0xFF2c2f3d), width: 4),
              ),
              child: isSelected
                  ? Center(
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
