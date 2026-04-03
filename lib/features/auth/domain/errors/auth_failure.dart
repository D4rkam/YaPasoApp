class AuthFailure {
  final String code;
  final String message;

  const AuthFailure(this.code, this.message);

  static const invalidCredentials = AuthFailure(
    'invalid_credentials',
    'No se pudo iniciar sesion con esas credenciales.',
  );

  static const invalidSession = AuthFailure(
    'invalid_session',
    'La sesion ya no es valida.',
  );

  static const registerFailed = AuthFailure(
    'register_failed',
    'No se pudo crear la cuenta.',
  );

  static const networkError = AuthFailure(
    'network_error',
    'No se pudo conectar con el servidor.',
  );
}
