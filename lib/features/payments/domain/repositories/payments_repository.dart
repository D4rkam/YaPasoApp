import 'package:prueba_buffet/features/payments/domain/entities/order.dart';
import 'package:prueba_buffet/features/payments/domain/entities/payment.dart';
import 'package:prueba_buffet/features/payments/domain/results/payments_result.dart';

abstract class PaymentsRepository {
  Future<void> saveOrderDateTime(DateTime dateTime);

  Future<bool> isBiometricsRequired();

  Future<PaymentsResult<PaymentOrderDraft>> buildPaymentDraftFromStorage();

  Future<PaymentsResult<int>> readSchoolIdFromStorage();

  Future<PaymentsResult<String>> startMercadoPagoPayment(
    PaymentOrderDraft draft,
  );

  Future<PaymentsResult<CreatedOrder>> createOrder(CreateOrderDraft draft);

  Future<PaymentsResult<CreatedOrder>> readStoredOrder();

  Future<PaymentsResult<void>> payWithBalance(CreatedOrder order);

  Future<void> clearAfterBalancePayment();

  Future<void> clearPaymentState();
}
