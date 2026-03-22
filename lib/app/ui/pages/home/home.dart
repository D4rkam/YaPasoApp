import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:prueba_buffet/app/controllers/balance_controller.dart';
import 'package:prueba_buffet/app/controllers/home_controller.dart';
import 'package:prueba_buffet/app/controllers/main_shell_controller.dart';
import 'package:prueba_buffet/app/data/models/category.dart';
import 'package:prueba_buffet/app/ui/global_widgets/custom_toast.dart';
import 'package:prueba_buffet/utils/constants/image_strings.dart';
import 'package:prueba_buffet/app/ui/global_widgets/carrusel.dart';
import 'package:prueba_buffet/app/ui/global_widgets/category_item.dart';
import 'package:prueba_buffet/app/ui/global_widgets/container_input.dart';
import 'package:prueba_buffet/app/ui/global_widgets/product_grid.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';
import 'package:prueba_buffet/app/ui/global_widgets/shopping_cart_button.dart';

class HomeContent extends StatelessWidget with ResponsiveMixin {
  HomeContent({super.key});

  HomeController get controller => Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    final MainShellController shellController = Get.find();

    return GestureDetector(
      // ---> MEJORA UX: Tocar el fondo blanco cierra el teclado y oculta la lista
      onTap: () {
        if (controller.searchFocusNode.hasFocus) {
          controller.searchFocusNode.unfocus();
        }
      },
      child: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          // ---> MEJORA UX: Hacer scroll también cierra el teclado automáticamente
          if (controller.searchFocusNode.hasFocus) {
            controller.searchFocusNode.unfocus();
          }
          shellController.updateScrollDirection(notification.direction);
          return true;
        },
        child: RefreshIndicator(
          onRefresh: controller.refreshHome,
          color: Colors.black,
          backgroundColor: const Color(0xFFFFE500),
          child: Obx(() => Stack(
                children: [
                  // 1. LA PANTALLA NORMAL DE FONDO
                  CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: ClampingScrollPhysics(),
                    ),
                    slivers: [
                      CustomAppBar(),

                      ContainerInputSearch(
                        textController: controller.searchController,
                        focusNode: controller.searchFocusNode,
                        onChanged: controller.onSearchChanged,
                      ),

                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(top: setHeight(40)),
                          child: const CarruselWidget(),
                        ),
                      ),

                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: setWidth(18),
                              vertical: setHeight(10)),
                          child: Text('Categorías',
                              style: TextStyle(
                                  fontSize: setSp(22),
                                  fontWeight: FontWeight.w400)),
                        ),
                      ),

                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(left: setWidth(20.0)),
                          child: SizedBox(
                            height: setHeight(100),
                            child: ListCategory(
                              categories: controller.listaCategorias,
                            ),
                          ),
                        ),
                      ),

                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: setWidth(18),
                              vertical: setHeight(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  'Más vendidos',
                                  style: TextStyle(
                                      fontSize: setSp(22),
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  controller.goToAllProducts();
                                },
                                child: Text(
                                  "Ver productos",
                                  style: TextStyle(
                                      fontSize: setSp(17),
                                      color: const Color(0xFFB3B3B3)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      // ---> LÓGICA DE ESTADOS: CARGANDO, ERROR, VACÍO o PRODUCTOS <---
                      if (controller.isInitialLoading.value ||
                          controller.isSearchingApi.value)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.only(top: setHeight(40)),
                            child: const Center(
                              child: CircularProgressIndicator(
                                  color: Color(0xFFFFE500)),
                            ),
                          ),
                        )
                      else if (controller.hasConnectionError.value)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.only(top: setHeight(30)),
                            // Le pasamos la función inteligente de reintento
                            child: ErrorServerState(
                              onRetry: controller.retryFetch,
                            ),
                          ),
                        )
                      else if (controller.filteredProducts.isEmpty)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.only(top: setHeight(30)),
                            child: EmptyProductsState(
                                message: controller.filteredProducts.isEmpty
                                    ? "No se vendío ningún producto aún"
                                    : "No se encontraron los productos más vendidos"),
                          ),
                        )
                      else
                        const ProductGrid(),

                      SliverToBoxAdapter(
                        child: SizedBox(height: setHeight(100)),
                      ),
                    ],
                  ),

                  // 2. LA CAPA SUPERIOR: LISTA FLOTANTE DE SUGERENCIAS
                  if (controller.isSearchFocused.value &&
                      controller.searchSuggestions.isNotEmpty)
                    Positioned(
                      top: setHeight(215),
                      left: setWidth(35),
                      right: setWidth(35),
                      child: Material(
                        elevation: 8,
                        shadowColor: Colors.black26,
                        borderRadius: BorderRadius.circular(15),
                        clipBehavior: Clip.antiAlias,
                        child: Container(
                          color: Colors.white,
                          constraints:
                              BoxConstraints(maxHeight: setHeight(300)),
                          child: ListView.separated(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: controller.searchSuggestions.length,
                            separatorBuilder: (_, __) => const Divider(
                                height: 1, color: Color(0xFFF0F0F0)),
                            itemBuilder: (context, index) {
                              final product =
                                  controller.searchSuggestions[index];

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
                                  controller.searchFocusNode.unfocus();
                                  controller.goToProductDetail(product);
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
              )),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget with ResponsiveMixin {
  CustomAppBar({super.key});
  final HomeController homeController = Get.find();
  final BalanceController balanceController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        constraints: BoxConstraints(
            minHeight: setHeight(130), maxHeight: setHeight(160)),
        color: const Color(0xFFFFE500),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: setWidth(25), vertical: setHeight(10)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => homeController.goToMyBalance(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            children: [
                              Text('Saldo Disponible',
                                  style: TextStyle(
                                      color: const Color(0xFF5E5400),
                                      fontSize: setSp(20))),
                              Icon(Icons.arrow_forward_ios_rounded,
                                  color: const Color(0xFF5E5400),
                                  size: setSp(16)),
                            ],
                          ),
                        ),
                        Obx(() {
                          final double targetBalance =
                              balanceController.balance.value;
                          return TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0, end: targetBalance),
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.easeOutCirc,
                            builder: (context, animValue, child) {
                              return Text(
                                "\$${NumberFormat.decimalPatternDigits(locale: "es-AR", decimalDigits: 2).format(animValue)}",
                                style: TextStyle(
                                    fontSize: setSp(28),
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              );
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                const ShoppingCartButton()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ListCategory extends StatelessWidget {
  ListCategory({
    super.key,
    required this.categories,
  });

  // Ahora recibe la lista observable de Objetos Category
  final RxList<Category> categories;
  final HomeController controller = Get.find();

  // Función auxiliar para asignar íconos estáticos basados en el nombre que viene de la BD
  String _getIconForCategory(String nombreCategoria) {
    switch (nombreCategoria.toLowerCase()) {
      case 'snacks':
        return ProjectImages.snacksIcon;
      case 'galletitas':
        return ProjectImages.galletitasIcon;
      case 'bebidas':
        return ProjectImages.bebidaIcon;
      case 'golosinas':
        return ProjectImages.golosinasIcon;
      default:
        return ProjectImages.snacksIcon; // Icono por defecto
    }
  }

  @override
  Widget build(BuildContext context) {
    // Envolvemos en Obx para que reaccione cuando el backend devuelva la lista
    return Obx(() {
      if (controller.isLoadingCategories.value) {
        return const Center(
            child: CircularProgressIndicator(color: Color(0xFFFFE500)));
      }

      return ListView.builder(
        shrinkWrap: true,
        itemCount: categories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) {
          final category = categories[index];

          return Opacity(
            // Magia UI: Si no tiene stock, le bajamos la opacidad (grisado)
            opacity: category.tieneStock ? 1.0 : 0.4,
            child: Row(
              children: [
                CategoryItem(
                  title: category.nombre,
                  imageUrl: _getIconForCategory(category.nombre),
                  onTap: () {
                    if (category.tieneStock) {
                      controller.goToCategory(category);
                    } else {
                      // Opcional: Un tostado avisando que no hay
                      CustomToast.showWarning(
                          title: "Categoría vacía",
                          message:
                              "Aún no hay ${category.nombre} en el buffet.");
                    }
                  },
                ),
              ],
            ),
          );
        },
      );
    });
  }
}

class NoOverscrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    if (Platform.isAndroid) {
      return child; // Desactiva el efecto glow nativo
    }
    return super.buildOverscrollIndicator(context, child, details);
  }
}

// ---------------------------------------------------------
// NUEVOS COMPONENTES DE ESTADO VACÍO Y ERROR
// ---------------------------------------------------------

class EmptyProductsState extends StatelessWidget with ResponsiveMixin {
  final String message;

  EmptyProductsState({super.key, this.message = "No encontramos productos"});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: setSp(80),
            color: Colors.grey.shade400,
          )
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(duration: 2000.ms, color: Colors.grey.shade200)
              .moveY(
                  begin: -5, end: 5, duration: 1500.ms, curve: Curves.easeInOut)
              .then()
              .moveY(
                  begin: 5,
                  end: -5,
                  duration: 1500.ms,
                  curve: Curves.easeInOut),
          SizedBox(height: setHeight(20)),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: setSp(20),
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: setHeight(10)),
          Text(
            "Intentá con otra palabra clave.",
            style: TextStyle(
              fontSize: setSp(16),
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.9, 0.9)),
    );
  }
}

class ErrorServerState extends StatelessWidget with ResponsiveMixin {
  final VoidCallback onRetry;

  ErrorServerState({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wifi_off_rounded,
            size: setSp(80),
            color: Colors.red.shade300,
          )
              .animate()
              .shake(hz: 4, curve: Curves.easeInOutCubic, duration: 600.ms),
          SizedBox(height: setHeight(20)),
          Text(
            "¡Ups! Problemas de conexión",
            style: TextStyle(
              fontSize: setSp(22),
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: setHeight(10)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: setWidth(40)),
            child: Text(
              "No pudimos conectar con el buffet. Revisá tu internet e intentá de nuevo.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: setSp(16),
                color: Colors.grey.shade600,
              ),
            ),
          ),
          SizedBox(height: setHeight(30)),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, color: Colors.black),
            label: Text(
              "Reintentar",
              style: TextStyle(
                color: Colors.black,
                fontSize: setSp(18),
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFE500),
              padding: EdgeInsets.symmetric(
                  horizontal: setWidth(30), vertical: setHeight(12)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          )
              .animate()
              .slideY(begin: 0.5, duration: 400.ms, curve: Curves.easeOutBack),
        ],
      ),
    );
  }
}
