import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/core/presentation/widgets/input.dart';
import 'package:prueba_buffet/core/presentation/widgets/mixins/responsive_mixin.dart';
import 'package:prueba_buffet/core/presentation/widgets/product_grid.dart';
import 'package:prueba_buffet/core/presentation/widgets/shopping_cart_button.dart';
import 'package:prueba_buffet/features/all_products/presentation/controllers/all_products_controller_v2.dart';
import 'package:prueba_buffet/features/home/presentation/controllers/home_controller_v2.dart';

class AllProductsV2Page extends StatelessWidget with ResponsiveMixin {
  AllProductsV2Page({super.key});

  final AllProductsControllerV2 controller =
      Get.find<AllProductsControllerV2>();
  final HomeControllerV2 homeController = Get.find<HomeControllerV2>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (homeController.searchFocusNode.hasFocus) {
          homeController.searchFocusNode.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFFE500),
        // --- APPBAR NATIVO ---
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFE500),
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.black, size: setSp(30)),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'Productos',
            style: TextStyle(
              fontSize: setSp(25),
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
          centerTitle: false,
          titleSpacing: 0,
          actions: const [
            ShoppingCartButton(),
            SizedBox(width: 15),
          ],
        ),

        body: SafeArea(
          bottom: false,
          child: LayoutBuilder(builder: (context, constraints) {
            return Obx(() => Stack(
                  children: [
                    // --- CAPA BASE ---
                    Positioned.fill(
                      child: Column(
                        children: [
                          // --- FILA DE BÚSQUEDA ---
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: setWidth(20),
                                vertical: setHeight(10)),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Material(
                                    elevation: 0,
                                    borderRadius: BorderRadius.circular(10),
                                    child: InputWidget(
                                      hintText: "Buscar producto",
                                      icon: Icons.search,
                                      withIcon: true,
                                      textEditingController:
                                          homeController.searchController,
                                      focusNode: homeController.searchFocusNode,
                                      onChanged: homeController.onSearchChanged,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: setHeight(10)),

                          // --- CUERPO BLANCO CON BORDES REDONDEADOS ---
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25),
                                ),
                                child: Obx(() {
                                  // 1. Estado de carga inicial
                                  if (controller.isLoading.value) {
                                    return const Center(
                                      child: CircularProgressIndicator(
                                          color: Color(0xFFFFE500)),
                                    );
                                  }

                                  // 2. Estado vacío
                                  if (controller.products.isEmpty) {
                                    return Center(
                                      child: Text(
                                        'No se encontraron productos',
                                        style: TextStyle(
                                            fontSize: setSp(16),
                                            color: Colors.grey),
                                      ),
                                    );
                                  }

                                  // 3. Grilla de productos
                                  return CustomScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    slivers: [
                                      // La grilla convertida a Sliver
                                      SliverPadding(
                                        padding: EdgeInsets.only(
                                          top: setHeight(25),
                                          left: setWidth(20),
                                          right: setWidth(20),
                                          bottom: setHeight(20),
                                        ),
                                        sliver: SliverGrid(
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio: 0.84,
                                            crossAxisSpacing: setWidth(15),
                                            mainAxisSpacing: setHeight(15),
                                          ),
                                          delegate: SliverChildBuilderDelegate(
                                            (context, index) {
                                              var product =
                                                  controller.products[index];
                                              return ProductCard(
                                                  product: product);
                                            },
                                            childCount:
                                                controller.products.length,
                                          ),
                                        ),
                                      ),

                                      // El botón "Cargar más" como elemento final del scroll
                                      if (controller.hasMore.value)
                                        SliverToBoxAdapter(
                                          child: SafeArea(
                                            top: false,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                bottom: setHeight(30),
                                                top: setHeight(10),
                                              ),
                                              child: Center(
                                                child: controller
                                                        .isFetchingMore.value
                                                    ? const CircularProgressIndicator(
                                                        color:
                                                            Color(0xFFFFE500))
                                                    : TextButton(
                                                        onPressed: controller
                                                            .fetchMoreProducts,
                                                        style: TextButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              const Color(
                                                                  0xFFF5F5F5),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      setWidth(
                                                                          30),
                                                                  vertical:
                                                                      setHeight(
                                                                          12)),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          "Cargar más",
                                                          style: TextStyle(
                                                            color:
                                                                Colors.black87,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: setSp(16),
                                                          ),
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                }),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // --- CAPA SUPERIOR: LISTA FLOTANTE ---
                    if (homeController.isSearchFocused.value &&
                        homeController.searchSuggestions.isNotEmpty)
                      Positioned(
                        top: setHeight(80),
                        left: setWidth(20),
                        right: setWidth(20),
                        child: Material(
                          elevation: 8,
                          shadowColor: Colors.black26,
                          borderRadius: BorderRadius.circular(15),
                          clipBehavior: Clip.antiAlias,
                          child: Container(
                            color: Colors.white,
                            constraints: BoxConstraints(
                                maxHeight: constraints.maxHeight * 0.4),
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount:
                                  homeController.searchSuggestions.length,
                              separatorBuilder: (_, __) => const Divider(
                                  height: 1, color: Color(0xFFF0F0F0)),
                              itemBuilder: (context, index) {
                                final product =
                                    homeController.searchSuggestions[index];
                                return ListTile(
                                  dense: true,
                                  leading: const Icon(Icons.search,
                                      color: Colors.grey, size: 20),
                                  title: Text(product.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500)),
                                  trailing: const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 12,
                                      color: Colors.grey),
                                  onTap: () {
                                    homeController.searchFocusNode.unfocus();
                                    homeController.goToProductDetail(product);
                                  },
                                );
                              },
                            ),
                          ),
                        )
                            .animate()
                            .fade(duration: 200.ms)
                            .slideY(begin: -0.05, end: 0, duration: 200.ms),
                      ),
                  ],
                ));
          }),
        ),
      ),
    );
  }
}
