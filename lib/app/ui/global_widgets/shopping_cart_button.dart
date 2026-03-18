import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/shopping_cart_controller.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';

class ShoppingCartButton extends StatelessWidget with ResponsiveMixin {
  const ShoppingCartButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShoppingCartController>(builder: (controller) {
      return GestureDetector(
        onTap: () {
          Get.toNamed('/shopping_cart');
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
