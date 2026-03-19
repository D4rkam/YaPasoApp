import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/pay_state_controller.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';

class SuccessScreen extends StatelessWidget with ResponsiveMixin {
  SuccessScreen({super.key});

  final PayStateController successController = Get.find<PayStateController>();

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
                  mainAxisAlignment: MainAxisAlignment.center, // Centramos todo
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: setWidth(20)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            successController.isPaymentForBalance
                                ? "assets/images/CARGA_SALDO_EXITOSO.webp"
                                : "assets/images/COMPRA_EXITOSA.webp",
                            width: setWidth(350),
                            fit: BoxFit
                                .contain, // Para que la imagen no rompa bordes
                          ),
                          SizedBox(height: setHeight(20)),
                          Text(
                            successController.isPaymentForBalance
                                ? "¡Carga de saldo realizada con éxito!"
                                : "¡Compra realizada con éxito!",
                            maxLines:
                                3, // Permitimos 3 líneas por si la fuente es grande
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: setSp(25),
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: setHeight(15)),
                          Text(
                            successController.isPaymentForBalance
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
                    // El botón está comentado en tu código, si lo descomentás, ponelo acá abajo
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
