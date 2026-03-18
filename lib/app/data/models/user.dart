import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/utils/logger.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

// ── Helpers de conversión segura ──────────────────────────────────────────
int? _safeInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is double) return v.toInt();
  return int.tryParse(v.toString());
}

double _safeDouble(dynamic v) {
  if (v == null) return 0.0;
  if (v is double) return v;
  if (v is int) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0.0;
}

String _safeString(dynamic v, [String fallback = ""]) {
  if (v == null) return fallback;
  return v.toString();
}

Map<String, dynamic>? _safeMap(dynamic v) {
  if (v == null) return null;
  if (v is Map) {
    try {
      return Map<String, dynamic>.from(v);
    } catch (_) {
      return {};
    }
  }
  return null;
}

List? _safeList(dynamic v) {
  if (v is List) return v;
  return [];
}

// ──────────────────────────────────────────────────────────────────────────

class User {
  int? id;
  String email;
  String name;
  String lastName;
  String username;
  String password;
  int age;
  String fileNum;
  int? schoolId;
  int? curse_year;
  String? curse_division;
  String? turn;
  List? orders;
  double? balance;
  Map<String, dynamic>? token;

  User(
      {this.id,
      this.name = "",
      this.email = "",
      this.lastName = "",
      this.username = "",
      this.password = "",
      this.fileNum = "0",
      this.age = 14,
      this.schoolId,
      this.curse_year,
      this.curse_division,
      this.turn,
      this.orders,
      this.balance,
      this.token});

  /// Parseo seguro desde un Map. Nunca lanza excepciones.
  factory User.fromJson(dynamic rawJson) {
    try {
      final Map<String, dynamic> json = (rawJson is Map)
          ? Map<String, dynamic>.from(rawJson)
          : <String, dynamic>{};

      return User(
        id: _safeInt(json["id"]),
        email: _safeString(json["email"]),
        name: _safeString(json["name"]),
        lastName: _safeString(json["last_name"]),
        username: _safeString(json["username"]),
        password: _safeString(json["password"]),
        fileNum: _safeString(json["file_num"], "0"),
        age: _safeInt(json["age"]) ?? 14,
        schoolId: _safeInt(json["school_id"]),
        curse_year: _safeInt(json["curse_year"]),
        curse_division: _safeString(json["curse_division"]),
        turn: _safeString(json["turn"], "SIN SELECCIONAR"),
        orders: _safeList(json["orders"]),
        balance: _safeDouble(json["balance"]),
        token: _safeMap(json["token"]),
      );
    } catch (e, stack) {
      logger.e("⚠️ User.fromJson CRASH capturado: $e", stackTrace: stack);
      logger.e("rawJson type: ${rawJson.runtimeType} → $rawJson");
      // Devolver usuario vacío para que la app no muera
      return User();
    }
  }

  /// Lee el usuario del storage local de forma 100% segura.
  /// Nunca lanza excepciones. Si no hay datos, devuelve un User vacío.
  static User safeFromStorage() {
    try {
      final raw = GetStorage().read("user");
      if (raw == null) return User();
      return User.fromJson(raw);
    } catch (e, stack) {
      logger.e("⚠️ User.safeFromStorage CRASH: $e", stackTrace: stack);
      return User();
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
        "last_name": lastName,
        "username": username,
        "password": password,
        "age": age,
        "file_num": fileNum,
        "school_id": schoolId,
        "curse_year": curse_year,
        "curse_division": curse_division,
        "turn": turn,
        "orders": orders,
        "balance": balance,
        "token": token is Map ? Map<String, dynamic>.from(token!) : null,
      };
}
