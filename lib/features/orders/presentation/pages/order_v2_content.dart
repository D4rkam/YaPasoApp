import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/features/orders/presentation/controllers/order_controller_v2.dart';
import 'package:prueba_buffet/app/controllers/main_shell_controller.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Reutilizamos los widgets de la UI legacy (ExpandableTicketCard, TicketContent, etc.)
import 'package:prueba_buffet/app/ui/pages/order/order.dart'
    show ExpandableTicketCard;

/// Versión V2 del contenido de Orders, embebido en el MainShell.
class OrderV2Content extends StatelessWidget with ResponsiveMixin {
  final ScrollController scrollController = ScrollController();
  final OrderControllerV2 controller = Get.find<OrderControllerV2>();

  OrderV2Content({super.key});

  @override
  Widget build(BuildContext context) {
    final MainShellController shellController = Get.find();
    return NotificationListener<UserScrollNotification>(
      onNotification: (notification) {
        shellController.updateScrollDirection(notification.direction);
        return true;
      },
      child: Column(
        children: [
          Container(
            color: const Color(0xFFFFE500),
            width: double.infinity,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.only(
                  left: setWidth(20),
                  top: setHeight(16),
                  bottom: setHeight(8),
                ),
                child: Text(
                  'Mis pedidos',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: setSp(22),
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
          Container(
            color: const Color(0xFFFFE500),
            height: setHeight(70),
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: setWidth(20)),
              child: Obx(() => Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildTab('En fila', 'ENCARGADO'),
                      SizedBox(width: setWidth(12)),
                      _buildTab('Listos', 'LISTO'),
                      SizedBox(width: setWidth(12)),
                      _buildTab('Retirados', 'ENTREGADO'),
                    ],
                  )),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFFFFE500)),
                );
              }
              if (controller.currentOrders.isEmpty) {
                return Center(
                  child: Text(
                    controller.activeTab.value == 'ENCARGADO'
                        ? 'No tenés pedidos en fila'
                        : 'No tenés pedidos retirados',
                    style: TextStyle(
                      color: const Color(0xFF999999),
                      fontSize: setSp(18),
                    ),
                  ),
                );
              }
              return ListView.separated(
                controller: scrollController,
                padding: EdgeInsets.only(
                  top: setHeight(20),
                  bottom: setHeight(100),
                  left: setWidth(20),
                  right: setWidth(20),
                ),
                itemCount: controller.currentOrders.length + 1,
                separatorBuilder: (_, __) => SizedBox(height: setHeight(16)),
                itemBuilder: (_, i) {
                  if (i == controller.currentOrders.length) {
                    if (controller.isFetchingMore.value) {
                      return const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Center(
                            child: CircularProgressIndicator(
                                color: Color(0xFFFFE500))),
                      );
                    }
                    if (controller.currentCursor != null) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: setHeight(20)),
                        child: Center(
                          child: TextButton(
                            onPressed: () => controller.fetchMoreOrders(),
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(0xFFF0F0F0),
                              padding: EdgeInsets.symmetric(
                                  horizontal: setWidth(24),
                                  vertical: setHeight(12)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            child: const Text(
                              "Buscar pedidos más antiguos",
                              style: TextStyle(
                                  color: Color(0xFF414141),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }

                  final order = controller.currentOrders[i];
                  return RepaintBoundary(
                    child: ExpandableTicketCard(order: order),
                  )
                      .animate()
                      .fade(duration: 300.ms)
                      .slideY(begin: 0.1, end: 0, duration: 250.ms);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, String status) {
    final isActive = controller.activeTab.value == status;

    return GestureDetector(
      onTap: () => controller.switchTab(status),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
            horizontal: setWidth(24), vertical: setHeight(10)),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF2D303E) : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFF5E5400),
            fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
            fontSize: setSp(16),
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
