import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart' hide Response; // Ocultamos Response de Get
import 'package:dio/dio.dart'; // Importamos Dio
import 'package:mocktail/mocktail.dart';
import 'package:prueba_buffet/app/controllers/balance_controller.dart';
import 'package:prueba_buffet/app/controllers/home_controller.dart';
import 'package:prueba_buffet/app/data/models/product.dart';
import 'package:prueba_buffet/app/data/provider/products_provider.dart';
import 'package:prueba_buffet/app/data/provider/users_provider.dart';

class MockProductsProvider extends Mock implements ProductsProvider {}

class MockUsersProvider extends Mock implements UsersProvider {}

class TestBalanceController extends BalanceController {
  @override
  void onInit() {}
}

void main() {
  late HomeController homeController;
  late MockProductsProvider mockProductsProvider;
  late MockUsersProvider mockUsersProvider;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    Get.testMode = true;

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall methodCall) async {
        return '.';
      },
    );
  });

  setUp(() {
    mockProductsProvider = MockProductsProvider();
    mockUsersProvider = MockUsersProvider();

    Get.put<BalanceController>(TestBalanceController());

    homeController = HomeController();
    homeController.productsProvider = mockProductsProvider;
    homeController.usersProvider = mockUsersProvider;
  });

  tearDown(() {
    Get.reset();
  });

  group('HomeController Tests - Búsqueda de Productos', () {
    test(
        'searchProductsInBackend debe actualizar searchResultsFromApi si es 200',
        () async {
      // Adaptamos el FakeResponse a Dio
      final fakeResponse = Response<dynamic>(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: [
          // Usamos data en vez de body
          {
            "id": 1,
            "name": "Alfajor",
            "description": "Triple",
            "price": 800,
            "imageUrl": "https://fake.url/img.png",
            "quantity": 10,
            "category": "Snacks",
            "sellerId": 1
          }
        ],
      );

      when(() => mockProductsProvider.searchProducts(query: 'Alfa'))
          .thenAnswer((_) async => fakeResponse);

      await homeController.searchProductsInBackend('Alfa');

      expect(homeController.searchResultsFromApi.length, 1);
      expect(homeController.searchResultsFromApi.first.name, 'Alfajor');
      expect(homeController.isSearchingApi.value, false);
    });

    test(
        'searchSuggestions debe devolver máximo 5 elementos cuando el input tiene foco',
        () {
      homeController.isSearchFocused.value = true;
      homeController.searchQuery.value = 'a';

      homeController.searchResultsFromApi.assignAll(List.generate(
          10,
          (index) => Product(
                id: index,
                name: 'Prod $index',
                description: 'Desc $index',
                price: 100,
                imageUrl: 'https://fake.url/img.png',
                quantity: 1,
                category: 'A',
                sellerId: 1,
              )));

      final suggestions = homeController.searchSuggestions;

      expect(suggestions.length, 5);
    });

    test('filteredProducts debe mostrar productos base si no hay búsqueda', () {
      homeController.searchQuery.value = '';
      homeController.productsFromApi.assignAll([
        Product(
          id: 1,
          name: 'Base 1',
          description: 'Desc base',
          price: 100,
          imageUrl: 'https://fake.url/img.png',
          quantity: 1,
          category: 'A',
          sellerId: 1,
        )
      ]);

      final list = homeController.filteredProducts;

      expect(list.length, 1);
      expect(list.first.name, 'Base 1');
    });
  });
}
