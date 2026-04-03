class PaymentFailure {
  final String code;
  final String message;

  const PaymentFailure(this.code, this.message);

  static const missingCart = PaymentFailure(
    'missing_cart',
    'No hay productos en el carrito para procesar el pago.',
  );

  static const missingDateTime = PaymentFailure(
    'missing_datetime',
    'No se selecciono horario de retiro.',
  );

  static const missingSchool = PaymentFailure(
    'missing_school',
    'No se pudo obtener la escuela del usuario.',
  );

  static const missingOrder = PaymentFailure(
    'missing_order',
    'No se encontro una orden valida para cobrar.',
  );

  static const invalidOrder = PaymentFailure(
    'invalid_order',
    'La orden almacenada es invalida.',
  );

  static const authenticationRequired = PaymentFailure(
    'auth_required',
    'Pago cancelado por falta de autenticacion.',
  );

  static const noInternet = PaymentFailure(
    'no_internet',
    'No podes realizar pagos sin internet.',
  );

  static const network = PaymentFailure(
    'network_error',
    'No se pudo conectar con el servidor.',
  );

  static const unknown = PaymentFailure(
    'unknown',
    'No se pudo completar la operacion.',
  );

  static PaymentFailure api(String message) {
    return PaymentFailure('api_error', message);
  }
}
