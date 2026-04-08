import 'package:prueba_buffet/core/data/providers/users_provider.dart';

class OrderRemoteDataSource {
  final UsersProvider _usersProvider;

  OrderRemoteDataSource(this._usersProvider);

  /// Retorna la respuesta cruda del servidor para orders con paginación y estado.
  Future<Map<String, dynamic>> getOrders({
    int limit = 10,
    String? cursor,
    String? status,
  }) async {
    final response = await _usersProvider.getOrders(
      limit: limit,
      cursor: cursor,
      status: status,
    );

    if (response.statusCode == 200 &&
        response.data != null &&
        response.data["orders"] is List) {
      return {
        'orders': List<Map<String, dynamic>>.from(response.data["orders"]),
        'next_cursor': response.data["next_cursor"],
      };
    }

    return {
      'orders': <Map<String, dynamic>>[],
      'next_cursor': null,
    };
  }
}
