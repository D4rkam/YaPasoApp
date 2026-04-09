import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prueba_buffet/features/balance/domain/repositories/balance_repository.dart';
import 'package:prueba_buffet/features/balance/domain/entities/balance_state.dart';
import 'package:prueba_buffet/features/balance/domain/entities/balance_transactions_page.dart';
import 'package:prueba_buffet/features/balance/presentation/controllers/balance_controller_v2.dart';

class MockBalanceRepository extends Mock implements BalanceRepository {}

void main() {
  late BalanceControllerV2 controller;
  late MockBalanceRepository mockRepository;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    Get.testMode = true;

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall methodCall) async => '.',
    );
  });

  setUp(() {
    mockRepository = MockBalanceRepository();

    // Default mock behaviors for onInit
    when(() => mockRepository.readStoredState()).thenReturn(
      BalanceState(balance: 2500.0, fileNum: 12345),
    );
    when(() => mockRepository.getTransactions(cursor: any(named: 'cursor')))
        .thenAnswer((_) async => const BalanceTransactionsPage(transactions: [], nextCursor: null));

    controller = BalanceControllerV2(repository: mockRepository);
    controller.onInit();
  });

  group('BalanceControllerV2 Tests', () {
    test('initial state should be loaded from repository', () {
      expect(controller.balance.value, 2500.0);
      expect(controller.fileNum, 12345);
      verify(() => mockRepository.readStoredState()).called(1);
    });

    test('updateBalance should increment balance value', () {
      controller.updateBalance(500.0);
      expect(controller.balance.value, 3000.0);
    });

    test('fetchBalance should update balance from remote', () async {
      // arrange
      when(() => mockRepository.fetchBalance()).thenAnswer((_) async => 3500.0);

      // act
      await controller.fetchBalance();

      // assert
      expect(controller.balance.value, 3500.0);
      verify(() => mockRepository.fetchBalance()).called(1);
    });

    test('getMyInitialTransactions should update transactions list', () async {
      // arrange
      const page = BalanceTransactionsPage(
        transactions: [],
        nextCursor: 'cursor-123'
      );
      when(() => mockRepository.getTransactions()).thenAnswer((_) async => page);

      // act
      await controller.getMyInitialTransactions();

      // assert
      expect(controller.nextCursor, 'cursor-123');
      expect(controller.isLoading.value, false);
    });
  });
}
