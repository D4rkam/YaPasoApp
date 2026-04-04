import 'package:prueba_buffet/features/balance/domain/entities/balance_state.dart';

class BalanceStateModel extends BalanceState {
  const BalanceStateModel({
    required super.balance,
    required super.fileNum,
  });

  factory BalanceStateModel.fromStorageMap(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return const BalanceStateModel(balance: 0, fileNum: 0);
    }

    final balanceRaw = map['balance'];
    final fileRaw = map['file_num'];

    return BalanceStateModel(
      balance: (balanceRaw is num) ? balanceRaw.toDouble() : 0,
      fileNum: int.tryParse(fileRaw?.toString() ?? '') ?? 0,
    );
  }
}
