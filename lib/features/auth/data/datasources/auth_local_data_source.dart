import 'package:get_storage/get_storage.dart';

class AuthLocalDataSource {
  static const String userKey = 'user';
  static const String useBiometricsKey = 'useBiometrics';

  final GetStorage _storage;

  AuthLocalDataSource(this._storage);

  Future<void> saveUser(Map<String, dynamic> userMap) async {
    await _storage.write(userKey, userMap);
  }

  Map<String, dynamic>? readUser() {
    final dynamic raw = _storage.read(userKey);
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return null;
  }

  Future<void> clearUser() async {
    await _storage.remove(userKey);
  }

  bool isBiometricEnabled() {
    return _storage.read<bool>(useBiometricsKey) ?? false;
  }
}
