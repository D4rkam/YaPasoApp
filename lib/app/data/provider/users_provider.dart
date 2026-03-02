import 'package:get/get.dart';
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
    required this.user_id,
    required this.seller_id,
    required this.products,
    required this.datetime,
  });

  final int user_id;
  final int seller_id;
  final List<ProductForOrder> products;
  final String datetime;

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
      'seller_id': seller_id,
      'products': products.map((product) => product.toJson()).toList(),
      'datetime_order': datetime, // Cambiar clave al formato esperado
    };
  }

  // Crear una instancia desde JSON
  factory Order.fromJson(Map<String, dynamic> json) {
    List<ProductForOrder> products = (json['products'] as List)
        .map((e) => ProductForOrder.fromJson(e))
        .toList();
    return Order(
      user_id: json['user_id'],
      seller_id: json['seller_id'],
      products: products,
      datetime: json['datetime_order'],
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

  Future<List<Map<String, dynamic>>> getSchools() async {
    final response = await get(ApiUrl.SCHOOLS);
    if (response.body != null && response.body is List) {
      return List<Map<String, dynamic>>.from(response.body);
    }
    return [];
  }
}
