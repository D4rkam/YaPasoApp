import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:prueba_buffet/core/models/user.dart';
import '../../utils/fixture_reader.dart';

void main() {
  group('User Model Tests', () {
    test('should return a valid model from JSON fixture', () {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('user_fixture.json'));

      // act
      final result = User.fromJson(jsonMap);

      // assert
      expect(result.id, 1);
      expect(result.email, "test@example.com");
      expect(result.name, "Thomas");
      expect(result.lastName, "Doe");
      expect(result.username, "tdoe");
      expect(result.age, 20);
      expect(result.fileNum, "12345");
      expect(result.balance, 2500.5);
      expect(result.accessToken, "valid_token");
      expect(result.refreshToken, "valid_refresh_token");
      expect(result.hasValidToken, true);
    });

    test('should handle numeric fields as strings and viceversa safely', () {
      // arrange
      final Map<String, dynamic> jsonMap = {
        "id": "100",
        "age": "25",
        "file_num": 99999,
        "balance": "1500.75"
      };

      // act
      final result = User.fromJson(jsonMap);

      // assert
      expect(result.id, 100);
      expect(result.age, 25);
      expect(result.fileNum, "99999");
      expect(result.balance, 1500.75);
    });

    test('should return safe default values when JSON is empty or null', () {
      // act
      final result = User.fromJson(null);

      // assert
      expect(result.name, "");
      expect(result.email, "");
      expect(result.fileNum, "0");
      expect(result.age, 14);
      expect(result.hasValidToken, false);
    });

    test('should handle crash in fromJson and return empty user', () {
      // This is to test the try-catch block in factory User.fromJson
      // Although we used _safe helpers, we want to ensure robustness.
      
      // arrange: passing something that might cause a cast error if not handled
      // Actually, fromJson handles dynamic rawJson, but we can pass a non-map 
      // where the code expects a map if we were not using _safeMap.
      // Since we use _safeMap, it's hard to crash it, but the try-catch is there.
      
      final result = User.fromJson("not a map");
      
      expect(result.name, "");
    });

    test('should return a valid JSON map from model', () {
      // arrange
      final user = User(
        id: 1,
        name: "Test",
        email: "test@test.com",
        token: {"access_token": "abc"}
      );

      // act
      final result = user.toJson();

      // assert
      expect(result["name"], "Test");
      expect(result["email"], "test@test.com");
      expect(result["token"]["access_token"], "abc");
    });
  });
}
