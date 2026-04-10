import 'package:prueba_buffet/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:prueba_buffet/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remote;

  ProfileRepositoryImpl(this._remote);

  @override
  Future<bool> updateProfile(Map<String, dynamic> data) async {
    final response = await _remote.updateProfile(data);
    return response.statusCode == 200 || response.statusCode == 202;
  }

  @override
  Future<bool> updateEmail(String newEmail) async {
    final response = await _remote.updateEmail(newEmail);
    return response.statusCode == 200 || response.statusCode == 202;
  }

  @override
  Future<bool> updatePassword(String oldPassword, String newPassword) async {
    final response = await _remote.updatePassword(oldPassword, newPassword);
    return response.statusCode == 200 || response.statusCode == 202;
  }

  @override
  Future<bool> deleteAccount() async {
    final response = await _remote.deleteAccount();
    return response.statusCode == 204;
  }
}
