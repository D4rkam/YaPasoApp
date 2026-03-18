import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/main_shell_controller.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';
import 'package:prueba_buffet/app/ui/global_widgets/modal_reporte.dart';

class AyudaContent extends StatelessWidget with ResponsiveMixin {
  const AyudaContent({super.key});

  @override
  Widget build(BuildContext context) {
    final MainShellController shellController = Get.find<MainShellController>();

    return Container(
      color: const Color(0xFFF9F9F9),
      child: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          shellController.updateScrollDirection(notification.direction);
          return true;
        },
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---> HEADER AMARILLO <---
                  Container(
                    width: double.infinity,
                    height: setHeight(120),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFE500),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(30),
                      ),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: setWidth(24), top: setHeight(20)),
                        child: Text(
                          'Centro de Ayuda',
                          style: TextStyle(
                            fontSize: setSp(25),
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: setHeight(30)),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: setWidth(24)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ---> PREGUNTAS FRECUENTES <---
                        _buildSectionTitle("Preguntas Frecuentes"),
                        _buildCard(
                          children: [
                            _buildFaqItem(
                              pregunta: "¿Cómo retiro mi pedido?",
                              respuesta:
                                  "Acercate a la fila de retiros rápidos del buffet (sin hacer la fila normal) y mostrale el estado 'Entregado' al vendedor desde la pestaña de 'Mis pedidos'.",
                            ),
                            _buildDivider(),
                            _buildFaqItem(
                              pregunta: "¿Cómo cargo saldo en mi cuenta?",
                              respuesta:
                                  "Podés cargar saldo directamente desde la app de Mercado Pago",
                            ),
                            _buildDivider(),
                            _buildFaqItem(
                              pregunta: "¿Qué pasa si me olvido de retirar?",
                              respuesta:
                                  "Tu pedido quedará separado y guardado hasta el final de tu turno escolar. Pasado ese tiempo, no se podrán realizar reembolsos.",
                            ),
                          ],
                        ),

                        SizedBox(height: setHeight(30)),

                        // ---> CONTACTO DIRECTO <---
                        _buildSectionTitle("¿Necesitás más ayuda?"),
                        _buildCard(
                          children: [
                            _buildContactItem(
                              title: "Reportar un problema",
                              subtitle: "Errores con pagos o pedidos rotos",
                              icon: Icons.report_problem_outlined,
                              iconColor: Colors.redAccent,
                              onTap: () {
                                Get.bottomSheet(
                                  const ModalReporte(),
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                            height: setHeight(
                                100)), // Espacio dinámico para la bottom bar
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // =======================================================
  // WIDGETS REUTILIZABLES DE LA PANTALLA DE AYUDA
  // =======================================================

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: setHeight(12), left: setWidth(5)),
      child: Text(
        title,
        style: TextStyle(
          fontSize: setSp(18),
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildFaqItem({required String pregunta, required String respuesta}) {
    return Theme(
      data: Get.theme.copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          pregunta,
          style: TextStyle(
            fontSize: setSp(15),
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        iconColor: const Color(0xFFFFE500),
        collapsedIconColor: const Color(0xFF999999),
        tilePadding: EdgeInsets.symmetric(
            horizontal: setWidth(16), vertical: setHeight(2)),
        childrenPadding: EdgeInsets.only(
            left: setWidth(16), right: setWidth(16), bottom: setHeight(16)),
        children: [
          Text(
            respuesta,
            style: TextStyle(
              fontSize: setSp(14),
              color: const Color(0xFF7A7878),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: setWidth(16), vertical: setHeight(16)),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(setWidth(10)),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: setSp(22)),
            ),
            SizedBox(width: setWidth(16)),
            Expanded(
              // 👈 Evita overflow en celulares angostos
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: setSp(16),
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: setHeight(2)),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: setSp(13),
                      color: const Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: setSp(16),
              color: const Color(0xFF999999),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: const Color(0xFFF0F0F0),
      indent: setWidth(16),
      endIndent: setWidth(16),
    );
  }
}
