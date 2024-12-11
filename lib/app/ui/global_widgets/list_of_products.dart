import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:prueba_buffet/app/data/models/product.dart';
import 'package:prueba_buffet/app/controllers/category_controller.dart';
import 'package:prueba_buffet/app/ui/global_widgets/product_cart_category.dart';

class ListOfProducts extends StatelessWidget {
  const ListOfProducts({
    super.key,
    required this.controller,
  });

  final CategoryController controller;

  List<Product> get products => controller.products;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return ProductCardCategory(
              product: products[index],
              controller: controller,
            );
          },
          childCount: products.length, // Número de elementos en la lista
        ),
      ),
    );
  }
}
