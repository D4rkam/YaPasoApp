import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/pages/home/home_controller.dart';
import 'package:prueba_buffet/pages/shopping_cart/shopping_cart_controller.dart';

class ShoppingCartButton extends StatelessWidget {
  ShoppingCartButton({
    super.key,
    required this.homeController,
  });

  final HomeController homeController;
  final ShoppingCartController shoppingCartController =
      Get.put(ShoppingCartController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        homeController.goToShoppingCart();
      },
      child: Container(
        width: 70,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(
              () => Text(
                "${shoppingCartController.cartItems.length}",
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
              ),
            ),
            const Icon(
              Icons.shopping_cart,
              size: 26,
            ),
          ],
        ),
      ),
    );
  }
}
