import 'package:flutter_test/flutter_test.dart';
import 'package:prueba_buffet/features/auth/data/models/auth_user_dto.dart';
import 'package:prueba_buffet/features/auth/data/models/auth_session_model.dart';

void main() {
  group('Auth Model Tests', () {
    final Map<String, dynamic> userMap = {
      'id': 1,
      'username': 'tdoe',
      'name': 'Thomas',
      'email': 't@t.com',
      'token': {'access_token': 'abc'}
    };

    test('AuthUserDto.fromMap should return a valid DTO', () {
      // act
      final result = AuthUserDto.fromMap(userMap);

      // assert
      expect(result.id, 1);
      expect(result.username, 'tdoe');
      expect(result.hasToken, true);
    });

    test('AuthUserDto should handle null or double IDs safely', () {
      // arrange
      final mapWithDoubleId = {...userMap, 'id': 100.5};
      
      // act
      final result = AuthUserDto.fromMap(mapWithDoubleId);

      // assert
      expect(result.id, 100);
    });

    test('AuthSessionModel.fromUserMap should return valid session', () {
      // act
      final result = AuthSessionModel.fromUserMap(userMap);

      // assert
      expect(result.userId, 1);
      expect(result.username, 'tdoe');
      expect(result.hasToken, true);
    });

    test('AuthSessionModel.fromUserDto should map correctly', () {
      // arrange
      final dto = AuthUserDto.fromMap(userMap);

      // act
      final result = AuthSessionModel.fromUserDto(dto);

      // assert
      expect(result.email, 't@t.com');
      expect(result.name, 'Thomas');
    });
  });
}
