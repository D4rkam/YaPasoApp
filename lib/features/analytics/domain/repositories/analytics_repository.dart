abstract class AnalyticsRepository {
  /// Captura un evento personalizado con propiedades opcionales.
  Future<void> capture({
    required String eventName,
    Map<String, Object>? properties,
  });

  /// Identifica al usuario con un ID único y propiedades opcionales.
  Future<void> identify({
    required String userId,
    Map<String, Object>? userProperties,
  });

  /// Registra una vista de pantalla.
  Future<void> screen({
    required String screenName,
    Map<String, Object>? properties,
  });

  /// Captura una excepción para el seguimiento de errores.
  Future<void> captureException({
    required dynamic exception,
    StackTrace? stackTrace,
    Map<String, Object>? properties,
  });

  /// Resetea la identidad del usuario (útil en logout).
  Future<void> reset();
}
