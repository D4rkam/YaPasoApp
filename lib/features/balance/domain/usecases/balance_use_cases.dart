import 'package:prueba_buffet/features/balance/domain/entities/balance_state.dart';
import 'package:prueba_buffet/features/balance/domain/entities/balance_transactions_page.dart';
import 'package:prueba_buffet/features/balance/domain/repositories/balance_repository.dart';

class GetStoredBalanceStateUseCase {
  final BalanceRepository _repository;

  GetStoredBalanceStateUseCase(this._repository);

  BalanceState call() => _repository.readStoredState();
}

class FetchBalanceUseCase {
  final BalanceRepository _repository;

  FetchBalanceUseCase(this._repository);

  Future<double?> call() => _repository.fetchBalance();
}

class GetTransactionsUseCase {
  final BalanceRepository _repository;

  GetTransactionsUseCase(this._repository);

  Future<BalanceTransactionsPage> call({String? cursor}) {
    return _repository.getTransactions(cursor: cursor);
  }
}

class StartLoadBalanceUseCase {
  final BalanceRepository _repository;

  StartLoadBalanceUseCase(this._repository);

  Future<String?> call({
    required double amount,
    required String description,
  }) {
    return _repository.startLoadBalance(
      amount: amount,
      description: description,
    );
  }
}

class SavePendingLoadAmountUseCase {
  final BalanceRepository _repository;

  SavePendingLoadAmountUseCase(this._repository);

  Future<void> call(double amount) {
    return _repository.savePendingLoadAmount(amount);
  }
}
