import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/data/provider/users_provider.dart';

class OrderController extends GetxController {
  final UsersProvider usersProvider = Get.find();
  RxList<Map<String, dynamic>> allOrders = <Map<String, dynamic>>[].obs;
  final formattedDateTime = "".obs;
  RxBool isLoading = false.obs;
  RxBool isFetchingMore = false.obs;
  String? nextCursor;

  /// Orden pendiente de inyectar localmente.
  /// Se usa cuando el pago ocurre antes de que carguen las órdenes.
  Map<String, dynamic>? _pendingLocalOrder;

  @override
  void onInit() {
    super.onInit();
    fetchInitialOrders();
  }

  /// Inserta o actualiza una orden localmente.
  /// Si las órdenes aún están cargando, la guarda como pendiente
  /// y se aplicará al terminar la carga.
  void addOrUpdateOrderLocally(Map<String, dynamic> order) {
    if (isLoading.value) {
      _pendingLocalOrder = order;
      return;
    }
    _applyLocalOrder(order);
  }

  void _applyLocalOrder(Map<String, dynamic> order) {
    final int? orderId = order['id'];
    final idx =
        orderId != null ? allOrders.indexWhere((o) => o['id'] == orderId) : -1;
    if (idx != -1) {
      allOrders[idx] = order;
    } else {
      allOrders.insert(0, order);
    }
  }

  List<Map<String, dynamic>> get ordersEncargadas =>
      allOrders.where((order) => order['status'] == 'ENCARGADO').toList();

  List<Map<String, dynamic>> get ordersEntregadas =>
      allOrders.where((order) => order['status'] == 'ENTREGADO').toList();

  Future<void> fetchInitialOrders() async {
    try {
      isLoading.value = true;

      final response = await usersProvider.getOrders();

      if (response.isOk &&
          response.body != null &&
          response.body["orders"] is List) {
        nextCursor = response.body["next_cursor"];
        allOrders.assignAll(
            List<Map<String, dynamic>>.from(response.body["orders"]));
        // Aplicar orden pendiente si llegó antes de que cargara la lista
        if (_pendingLocalOrder != null) {
          _applyLocalOrder(_pendingLocalOrder!);
          _pendingLocalOrder = null;
        }
      } else {
        allOrders.clear();
      }
    } catch (e) {
      print("Error fetching orders: $e");
      Get.snackbar('Error', 'No se pudieron obtener las órdenes',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMoreOrders() async {
    if (nextCursor == null || isFetchingMore.value) return;

    try {
      isFetchingMore.value = true;

      final response = await usersProvider.getOrders(cursor: nextCursor);

      if (response.isOk &&
          response.body != null &&
          response.body["orders"] is List) {
        nextCursor = response.body["next_cursor"];
        final newOrders =
            List<Map<String, dynamic>>.from(response.body["orders"]);
        allOrders.addAll(newOrders);
      } else {
        Get.snackbar('Error', 'No se pudieron obtener más órdenes',
            backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    } catch (e) {
      print("Error fetching more orders: $e");
      Get.snackbar('Error', 'No se pudieron obtener más órdenes',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isFetchingMore.value = false;
    }
  }
}
