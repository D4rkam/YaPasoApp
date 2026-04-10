import 'package:dio/dio.dart';
import 'package:prueba_buffet/features/payments/data/datasources/payments_local_data_source.dart';
import 'package:prueba_buffet/features/payments/data/datasources/payments_remote_data_source.dart';
import 'package:prueba_buffet/features/payments/data/models/payments_model.dart';
import 'package:prueba_buffet/features/payments/domain/entities/order.dart';
import 'package:prueba_buffet/features/payments/domain/entities/payment.dart';
import 'package:prueba_buffet/features/payments/domain/errors/payment_failure.dart';
import 'package:prueba_buffet/features/payments/domain/repositories/payments_repository.dart';
import 'package:prueba_buffet/features/payments/domain/results/payments_result.dart';

class PaymentsRepositoryImpl implements PaymentsRepository {
  final PaymentsRemoteDataSource _remote;
  final PaymentsLocalDataSource _local;

  PaymentsRepositoryImpl(this._remote, this._local);

  @override
  Future<void> saveOrderDateTime(DateTime dateTime) {
    return _local.saveOrderDateTime(dateTime);
  }

  @override
  Future<bool> isBiometricsRequired() async {
    return _local.isBiometricsRequired();
  }

  @override
  Future<PaymentsResult<PaymentOrderDraft>>
      buildPaymentDraftFromStorage() async {
    final cartItems = _local.readStoredCartItems();
    if (cartItems.isEmpty) {
      return PaymentsResult.error(PaymentFailure.missingCart);
    }

    final dateTime = _local.readOrderDateTime();
    if (dateTime == null) {
      return PaymentsResult.error(PaymentFailure.missingDateTime);
    }

    final items = cartItems.map((item) => item.toDomain()).toList();
    if (items.any((item) => item.quantity <= 0)) {
      return PaymentsResult.error(PaymentFailure.missingCart);
    }

    return PaymentsResult.success(
      PaymentOrderDraft(items: items, pickupDateTime: dateTime),
    );
  }

  @override
  Future<PaymentsResult<int>> readSchoolIdFromStorage() async {
    final schoolId = _local.readSchoolIdFromUser();
    if (schoolId == null) {
      return PaymentsResult.error(PaymentFailure.missingSchool);
    }
    return PaymentsResult.success(schoolId);
  }

  @override
  Future<PaymentsResult<String>> startMercadoPagoPayment(
    PaymentOrderDraft draft,
  ) async {
    try {
      final dto = PaymentRequestDto.fromDraft(draft);
      final response = await _remote.startMercadoPagoPayment(dto.toJson());

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is! Map) {
          return PaymentsResult.error(PaymentFailure.unknown);
        }

        final checkout = MercadoPagoCheckoutDto.fromJson(
          Map<String, dynamic>.from(response.data as Map),
        );
        if (checkout.initPoint.isEmpty) {
          return PaymentsResult.error(
            PaymentFailure.api('No se recibio un enlace de pago valido.'),
          );
        }

        await _local.savePendingCartTotal(draft.totalAmount);
        return PaymentsResult.success(checkout.initPoint);
      }

      return PaymentsResult.error(
        PaymentFailure.api('No se pudo iniciar el proceso de pago.'),
      );
    } on DioException {
      return PaymentsResult.error(PaymentFailure.network);
    } catch (_) {
      return PaymentsResult.error(PaymentFailure.unknown);
    }
  }

  @override
  Future<PaymentsResult<CreatedOrder>> createOrder(
      CreateOrderDraft draft) async {
    try {
      final dto = CreateOrderRequestDto.fromEntity(draft);
      final response = await _remote.createOrder(dto.toJson());

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is! Map) {
          return PaymentsResult.error(PaymentFailure.invalidOrder);
        }
        final createdOrderDto = CreatedOrderDto.fromJson(
          Map<String, dynamic>.from(response.data as Map),
        );
        await _local.saveCreatedOrder(createdOrderDto.raw);
        return PaymentsResult.success(createdOrderDto.toDomain());
      }

      if (response.statusCode == 400 && response.data is Map) {
        final detail = (response.data['detail'] ?? '').toString();
        if (detail.isNotEmpty) {
          return PaymentsResult.error(PaymentFailure.api(detail));
        }
      }

      return PaymentsResult.error(
        PaymentFailure.api('No pudimos procesar tu pedido. Intenta de nuevo.'),
      );
    } on DioException {
      return PaymentsResult.error(PaymentFailure.network);
    } catch (_) {
      return PaymentsResult.error(PaymentFailure.unknown);
    }
  }

  @override
  Future<PaymentsResult<CreatedOrder>> readStoredOrder() async {
    final rawOrder = _local.readCreatedOrder();
    if (rawOrder == null) {
      return PaymentsResult.error(PaymentFailure.missingOrder);
    }

    try {
      final dto = CreatedOrderDto.fromJson(rawOrder);
      if (dto.id <= 0 || dto.sellerId <= 0) {
        return PaymentsResult.error(PaymentFailure.invalidOrder);
      }
      return PaymentsResult.success(dto.toDomain());
    } catch (_) {
      return PaymentsResult.error(PaymentFailure.invalidOrder);
    }
  }

  @override
  Future<PaymentsResult<void>> payWithBalance(CreatedOrder order) async {
    try {
      final response = await _remote.payWithBalance(
        amount: order.total,
        sellerId: order.sellerId,
        orderId: order.id,
      );

      if (response.statusCode == 200) {
        return PaymentsResult.success(null);
      }

      return PaymentsResult.error(
        PaymentFailure.api('No se pudo procesar el pago con saldo virtual.'),
      );
    } on DioException {
      return PaymentsResult.error(PaymentFailure.network);
    } catch (_) {
      return PaymentsResult.error(PaymentFailure.unknown);
    }
  }

  @override
  Future<void> clearAfterBalancePayment() {
    return _local.clearAfterBalancePayment();
  }

  @override
  Future<void> clearPaymentState() {
    return _local.clearPaymentState();
  }
}
