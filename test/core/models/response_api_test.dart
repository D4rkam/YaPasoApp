import 'package:flutter_test/flutter_test.dart';
import 'package:prueba_buffet/core/models/response_api.dart';

void main() {
  group('ResponseApi Model Tests', () {
    test('should return a valid model from JSON map', () {
      // arrange
      final Map<String, dynamic> jsonMap = {"id": 1, "name": "Test"};
      final bool success = true;

      // act
      final result = ResponseApi.fromJson(jsonMap, success);

      // assert
      expect(result.data, jsonMap);
      expect(result.success, true);
    });

    test('should return responseApiFromJson with String', () {
      // arrange
      final String jsonStr = '{"id": 1, "name": "Test"}';
      final bool success = true;

      // act
      final result = responseApiFromJson(jsonStr, success);

      // assert
      expect(result.data["id"], 1);
      expect(result.success, true);
    });

    test('should return a valid JSON map from model', () {
      // arrange
      final Map<String, dynamic> dataMap = {"id": 1};
      final responseApi = ResponseApi(data: dataMap, success: true);

      // act
      final result = responseApi.toJson();

      // assert
      expect(result["user"], dataMap);
      expect(result["success"], true);
    });
  });
}
