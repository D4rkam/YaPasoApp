import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/data/models/product.dart';
import 'package:prueba_buffet/app/controllers/category_controller.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';
import 'package:prueba_buffet/utils/helpers/image_helper.dart';

class ProductCardCategory extends StatelessWidget with ResponsiveMixin {
  const ProductCardCategory(
      {super.key, required this.product, required this.controller});

  final Product product;
  final CategoryController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
      // 1. AÑADIMOS GESTURE DETECTOR AQUÍ 👇
      child: GestureDetector(
        onTap: () {
          // 2. NAVEGAMOS A LA VISTA DE PRODUCTO PASANDO EL ID COMO ARGUMENTO
          Get.toNamed('/product', arguments: product.id.toString());
        },
        child: Container(
          // Quitamos el height fijo de 135 y usamos padding para dar forma
          margin: EdgeInsets.symmetric(
              vertical: setHeight(5), horizontal: setWidth(10)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(setHeight(20)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, 1),
                  blurRadius: 1,
                  spreadRadius: 1)
            ],
          ),
          padding: EdgeInsets.all(setWidth(12)),
          child: IntrinsicHeight(
            // Permite que se estire si el texto es largo
            child: Row(
              children: [
                // Product Image
                Container(
                  width: setWidth(80), // Ajustado un poquito
                  height: setWidth(80),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(setHeight(8)),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                          ImageHelper.getOptimizedUrl(
                        product.imageUrl,
                        width: 300,
                        height: 300,
                      )),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: setWidth(15)), // Espacio relativo

                // Product Details
                // 3. AÑADIMOS EXPANDED PARA EVITAR OVERFLOW EN PANTALLAS CHICAS 👇
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        product.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines:
                            2, // Permite 2 líneas por si el nombre es largo
                        style: TextStyle(
                            fontSize: setSp(20),
                            fontWeight:
                                FontWeight.bold), // Bold se ve mejor en nombres
                      ),
                      SizedBox(height: setHeight(4)),
                      Text(
                        product.description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style:
                            TextStyle(color: Colors.grey, fontSize: setSp(14)),
                      ),
                      SizedBox(height: setHeight(10)),
                      Text(
                        '\$${product.price}',
                        style: TextStyle(
                            color: const Color(0xFF98C21F),
                            fontSize: setSp(20),
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
