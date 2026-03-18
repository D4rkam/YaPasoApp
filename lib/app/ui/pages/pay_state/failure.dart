import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/pay_state_controller.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';

class FailureScreen extends StatelessWidget with ResponsiveMixin {
  FailureScreen({super.key});
  final PayStateController payStateController = Get.find<PayStateController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: setWidth(400),
                          height: setHeight(
                              400), // Fijamos una altura máxima proporcional
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                    "assets/images/error_pago.png",
                                  ),
                                  fit: BoxFit
                                      .contain)), // contain evita que se corte
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: setWidth(20)),
                          child: Text(
                            "¡Falló la transacción!",
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: setSp(25),
                                fontWeight: FontWeight.w600),
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
                              Get.toNamed("/home");
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(setHeight(10)),
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
            ),
          );
        }),
      ),
    );
  }
}
