import 'package:get/get.dart';
import 'package:prueba_buffet/core/models/product.dart';
import 'package:prueba_buffet/features/analytics/domain/constants/analytics_constants.dart';
import 'package:prueba_buffet/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:prueba_buffet/features/products/domain/repositories/product_repository.dart';
import 'package:prueba_buffet/features/products/domain/usecases/get_product_by_id_use_case.dart';

class ProductControllerV2 extends GetxController {
  late final GetProductByIdUseCase _getProductById;

  final Rx<Product?> product = Rx<Product?>(null);
  final RxInt quantitySelected = 0.obs;

  ProductControllerV2({required ProductRepository repository}) {
    _getProductById = GetProductByIdUseCase(repository);
  }

  @override
  void onInit() {
    super.onInit();
    final productId = Get.arguments?.toString() ?? '';
    if (productId.isNotEmpty) {
      _fetchProduct(productId);
    }
  }

  Future<void> _fetchProduct(String id) async {
    try {
      final result = await _getProductById(id);
      product.value = result;
      product.refresh();

      if (result != null && result.quantity <= 0) {
        Get.find<AnalyticsRepository>().capture(
          eventName: AnalyticsEvents.itemOutOfStockViewed,
          properties: <String, Object>{
            'product_id': result.id,
            'product_name': result.name,
          },
        );
      }
    } catch (_) {
      // Si falla, product queda null y la UI muestra loading/error
    }
  }
}
