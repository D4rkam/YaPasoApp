import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/all_products_controller.dart';
import 'package:prueba_buffet/app/controllers/home_controller.dart';
import 'package:prueba_buffet/app/ui/global_widgets/input.dart'; // <-- Import de tu InputWidget base
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';
import 'package:prueba_buffet/app/ui/global_widgets/product_grid.dart'; // O donde tengas tu ProductCard
import 'package:prueba_buffet/app/ui/global_widgets/shopping_cart_button.dart';

class AllProductsScreen extends StatelessWidget with ResponsiveMixin {
  AllProductsScreen({super.key});

  final AllProductsController controller = Get.put(AllProductsController());
  final HomeController homeController = Get.find<HomeController>();

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
                                // ---> USAMOS INPUTWIDGET BASE DIRECTAMENTE <---
                                Expanded(
                                  // 👈 Vital para que el input no se desborde
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
                          SizedBox(
                              height:
                                  setHeight(10)), // Espacio antes de la curva

                          // --- CUERPO BLANCO CON BORDES REDONDEADOS ---
                          Expanded(
                            // 👈 Esto asegura que el contenedor blanco ocupe todo el espacio sobrante hacia abajo
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
                                  return Column(
                                    children: [
                                      Expanded(
                                        // 👈 Deja que la grilla scrollee internamente
                                        child: GridView.builder(
                                          padding: EdgeInsets.only(
                                            top: setHeight(25),
                                            left: setWidth(20),
                                            right: setWidth(20),
                                            bottom: setHeight(20),
                                          ),
                                          physics:
                                              const BouncingScrollPhysics(),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount:
                                                2, // Podrías cambiar esto según constraints.maxWidth si quisieras en el futuro
                                            childAspectRatio: 0.84,
                                            crossAxisSpacing: setWidth(15),
                                            mainAxisSpacing: setHeight(15),
                                          ),
                                          itemCount: controller.products.length,
                                          itemBuilder: (context, index) {
                                            var product =
                                                controller.products[index];
                                            return ProductCard(
                                                product: product);
                                          },
                                        ),
                                      ),

                                      // 4. Botón "Cargar Más"
                                      if (controller.hasMore.value)
                                        SafeArea(
                                          // SafeArea para evitar tapar el botón con el home indicator en iOS
                                          top: false,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                bottom: setHeight(30),
                                                top: setHeight(10)),
                                            child: controller
                                                    .isFetchingMore.value
                                                ? const CircularProgressIndicator(
                                                    color: Color(0xFFFFE500))
                                                : TextButton(
                                                    onPressed: controller
                                                        .fetchMoreProducts,
                                                    style: TextButton.styleFrom(
                                                      backgroundColor:
                                                          const Color(
                                                              0xFFF5F5F5),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  setWidth(30),
                                                              vertical:
                                                                  setHeight(
                                                                      12)),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                    ),
                                                    child: Text(
                                                      "Cargar más",
                                                      style: TextStyle(
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: setSp(16),
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
                                maxHeight: constraints.maxHeight *
                                    0.4), // 👈 La lista no va a tapar toda la pantalla, solo un %
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
