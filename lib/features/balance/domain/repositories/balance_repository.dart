import 'package:prueba_buffet/features/balance/domain/entities/balance_state.dart';
import 'package:prueba_buffet/features/balance/domain/entities/balance_transactions_page.dart';

abstract class BalanceRepository {
  BalanceState readStoredState();
  Future<double?> fetchBalance();
  Future<BalanceTransactionsPage> getTransactions({String? cursor});
  Future<String?> startLoadBalance({
    required double amount,
    required String description,
  });
  Future<void> savePendingLoadAmount(double amount);
}
