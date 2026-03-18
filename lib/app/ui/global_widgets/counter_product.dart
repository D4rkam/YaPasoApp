import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/shopping_cart_controller.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';

class Counter extends StatelessWidget with ResponsiveMixin {
  Counter(
      {super.key,
      required this.product,
      required this.widthButton,
      required this.heightButton});

  final ProductForCart product;
  final ShoppingCartController controller = Get.find();
  final double widthButton;
  final double heightButton;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(
            () => InkWell(
              overlayColor:
                  WidgetStateProperty.all(Colors.black.withOpacity(0.2)),
              onTap: (product.quantity.value > 1)
                  ? () {
                      product.quantity.value--;
                      controller.updateQuantity(
                          product.id, product.quantity.value);
                    }
                  : null,
              child: Obx(
                () => Ink(
                  width: widthButton,
                  height: heightButton,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(setHeight(5)),
                      color: (product.quantity.value > 1)
                          ? const Color(0xFFF9EA68)
                          : const Color(0xFFD7D7D7)),
                  child: Icon(Icons.remove,
                      color: (product.quantity.value > 1)
                          ? const Color(0xFFD3BF09)
                          : const Color(0xFF6F6F6F)),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: setWidth(5)),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Obx(() => Text(
                    '${product.quantity.value}',
                    style: TextStyle(
                      color: Color(0xFFD3BF09),
                      fontSize: setSp(24),
                      fontWeight: FontWeight.normal,
                    ),
                  )),
            ),
          ),
          // Mostrar la cantidad seleccionada
          InkWell(
            onTap: () {
              if (product.quantity.value < product.maxQuantity) {
                product.quantity.value++;
                controller.updateQuantity(product.id, product.quantity.value);
              }
            },
            overlayColor:
                WidgetStateProperty.all(Colors.black.withOpacity(0.1)),
            child: Obx(
              () => Ink(
                width: widthButton,
                height: heightButton,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(setHeight(5)),
                  color: (product.quantity.value < product.maxQuantity)
                      ? const Color(0xFFF9EA68)
                      : const Color(0xFFD7D7D7),
                ),
                child: Icon(
                  Icons.add,
                  color: (product.quantity.value < product.maxQuantity)
                      ? const Color(0xFFD3BF09)
                      : const Color(0xFF6F6F6F),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
