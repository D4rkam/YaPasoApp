import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/features/pay_state/presentation/controllers/pay_state_controller_v2.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';

class SuccessV2Screen extends StatelessWidget with ResponsiveMixin {
  SuccessV2Screen({super.key});

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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: setWidth(20)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            controller.isPaymentForBalance
                                ? "assets/images/CARGA_SALDO_EXITOSO.webp"
                                : "assets/images/order_confirm.webp",
                            width: setWidth(350),
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: setHeight(20)),
                          Text(
                            controller.isPaymentForBalance
                                ? "¡Carga de saldo realizada con éxito!"
                                : "¡Compra realizada con éxito!",
                            maxLines: 3,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: setSp(25),
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: setHeight(15)),
                          Text(
                            controller.isPaymentForBalance
                                ? "Puedes ver tus movimientos en la sección \"Mi saldo\""
                                : "Puedes ver tus pedidos en la sección \"Mis pedidos\"",
                            maxLines: 3,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF999999),
                              fontSize: setSp(20),
                            ),
                          ),
                        ],
                      ),
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
