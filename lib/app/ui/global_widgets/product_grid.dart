import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/home_controller.dart';
import 'package:prueba_buffet/app/controllers/shopping_cart_controller.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductGrid extends StatelessWidget with ResponsiveMixin {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    return Obx(
      () {
        final products = controller.productsFromApi;
        if (products.isEmpty) {
          return SliverToBoxAdapter(
            child: Center(
                child: Column(
              children: [
                Image.asset(
                  "assets/images/not_load.png",
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
              product: ProductForCart(
                  id: products[i].id.toString(),
                  name: products[i].name,
                  price: products[i].price,
                  imagePath: products[i].imageUrl ?? "",
                  quantity: (products[i].quantity > 0) ? 1.obs : 0.obs,
                  maxQuantity: products[i].quantity),
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
  final ProductForCart product;
  final ShoppingCartController controller = Get.find<ShoppingCartController>();

  ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        behavior: HitTestBehavior.deferToChild,
        onTap: () {
          Get.toNamed("/product", arguments: product.id);
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
                            scale: 1,
                            product
                                .imagePath), // Reemplaza con la URL de tu imagen
                        height: setHeight(90),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/not_load.png', // Tu imagen de respaldo
                            height: setHeight(90),
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () {},
                    color: Colors.yellow,
                  ),
                ),
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
                Align(
                  alignment: Alignment.bottomRight,
                  child: Obx(
                    () => product.quantity.value > 0
                        ? IconButton(
                            icon: Icon(
                              controller.isInCart(product.id)
                                  ? Icons.check
                                  : Icons.add_shopping_cart,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              if (controller.isInCart(product.id)) {
                                controller.removeItemFromCart(product.id);
                              } else {
                                controller.addItemToCart(product);
                              }
                            },
                            style: IconButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(setHeight(10)),
                              ),
                              backgroundColor: const Color(0xFFFFE500),
                            ),
                          )
                        : IconButton(
                            icon: const Icon(
                              Icons.remove_shopping_cart,
                              color: Colors.grey,
                            ),
                            onPressed: null,
                            style: IconButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(setHeight(10)),
                              ),
                              backgroundColor: const Color(0xFFD7D7D7),
                            ),
                          ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
