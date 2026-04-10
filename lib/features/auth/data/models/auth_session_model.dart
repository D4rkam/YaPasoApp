import 'package:prueba_buffet/features/auth/data/models/auth_user_dto.dart';
import 'package:prueba_buffet/features/auth/domain/entities/auth_session.dart';

class AuthSessionModel extends AuthSession {
  const AuthSessionModel({
    required super.userId,
    required super.username,
    required super.name,
    required super.email,
    required super.hasToken,
  });

  factory AuthSessionModel.fromUserDto(AuthUserDto user) {
    return AuthSessionModel(
      userId: user.id,
      username: user.username,
      name: user.name,
      email: user.email,
      hasToken: user.hasToken,
    );
  }

  factory AuthSessionModel.fromUserMap(Map<String, dynamic> map) {
    return AuthSessionModel.fromUserDto(AuthUserDto.fromMap(map));
  }
}
