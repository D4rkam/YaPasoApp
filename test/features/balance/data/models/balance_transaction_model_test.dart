import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:prueba_buffet/features/balance/data/models/balance_transaction_model.dart';
import '../../../../utils/fixture_reader.dart';

void main() {
  group('BalanceTransactionModel Tests', () {
    test('should return a valid model from map', () {
      // arrange
      final dynamic fullJson = json.decode(fixture('balance_fixtures.json'));
      final Map<dynamic, dynamic> map = fullJson['transaction'];

      // act
      final result = BalanceTransactionModel.fromMap(map);

      // assert
      expect(result.type, "CARGA");
      expect(result.amount, 500);
      expect(result.createdAt, "2023-10-27T10:00:00Z");
    });

    test('should return valid JSON map from model', () {
      // arrange
      const model = BalanceTransactionModel(
        type: "COMPRA",
        amount: -150,
        createdAt: "today",
      );

      // act
      final result = model.toMap();

      // assert
      expect(result['type'], "COMPRA");
      expect(result['amount'], -150);
      expect(result['created_at'], "today");
    });

    test('should handle amount as String safely', () {
      // arrange
      final map = {
        'type': 'DEVOLUCION',
        'amount': '250.50',
        'created_at': 'yesterday'
      };

      // act
      final result = BalanceTransactionModel.fromMap(map);

      // assert
      expect(result.amount, 250.50);
    });
  });
}
