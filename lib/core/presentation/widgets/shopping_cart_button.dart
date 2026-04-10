import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/features/cart/presentation/controllers/shopping_cart_controller_v2.dart';
import 'package:prueba_buffet/core/routes/routes.dart';
import 'package:prueba_buffet/core/presentation/widgets/mixins/responsive_mixin.dart';

class ShoppingCartButton extends StatelessWidget with ResponsiveMixin {
  const ShoppingCartButton({super.key});

  Widget build(BuildContext context) {
    return GetBuilder<ShoppingCartControllerV2>(builder: (controller) {
      return GestureDetector(
        onTap: () {
          Get.toNamed(Routes.SHOPPING_CART);
        },
        child: Container(
          width: setWidth(70),
          height: setHeight(48),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(setHeight(10)),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(
                () => Text(
                  "${controller.cartItems.length}",
                  style: TextStyle(
                      fontWeight: FontWeight.normal, fontSize: setSp(24)),
                ),
              ),
              Icon(
                Icons.shopping_cart,
                size: setHeight(22),
              ),
            ],
          ),
        ),
      );
    });
  }
}
