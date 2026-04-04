import 'package:prueba_buffet/features/balance/domain/entities/balance_transaction.dart';

class BalanceTransactionModel extends BalanceTransaction {
  const BalanceTransactionModel({
    required super.type,
    required super.amount,
    required super.createdAt,
  });

  factory BalanceTransactionModel.fromMap(Map<dynamic, dynamic> map) {
    final amountRaw = map['amount'];
    return BalanceTransactionModel(
      type: (map['type'] ?? '').toString(),
      amount: (amountRaw is num)
          ? amountRaw
          : num.tryParse(amountRaw?.toString() ?? '') ?? 0,
      createdAt: (map['created_at'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'amount': amount,
      'created_at': createdAt,
    };
  }
}
