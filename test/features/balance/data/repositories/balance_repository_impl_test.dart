import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prueba_buffet/features/balance/data/datasources/balance_local_data_source.dart';
import 'package:prueba_buffet/features/balance/data/datasources/balance_remote_data_source.dart';
import 'package:prueba_buffet/features/balance/data/models/balance_state_model.dart';
import 'package:prueba_buffet/features/balance/data/models/balance_transactions_page_model.dart';
import 'package:prueba_buffet/features/balance/data/repositories/balance_repository_impl.dart';

class MockBalanceLocalDataSource extends Mock implements BalanceLocalDataSource {}
class MockBalanceRemoteDataSource extends Mock implements BalanceRemoteDataSource {}

void main() {
  late MockBalanceLocalDataSource mockLocal;
  late MockBalanceRemoteDataSource mockRemote;
  late BalanceRepositoryImpl repository;

  setUp(() {
    mockLocal = MockBalanceLocalDataSource();
    mockRemote = MockBalanceRemoteDataSource();
    repository = BalanceRepositoryImpl(mockLocal, mockRemote);
  });

  group('BalanceRepositoryImpl Tests', () {
    test('readStoredState should delegate to local datasource', () {
      // arrange
      const state = BalanceStateModel(balance: 100, fileNum: 1);
      when(() => mockLocal.readStoredState()).thenReturn(state);

      // act
      final result = repository.readStoredState();

      // assert
      expect(result, state);
      verify(() => mockLocal.readStoredState()).called(1);
    });

    test('fetchBalance should delegate to remote datasource', () async {
      // arrange
      when(() => mockRemote.fetchBalance()).thenAnswer((_) async => 1000.0);

      // act
      final result = await repository.fetchBalance();

      // assert
      expect(result, 1000.0);
      verify(() => mockRemote.fetchBalance()).called(1);
    });

    test('getTransactions should delegate to remote datasource', () async {
      // arrange
      const page = BalanceTransactionsPageModel(transactions: [], nextCursor: null);
      when(() => mockRemote.getTransactions(cursor: any(named: 'cursor')))
          .thenAnswer((_) async => page);

      // act
      final result = await repository.getTransactions(cursor: 'abc');

      // assert
      expect(result, page);
      verify(() => mockRemote.getTransactions(cursor: 'abc')).called(1);
    });

    test('startLoadBalance should delegate to remote datasource', () async {
      // arrange
      when(() => mockRemote.startLoadBalance(
            amount: any(named: 'amount'),
            description: any(named: 'description'),
          )).thenAnswer((_) async => 'url');

      // act
      final result = await repository.startLoadBalance(amount: 100, description: 'desc');

      // assert
      expect(result, 'url');
      verify(() => mockRemote.startLoadBalance(amount: 100, description: 'desc')).called(1);
    });

    test('savePendingLoadAmount should delegate to local datasource', () async {
      // arrange
      when(() => mockLocal.savePendingLoadAmount(any()))
          .thenAnswer((_) async => Future.value());

      // act
      await repository.savePendingLoadAmount(500.0);

      // assert
      verify(() => mockLocal.savePendingLoadAmount(500.0)).called(1);
    });
  });
}
