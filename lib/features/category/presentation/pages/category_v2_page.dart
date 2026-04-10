import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/core/models/product.dart';
import 'package:prueba_buffet/features/category/presentation/controllers/category_controller_v2.dart';
import 'package:prueba_buffet/utils/helpers/image_helper.dart';
import 'package:prueba_buffet/core/presentation/widgets/mixins/responsive_mixin.dart';
import 'package:prueba_buffet/core/presentation/widgets/shopping_cart_button.dart';

class CategoryV2Page extends GetView<CategoryControllerV2>
    with ResponsiveMixin {
  final VoidCallback? onBack;

  const CategoryV2Page({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    // Obtenemos el título de los argumentos de la ruta
    final String categoryTitle = Get.arguments?.toString() ?? "Categoría";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: setHeight(100),
        backgroundColor: const Color(0xFFFFE500),
        titleSpacing: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: setWidth(30)),
            child: const ShoppingCartButton(),
          )
        ],
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: setSp(30),
            color: Colors.black,
          ),
          onPressed: onBack ?? () => Navigator.pop(context),
        ),
        title: Text(
          categoryTitle,
          style: TextStyle(
            fontSize: setSp(25),
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          // Manejo de estado de carga y lista vacía
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFE500)),
            );
          }

          if (controller.products.isEmpty) {
            return Center(
              child: Text(
                'No hay productos en esta categoría',
                style: TextStyle(
                  fontSize: setSp(18),
                  color: Colors.grey,
                ),
              ),
            );
          }

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(height: setHeight(30)),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return _ProductCardCategoryV2(
                      product: controller.products[index],
                    );
                  },
                  childCount: controller.products.length,
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: setHeight(40)),
              ),
            ],
          );
        }),
      ),
    );
  }
}

/// Card de producto para categoría V2 — misma UI que la legacy
/// pero sin dependencia al CategoryController legacy.
class _ProductCardCategoryV2 extends StatelessWidget with ResponsiveMixin {
  const _ProductCardCategoryV2({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
      child: GestureDetector(
        onTap: () {
          final enableProductsV2 =
              GetStorage().read<bool>('enable_products_v2') ?? false;
          Get.toNamed(
            enableProductsV2 ? '/product_v2' : '/product',
            arguments: product.id.toString(),
          );
        },
        child: Container(
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
            child: Row(
              children: [
                // Product Image
                Container(
                  width: setWidth(80),
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
                SizedBox(width: setWidth(15)),

                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        product.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: setSp(20), fontWeight: FontWeight.bold),
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
