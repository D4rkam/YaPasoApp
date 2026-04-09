import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prueba_buffet/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:prueba_buffet/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:prueba_buffet/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:prueba_buffet/features/auth/domain/entities/login_credentials.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}
class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

void main() {
  late MockAuthRemoteDataSource mockRemote;
  late MockAuthLocalDataSource mockLocal;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockRemote = MockAuthRemoteDataSource();
    mockLocal = MockAuthLocalDataSource();
    repository = AuthRepositoryImpl(mockRemote, mockLocal);
  });

  group('AuthRepositoryImpl Tests', () {
    final Map<String, dynamic> successUserResponse = {
      'id': 1,
      'username': 'tdoe',
      'name': 'Thomas',
      'email': 't@t.com',
      'token': {'access_token': 'abc'}
    };

    test('login should return success and save user when remote is 200', () async {
      // arrange
      const credentials = LoginCredentials(username: 'u', password: 'p');
      final response = Response(
        requestOptions: RequestOptions(path: ''),
        data: successUserResponse,
        statusCode: 200,
      );
      
      when(() => mockRemote.login(
            username: any(named: 'username'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => response);
      
      when(() => mockLocal.saveUser(any()))
          .thenAnswer((_) async => Future.value());

      // act
      final result = await repository.login(credentials);

      // assert
      expect(result.isSuccess, true);
      expect(result.data?.userId, 1);
      verify(() => mockLocal.saveUser(any())).called(1);
    });

    test('login should return invalidCredentials when remote fails', () async {
      // arrange
      const credentials = LoginCredentials(username: 'u', password: 'p');
      final response = Response(
        requestOptions: RequestOptions(path: ''),
        data: null,
        statusCode: 401,
      );
      
      when(() => mockRemote.login(
            username: any(named: 'username'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => response);

      // act
      final result = await repository.login(credentials);

      // assert
      expect(result.isSuccess, false);
      expect(result.failure?.code, 'invalid_credentials');
    });

    test('checkSession should delegate to remote and update local', () async {
       // arrange
      final response = Response(
        requestOptions: RequestOptions(path: ''),
        data: successUserResponse,
        statusCode: 200,
      );
      
      when(() => mockRemote.checkToken()).thenAnswer((_) async => response);
      when(() => mockLocal.saveUser(any())).thenAnswer((_) async => Future.value());

      // act
      final result = await repository.checkSession();

      // assert
      expect(result.isSuccess, true);
      verify(() => mockLocal.saveUser(any())).called(1);
    });

    test('clearSession should delegate to local', () async {
       // arrange
      when(() => mockLocal.clearUser()).thenAnswer((_) async => Future.value());

      // act
      await repository.clearSession();

      // assert
      verify(() => mockLocal.clearUser()).called(1);
    });
  });
}
