import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:prueba_buffet/app/controllers/order_controller.dart';
import 'package:prueba_buffet/app/controllers/main_shell_controller.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
              SizedBox(height: setHeight(20)),

              _buildLabel('Productos'),
              SizedBox(height: setHeight(8)),

              // Lista de productos organizada verticalmente (Cant y Nombre)
              if (products.isEmpty)
                _buildValue('-', setSp(16))
              else
                Column(
                  children: products.map((p) {
                    final qty = p['quantity'] ?? 1;
                    final name = p['name'] ?? 'Producto';
                    return Padding(
                      padding: EdgeInsets.only(bottom: setHeight(8)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${qty}x',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: setSp(16),
                              color: const Color(0xFF111111),
                            ),
                          ),
                          SizedBox(width: setWidth(12)),
                          Expanded(
                            child: Text(
                              name.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: setSp(16),
                                color: const Color(0xFF111111),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),

        // Línea punteada única
        Padding(
          padding: EdgeInsets.symmetric(horizontal: setWidth(24)),
          child: CustomPaint(
            isComplex: true,
            willChange: false,
            size: Size(double.infinity, setHeight(1)),
            painter: DashedLinePainter(),
          ),
        ),

        // Parte inferior del ticket (Fechas y N° Pedido gigante)
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
              SizedBox(height: setHeight(28)),

              // ---> CORRECCIÓN: N° de Pedido como protagonista absoluto
              Column(
                children: [
                  Text(
                    'N° de Pedido',
                    style: TextStyle(
                        fontSize: setSp(14),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF7A7878)),
                  ),
                  SizedBox(height: setHeight(4)),
                  Text(
                    '#${order['id']}',
                    style: TextStyle(
                      fontSize: setSp(18), // Bien grande
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                      color: const Color(0xFF111111),
                    ),
                  ),
                ],
              ),

              SizedBox(height: setHeight(28)),

              // ---> CORRECCIÓN: Detalle sutil al final
              Text(
                mpPaymentId != null
                    ? "Pagado vía Mercado Pago (Ref: $mpPaymentId)"
                    : "Pagado con Saldo Virtual",
                style: TextStyle(
                  fontSize: setSp(11), // Letra muy chiquita, como letra chica
                  color:
                      const Color(0xFF999999), // Gris claro para que no compita
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: setHeight(4)),
              Text(
                "¡Gracias por usar Ya Paso!",
                style: TextStyle(
                  fontSize: setSp(12),
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF7A7878),
                  fontStyle: FontStyle.italic,
                ),
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
class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    const double holeRadius = 12.0;
    final double holePosition = size.height * 0.52;

    path.addOval(
        Rect.fromCircle(center: Offset(0, holePosition), radius: holeRadius));
    path.addOval(Rect.fromCircle(
        center: Offset(size.width, holePosition), radius: holeRadius));

    path.fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

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

  bool _isNewOrder(String? createdAtString) {
    if (createdAtString == null) return false;
    try {
      final createdAt = DateTime.parse(createdAtString);
      return DateTime.now().difference(createdAt).inMinutes < 5;
    } catch (e) {
      return false;
    }
  }

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

  Color _statusColor(String? status) {
    switch (status) {
      case 'LISTO':
        return const Color(0xFF67FF5E);
      case 'ENTREGADO':
        return const Color(0xFFE0E0E0);
      case 'PENDIENTE_PAGO':
      case 'ENCARGADO':
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
      case 'ENTREGADO':
        return 'Retirado';
      case 'LISTO':
        return '¡Listo!';
      case 'PENDIENTE_PAGO':
        return 'Pendiente';
      case 'ENCARGADO':
        return 'En preparación';
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
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.all(setWidth(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // LADO IZQUIERDO: Información del pedido
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pedido #${widget.order['id']}",
                            style: TextStyle(
                              fontSize: setSp(18),
                              fontWeight: FontWeight.w900,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: setHeight(4)),
                          Text(
                            "${_formatDate(widget.order['datetime_order'])}  •  ${_formatTime(widget.order['datetime_order'])}",
                            style: TextStyle(
                              fontSize: setSp(14),
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF888888),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: setWidth(8)),

                    // LADO DERECHO: Estado y Etiqueta Nuevo
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: setWidth(12), vertical: setHeight(6)),
                          decoration: BoxDecoration(
                            color:
                                _statusColor(widget.order['status'] as String?),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          constraints: BoxConstraints(maxWidth: setWidth(110)),
                          child: Text(
                            _statusLabel(widget.order['status'] as String?),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: setSp(13),
                            ),
                          ),
                        ),

                        // ---> FIX: Etiqueta NUEVO debajo del estado
                        if (_isNewOrder(
                            widget.order['created_at'] as String?)) ...[
                          SizedBox(height: setHeight(6)),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF4D4D),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              "NUEVO",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1,
                              ),
                            ),
                          )
                              .animate(
                                  onPlay: (controller) =>
                                      controller.repeat(reverse: true))
                              .scale(
                                  begin: const Offset(1, 1),
                                  end: const Offset(1.08, 1.08),
                                  duration: 800.ms,
                                  curve: Curves.easeInOut)
                              .tint(color: Colors.white24, duration: 800.ms),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
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
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Versión embebida en el MainShell
class OrderContent extends StatelessWidget with ResponsiveMixin {
  final ScrollController scrollController = ScrollController();
  final OrderController controller = Get.find();

  OrderContent({super.key});

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
            height: setHeight(
                70), // Un poquito más ajustado para que quede elegante
            width: double.infinity,
            // Usamos un SingleChildScrollView para que los botones mantengan su tamaño real
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(), // Efecto rebote nativo
              padding: EdgeInsets.symmetric(
                  horizontal: setWidth(20)), // Margen inicial
              child: Obx(() => Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildTab('En fila', 'ENCARGADO'),
                      SizedBox(
                          width: setWidth(12)), // Espaciado fijo entre píldoras
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
              // ---> NUEVO: Leemos currentOrders que ya sabe qué pestaña estamos viendo
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
                  // ---> NUEVO: Paginación usando las variables maestras
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
        // Recuperamos el padding generoso original de tu diseño
        padding: EdgeInsets.symmetric(
            horizontal: setWidth(24), vertical: setHeight(10)),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF2D303E) : Colors.transparent,
          borderRadius: BorderRadius.circular(25), // Bordes bien redondeados
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive
                ? Colors.white
                : const Color(
                    0xFF5E5400), // El mismo tono oscuro que usas en el AppBar
            fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
            fontSize: setSp(16), // Tamaño de fuente equilibrado
            letterSpacing: 0.3, // Un pequeñísimo espaciado para mejor lectura
          ),
        ),
      ),
    );
  }
}
