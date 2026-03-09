import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:prueba_buffet/app/controllers/order_controller.dart';
import 'package:prueba_buffet/app/controllers/main_shell_controller.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';

class Order extends StatelessWidget with ResponsiveMixin {
  final ScrollController scrollController = ScrollController();
  final OrderController controller = Get.find();

  Order({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFE500),
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: setSp(30),
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Mis pedidos',
          style: TextStyle(
            color: Colors.black,
            fontSize: setSp(22),
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      body: Column(
        children: [
          // Tabs
          Container(
            color: const Color(0xFFFFE500),
            height: setHeight(80),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: setWidth(24), vertical: setHeight(8)),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D303E),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Activos",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: setSp(18),
                    ),
                  ),
                ),
                SizedBox(width: setWidth(20)),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "Vencidos",
                    style: TextStyle(
                      color: const Color(0xFF414141),
                      fontWeight: FontWeight.w500,
                      fontSize: setSp(18),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Lista de pedidos
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFFFFE500)),
                );
              }
              if (controller.allOrders.isEmpty) {
                return Center(
                  child: Text(
                    'No tenés pedidos aún',
                    style: TextStyle(
                      color: const Color(0xFF999999),
                      fontSize: setSp(18),
                    ),
                  ),
                );
              }
              return ListView.separated(
                padding: EdgeInsets.only(
                  top: setHeight(20),
                  bottom: setHeight(100),
                  left: setWidth(20),
                  right: setWidth(20),
                ),
                itemCount: controller.allOrders.length,
                separatorBuilder: (_, __) => SizedBox(height: setHeight(16)),
                itemBuilder: (_, i) {
                  final order = controller.allOrders[i] as Map<String, dynamic>;

                  return RepaintBoundary(
                    child: ExpandableTicketCard(order: order),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

// Contenido interno del Ticket
class TicketContent extends StatelessWidget with ResponsiveMixin {
  final Map<String, dynamic> order;
  const TicketContent({super.key, required this.order});

  String _formatDate(String? raw) {
    if (raw == null) return '-';
    try {
      final dt = DateTime.parse(raw);
      return DateFormat("dd MMM yyyy", "es").format(dt);
    } catch (_) {
      return raw;
    }
  }

  String _formatTime(String? raw) {
    if (raw == null) return '-';
    try {
      final dt = DateTime.parse(raw);
      return DateFormat("HH:mm").format(dt);
    } catch (_) {
      return '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = (order['products'] as List?) ?? [];
    final productNames = products.map((p) => p['name'] as String).join(', ');
    final total = order['total'];
    final datetime = order['datetime_order'] as String?;
    final mpPaymentId = order['mp_payment_id'];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Parte superior del ticket
        Padding(
          padding: EdgeInsets.fromLTRB(
              setWidth(24), setHeight(24), setWidth(24), setHeight(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLabel('Lugar de retiro'),
                  _buildLabel('Total'),
                ],
              ),
              SizedBox(height: setHeight(4)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildValue('Buffet', setSp(20)),
                  _buildValue('\$$total', setSp(20)),
                ],
              ),
              SizedBox(height: setHeight(16)),
              _buildLabel('Productos'),
              SizedBox(height: setHeight(4)),
              _buildValue(
                  productNames.isNotEmpty ? productNames : '-', setSp(16)),
            ],
          ),
        ),

        // Línea punteada
        Padding(
          padding: EdgeInsets.symmetric(horizontal: setWidth(24)),
          child: CustomPaint(
            isComplex: true,
            willChange: false,
            size: Size(double.infinity, setHeight(1)),
            painter: DashedLinePainter(),
          ),
        ),

        // Parte inferior del ticket
        Padding(
          padding: EdgeInsets.fromLTRB(
              setWidth(24), setHeight(16), setWidth(24), setHeight(24)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLabel('Fecha de retiro'),
                  _buildLabel('Hora'),
                ],
              ),
              SizedBox(height: setHeight(8)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildValue(_formatDate(datetime), setSp(14)),
                  _buildValue(_formatTime(datetime), setSp(14)),
                ],
              ),
              SizedBox(height: setHeight(24)),
              Column(
                children: [
                  SizedBox(
                    height: setHeight(25),
                    child: Text(
                      mpPaymentId != null ? 'N° de pago' : 'ID Pedido',
                      style: TextStyle(
                          fontSize: setSp(19), fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: setHeight(4)),
                  Text(
                    mpPaymentId?.toString() ?? '#${order['id']}',
                    style: TextStyle(
                      fontSize: setSp(15),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Color(0xFF7A7878),
      ),
    );
  }

  Widget _buildValue(String text, double fontSize) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: fontSize,
        color: const Color(0xFF111111),
      ),
    );
  }
}

// --- UTILIDADES GRÁFICAS ---

// Crea los recortes semicirculares a los lados del ticket
class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    const double holeRadius = 12.0;
    // Posición aproximada de la línea punteada
    final double holePosition = size.height * 0.52;

    // Recorte izquierdo
    path.addOval(
        Rect.fromCircle(center: Offset(0, holePosition), radius: holeRadius));
    // Recorte derecho
    path.addOval(Rect.fromCircle(
        center: Offset(size.width, holePosition), radius: holeRadius));

    // FillType.evenOdd permite que los óvalos "corten" el rectángulo principal
    path.fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Dibuja la línea horizontal punteada
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 5.0;
    double dashSpace = 4.0;
    double startX = 0.0;

    final paint = Paint()
      ..color = const Color(0xFFBDBDBD)
      ..strokeWidth = 1.5;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ExpandableTicketCard extends StatefulWidget {
  final Map<String, dynamic> order;
  const ExpandableTicketCard({super.key, required this.order});

  @override
  State<ExpandableTicketCard> createState() => _ExpandableTicketCardState();
}

class _ExpandableTicketCardState extends State<ExpandableTicketCard>
    with SingleTickerProviderStateMixin, ResponsiveMixin {
  bool isExpanded = false;

  String _formatDate(String? raw) {
    if (raw == null) return '-';
    try {
      final dt = DateTime.parse(raw);
      return DateFormat("dd MMM yyyy", "es").format(dt);
    } catch (_) {
      return raw;
    }
  }

  Color _statusColor(String? status) {
    switch (status) {
      case 'PAGADO':
        return const Color(0xFF67FF5E);
      case 'PENDIENTE_PAGO':
        return const Color(0xFFFFE500);
      case 'CANCELADO':
        return const Color(0xFFFF5252);
      default:
        return const Color(0xFFD7D7D7);
    }
  }

  String _statusLabel(String? status) {
    switch (status) {
      case 'PAGADO':
        return 'Pagado';
      case 'PENDIENTE_PAGO':
        return 'Pendiente';
      case 'CANCELADO':
        return 'Cancelado';
      default:
        return status ?? '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: setWidth(20)),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA), // Fondo del contenedor exterior
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            // Cabecera (Siempre visible y clickeable)
            GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Container(
                // Color transparente para que todo el área sea clickeable
                color: Colors.transparent,
                padding: EdgeInsets.all(setWidth(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDate(widget.order['datetime_order'] as String?),
                      style: TextStyle(
                        fontSize: setSp(20),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: setWidth(16), vertical: setHeight(6)),
                      decoration: BoxDecoration(
                        color: _statusColor(widget.order['status'] as String?),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _statusLabel(widget.order['status'] as String?),
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: setSp(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Cuerpo del ticket (Colapsable)
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: isExpanded
                  ? Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TicketContent(order: widget.order),
                    )
                  : const SizedBox
                      .shrink(), // Oculta el contenido si no está expandido
            ),
          ],
        ),
      ),
    );
  }
}

/// Versión embebida en el MainShell (sin Scaffold/AppBar propio).
class OrderContent extends StatelessWidget with ResponsiveMixin {
  final ScrollController scrollController = ScrollController();
  final OrderController controller = Get.find();
  OrderContent({super.key}) {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        controller.fetchMoreOrders();
      }
    });
  }

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
          // Header amarillo (reemplaza AppBar)
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
          // Tabs
          Container(
            color: const Color(0xFFFFE500),
            height: setHeight(80),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: setWidth(24), vertical: setHeight(8)),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D303E),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Activos",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: setSp(18),
                    ),
                  ),
                ),
                SizedBox(width: setWidth(20)),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "Vencidos",
                    style: TextStyle(
                      color: const Color(0xFF414141),
                      fontWeight: FontWeight.w500,
                      fontSize: setSp(18),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Lista de pedidos
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFFFFE500)),
                );
              }
              if (controller.allOrders.isEmpty) {
                return Center(
                  child: Text(
                    'No tenés pedidos aún',
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
                itemCount: controller.ordersEncargadas.length,
                separatorBuilder: (_, __) => SizedBox(height: setHeight(16)),
                itemBuilder: (_, i) {
                  if (i == controller.ordersEncargadas.length) {
                    if (controller.isFetchingMore.value) {
                      return const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (controller.nextCursor == null &&
                        controller.ordersEncargadas.isNotEmpty) {
                      return const Center(
                          child: Text("No hay más transacciones"));
                    }
                    return const SizedBox.shrink();
                  }
                  final order = controller.ordersEncargadas[i];
                  return RepaintBoundary(
                    child: ExpandableTicketCard(order: order),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
