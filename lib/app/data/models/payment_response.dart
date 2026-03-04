class MercadoPagoPreference {
  final String id;
  final String initPoint;
  final String sandoxInitPoint;

  MercadoPagoPreference(
      {required this.id,
      required this.initPoint,
      required this.sandoxInitPoint});

  factory MercadoPagoPreference.fromJson(Map<String, dynamic> json) {
    return MercadoPagoPreference(
      id: json['id']?.toString() ?? '',
      initPoint: json['init_point']?.toString() ?? '',
      sandoxInitPoint: json['sandbox_init_point']?.toString() ?? '',
    );
  }
}

/// Modelo que representa la respuesta común de los endpoints:
/// POST /api/pay/ y POST /api/transactions/load-balance
class PaymentResponse {
  final MercadoPagoPreference preference;

  PaymentResponse({required this.preference});

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      preference:
          MercadoPagoPreference.fromJson(Map<String, dynamic>.from(json ?? {})),
    );
  }
}
