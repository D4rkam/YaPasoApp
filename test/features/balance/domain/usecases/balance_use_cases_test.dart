import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prueba_buffet/features/balance/domain/entities/balance_state.dart';
import 'package:prueba_buffet/features/balance/domain/entities/balance_transactions_page.dart';
import 'package:prueba_buffet/features/balance/domain/repositories/balance_repository.dart';
import 'package:prueba_buffet/features/balance/domain/usecases/balance_use_cases.dart';

class MockBalanceRepository extends Mock implements BalanceRepository {}

void main() {
  late MockBalanceRepository mockRepository;
  late GetStoredBalanceStateUseCase getStoredBalanceState;
  late FetchBalanceUseCase fetchBalance;
  late GetTransactionsUseCase getTransactions;
  late StartLoadBalanceUseCase startLoadBalance;
  late SavePendingLoadAmountUseCase savePendingLoadAmount;

  setUp(() {
    mockRepository = MockBalanceRepository();
    getStoredBalanceState = GetStoredBalanceStateUseCase(mockRepository);
    fetchBalance = FetchBalanceUseCase(mockRepository);
    getTransactions = GetTransactionsUseCase(mockRepository);
    startLoadBalance = StartLoadBalanceUseCase(mockRepository);
    savePendingLoadAmount = SavePendingLoadAmountUseCase(mockRepository);
  });

  group('Balance Use Cases Tests', () {
    test('GetStoredBalanceStateUseCase should call repository and return state', () {
      // arrange
      const state = BalanceState(balance: 100, fileNum: 1);
      when(() => mockRepository.readStoredState()).thenReturn(state);

      // act
      final result = getStoredBalanceState();

      // assert
      expect(result, state);
      verify(() => mockRepository.readStoredState()).called(1);
    });

    test('FetchBalanceUseCase should call repository and return value', () async {
      // arrange
      when(() => mockRepository.fetchBalance()).thenAnswer((_) async => 500.0);

      // act
      final result = await fetchBalance();

      // assert
      expect(result, 500.0);
      verify(() => mockRepository.fetchBalance()).called(1);
    });

    test('GetTransactionsUseCase should call repository with optional cursor', () async {
      // arrange
      const page = BalanceTransactionsPage(transactions: [], nextCursor: null);
      when(() => mockRepository.getTransactions(cursor: any(named: 'cursor')))
          .thenAnswer((_) async => page);

      // act
      final result = await getTransactions(cursor: 'abc');

      // assert
      expect(result, page);
      verify(() => mockRepository.getTransactions(cursor: 'abc')).called(1);
    });

    test('StartLoadBalanceUseCase should call repository with params', () async {
      // arrange
      when(() => mockRepository.startLoadBalance(
            amount: any(named: 'amount'),
            description: any(named: 'description'),
          )).thenAnswer((_) async => 'init_point_url');

      // act
      final result = await startLoadBalance(amount: 1000, description: 'Load');

      // assert
      expect(result, 'init_point_url');
      verify(() => mockRepository.startLoadBalance(amount: 1000, description: 'Load')).called(1);
    });

    test('SavePendingLoadAmountUseCase should call repository', () async {
      // arrange
      when(() => mockRepository.savePendingLoadAmount(any()))
          .thenAnswer((_) async => Future.value());

      // act
      await savePendingLoadAmount(100.0);

      // assert
      verify(() => mockRepository.savePendingLoadAmount(100.0)).called(1);
    });
  });
}
