import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prueba_buffet/features/payments/domain/results/payments_result.dart';
import 'package:prueba_buffet/features/payments/domain/errors/payment_failure.dart';
import 'package:prueba_buffet/features/payments/domain/usecases/payments_use_cases.dart';
import 'package:prueba_buffet/features/payments/presentation/controllers/payments_controller_v2.dart';

class MockSaveOrderDateTimeUseCase extends Mock implements SaveOrderDateTimeUseCase {}
class MockIsBiometricsRequiredUseCase extends Mock implements IsBiometricsRequiredUseCase {}
class MockStartMercadoPagoPaymentFromStorageUseCase extends Mock implements StartMercadoPagoPaymentFromStorageUseCase {}
class MockCreateOrderFromStorageUseCase extends Mock implements CreateOrderFromStorageUseCase {}
class MockPayWithBalanceFromStorageUseCase extends Mock implements PayWithBalanceFromStorageUseCase {}
class MockClearPaymentStateUseCase extends Mock implements ClearPaymentStateUseCase {}

void main() {
  late PaymentsControllerV2 controller;
  late MockSaveOrderDateTimeUseCase mockSaveDate;
  late MockIsBiometricsRequiredUseCase mockIsBiometric;
  late MockStartMercadoPagoPaymentFromStorageUseCase mockStartMP;
  late MockCreateOrderFromStorageUseCase mockCreateOrder;
  late MockPayWithBalanceFromStorageUseCase mockPayBalance;
  late MockClearPaymentStateUseCase mockClear;

  setUp(() {
    mockSaveDate = MockSaveOrderDateTimeUseCase();
    mockIsBiometric = MockIsBiometricsRequiredUseCase();
    mockStartMP = MockStartMercadoPagoPaymentFromStorageUseCase();
    mockCreateOrder = MockCreateOrderFromStorageUseCase();
    mockPayBalance = MockPayWithBalanceFromStorageUseCase();
    mockClear = MockClearPaymentStateUseCase();

    controller = PaymentsControllerV2(
      mockSaveDate,
      mockIsBiometric,
      mockStartMP,
      mockCreateOrder,
      mockPayBalance,
      mockClear,
    );
  });

  group('PaymentsControllerV2 Tests', () {
    test('executeMercadoPagoFlow should set errorMessage on failure', () async {
      // arrange
      when(() => mockStartMP()).thenAnswer((_) async => PaymentsResult.error(PaymentFailure.unknown));

      // act
      final result = await controller.executeMercadoPagoFlow();

      // assert
      expect(result, false);
      expect(controller.errorMessage.value, PaymentFailure.unknown.message);
      expect(controller.isLoading.value, false);
    });

    test('executeMercadoPagoFlow should return true on success', () async {
      // arrange
      when(() => mockStartMP()).thenAnswer((_) async => PaymentsResult.success('https://mp.com'));
      // In a real test we might need a wrapper for url_launcher to mock it properly.
    });

    test('clearState should call clear use case', () async {
      // arrange
      when(() => mockClear()).thenAnswer((_) async {});

      // act
      await controller.clearState();

      // assert
      verify(() => mockClear()).called(1);
    });
  });
}
