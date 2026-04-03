import 'package:prueba_buffet/features/payments/domain/errors/payment_failure.dart';

class PaymentsResult<T> {
  final T? data;
  final PaymentFailure? failure;

  const PaymentsResult._({this.data, this.failure});

  bool get isSuccess => failure == null;

  factory PaymentsResult.success(T data) {
    return PaymentsResult._(data: data);
  }

  factory PaymentsResult.error(PaymentFailure failure) {
    return PaymentsResult._(failure: failure);
  }
}
