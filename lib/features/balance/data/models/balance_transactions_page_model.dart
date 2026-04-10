import 'package:prueba_buffet/features/balance/data/models/balance_transaction_model.dart';
import 'package:prueba_buffet/features/balance/domain/entities/balance_transactions_page.dart';

class BalanceTransactionsPageModel extends BalanceTransactionsPage {
  const BalanceTransactionsPageModel({
    required super.transactions,
    required super.nextCursor,
  });

  factory BalanceTransactionsPageModel.fromResponseMap(
    Map<dynamic, dynamic> map,
  ) {
    final rawTransactions = map['transactions'];
    final parsed = <BalanceTransactionModel>[];

    if (rawTransactions is List) {
      for (final item in rawTransactions) {
        if (item is Map) {
          parsed.add(BalanceTransactionModel.fromMap(item));
        }
      }
    }

    return BalanceTransactionsPageModel(
      transactions: parsed,
      nextCursor: map['next_cursor']?.toString(),
    );
  }
}
