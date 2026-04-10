import 'package:prueba_buffet/features/orders/data/datasources/order_remote_data_source.dart';
import 'package:prueba_buffet/features/orders/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource _remote;

  OrderRepositoryImpl(this._remote);

  @override
  Future<Map<String, dynamic>> getOrders({
    int limit = 10,
    String? cursor,
    String? status,
  }) {
    return _remote.getOrders(limit: limit, cursor: cursor, status: status);
  }
}
