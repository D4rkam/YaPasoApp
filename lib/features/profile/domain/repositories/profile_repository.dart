abstract class ProfileRepository {
  Future<bool> updateProfile(Map<String, dynamic> data);
  Future<bool> updateEmail(String newEmail);
  Future<bool> updatePassword(String oldPassword, String newPassword);
  Future<bool> deleteAccount();
}
