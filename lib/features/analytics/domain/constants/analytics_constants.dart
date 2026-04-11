class AnalyticsEvents {
  AnalyticsEvents._();

  // Flujo de Carrito
  static const String viewCart = 'view_cart';
  static const String addToCart = 'add_to_cart';
  static const String removeFromCart = 'remove_from_cart';

  // Flujo de Checkout
  static const String startCheckout = 'start_checkout';
  static const String enterPaymentInfo = 'enter_payment_info';
  static const String purchaseSuccess = 'purchase_success';
  static const String purchaseFailed = 'purchase_failed';

  // Otros
  static const String loginSuccess = 'login_success';
  static const String loginFailed = 'login_failed';
  static const String logout = 'logout';
}

class AnalyticsProperties {
  AnalyticsProperties._();

  static const String orderId = 'order_id';
  static const String totalAmount = 'total_amount';
  static const String currency = 'currency';
  static const String productCount = 'product_count';
  static const String errorMessage = 'error_message';
  static const String paymentMethod = 'payment_method';
}
