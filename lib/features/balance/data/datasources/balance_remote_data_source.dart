import 'package:prueba_buffet/app/data/models/payment_response.dart';
import 'package:prueba_buffet/app/data/provider/users_provider.dart';
import 'package:prueba_buffet/app/data/provider/wallet_provider.dart';
import 'package:prueba_buffet/features/balance/data/models/balance_transactions_page_model.dart';

class BalanceRemoteDataSource {
  final WalletProvider _walletProvider;
  final UsersProvider _usersProvider;

  BalanceRemoteDataSource(this._walletProvider, this._usersProvider);

  Future<double?> fetchBalance() async {
    try {
      final result = await _usersProvider.getBalance();
      if (!result.containsKey('balance')) {
        return null;
      }
      return result['balance'];
    } catch (_) {
      return null;
    }
  }

  Future<BalanceTransactionsPageModel> getTransactions({String? cursor}) async {
    try {
      final response = await _walletProvider.getTransactions(cursor: cursor);
      if (response.statusCode == 200 && response.data is Map) {
        return BalanceTransactionsPageModel.fromResponseMap(
          response.data as Map,
        );
      }
    } catch (_) {}

    return const BalanceTransactionsPageModel(
        transactions: [], nextCursor: null);
  }

  Future<String?> startLoadBalance({
    required double amount,
    required String description,
  }) async {
    try {
      final response = await _walletProvider.loadBalance(
        amount: amount,
        description: description,
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null) {
        final payment = PaymentResponse.fromJson(response.data);
        if (payment.preference.initPoint.isNotEmpty) {
          return payment.preference.initPoint;
        }
      }
    } catch (_) {}

    return null;
  }
}
