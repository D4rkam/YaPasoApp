import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:prueba_buffet/core/models/product.dart';
import 'package:prueba_buffet/core/presentation/widgets/product_cart_category.dart';
import 'package:prueba_buffet/features/category/presentation/controllers/category_controller_v2.dart';

class ListOfProducts extends StatelessWidget {
  const ListOfProducts({
    super.key,
    required this.controller,
  });

  final CategoryControllerV2 controller;

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
