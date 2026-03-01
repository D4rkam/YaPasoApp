import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/success_controller.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';

class SuccessScreen extends StatefulWidget {
  @override
  SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> with ResponsiveMixin {
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
                  width: setWidth(400),
                ),
                Text(
                  "¡Compra realizada con exito!",
                  style: TextStyle(
                      fontSize: setSp(28), fontWeight: FontWeight.w600),
                ),
                Text(
                  "Puedes seguir la entrega en la sección \"mis pedidos\"",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF999999),
                    fontSize: setSp(25),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: setHeight(80),
                  width: setWidth(350),
                  child: ElevatedButton(
                    onPressed: () {
                      successController.goToOrderScreen();
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: const Color(0xFFFFE500)),
                    child: Text(
                      "Mis Pedidos",
                      style: TextStyle(
                          fontSize: setSp(35),
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                SizedBox(
                  height: setHeight(20),
                ),
                GestureDetector(
                  onTap: () {
                    successController.goToHomeScreen();
                  },
                  child: Text(
                    "Volver a Inicio",
                    style: TextStyle(
                        fontSize: setSp(25),
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
