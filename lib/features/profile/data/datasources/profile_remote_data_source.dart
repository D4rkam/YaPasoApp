import 'package:prueba_buffet/app/data/provider/users_provider.dart';

class ProfileRemoteDataSource {
  final UsersProvider _usersProvider;

  ProfileRemoteDataSource(this._usersProvider);

  Future<dynamic> updateProfile(Map<String, dynamic> data) async {
    return await _usersProvider.updateUserInfo(data);
  }

  Future<dynamic> updateEmail(String newEmail) async {
    return await _usersProvider.updateEmail(newEmail);
  }

  Future<dynamic> updatePassword(String oldPassword, String newPassword) async {
    return await _usersProvider.updatePassword(oldPassword, newPassword);
  }

  Future<dynamic> deleteAccount() async {
    return await _usersProvider.deleteMyAccount();
  }
}
