import 'package:get/get.dart';
import 'package:prueba_buffet/app/data/provider/users_provider.dart';
import 'package:prueba_buffet/utils/logger.dart';

class OrderController extends GetxController {
  final UsersProvider usersProvider = Get.find();

  RxString activeTab = 'ENCARGADO'.obs;

  // ---> MAGIA AQUÍ: Un solo mapa reactivo para todas las pestañas. NO hay listas nuevas.
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

  @override
  void onInit() {
    super.onInit();
    fetchInitialOrders();
  }

  void switchTab(String tab) {
    if (activeTab.value == tab) return;
    activeTab.value = tab;
    if (!hasFetched[tab]!) {
      fetchOrders(tab, isInitial: true);
    }
  }

  // La UI siempre lee esta variable unificada. No le importa en qué pestaña estás.
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
    // 1. Creamos copias locales de todas las listas para no mutar el estado directamente
    final Map<String, List<Map<String, dynamic>>> tempMap = {};
    ordersData.forEach((key, list) {
      tempMap[key] = List<Map<String, dynamic>>.from(list);
    });

    // 2. Procesamos cada pedido que acaba de llegar del servidor
    for (var newOrder in incoming) {
      final int? orderId = newOrder['id'];

      // BARRIDO: Lo eliminamos de CUALQUIER pestaña donde pudiera estar guardado
      tempMap.forEach((key, list) {
        list.removeWhere((o) => o['id'] == orderId);
      });

      // INSERCIÓN: Lo agregamos exclusivamente a la pestaña a la que pertenece ahora
      tempMap[currentTab]!.add(newOrder);
    }

    // 3. Ordenamos la pestaña actual
    _sortOrders(tempMap[currentTab]!);

    // 4. Sobrescribimos el mapa reactivo de GetX para que actualice toda la UI de golpe
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
      final response = await usersProvider.getOrders(
        cursor: cursorToUse,
        status: status,
      );

      if (response.statusCode == 200 &&
          response.data != null &&
          response.data["orders"] is List) {
        final rawOrders =
            List<Map<String, dynamic>>.from(response.data["orders"]);

        // ---> LA MAGIA: Traducimos el JSON nuevo al formato que espera la UI <---
        final incomingOrders = rawOrders.map((order) {
          // Hacemos una copia para poder modificarla
          final mappedOrder = Map<String, dynamic>.from(order);

          if (mappedOrder['items'] != null) {
            // Transformamos 'items' en 'products' para que la tarjeta no se rompa
            mappedOrder['products'] =
                (mappedOrder['items'] as List).map((item) {
              final productData = item['product'] ?? {};
              return {
                'id': item['product_id'],
                'name': productData['name'] ?? 'Producto',
                'price': item['unit_price'],
                'quantity': item[
                    'quantity'], // Usamos la cantidad comprada, no el stock!
              };
            }).toList();
          } else {
            mappedOrder['products'] = [];
          }

          return mappedOrder;
        }).toList();

        final String? newCursor = response.data["next_cursor"];

        if (isInitial) {
          ordersData[status] = [];
          hasFetched[status] = true;
        }

        // Le pasamos las órdenes ya traducidas a la función de merge
        _mergeOrders(incomingOrders, status);
        cursors[status] = newCursor == cursors[status] ? null : newCursor;
      } else {
        if (isInitial) hasFetched[status] = true;
      }
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
