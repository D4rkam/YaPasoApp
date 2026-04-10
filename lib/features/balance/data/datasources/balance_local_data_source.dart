import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/features/balance/data/models/balance_state_model.dart';

class BalanceLocalDataSource {
  static const String userKey = 'user';
  static const String pendingLoadAmountKey = 'pending_load_amount';

  final GetStorage _storage;

  BalanceLocalDataSource(this._storage);

  BalanceStateModel readStoredState() {
    final rawUser = _storage.read(userKey);
    if (rawUser is Map) {
      return BalanceStateModel.fromStorageMap(rawUser);
    }
    return const BalanceStateModel(balance: 0, fileNum: 0);
  }

  Future<void> savePendingLoadAmount(double amount) {
    return _storage.write(pendingLoadAmountKey, amount);
  }
}
