import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/core/models/user.dart';
import 'package:prueba_buffet/core/presentation/widgets/custom_toast.dart';
import 'package:prueba_buffet/features/balance/presentation/pages/load_balance_v2_page.dart';
import 'package:prueba_buffet/features/balance/data/datasources/balance_local_data_source.dart';
import 'package:prueba_buffet/features/balance/data/datasources/balance_remote_data_source.dart';
import 'package:prueba_buffet/features/balance/data/repositories/balance_repository_impl.dart';
import 'package:prueba_buffet/features/balance/domain/entities/balance_transaction.dart';
import 'package:prueba_buffet/features/balance/domain/repositories/balance_repository.dart';
import 'package:prueba_buffet/features/balance/domain/usecases/balance_use_cases.dart';
import 'package:prueba_buffet/core/data/providers/users_provider.dart';
import 'package:prueba_buffet/core/data/providers/wallet_provider.dart';
import 'package:prueba_buffet/utils/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class BalanceControllerV2 extends GetxController {
  late final BalanceRepository _repository;
  late final GetStoredBalanceStateUseCase _getStoredBalanceState;
  late final FetchBalanceUseCase _fetchBalance;
  late final GetTransactionsUseCase _getTransactions;
  late final StartLoadBalanceUseCase _startLoadBalance;
  late final SavePendingLoadAmountUseCase _savePendingLoadAmount;

  BalanceControllerV2({BalanceRepository? repository}) {
    _repository = repository ??
        BalanceRepositoryImpl(
          BalanceLocalDataSource(GetStorage()),
          BalanceRemoteDataSource(WalletProvider(), UsersProvider()),
        );

    _getStoredBalanceState = GetStoredBalanceStateUseCase(_repository);
    _fetchBalance = FetchBalanceUseCase(_repository);
    _getTransactions = GetTransactionsUseCase(_repository);
    _startLoadBalance = StartLoadBalanceUseCase(_repository);
    _savePendingLoadAmount = SavePendingLoadAmountUseCase(_repository);
  }

  final User userSession = User.safeFromStorage();

  late Rx<double> balance;
  late int fileNum;
  final transactions = <Map<String, dynamic>>[].obs;

  final isLoading = false.obs;
  final isFetchingMore = false.obs;

  String? nextCursor;

  Map<String, dynamic> _transactionToMap(BalanceTransaction transaction) {
    return {
      'type': transaction.type,
      'amount': transaction.amount,
      'created_at': transaction.createdAt,
    };
  }

  @override
  void onInit() async {
    final state = _getStoredBalanceState();
    balance = state.balance.obs;
    fileNum = state.fileNum;
    await getMyInitialTransactions();
    super.onInit();
  }

  void refreshFromStorage() {
    try {
      final state = _getStoredBalanceState();
      balance.value = state.balance;
      fileNum = state.fileNum;
    } catch (e) {
      logger.e('BalanceController.refreshFromStorage CRASH: $e');
    }
  }

  Future<void> fetchBalance() async {
    try {
      final result = await _fetchBalance();
      if (result != null) {
        balance.value = result;
        logger.i('BalanceController.fetchBalance -> balance: ${balance.value}');
      }
    } catch (e) {
      logger.e('Error obteniendo saldo fresco: $e');
    }
  }

  void updateBalance(double newBalance) {
    balance.value = balance.value + newBalance;
  }

  void goToLoadBalanceScreen() {
    Get.to(() => LoadBalanceV2Page());
  }

  Future<void> confirmLoadBalance(String amountText) async {
    final amount = double.tryParse(amountText.replaceAll(',', '.'));
    if (amount == null || amount <= 0) {
      CustomToast.showError(
        title: 'Error',
        message: 'Ingresa un monto valido para cargar',
      );
      return;
    }
    if (amount < 500) {
      CustomToast.showError(
        title: 'Error',
        message: 'La carga minima es de \$500',
      );
      return;
    }

    isLoading.value = true;
    try {
      final initPoint = await _startLoadBalance(
        amount: amount,
        description: 'Carga de saldo desde la app - ${userSession.name}',
      );

      if (initPoint != null && initPoint.isNotEmpty) {
        await _savePendingLoadAmount(amount);
        Get.back();
        await _launchMercadoPago(initPoint);
      } else {
        CustomToast.showError(
          title: 'Error',
          message: 'No se pudo obtener el link de Mercado Pago',
        );
      }
    } catch (e) {
      CustomToast.showError(
        title: 'Error',
        message: 'No se pudo conectar con el servidor',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _launchMercadoPago(String initPoint) async {
    final uri = Uri.parse(initPoint);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      CustomToast.showError(
        title: 'Error',
        message: 'No se pudo abrir el link de Mercado Pago',
      );
    }
  }

  Future<void> getMyInitialTransactions() async {
    isLoading.value = true;
    try {
      logger.i('[BALANCE CONTROLLER] Obteniendo transacciones iniciales...');
      final page = await _getTransactions();
      transactions.assignAll(page.transactions.map(_transactionToMap));
      nextCursor = page.nextCursor;
    } catch (e) {
      CustomToast.showError(
        title: 'Error',
        message: 'No se pudieron cargar las transacciones',
      );
    }
    isLoading.value = false;
  }

  Future<void> getMoreTransactions() async {
    if (nextCursor == null || isFetchingMore.value) return;

    isFetchingMore.value = true;
    try {
      final page = await _getTransactions(cursor: nextCursor);
      transactions.addAll(page.transactions.map(_transactionToMap));
      nextCursor = page.nextCursor;
    } catch (e) {
      CustomToast.showError(
        title: 'Error',
        message: 'No se pudieron cargar mas transacciones',
      );
    }
    isFetchingMore.value = false;
  }
}
