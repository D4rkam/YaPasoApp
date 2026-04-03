import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';
import 'package:prueba_buffet/features/payments/domain/errors/payment_failure.dart';
import 'package:prueba_buffet/features/payments/domain/usecases/payments_use_cases.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentsControllerV2 extends GetxController {
  final SaveOrderDateTimeUseCase _saveOrderDateTime;
  final IsBiometricsRequiredUseCase _isBiometricsRequired;
  final StartMercadoPagoPaymentFromStorageUseCase _startMercadoPago;
  final CreateOrderFromStorageUseCase _createOrder;
  final PayWithBalanceFromStorageUseCase _payWithBalance;
  final ClearPaymentStateUseCase _clearPaymentState;

  PaymentsControllerV2(
    this._saveOrderDateTime,
    this._isBiometricsRequired,
    this._startMercadoPago,
    this._createOrder,
    this._payWithBalance,
    this._clearPaymentState,
  );

  final isLoading = false.obs;
  final errorMessage = RxnString();

  final LocalAuthentication _auth = LocalAuthentication();

  Future<void> setOrderDateTime(DateTime dateTime) {
    return _saveOrderDateTime(dateTime);
  }

  Future<bool> executeMercadoPagoFlow() async {
    isLoading.value = true;
    errorMessage.value = null;

    final paymentResult = await _startMercadoPago();
    if (!paymentResult.isSuccess || paymentResult.data == null) {
      errorMessage.value = paymentResult.failure?.message;
      isLoading.value = false;
      return false;
    }

    final opened = await _launchExternal(paymentResult.data!);
    if (!opened) {
      errorMessage.value = 'No se pudo abrir Mercado Pago.';
      isLoading.value = false;
      return false;
    }

    isLoading.value = false;
    return true;
  }

  Future<bool> executeBalanceFlow() async {
    isLoading.value = true;
    errorMessage.value = null;

    final isAuthorized = await _authenticateIfRequired();
    if (!isAuthorized) {
      errorMessage.value = PaymentFailure.authenticationRequired.message;
      isLoading.value = false;
      return false;
    }

    final hasConnection = await _hasConnectivity();
    if (!hasConnection) {
      errorMessage.value = PaymentFailure.noInternet.message;
      isLoading.value = false;
      return false;
    }

    final createOrderResult = await _createOrder();
    if (!createOrderResult.isSuccess) {
      errorMessage.value = createOrderResult.failure?.message;
      isLoading.value = false;
      return false;
    }

    final paymentResult = await _payWithBalance();
    if (!paymentResult.isSuccess) {
      errorMessage.value = paymentResult.failure?.message;
      isLoading.value = false;
      return false;
    }

    isLoading.value = false;
    return true;
  }

  Future<void> clearState() {
    return _clearPaymentState();
  }

  Future<bool> _authenticateIfRequired() async {
    final requireBiometrics = await _isBiometricsRequired();
    if (!requireBiometrics) return true;

    try {
      final canAuthBiometric = await _auth.canCheckBiometrics;
      final canAuthenticate =
          canAuthBiometric || await _auth.isDeviceSupported();
      if (!canAuthenticate) return true;

      return await _auth.authenticate(
        localizedReason:
            'Por favor, verifica tu identidad para confirmar la compra',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
        authMessages: const [
          AndroidAuthMessages(
            signInTitle: 'Confirmar pago',
            biometricHint: '',
            biometricNotRecognized: 'No se reconocio la huella',
            biometricRequiredTitle: 'Se requiere huella',
            biometricSuccess: 'Pago autorizado',
            cancelButton: 'Cancelar',
          ),
          IOSAuthMessages(cancelButton: 'Cancelar'),
        ],
      );
    } catch (_) {
      return true;
    }
  }

  Future<bool> _hasConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult.isNotEmpty &&
        !connectivityResult.contains(ConnectivityResult.none);
  }

  Future<bool> _launchExternal(String url) async {
    final uri = Uri.parse(url);
    if (!await canLaunchUrl(uri)) return false;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
    return true;
  }
}
