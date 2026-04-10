import 'package:prueba_buffet/features/orders/domain/repositories/order_repository.dart';

class GetOrdersUseCase {
  final OrderRepository _repository;

  GetOrdersUseCase(this._repository);

  Future<Map<String, dynamic>> call({
    int limit = 10,
    String? cursor,
    String? status,
  }) =>
      _repository.getOrders(limit: limit, cursor: cursor, status: status);
}
