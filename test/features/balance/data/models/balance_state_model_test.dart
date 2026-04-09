import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:prueba_buffet/features/balance/data/models/balance_state_model.dart';
import '../../../../utils/fixture_reader.dart';

void main() {
  group('BalanceStateModel Tests', () {
    test('should return a valid model from storage map', () {
      // arrange
      final dynamic fullJson = json.decode(fixture('balance_fixtures.json'));
      final Map<dynamic, dynamic> map = fullJson['state'];

      // act
      final result = BalanceStateModel.fromStorageMap(map);

      // assert
      expect(result.balance, 1500.5);
      expect(result.fileNum, 12345);
    });

    test('should return default model when map is null', () {
      // act
      final result = BalanceStateModel.fromStorageMap(null);

      // assert
      expect(result.balance, 0);
      expect(result.fileNum, 0);
    });

    test('should handle incorrect types safely', () {
      // arrange
      final map = {
        'balance': '1500.5', // String instead of num
        'file_num': 12345.0   // Double instead of int
      };

      // act
      final result = BalanceStateModel.fromStorageMap(map);

      // assert
      expect(result.balance, 0); 
      expect(result.fileNum, 0); // int.tryParse('12345.0') returns null, then ?? 0
    });
  });
}
