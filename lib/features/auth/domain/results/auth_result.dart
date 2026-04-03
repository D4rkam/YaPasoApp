import 'package:prueba_buffet/features/auth/domain/errors/auth_failure.dart';

class AuthResult<T> {
  final T? data;
  final AuthFailure? failure;

  const AuthResult._({this.data, this.failure});

  bool get isSuccess => failure == null;

  factory AuthResult.success(T data) {
    return AuthResult._(data: data);
  }

  factory AuthResult.error(AuthFailure failure) {
    return AuthResult._(failure: failure);
  }
}
