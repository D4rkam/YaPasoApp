import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/app/data/models/response_api.dart';
import 'package:prueba_buffet/app/data/models/user.dart';
import 'package:prueba_buffet/app/data/provider/base_provider.dart';
import 'package:prueba_buffet/utils/constants/api_constants.dart';

class ProductForOrder {
  ProductForOrder({
    required this.id,
  });

  final int id;

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }

  // Crear una instancia desde JSON
  factory ProductForOrder.fromJson(Map<String, dynamic> json) {
    return ProductForOrder(
      id: json['id'],
    );
  }
}

class Order {
  Order({
    this.user_id,
    required this.school_id,
    required this.products,
    required this.datetime,
    this.payment_id,
  });

  final int? user_id;
  final int school_id;
  final String? payment_id;
  final List<ProductForOrder> products;
  final String datetime;

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
      'school_id': school_id,
      'products': products.map((product) => product.toJson()).toList(),
      'datetime_order': datetime, // Cambiar clave al formato esperado
      'mp_payment_id': payment_id,
    };
  }

  // Crear una instancia desde JSON
  factory Order.fromJson(Map<String, dynamic> json) {
    List<ProductForOrder> products = (json['products'] as List)
        .map((e) => ProductForOrder.fromJson(e))
        .toList();
    return Order(
      user_id: json['user_id'],
      school_id: json['school_id'],
      products: products,
      datetime: json['datetime_order'],
      payment_id: json['mp_payment_id'],
    );
  }
}

class UsersProvider extends BaseProvider {
  // Los interceptores y la logica de refresh token son heredados de BaseProvider

  Future<Response> create(User user) async {
    // El interceptor ya sabe qué cookies enviar si existen
    return await post(ApiUrl.REGISTER, user.toJson());
  }

  Future<ResponseApi> login(String username, String password) async {
    print("Iniciando login para: $username");

    Response response = await post(
      ApiUrl.LOGIN,
      {
        "username": username,
        "password": password,
      },
    );

    if (response.body == null) {
      Get.snackbar("Error", "No se pudo conectar con el servidor");
      return ResponseApi(success: false);
    }

    // Si el login fue exitoso, el Response Modifier de BaseProvider ya guardó las cookies
    return ResponseApi.fromJson(
      response.body,
      response.statusCode == 200,
    );
  }

  @override
  Future<Response> logout() async {
    // El interceptor de BaseProvider se encargará de limpiar las cookies
    return await post(ApiUrl.LOGOUT, {});
  }

  Future<ResponseApi> checkToken() async {
    // El interceptor de BaseProvider se encargará de la lógica de reintento
    // y renovación del token. Aquí solo necesitamos hacer la llamada.
    Response response = await get(ApiUrl.USER);

    if (response.body == null) {
      return ResponseApi(success: false);
    }

    return ResponseApi.fromJson(response.body, response.isOk);
  }

  Future<Response> createOrder(Map<String, dynamic> orderJson) async {
    return await post(ApiUrl.ORDER, orderJson);
  }

  /// Obtiene los datos frescos del usuario desde el servidor y actualiza el storage local.
  /// Retorna el User actualizado o null si falló.
  Future<User?> refreshUserData() async {
    print("UsersProvider: Solicitando datos frescos a ${ApiUrl.USER}");
    Response response = await get(ApiUrl.USER);

    print("UsersProvider response status: ${response.statusCode}");
    print("UsersProvider response body: ${response.bodyString}");

    if (response.isOk && response.body != null) {
      // Sanitizar: parsear primero, luego escribir el toJson limpio
      try {
        final user = User.fromJson(response.body);
        // Guardar la versión limpia (toJson) para evitar problemas de tipos
        GetStorage().write("user", user.toJson());
        print(
            "UsersProvider: Usuario parseado correctamente. Saldo: ${user.balance}");
        return user;
      } catch (e) {
        print("UsersProvider: Error parseando usuario: $e");
        // Intentar guardar igual los datos crudos como fallback
        GetStorage().write("user", response.body);
      }
    } else {
      print("UsersProvider: Falló la obtención de datos frescos.");
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getSchools() async {
    final response = await get(ApiUrl.SCHOOLS);
    if (response.body != null && response.body is List) {
      return List<Map<String, dynamic>>.from(response.body);
    }
    return [];
  }

  Future<Map<String, double>> getBalance() async {
    final response = await get(
      ApiUrl.BALANCE,
      contentType: 'application/json',
      decoder: (body) => body,
    );
    if (response.body != null && response.body is Map) {
      final data = Map<String, dynamic>.from(response.body);
      return data.map(
        (key, value) => MapEntry(key, (value is num) ? value.toDouble() : 0.0),
      );
    }
    return {};
  }

  Future<Response> getOrders(
      {int limit = 10,
      String? cursor,
      DateTime? filter_date,
      bool? desc}) async {
    final query = {
      'limit': limit.toString(),
      if (cursor != null) 'cursor': cursor,
      if (filter_date != null) 'filter_date': filter_date.toIso8601String(),
      if (desc != null) 'desc': desc.toString(),
    };
    return await get(ApiUrl.ORDERS_USER, query: query);
  }
}
