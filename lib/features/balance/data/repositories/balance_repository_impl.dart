import 'package:prueba_buffet/features/balance/data/datasources/balance_local_data_source.dart';
import 'package:prueba_buffet/features/balance/data/datasources/balance_remote_data_source.dart';
import 'package:prueba_buffet/features/balance/domain/entities/balance_state.dart';
import 'package:prueba_buffet/features/balance/domain/entities/balance_transactions_page.dart';
import 'package:prueba_buffet/features/balance/domain/repositories/balance_repository.dart';

class BalanceRepositoryImpl implements BalanceRepository {
  final BalanceLocalDataSource _local;
  final BalanceRemoteDataSource _remote;

  BalanceRepositoryImpl(this._local, this._remote);

  @override
  BalanceState readStoredState() {
    return _local.readStoredState();
  }

  @override
  Future<double?> fetchBalance() {
    return _remote.fetchBalance();
  }

  @override
  Future<BalanceTransactionsPage> getTransactions({String? cursor}) {
    return _remote.getTransactions(cursor: cursor);
  }

  @override
  Future<String?> startLoadBalance({
    required double amount,
    required String description,
  }) {
    return _remote.startLoadBalance(
      amount: amount,
      description: description,
    );
  }

  @override
  Future<void> savePendingLoadAmount(double amount) {
    return _local.savePendingLoadAmount(amount);
  }
}
