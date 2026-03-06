import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';

class FailureScreen extends StatelessWidget with ResponsiveMixin {
  FailureScreen({super.key});

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
                  "assets/images/error_pago.png",
                  width: setWidth(400),
                ),
                Text(
                  "¡Falló la transacción!",
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: setSp(25), fontWeight: FontWeight.w600),
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
                      Get.toNamed("/home");
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(setHeight(10)),
                        ),
                        backgroundColor: const Color(0xFFFFE500)),
                    child: Text(
                      "Volver a Inicio",
                      style: TextStyle(
                          fontSize: setSp(25),
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                SizedBox(
                  height: setHeight(20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
