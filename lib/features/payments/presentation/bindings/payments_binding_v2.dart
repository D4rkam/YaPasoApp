import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/features/payments/data/datasources/payments_local_data_source.dart';
import 'package:prueba_buffet/features/payments/data/datasources/payments_remote_data_source.dart';
import 'package:prueba_buffet/features/payments/data/providers/payments_api_provider.dart';
import 'package:prueba_buffet/features/payments/data/repositories/payments_repository_impl.dart';
import 'package:prueba_buffet/features/payments/domain/repositories/payments_repository.dart';
import 'package:prueba_buffet/features/payments/domain/usecases/payments_use_cases.dart';
import 'package:prueba_buffet/features/payments/presentation/controllers/payments_controller_v2.dart';

class PaymentsBindingV2 implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentsApiProvider>(() => PaymentsApiProvider(), fenix: true);

    Get.lazyPut<PaymentsRemoteDataSource>(
      () => PaymentsRemoteDataSource(Get.find<PaymentsApiProvider>()),
      fenix: true,
    );

    Get.lazyPut<PaymentsLocalDataSource>(
      () => PaymentsLocalDataSource(GetStorage()),
      fenix: true,
    );

    Get.lazyPut<PaymentsRepository>(
      () => PaymentsRepositoryImpl(
        Get.find<PaymentsRemoteDataSource>(),
        Get.find<PaymentsLocalDataSource>(),
      ),
      fenix: true,
    );

    Get.lazyPut<SaveOrderDateTimeUseCase>(
      () => SaveOrderDateTimeUseCase(Get.find<PaymentsRepository>()),
    );
    Get.lazyPut<IsBiometricsRequiredUseCase>(
      () => IsBiometricsRequiredUseCase(Get.find<PaymentsRepository>()),
    );
    Get.lazyPut<StartMercadoPagoPaymentFromStorageUseCase>(
      () => StartMercadoPagoPaymentFromStorageUseCase(
        Get.find<PaymentsRepository>(),
      ),
    );
    Get.lazyPut<CreateOrderFromStorageUseCase>(
      () => CreateOrderFromStorageUseCase(Get.find<PaymentsRepository>()),
    );
    Get.lazyPut<PayWithBalanceFromStorageUseCase>(
      () => PayWithBalanceFromStorageUseCase(Get.find<PaymentsRepository>()),
    );
    Get.lazyPut<ClearPaymentStateUseCase>(
      () => ClearPaymentStateUseCase(Get.find<PaymentsRepository>()),
    );

    Get.lazyPut<PaymentsControllerV2>(
      () => PaymentsControllerV2(
        Get.find<SaveOrderDateTimeUseCase>(),
        Get.find<IsBiometricsRequiredUseCase>(),
        Get.find<StartMercadoPagoPaymentFromStorageUseCase>(),
        Get.find<CreateOrderFromStorageUseCase>(),
        Get.find<PayWithBalanceFromStorageUseCase>(),
        Get.find<ClearPaymentStateUseCase>(),
      ),
    );
  }
}
