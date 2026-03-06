import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/success_controller.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';

class SuccessScreen extends StatelessWidget with ResponsiveMixin {
  SuccessScreen({super.key});

  final SuccessController successController = Get.find<SuccessController>();

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
                  width: setWidth(400),
                ),
                Text(
                  successController.isPaymentForBalance
                      ? "¡Carga de saldo realizada con éxito!"
                      : "¡Compra realizada con éxito!",
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: setSp(25), fontWeight: FontWeight.w600),
                ),
                Text(
                  successController.isPaymentForBalance
                      ? "Puedes ver tus movimientos en la sección \"Mi saldo\""
                      : "Puedes ver tus pedidos en la sección \"Mis pedidos\"",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF999999),
                    fontSize: setSp(20),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: setHeight(60),
                  width: setWidth(350),
                  child: ElevatedButton(
                    onPressed: () {
                      successController.goToOrderScreen();
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(setHeight(10)),
                        ),
                        backgroundColor: const Color(0xFFFFE500)),
                    child: Text(
                      "Mis Pedidos",
                      style: TextStyle(
                          fontSize: setSp(25),
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                SizedBox(height: setHeight(20)),
                GestureDetector(
                  onTap: () {
                    successController.goToHomeScreen();
                  },
                  child: Text(
                    "Volver a Inicio",
                    style: TextStyle(
                        fontSize: setSp(20),
                        color: const Color(0xFF999999),
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
