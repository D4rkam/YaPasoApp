import 'package:get/get.dart';
import 'package:prueba_buffet/app/data/provider/base_provider.dart';
import 'package:prueba_buffet/utils/constants/api_constants.dart';

class WalletProvider extends BaseProvider {
  /// Solicita la carga de saldo a través de Mercado Pago.
  /// Devuelve la respuesta con `transaction` y `preference` (contiene `init_point`).

  @override
  void onInit() {
    super.onInit();
    // Cualquier inicialización específica para WalletProvider puede ir aquí
  }

  Future<Response> loadBalance({
    required double amount,
    String description = '',
  }) async {
    final body = {
      'amount': amount,
      if (description.isNotEmpty) 'description': description,
    };

    return await post(
      ApiUrl.LOAD_BALANCE,
      body,
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<Response> getTransactions(
      {int limit = 20, String? cursor, String? type}) async {
    return await get(
      ApiUrl.TRANSACTIONS,
      query: {
        'limit': limit.toString(),
        if (cursor != null) 'cursor': cursor,
        if (type != null) 'type': type,
      },
    );
  }
}
