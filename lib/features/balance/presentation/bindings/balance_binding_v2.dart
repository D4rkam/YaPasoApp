import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/core/data/providers/users_provider.dart';
import 'package:prueba_buffet/core/data/providers/wallet_provider.dart';
import 'package:prueba_buffet/features/balance/data/datasources/balance_local_data_source.dart';
import 'package:prueba_buffet/features/balance/data/datasources/balance_remote_data_source.dart';
import 'package:prueba_buffet/features/balance/data/repositories/balance_repository_impl.dart';
import 'package:prueba_buffet/features/balance/domain/repositories/balance_repository.dart';
import 'package:prueba_buffet/features/balance/presentation/controllers/balance_controller_v2.dart';

class BalanceBindingV2 implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BalanceLocalDataSource>(
      () => BalanceLocalDataSource(GetStorage()),
      fenix: true,
    );

    Get.lazyPut<BalanceRemoteDataSource>(
      () => BalanceRemoteDataSource(WalletProvider(), UsersProvider()),
      fenix: true,
    );

    Get.lazyPut<BalanceRepository>(
      () => BalanceRepositoryImpl(
        Get.find<BalanceLocalDataSource>(),
        Get.find<BalanceRemoteDataSource>(),
      ),
      fenix: true,
    );

    if (Get.isRegistered<BalanceControllerV2>()) {
      Get.find<BalanceControllerV2>().fetchBalance();
      return;
    }

    Get.put(
      BalanceControllerV2(repository: Get.find<BalanceRepository>()),
      permanent: true,
    );
  }
}
