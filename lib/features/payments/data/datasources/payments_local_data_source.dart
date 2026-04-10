import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/features/payments/data/models/payments_model.dart';

class PaymentsLocalDataSource {
  static const String cartItemsKey = 'cart_items';
  static const String orderDateTimeKey = 'order_datetime';
  static const String pendingCartTotalKey = 'pending_cart_total';
  static const String orderKey = 'order';
  static const String userKey = 'user';
  static const String requireBiometricsKey = 'requireBiometricsForPay';

  final GetStorage _storage;

  PaymentsLocalDataSource(this._storage);

  Future<void> saveOrderDateTime(DateTime dateTime) async {
    await _storage.write(orderDateTimeKey, dateTime.toIso8601String());
  }

  DateTime? readOrderDateTime() {
    final raw = _storage.read(orderDateTimeKey);
    if (raw == null) return null;
    return DateTime.tryParse(raw.toString());
  }

  List<StoredCartItemDto> readStoredCartItems() {
    final raw = _storage.read(cartItemsKey);
    if (raw == null) return const [];

    try {
      List<dynamic> decoded;
      if (raw is String) {
        decoded = jsonDecode(raw) as List<dynamic>;
      } else if (raw is List) {
        decoded = raw;
      } else {
        return const [];
      }

      return decoded
          .whereType<Map>()
          .map((json) =>
              StoredCartItemDto.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } catch (_) {
      return const [];
    }
  }

  int? readSchoolIdFromUser() {
    final raw = _storage.read(userKey);
    if (raw is! Map) return null;
    final userMap = Map<String, dynamic>.from(raw);
    final schoolId = userMap['school_id'];
    if (schoolId is int) return schoolId;
    return int.tryParse(schoolId?.toString() ?? '');
  }

  bool isBiometricsRequired() {
    return _storage.read<bool>(requireBiometricsKey) ?? false;
  }

  Future<void> savePendingCartTotal(double total) async {
    await _storage.write(pendingCartTotalKey, total);
  }

  Future<void> saveCreatedOrder(Map<String, dynamic> order) async {
    await _storage.write(orderKey, order);
  }

  Map<String, dynamic>? readCreatedOrder() {
    final raw = _storage.read(orderKey);
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return null;
  }

  Future<void> clearAfterBalancePayment() async {
    await _storage.remove(orderDateTimeKey);
    await _storage.remove(orderKey);
  }

  Future<void> clearPaymentState() async {
    await _storage.remove(orderDateTimeKey);
    await _storage.remove(orderKey);
    await _storage.remove(pendingCartTotalKey);
  }
}
