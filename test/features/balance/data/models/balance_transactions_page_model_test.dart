import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:prueba_buffet/features/balance/data/models/balance_transactions_page_model.dart';
import '../../../../utils/fixture_reader.dart';

void main() {
  group('BalanceTransactionsPageModel Tests', () {
    test('should return a valid page model from response map', () {
      // arrange
      final dynamic fullJson = json.decode(fixture('balance_fixtures.json'));
      final Map<dynamic, dynamic> map = fullJson['transactions_page'];

      // act
      final result = BalanceTransactionsPageModel.fromResponseMap(map);

      // assert
      expect(result.transactions.length, 2);
      expect(result.transactions[0].type, "CARGA");
      expect(result.transactions[1].type, "COMPRA");
      expect(result.nextCursor, "some_cursor");
    });

    test('should handle missing transactions or null cursor safely', () {
      // arrange
      final map = {
        'transactions': null,
        'next_cursor': null
      };

      // act
      final result = BalanceTransactionsPageModel.fromResponseMap(map);

      // assert
      expect(result.transactions.isEmpty, true);
      expect(result.nextCursor, isNull);
    });
  });
}
