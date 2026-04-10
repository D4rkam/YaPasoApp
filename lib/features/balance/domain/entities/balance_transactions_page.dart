import 'package:prueba_buffet/features/balance/domain/entities/balance_transaction.dart';

class BalanceTransactionsPage {
  final List<BalanceTransaction> transactions;
  final String? nextCursor;

  const BalanceTransactionsPage({
    required this.transactions,
    required this.nextCursor,
  });
}
