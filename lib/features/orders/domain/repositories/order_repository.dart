abstract class OrderRepository {
  Future<Map<String, dynamic>> getOrders({
    int limit = 10,
    String? cursor,
    String? status,
  });
}
