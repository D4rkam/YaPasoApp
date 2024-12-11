import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/home_controller.dart';
import 'package:prueba_buffet/app/controllers/shopping_cart_controller.dart';

class ShoppingCartButton extends StatelessWidget {
  const ShoppingCartButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();
    return GetBuilder<ShoppingCartController>(builder: (controller) {
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
                  "${controller.cartItems.length}",
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 24),
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
    });
  }
}
