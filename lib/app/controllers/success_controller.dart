import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/app/data/models/user.dart';
import 'package:prueba_buffet/app/controllers/shopping_cart_controller.dart';
import 'package:prueba_buffet/app/data/provider/users_provider.dart';
import 'package:intl/intl.dart';

class SuccessController extends GetxController {
  UsersProvider usersProvider = UsersProvider();
  User userSession = User.fromJson(GetStorage().read("user") ?? {});
  void goToHomeScreen() => Get.offNamedUntil("/home", (route) => false);
  void goToOrderScreen() => Get.offNamedUntil("/orders", (route) => false);

  final List<ProductForOrder> productsForOrder = [];
  late List<dynamic> cartItems;
  late String datetime;

  void createOrder() async {
    String? jsonString = GetStorage().read("cart_items");
    if (jsonString != null) {
      List<dynamic> jsonList = jsonDecode(jsonString);
      cartItems =
          jsonList.map((json) => ProductForCart.fromJson(json)).toList();
    }
    // Construir la lista de productos para la orden
    cartItems.forEach((item) {
      productsForOrder.add(ProductForOrder(id: item.id));
    });
    datetime = GetStorage().read("order_datetime");
    DateTime datetime_type_datetime = DateTime.parse(datetime);
    Order order = Order(
        user_id: userSession.id!,
        seller_id: 1,
        products: productsForOrder,
        datetime:
            DateFormat("yyyy-MM-dd'T'HH:mm").format(datetime_type_datetime));

    print(order.toJson());
    Response response = await usersProvider.createOrder(order.toJson());
    GetStorage().write("order", response.body);
  }
}
