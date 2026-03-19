import 'package:dio/dio.dart'
    show Response, Options, DioException; // Importamos Dio
import 'package:get/get.dart'
    hide Response; // Escondemos Response de Get para no chocar con Dio
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/app/data/models/response_api.dart';
import 'package:prueba_buffet/app/data/models/user.dart';
import 'package:prueba_buffet/app/data/provider/base_provider.dart';
import 'package:prueba_buffet/utils/constants/api_constants.dart';

import 'package:prueba_buffet/utils/logger.dart';

// (Tus clases ProductForOrder y Order se mantienen EXACTAMENTE igual)
class ProductForOrder {
  ProductForOrder({required this.id, required this.quantity});
  final int id;
  final int quantity;
  Map<String, dynamic> toJson() => {'id': id, "quantity": quantity};
  factory ProductForOrder.fromJson(Map<String, dynamic> json) =>
      ProductForOrder(id: json['id'], quantity: json['quantity']);
}

class Order {
  Order(
      {this.user_id,
      required this.school_id,
      required this.products,
      required this.datetime,
      this.payment_id});
  final int? user_id;
  final int school_id;
  final String? payment_id;
  final List<ProductForOrder> products;
  final String datetime;
  Map<String, dynamic> toJson() => {
        'user_id': user_id,
        'school_id': school_id,
        'products': products.map((product) => product.toJson()).toList(),
        'datetime_order': datetime,
        'mp_payment_id': payment_id,
      };
  factory Order.fromJson(Map<String, dynamic> json) {
    List<ProductForOrder> products = (json['products'] as List)
        .map((e) => ProductForOrder.fromJson(e))
        .toList();
    return Order(
        user_id: json['user_id'],
        school_id: json['school_id'],
        products: products,
        datetime: json['datetime_order'],
        payment_id: json['mp_payment_id']);
  }
}

class UsersProvider extends BaseProvider {
  Future<Response> create(User user) async {
    return await dio.post(ApiUrl.REGISTER, data: user.toJson());
  }

  Future<ResponseApi> login(String username, String password) async {
    logger.i("Iniciando login para: $username");
    try {
      Response response = await dio.post(
        ApiUrl.LOGIN,
        data: {
          "username": username,
          "password": password,
        },
      );
      // En Dio los datos ya vienen parseados en response.data
      return ResponseApi.fromJson(
        response.data,
        response.statusCode == 200,
      );
    } catch (e) {
      logger.e("UsersProvider login: Error durante el login: $e");
      return ResponseApi(success: false);
    }
  }

  Future<Response> logoutApp() async {
    // Le cambié el nombre a logoutApp porque logout ya existe en BaseProvider
    return await dio.post(ApiUrl.LOGOUT);
  }

  Future<ResponseApi> checkToken() async {
    try {
      // Dio hace la petición. Si da 401, el interceptor la frena,
      // refresca el token y la vuelve a lanzar.
      // Si todo sale bien, llega a la siguiente línea:
      Response response = await dio.get(ApiUrl.USER);
      return ResponseApi.fromJson(response.data, response.statusCode == 200);
    } on DioException catch (e) {
      // Si llega acá, es porque el interceptor se rindió (el refresh falló).
      // El BaseProvider ya llamó a logout() por dentro, así que solo devolvemos false.
      logger.e("UsersProvider checkToken: Fallo definitivo. ${e.message}");
      return ResponseApi(success: false);
    }
  }

  Future<Response> createOrder(Map<String, dynamic> orderJson) async {
    return await dio.post(ApiUrl.ORDER, data: orderJson);
  }

  Future<User?> refreshUserData() async {
    logger.i("UsersProvider: Solicitando datos frescos a ${ApiUrl.USER}");
    try {
      Response response = await dio.get(ApiUrl.USER);
      logger.i("UsersProvider response status: ${response.statusCode}");
      logger.i("UsersProvider response data: ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        final user = User.fromJson(response.data);
        GetStorage().write("user", user.toJson());
        logger.i(
            "UsersProvider: Usuario parseado correctamente. Saldo: ${user.balance}");
        return user;
      }
    } catch (e) {
      logger.e("UsersProvider: Error obteniendo/parseando usuario: $e");
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getSchools() async {
    try {
      final response = await dio.get(ApiUrl.SCHOOLS);
      if (response.data != null && response.data is List) {
        return List<Map<String, dynamic>>.from(response.data);
      }
    } catch (e) {
      logger.e("Error getSchools: $e");
    }
    return [];
  }

  Future<Map<String, double>> getBalance() async {
    try {
      final response = await dio.get(
        ApiUrl.BALANCE,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      if (response.data != null && response.data is Map) {
        final data = Map<String, dynamic>.from(response.data);
        return data.map((key, value) =>
            MapEntry(key, (value is num) ? value.toDouble() : 0.0));
      }
    } catch (e) {
      logger.e("Error getBalance: $e");
    }
    return {};
  }

  Future<Response> getOrders(
      {int limit = 10,
      String? cursor,
      String? status,
      DateTime? filter_date,
      bool? desc}) async {
    final query = {
      'limit': limit.toString(),
      if (cursor != null) 'cursor': cursor,
      if (filter_date != null) 'filter_date': filter_date.toIso8601String(),
      if (desc != null) 'desc': desc.toString(),
      if (status != null) 'status': status,
    };
    return await dio.get(ApiUrl.ORDERS_USER, queryParameters: query);
  }

  Future<Response> updateUserInfo(Map<String, dynamic> data) async {
    return await dio.put(ApiUrl.USER_UPDATE, data: data);
  }

  Future<Response> updateEmail(String newEmail) async {
    return await dio
        .put(ApiUrl.UPDATE_EMAIL, queryParameters: {'new_email': newEmail});
  }

  Future<Response> updatePassword(
      String oldPassword, String newPassword) async {
    return await dio.put(ApiUrl.UPDATE_PASSWORD, data: {
      'old_password': oldPassword,
      'new_password': newPassword,
    });
  }

  Future<Response> deleteMyAccount() async {
    return await dio.delete(ApiUrl.USER_DELETE);
  }

  Future<Response> sendReporte(
      {required String subject, required String description}) async {
    return await dio.post(ApiUrl.REPORT, data: {
      "subject": subject,
      "description": description,
    });
  }
}
