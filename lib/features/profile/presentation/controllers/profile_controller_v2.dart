import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/app/data/models/user.dart';
import 'package:prueba_buffet/app/ui/global_widgets/custom_toast.dart';
import 'package:prueba_buffet/features/profile/domain/repositories/profile_repository.dart';
import 'package:prueba_buffet/features/profile/domain/usecases/profile_use_cases.dart';
import 'package:prueba_buffet/utils/logger.dart';

class ProfileControllerV2 extends GetxController {
  late final UpdateProfileUseCase _updateProfile;
  late final UpdateEmailUseCase _updateEmail;
  late final UpdatePasswordUseCase _updatePassword;
  late final DeleteAccountUseCase _deleteAccount;

  RxBool isUpdatingProfile = false.obs;
  RxBool isUpdatingEmail = false.obs;
  RxBool isUpdatingPassword = false.obs;

  late User userSession;

  ProfileControllerV2({required ProfileRepository repository}) {
    _updateProfile = UpdateProfileUseCase(repository);
    _updateEmail = UpdateEmailUseCase(repository);
    _updatePassword = UpdatePasswordUseCase(repository);
    _deleteAccount = DeleteAccountUseCase(repository);
  }

  @override
  void onInit() {
    super.onInit();
    _loadUserSession();
  }

  void _loadUserSession() {
    final userData = GetStorage().read("user");
    if (userData != null) {
      userSession = User.fromJson(Map<String, dynamic>.from(userData));
    } else {
      userSession = User();
    }
  }

  Future<void> updateProfile(Map<String, dynamic> newInfo) async {
    isUpdatingProfile.value = true;
    try {
      final success = await _updateProfile(newInfo);

      if (success) {
        if (newInfo.containsKey('age'))
          userSession.age = int.parse(newInfo['age'].toString());
        if (newInfo.containsKey('curse_year'))
          userSession.curse_year = int.parse(newInfo['curse_year'].toString());
        if (newInfo.containsKey('curse_division'))
          userSession.curse_division = newInfo['curse_division'];
        if (newInfo.containsKey('turn')) userSession.turn = newInfo['turn'];

        GetStorage().write("user", userSession.toJson());
        update(['profile_info']);

        Get.back();
        CustomToast.showSuccess(
            title: "Perfil actualizado",
            message: "Tus datos se han actualizado correctamente");
      } else {
        CustomToast.showError(
            title: "Error", message: "No se pudo actualizar el perfil");
      }
    } catch (e) {
      logger.e("Error al actualizar perfil: $e");
    } finally {
      isUpdatingProfile.value = false;
    }
  }

  Future<void> updateEmail(String newEmail) async {
    if (newEmail.isEmpty || !newEmail.contains('@')) {
      CustomToast.showError(title: "Error", message: "Ingresa un email válido");
      return;
    }

    isUpdatingEmail.value = true;
    try {
      final success = await _updateEmail(newEmail);

      if (success) {
        userSession.email = newEmail;
        GetStorage().write("user", userSession.toJson());
        update(['profile_info']);

        Get.back();
        CustomToast.showSuccess(
            title: "Email actualizado",
            message: "Tu email se ha actualizado correctamente");
      } else {
        CustomToast.showError(
            title: "Error", message: "No se pudo actualizar el email");
      }
    } catch (e) {
      logger.e("Error al actualizar email: $e");
    } finally {
      isUpdatingEmail.value = false;
    }
  }

  Future<void> updatePassword(String oldPassword, String newPassword) async {
    if (newPassword.length < 6) {
      CustomToast.showError(
          title: "Error",
          message: "La contraseña debe tener al menos 6 caracteres");
      return;
    }

    isUpdatingPassword.value = true;
    try {
      final success = await _updatePassword(oldPassword, newPassword);

      if (success) {
        Get.back();
        CustomToast.showSuccess(
            title: "Contraseña actualizada",
            message: "Tu contraseña se ha actualizado de forma segura");
      } else {
        CustomToast.showError(
            title: "Error", message: "Verifica tu contraseña actual");
      }
    } catch (e) {
      logger.e("Error al actualizar contraseña: $e");
    } finally {
      isUpdatingPassword.value = false;
    }
  }

  Future<void> deleteAccount() async {
    try {
      final success = await _deleteAccount();

      if (success) {
        GetStorage().erase();
        Get.offAllNamed('/login');
        CustomToast.showSuccess(
            title: "Cuenta eliminada",
            message: "Tu cuenta ha sido eliminada correctamente");
      }
    } catch (e) {
      CustomToast.showError(
          title: "Error", message: "No se pudo eliminar la cuenta");
    }
  }
}
