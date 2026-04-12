import 'package:get/get.dart';
import 'package:prueba_buffet/features/analytics/domain/constants/analytics_constants.dart';
import 'package:prueba_buffet/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:prueba_buffet/features/orders/domain/repositories/order_repository.dart';
import 'package:prueba_buffet/features/orders/domain/usecases/get_orders_use_case.dart';
import 'package:prueba_buffet/utils/logger.dart';

class OrderControllerV2 extends GetxController {
  late final GetOrdersUseCase _getOrders;

  RxString activeTab = 'ENCARGADO'.obs;

  // Un solo mapa reactivo para todas las pestañas
  RxMap<String, List<Map<String, dynamic>>> ordersData = {
    'ENCARGADO': <Map<String, dynamic>>[],
    'LISTO': <Map<String, dynamic>>[],
    'ENTREGADO': <Map<String, dynamic>>[],
  }.obs;

  Map<String, String?> cursors = {
    'ENCARGADO': null,
    'LISTO': null,
    'ENTREGADO': null,
  };

  Map<String, bool> hasFetched = {
    'ENCARGADO': false,
    'LISTO': false,
    'ENTREGADO': false,
  };

  RxBool isLoading = false.obs;
  RxBool isFetchingMore = false.obs;

  OrderControllerV2({required OrderRepository repository}) {
    _getOrders = GetOrdersUseCase(repository);
  }

  @override
  void onReady() {
    fetchInitialOrders();

    Get.find<AnalyticsRepository>().capture(
      eventName: AnalyticsEvents.viewOrderHistory,
    );
  }

  void switchTab(String tab) {
    if (activeTab.value == tab) return;
    activeTab.value = tab;
    if (!hasFetched[tab]!) {
      fetchOrders(tab, isInitial: true);
    }
  }

  List<Map<String, dynamic>> get currentOrders =>
      ordersData[activeTab.value] ?? [];
  String? get currentCursor => cursors[activeTab.value];

  void _sortOrders(List<Map<String, dynamic>> list) {
    list.sort((a, b) {
      final idA = a['id'] as int? ?? 0;
      final idB = b['id'] as int? ?? 0;
      return idB.compareTo(idA);
    });
  }

  void _mergeOrders(List<Map<String, dynamic>> incoming, String currentTab) {
    final Map<String, List<Map<String, dynamic>>> tempMap = {};
    ordersData.forEach((key, list) {
      tempMap[key] = List<Map<String, dynamic>>.from(list);
    });

    for (var newOrder in incoming) {
      final int? orderId = newOrder['id'];
      tempMap.forEach((key, list) {
        list.removeWhere((o) => o['id'] == orderId);
      });
      tempMap[currentTab]!.add(newOrder);
    }

    _sortOrders(tempMap[currentTab]!);
    ordersData.value = tempMap;
  }

  Future<void> fetchInitialOrders() async {
    hasFetched.updateAll((key, value) => false);
    cursors.updateAll((key, value) => null);
    ordersData.updateAll((key, value) => []);
    await fetchOrders(activeTab.value, isInitial: true);
  }

  Future<void> fetchOrders(String status, {bool isInitial = false}) async {
    if (isInitial) {
      isLoading.value = true;
    } else {
      if (cursors[status] == null || isFetchingMore.value) return;
      isFetchingMore.value = true;
    }

    try {
      final String? cursorToUse = isInitial ? null : cursors[status];
      final data = await _getOrders(
        cursor: cursorToUse,
        status: status,
      );

      final rawOrders = List<Map<String, dynamic>>.from(data['orders'] ?? []);

      // Traducimos el JSON al formato que espera la UI
      final incomingOrders = rawOrders.map((order) {
        final mappedOrder = Map<String, dynamic>.from(order);

        if (mappedOrder['items'] != null) {
          mappedOrder['products'] = (mappedOrder['items'] as List).map((item) {
            final productData = item['product'] ?? {};
            return {
              'id': item['product_id'],
              'name': productData['name'] ?? 'Producto',
              'price': item['unit_price'],
              'quantity': item['quantity'],
            };
          }).toList();
        } else {
          mappedOrder['products'] = [];
        }

        return mappedOrder;
      }).toList();

      final String? newCursor = data['next_cursor'] as String?;

      if (isInitial) {
        ordersData[status] = [];
        hasFetched[status] = true;
      }

      _mergeOrders(incomingOrders, status);
      cursors[status] = newCursor == cursors[status] ? null : newCursor;
    } catch (e) {
      logger.e("Error fetching orders for $status: $e");
    } finally {
      if (isInitial) {
        isLoading.value = false;
      } else {
        isFetchingMore.value = false;
      }
    }
  }

  Future<void> fetchMoreOrders() async {
    await fetchOrders(activeTab.value, isInitial: false);
  }
}
