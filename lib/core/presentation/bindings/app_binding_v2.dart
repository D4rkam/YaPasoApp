import 'package:get/get.dart';

import 'package:prueba_buffet/features/balance/presentation/bindings/balance_binding_v2.dart';
import 'package:prueba_buffet/features/cart/presentation/bindings/cart_binding_v2.dart';
import 'package:prueba_buffet/features/orders/presentation/bindings/order_binding_v2.dart';

class AppBindingV2 implements Bindings {
  @override
  void dependencies() {
    // Inyecta las dependencias principales globales que deben persistir o
    // estar disponibles en toda la app cuando hay una sesión activa.

    // 1. Balance (Global para AppBar)
    BalanceBindingV2().dependencies();

    // 2. Shopping Cart (Global para interactuar desde Home, AllProducts, etc)
    CartBindingV2().dependencies();

    // 3. Orders (Global para interactuar desde Home, AllProducts, etc)
    OrderBindingV2().dependencies();
  }
}
