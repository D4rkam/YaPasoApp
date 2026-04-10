import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prueba_buffet/features/orders/domain/repositories/order_repository.dart';
import 'package:prueba_buffet/features/orders/presentation/controllers/order_controller_v2.dart';

class MockOrderRepository extends Mock implements OrderRepository {}

void main() {
  late OrderControllerV2 controller;
  late MockOrderRepository mockRepository;

  setUp(() {
    mockRepository = MockOrderRepository();
    
    // Mock successful fetch for onInit's fetchInitialOrders
    when(() => mockRepository.getOrders(
      limit: any(named: 'limit'),
      status: any(named: 'status'),
      cursor: any(named: 'cursor'),
    )).thenAnswer((_) async => {'orders': [], 'next_cursor': null});

    controller = OrderControllerV2(repository: mockRepository);
  });

  group('OrderControllerV2 Tests', () {
    test('initial state should be correct', () {
      expect(controller.activeTab.value, 'ENCARGADO');
      expect(controller.ordersData['ENCARGADO'], isEmpty);
    });

    test('switchTab should change activeTab and fetch if not fetched', () async {
      // arrange
      final status = 'LISTO';
      when(() => mockRepository.getOrders(
        status: status,
        limit: any(named: 'limit'),
        cursor: any(named: 'cursor'),
      )).thenAnswer((_) async => {'orders': [], 'next_cursor': null});

      // act
      controller.switchTab(status);

      // assert
      expect(controller.activeTab.value, status);
      verify(() => mockRepository.getOrders(status: status, limit: any(named: 'limit'))).called(1);
    });

    test('fetchOrders should update ordersData and cursors', () async {
      // arrange
      final status = 'ENCARGADO';
      final orders = [
        {'id': 1, 'total_price': 100, 'items': []}
      ];
      when(() => mockRepository.getOrders(
        status: status,
        limit: any(named: 'limit'),
        cursor: any(named: 'cursor'),
      )).thenAnswer((_) async => {'orders': orders, 'next_cursor': 'next-123'});

      // act
      await controller.fetchOrders(status, isInitial: true);

      // assert
      expect(controller.ordersData[status]!.length, 1);
      expect(controller.cursors[status], 'next-123');
    });
  });
}
