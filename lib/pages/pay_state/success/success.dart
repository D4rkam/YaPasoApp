import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/pages/pay_state/success/success_controller.dart';

class SuccessScreen extends StatefulWidget {
  @override
  SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  final SuccessController successController = Get.put(SuccessController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    successController.createOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/images/order_confirm.png",
                  width: 400,
                ),
                const Text(
                  "¡Compra realizada con exito!",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                ),
                const Text(
                  "Puedes seguir la entrega en la sección \"mis pedidos\"",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF999999),
                    fontSize: 25,
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 80,
                  width: 350,
                  child: ElevatedButton(
                    onPressed: () {
                      successController.goToOrderScreen();
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: const Color(0xFFFFE500)),
                    child: const Text(
                      "Mis Pedidos",
                      style: TextStyle(
                          fontSize: 35,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    successController.goToHomeScreen();
                  },
                  child: const Text(
                    "Volver a Inicio",
                    style: TextStyle(
                        fontSize: 25,
                        color: Color(0xFF999999),
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
