import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/shopping_cart_controller.dart';

class Counter extends StatelessWidget {
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
                      controller.updateQuantity(
                          product.id, product.quantity.value - 1);
                    }
                  : null,
              child: Obx(
                () => Ink(
                  width: widthButton,
                  height: heightButton,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
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
          Obx(
            () => FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '${product.quantity.value}',
                style: const TextStyle(
                  color: Color(0xFFD3BF09),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ), // Mostrar la cantidad seleccionada
          InkWell(
            onTap: () {
              controller.updateQuantity(product.id, product.quantity.value + 1);
            },
            overlayColor:
                WidgetStateProperty.all(Colors.black.withOpacity(0.1)),
            child: Ink(
              width: widthButton,
              height: heightButton,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color(0xFFF9EA68),
              ),
              child: const Icon(
                Icons.add,
                color: Color(0xFFD3BF09),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
