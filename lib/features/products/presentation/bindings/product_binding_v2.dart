import 'package:get/get.dart';
import 'package:prueba_buffet/core/data/providers/products_provider.dart';
import 'package:prueba_buffet/features/products/data/datasources/product_remote_data_source.dart';
import 'package:prueba_buffet/features/products/data/repositories/product_repository_impl.dart';
import 'package:prueba_buffet/features/products/domain/repositories/product_repository.dart';
import 'package:prueba_buffet/features/products/presentation/controllers/product_controller_v2.dart';

class ProductBindingV2 implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductRemoteDataSource>(
      () => ProductRemoteDataSource(ProductsProvider()),
      fenix: true,
    );

    Get.lazyPut<ProductRepository>(
      () => ProductRepositoryImpl(Get.find<ProductRemoteDataSource>()),
      fenix: true,
    );

    // Forzamos recreación cada vez (misma semántica que el legacy ProductBinding)
    Get.delete<ProductControllerV2>(force: true);
    Get.put<ProductControllerV2>(
      ProductControllerV2(repository: Get.find<ProductRepository>()),
    );
  }
}
