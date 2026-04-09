import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prueba_buffet/core/models/user.dart';
import 'package:prueba_buffet/features/balance/domain/repositories/balance_repository.dart';
import 'package:prueba_buffet/features/balance/domain/entities/balance_state.dart';
import 'package:prueba_buffet/features/balance/domain/entities/balance_transaction.dart';
import 'package:prueba_buffet/features/balance/domain/entities/balance_transactions_page.dart';
import 'package:prueba_buffet/features/balance/presentation/controllers/balance_controller_v2.dart';

class MockBalanceRepository extends Mock implements BalanceRepository {}

void main() {
  late BalanceControllerV2 controller;
  late MockBalanceRepository mockRepository;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    Get.testMode = true;

    // Mock path_provider
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall methodCall) async => '.',
    );

    // Mock url_launcher to avoid hanging in confirmLoadBalance tests
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/url_launcher'),
      (MethodCall methodCall) async {
        if (methodCall.method == 'canLaunch') return true;
        if (methodCall.method == 'launch') return true;
        return null;
      },
    );
  });

  setUp(() {
    mockRepository = MockBalanceRepository();

    // Default mock behaviors for onInit
    when(() => mockRepository.readStoredState()).thenReturn(
      const BalanceState(balance: 2500.0, fileNum: 12345),
    );
    when(() => mockRepository.getTransactions(cursor: any(named: 'cursor')))
        .thenAnswer((_) async => const BalanceTransactionsPage(transactions: [], nextCursor: null));

    controller = BalanceControllerV2(repository: mockRepository);
  });

  group('BalanceControllerV2 Tests', () {
    test('initial state should be loaded from repository onInit', () async {
      // act
      controller.onInit();
      await Future.delayed(Duration.zero); // Give time for async getMyInitialTransactions

      // assert
      expect(controller.balance.value, 2500.0);
      expect(controller.fileNum, 12345);
      verify(() => mockRepository.readStoredState()).called(1);
    });

    test('updateBalance should increment balance value', () {
      controller.balance = 2500.0.obs;
      controller.updateBalance(500.0);
      expect(controller.balance.value, 3000.0);
    });

    test('fetchBalance should update balance from remote', () async {
      // arrange
      controller.balance = 2500.0.obs;
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
        transactions: [
          BalanceTransaction(type: 'T1', amount: 100, createdAt: '2023')
        ],
        nextCursor: 'cursor-123'
      );
      when(() => mockRepository.getTransactions()).thenAnswer((_) async => page);

      // act
      await controller.getMyInitialTransactions();

      // assert
      expect(controller.transactions.length, 1);
      expect(controller.nextCursor, 'cursor-123');
      expect(controller.isLoading.value, false);
    });

    test('getMoreTransactions should append items', () async {
      // arrange
      controller.nextCursor = 'initial-cursor';
      const page = BalanceTransactionsPage(
        transactions: [
          BalanceTransaction(type: 'T2', amount: 200, createdAt: '2023')
        ],
        nextCursor: 'next-cursor'
      );
      when(() => mockRepository.getTransactions(cursor: 'initial-cursor'))
          .thenAnswer((_) async => page);

      // act
      await controller.getMoreTransactions();

      // assert
      expect(controller.transactions.length, 1);
      expect(controller.nextCursor, 'next-cursor');
      expect(controller.isFetchingMore.value, false);
    });

    testWidgets('confirmLoadBalance should show error if amount invalid', (tester) async {
      await tester.pumpWidget(GetMaterialApp(home: Container()));
      // act
      await controller.confirmLoadBalance('invalid');
      await tester.pumpAndSettle();

      // assert
      expect(controller.isLoading.value, false);
    });

    testWidgets('confirmLoadBalance should call repository if amount valid', (tester) async {
      // arrange
      controller.userSession = User.fromJson(const {
        'id': 1,
        'username': 'u',
        'name': 'Test',
        'email': 'e',
        'password': 'p',
        'token': {}
      });
      when(() => mockRepository.startLoadBalance(
            amount: 500.0,
            description: any(named: 'description'),
          )).thenAnswer((_) async => 'http://mercadopago.com');
      when(() => mockRepository.savePendingLoadAmount(500.0))
          .thenAnswer((_) async => Future.value());

      // We need a GetMaterialApp to avoid Get.back() crashing
      await tester.pumpWidget(GetMaterialApp(home: Container()));

      // act
      await controller.confirmLoadBalance('500');
      await tester.pumpAndSettle();

      // assert
      verify(() => mockRepository.startLoadBalance(
        amount: 500.0,
        description: any(named: 'description'),
      )).called(1);
      verify(() => mockRepository.savePendingLoadAmount(500.0)).called(1);
    });
  });
}

