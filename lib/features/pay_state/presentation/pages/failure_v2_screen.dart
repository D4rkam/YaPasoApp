import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/core/presentation/widgets/mixins/responsive_mixin.dart';
import 'package:prueba_buffet/features/pay_state/presentation/controllers/pay_state_controller_v2.dart';

class FailureV2Screen extends StatelessWidget with ResponsiveMixin {
  FailureV2Screen({super.key});
  final PayStateControllerV2 controller = Get.find<PayStateControllerV2>();

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
                          height: setHeight(400),
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                    "assets/images/error_pago.webp",
                                  ),
                                  fit: BoxFit.contain)),
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
