import 'package:get/get.dart';
import 'package:prueba_buffet/core/data/providers/users_provider.dart';
import 'package:prueba_buffet/features/orders/data/datasources/order_remote_data_source.dart';
import 'package:prueba_buffet/features/orders/data/repositories/order_repository_impl.dart';
import 'package:prueba_buffet/features/orders/domain/repositories/order_repository.dart';
import 'package:prueba_buffet/features/orders/presentation/controllers/order_controller_v2.dart';

class OrderBindingV2 implements Bindings {
  @override
  void dependencies() {
    // Reutilizamos el UsersProvider si ya está registrado
    if (!Get.isRegistered<UsersProvider>()) {
      Get.lazyPut<UsersProvider>(() => UsersProvider(), fenix: true);
    }

    Get.lazyPut<OrderRemoteDataSource>(
      () => OrderRemoteDataSource(Get.find<UsersProvider>()),
      fenix: true,
    );

    Get.lazyPut<OrderRepository>(
      () => OrderRepositoryImpl(Get.find<OrderRemoteDataSource>()),
      fenix: true,
    );

    if (!Get.isRegistered<OrderControllerV2>()) {
      Get.lazyPut<OrderControllerV2>(
        () => OrderControllerV2(repository: Get.find<OrderRepository>()),
        fenix: true,
      );
    }
  }
}
