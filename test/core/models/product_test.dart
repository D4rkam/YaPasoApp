import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:prueba_buffet/core/models/product.dart';
import '../../utils/fixture_reader.dart';

void main() {
  group('Product Model Tests', () {
    test('should return a valid model from JSON fixture', () {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('product_fixture.json'));

      // act
      final result = Product.fromJson(jsonMap);

      // assert
      expect(result.id, 1);
      expect(result.name, "Coca Cola 500ml");
      expect(result.category, "Bebidas");
      expect(result.price, 1500);
      expect(result.sellerId, 10);
    });

    test('should handle category as String for legacy support', () {
      // arrange
      final Map<String, dynamic> jsonMap = {
        "id": 2,
        "name": "Alfajor",
        "category": "Snacks",
      };

      // act
      final result = Product.fromJson(jsonMap);

      // assert
      expect(result.category, "Snacks");
    });

    test('should provide safe default values for missing fields', () {
      // arrange
      final Map<String, dynamic> jsonMap = {
        "id": 3,
        "name": "Producto Sin Datos",
      };

      // act
      final result = Product.fromJson(jsonMap);

      // assert
      expect(result.description, "Sin descripción");
      expect(result.price, 0);
      expect(result.category, "Sin categoría");
      expect(result.quantity, 1);
    });

    test('should handle price and quantity as double and cast to int safely', () {
      // arrange
      final Map<String, dynamic> jsonMap = {
        "id": 4,
        "name": "Test Double",
        "price": 150.5,
        "quantity": 10.0,
      };

      // act
      final result = Product.fromJson(jsonMap);

      // assert
      expect(result.price, 150);
      expect(result.quantity, 10);
    });

    test('should return a valid JSON map from model', () {
      // arrange
      final product = Product(
        id: 1,
        name: "Test",
        description: "Desc",
        price: 100,
        imageUrl: "url",
        quantity: 5,
        category: "Cat",
        sellerId: 1,
      );

      // act
      final result = product.toJson();

      // assert
      expect(result["name"], "Test");
      expect(result["id"], 1);
      expect(result["price"], 100);
      expect(result["category"], "Cat");
    });
  });
}
