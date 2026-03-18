import 'package:dio/dio.dart' show Response, Options; // Importamos Dio
import 'package:prueba_buffet/app/data/provider/base_provider.dart';
import 'package:prueba_buffet/utils/constants/api_constants.dart';

class WalletProvider extends BaseProvider {
  Future<Response> loadBalance({
    required double amount,
    String description = '',
  }) async {
    final body = {
      'amount': amount,
      if (description.isNotEmpty) 'description': description,
    };

    return await dio.post(
      ApiUrl.LOAD_BALANCE,
      data: body,
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
  }

  Future<Response> getTransactions(
      {int limit = 20, String? cursor, String? type}) async {
    return await dio.get(
      ApiUrl.TRANSACTIONS,
      queryParameters: {
        'limit': limit.toString(),
        if (cursor != null) 'cursor': cursor,
        if (type != null) 'type': type,
      },
    );
  }
}
