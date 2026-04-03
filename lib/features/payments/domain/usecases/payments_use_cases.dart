import 'package:prueba_buffet/features/payments/domain/entities/order.dart';
import 'package:prueba_buffet/features/payments/domain/errors/payment_failure.dart';
import 'package:prueba_buffet/features/payments/domain/repositories/payments_repository.dart';
import 'package:prueba_buffet/features/payments/domain/results/payments_result.dart';

class SaveOrderDateTimeUseCase {
  final PaymentsRepository _repository;

  SaveOrderDateTimeUseCase(this._repository);

  Future<void> call(DateTime dateTime) {
    return _repository.saveOrderDateTime(dateTime);
  }
}

class IsBiometricsRequiredUseCase {
  final PaymentsRepository _repository;

  IsBiometricsRequiredUseCase(this._repository);

  Future<bool> call() {
    return _repository.isBiometricsRequired();
  }
}

class StartMercadoPagoPaymentFromStorageUseCase {
  final PaymentsRepository _repository;

  StartMercadoPagoPaymentFromStorageUseCase(this._repository);

  Future<PaymentsResult<String>> call() async {
    final draftResult = await _repository.buildPaymentDraftFromStorage();
    if (!draftResult.isSuccess || draftResult.data == null) {
      return PaymentsResult.error(
          draftResult.failure ?? PaymentFailure.unknown);
    }

    return _repository.startMercadoPagoPayment(draftResult.data!);
  }
}

class CreateOrderFromStorageUseCase {
  final PaymentsRepository _repository;

  CreateOrderFromStorageUseCase(this._repository);

  Future<PaymentsResult<CreatedOrder>> call() async {
    final draftResult = await _repository.buildPaymentDraftFromStorage();
    if (!draftResult.isSuccess || draftResult.data == null) {
      return PaymentsResult.error(
          draftResult.failure ?? PaymentFailure.unknown);
    }

    final schoolResult = await _repository.readSchoolIdFromStorage();
    if (!schoolResult.isSuccess || schoolResult.data == null) {
      return PaymentsResult.error(
          schoolResult.failure ?? PaymentFailure.missingSchool);
    }

    final createDraft = CreateOrderDraft.fromPaymentDraft(
      draftResult.data!,
      schoolResult.data!,
    );

    return _repository.createOrder(createDraft);
  }
}

class PayWithBalanceFromStorageUseCase {
  final PaymentsRepository _repository;

  PayWithBalanceFromStorageUseCase(this._repository);

  Future<PaymentsResult<void>> call() async {
    final orderResult = await _repository.readStoredOrder();
    if (!orderResult.isSuccess || orderResult.data == null) {
      return PaymentsResult.error(
          orderResult.failure ?? PaymentFailure.missingOrder);
    }

    final paymentResult = await _repository.payWithBalance(orderResult.data!);
    if (paymentResult.isSuccess) {
      await _repository.clearAfterBalancePayment();
    }
    return paymentResult;
  }
}

class ClearPaymentStateUseCase {
  final PaymentsRepository _repository;

  ClearPaymentStateUseCase(this._repository);

  Future<void> call() {
    return _repository.clearPaymentState();
  }
}
