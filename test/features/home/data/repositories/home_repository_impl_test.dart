import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prueba_buffet/features/home/data/datasources/home_remote_data_source.dart';
import 'package:prueba_buffet/features/home/data/repositories/home_repository_impl.dart';

class MockHomeRemoteDataSource extends Mock implements HomeRemoteDataSource {}

void main() {
  late MockHomeRemoteDataSource mockRemote;
  late HomeRepositoryImpl repository;

  setUp(() {
    mockRemote = MockHomeRemoteDataSource();
    repository = HomeRepositoryImpl(mockRemote);
  });

  group('HomeRepositoryImpl Tests', () {
    test('getTopSellingProducts should return products when remote is 200', () async {
      // arrange
      final response = Response(
        requestOptions: RequestOptions(path: ''),
        data: [
          {'id': 1, 'name': 'P1', 'price': 100, 'category': 'C1'}
        ],
        statusCode: 200,
      );
      when(() => mockRemote.getTopSellingProducts(limit: any(named: 'limit')))
          .thenAnswer((_) async => response);

      // act
      final result = await repository.getTopSellingProducts(limit: 4);

      // assert
      expect(result.length, 1);
      expect(result[0].name, 'P1');
      verify(() => mockRemote.getTopSellingProducts(limit: 4)).called(1);
    });

    test('getCategoriesWithStock should return categories when remote is 200', () async {
      // arrange
      final response = Response(
        requestOptions: RequestOptions(path: ''),
        data: [
          {'id': 1, 'nombre': 'C1', 'orden': 1, 'activa': true, 'tiene_stock': true}
        ],
        statusCode: 200,
      );
      when(() => mockRemote.getCategoriesWithStock()).thenAnswer((_) async => response);

      // act
      final result = await repository.getCategoriesWithStock();

      // assert
      expect(result.length, 1);
      expect(result[0].nombre, 'C1');
    });

    test('searchProducts should return results when remote is 200', () async {
      // arrange
      final response = Response(
        requestOptions: RequestOptions(path: ''),
        data: [],
        statusCode: 200,
      );
      when(() => mockRemote.searchProducts('abc')).thenAnswer((_) async => response);

      // act
      final result = await repository.searchProducts('abc');

      // assert
      expect(result, isEmpty);
    });

    test('checkVersion should return map when remote is 200', () async {
      // arrange
      final response = Response(
        requestOptions: RequestOptions(path: ''),
        data: {'latest_version': '2.0.0'},
        statusCode: 200,
      );
      when(() => mockRemote.checkVersion()).thenAnswer((_) async => response);

      // act
      final result = await repository.checkVersion();

      // assert
      expect(result['latest_version'], '2.0.0');
    });

    test('should throw Exception when status is not 200', () async {
      // arrange
      final response = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 500,
      );
      when(() => mockRemote.checkVersion()).thenAnswer((_) async => response);

      // act & assert
      expect(() => repository.checkVersion(), throwsException);
    });
  });
}
