import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:prueba_buffet/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:prueba_buffet/features/cart/domain/repositories/cart_repository.dart';
import 'package:prueba_buffet/features/cart/presentation/controllers/shopping_cart_controller_v2.dart';

class CartBindingV2 implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartLocalDataSource>(
      () => CartLocalDataSource(GetStorage()),
      fenix: true,
    );

    Get.lazyPut<CartRepository>(
      () => CartRepositoryImpl(Get.find<CartLocalDataSource>()),
      fenix: true,
    );

    if (!Get.isRegistered<ShoppingCartController>()) {
      Get.lazyPut<ShoppingCartController>(
        () => ShoppingCartController(repository: Get.find<CartRepository>()),
        fenix: true,
      );
    }
  }
}
