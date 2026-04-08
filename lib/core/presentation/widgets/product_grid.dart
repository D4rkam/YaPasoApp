import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/features/home/presentation/controllers/home_controller_v2.dart';
import 'package:prueba_buffet/core/models/product.dart';
import 'package:prueba_buffet/core/presentation/widgets/mixins/responsive_mixin.dart';
import 'package:prueba_buffet/utils/helpers/image_helper.dart';

class ProductGrid extends StatelessWidget with ResponsiveMixin {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeControllerV2 controller = Get.find<HomeControllerV2>();

    return Obx(
      () {
        final products = controller.productsFromApi;
        if (products.isEmpty) {
          return SliverToBoxAdapter(
            child: Center(
                child: Column(
              children: [
                Image.asset(
                  "assets/images/not_load.webp",
                  width: MediaQuery.of(context).size.width * 0.5,
                ),
                Text(
                  "Revise su conexión a Internet",
                  style: TextStyle(
                      fontSize: setSp(20),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF8B8B8B)),
                )
              ],
            )),
          );
        }

        return SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (ctx, i) => ProductCard(
              product: products[i],
            ),
            childCount: (products.length > 4) ? 4 : products.length,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
        );
      },
    );
  }
}

class ProductCard extends StatelessWidget with ResponsiveMixin {
  final Product product;

  ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        onTap: () {
          final enableProductsV2 =
              GetStorage().read<bool>('enable_products_v2') ?? false;
          Get.toNamed(
            enableProductsV2 ? "/product_v2" : "/product",
            arguments: product.id.toString(),
          );
        },
        child: SizedBox(
          height: setHeight(100),
          width: double.infinity,
          child: Card(
            color: Colors.white,
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(setHeight(10)),
            ),
            child: Stack(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: setHeight(4)),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ClipRRect(
                      child: Image(
                        image: CachedNetworkImageProvider(
                          ImageHelper.getOptimizedUrl(
                            product.imageUrl,
                            width: 300,
                            height: 300,
                          ),
                          scale: 1,
                        ),
                        height: setHeight(90),
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/not_load.webp', // Tu imagen de respaldo
                            height: setHeight(90),
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                // Align(
                //   alignment: Alignment.topRight,
                //   child: IconButton(
                //     icon: const Icon(Icons.favorite_border),
                //     onPressed: () {},
                //     color: Colors.yellow,
                //   ),
                // ),
                Positioned(
                  bottom: setHeight(45),
                  left: setHeight(12),
                  child: Text(
                    product.name,
                    style: TextStyle(
                        fontSize: setHeight(14), fontWeight: FontWeight.w500),
                  ),
                ),
                Positioned(
                  bottom: setHeight(18),
                  left: setHeight(12),
                  child: Text(
                    '\$${product.price}',
                    style: TextStyle(
                        fontSize: setHeight(19),
                        color: Colors.green,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                // Align(
                //   alignment: Alignment.bottomRight,
                //   child: Obx(
                //     () => product.quantity.value > 0
                //         ? IconButton(
                //             icon: Icon(
                //               controller.isInCart(product.id)
                //                   ? Icons.check
                //                   : Icons.add_shopping_cart,
                //               color: Colors.black,
                //             ),
                //             onPressed: () {
                //               if (controller.isInCart(product.id)) {
                //                 controller.removeItemFromCart(product.id);
                //               } else if (product.maxQuantity > 0) {
                //                 controller.addItemToCart(product);
                //               }
                //             },
                //             style: IconButton.styleFrom(
                //               shape: RoundedRectangleBorder(
                //                 borderRadius:
                //                     BorderRadius.circular(setHeight(10)),
                //               ),
                //               backgroundColor: const Color(0xFFFFE500),
                //             ),
                //           )
                //         : IconButton(
                //             icon: const Icon(
                //               Icons.remove_shopping_cart,
                //               color: Colors.grey,
                //             ),
                //             onPressed: null,
                //             style: IconButton.styleFrom(
                //               shape: RoundedRectangleBorder(
                //                 borderRadius:
                //                     BorderRadius.circular(setHeight(10)),
                //               ),
                //               backgroundColor: const Color(0xFFD7D7D7),
                //             ),
                //           ),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
