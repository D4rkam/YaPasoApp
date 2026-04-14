import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/core/models/user.dart';
import 'package:prueba_buffet/core/routes/routes.dart';
import 'package:prueba_buffet/core/presentation/bindings/app_binding_v2.dart';
import 'package:prueba_buffet/features/auth/presentation/bindings/auth_binding_v2.dart';

class AuthService extends GetxService {
  final _user = Rxn<User>();
  User? get user => _user.value;
  bool get isAuthenticated => _user.value?.id != null;

  Future<AuthService> init() async {
    await _loadUserFromStorage();
    return this;
  }

  Future<void> _loadUserFromStorage() async {
    _user.value = User.safeFromStorage();
  }

  String resolveInitialRoute() {
    if (isAuthenticated) {
      bool useBiometrics = GetStorage().read<bool>('useBiometrics') ?? false;
      return useBiometrics ? Routes.SECURITY : Routes.HOME;
    }
    return Routes.INITIAL;
  }

  Bindings? resolveInitialBinding() {
    return isAuthenticated ? AppBindingV2() : AuthBindingV2();
  }

  /// Actualiza la sesión tras un login exitoso
  void updateSession(User newUser) {
    _user.value = newUser;
  }

  /// Limpia la sesión tras un logout
  void logout() {
    _user.value = null;
  }
}
