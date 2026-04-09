import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:prueba_buffet/core/models/category.dart';
import '../../utils/fixture_reader.dart';

void main() {
  group('Category Model Tests', () {
    test('should return a list of categories from JSON fixture', () {
      // arrange
      final dynamic jsonData = json.decode(fixture('category_fixture.json'));

      // act
      final result = categoryFromJson(jsonData);

      // assert
      expect(result.length, 2);
      expect(result[0].nombre, "Snacks");
      expect(result[0].tieneStock, true);
      expect(result[1].nombre, "Bebidas");
      expect(result[1].tieneStock, false);
    });

    test('should return a valid model from JSON map', () {
      // arrange
      final Map<String, dynamic> jsonMap = {
        "id": 3,
        "nombre": "Golosinas",
        "orden": 3,
        "activa": true,
        "tiene_stock": true
      };

      // act
      final result = Category.fromJson(jsonMap);

      // assert
      expect(result.id, 3);
      expect(result.nombre, "Golosinas");
      expect(result.orden, 3);
      expect(result.activa, true);
      expect(result.tieneStock, true);
    });

    test('should use default values for missing bool/int fields', () {
      // arrange
      final Map<String, dynamic> jsonMap = {
        "id": 4,
        "nombre": "Test Defaults",
      };

      // act
      final result = Category.fromJson(jsonMap);

      // assert
      expect(result.orden, 0);
      expect(result.activa, true);
      expect(result.tieneStock, false);
    });
  });
}
