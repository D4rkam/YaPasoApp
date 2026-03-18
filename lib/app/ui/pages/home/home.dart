import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';

import 'package:intl/intl.dart';

import 'package:prueba_buffet/app/controllers/balance_controller.dart';

import 'package:prueba_buffet/app/controllers/home_controller.dart';

import 'package:prueba_buffet/app/controllers/main_shell_controller.dart';

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

    // ---> MEJORA UX: Tocar el fondo blanco cierra el teclado y oculta la lista

    return GestureDetector(
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

          // ---> ENVOLVEMOS LA PANTALLA EN UN STACK Y UN OBX <---

          child: Obx(() => Stack(
                children: [
                  // 1. LA PANTALLA NORMAL DE FONDO

                  CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: ClampingScrollPhysics(),
                    ),
                    slivers: [
                      CustomAppBar(),

                      // El Input conectado

                      ContainerInputSearch(
                        textController: controller.searchController,
                        focusNode: controller.searchFocusNode,
                        onChanged: controller.onSearchChanged,
                      ),

                      // Todo tu contenido vuelve a mostrarse siempre, sin "if"

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
                              categorys: controller.listaCategorias,
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
                                  "Ver más",
                                  style: TextStyle(
                                      fontSize: setSp(17),
                                      color: const Color(0xFFB3B3B3)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      const ProductGrid(),

                      SliverToBoxAdapter(
                        child: SizedBox(height: setHeight(100)),
                      ),
                    ],
                  ),

                  // 2. LA CAPA SUPERIOR: LISTA FLOTANTE (Solo se pinta si tiene foco y hay sugerencias)

                  if (controller.isSearchFocused.value &&
                      controller.searchSuggestions.isNotEmpty)
                    Positioned(
                      // 215px es la matemática exacta: AppBar(150) + InputAmarillo(40) + InputBlanco sobresaliendo(20) + 5 de margen

                      top: setHeight(215),

                      left: setWidth(35),

                      right: setWidth(35),

                      child: Material(
                        elevation:
                            8, // Da la sombra para que parezca que flota por encima del carrusel

                        shadowColor: Colors.black26,

                        borderRadius: BorderRadius.circular(15),

                        clipBehavior: Clip.antiAlias,

                        child: Container(
                          color: Colors.white,

                          // Límite de altura por si la lista es muy larga

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
                                  // Al tocar, quitamos foco (cierra teclado y oculta lista flotante)

                                  controller.searchFocusNode.unfocus();

                                  // Viajamos a la vista

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
        // Cambiamos setHeight(150) por un valor que se adapte al contenido o usamos constraints
        constraints: BoxConstraints(
            minHeight: setHeight(130), maxHeight: setHeight(160)),
        color: const Color(0xFFFFE500),
        child: SafeArea(
          bottom: false, // Importante para no dejar huecos blancos abajo
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: setWidth(25), vertical: setHeight(10)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  // 👈 Agregamos Expanded para que el texto no empuje el botón de carrito fuera de la pantalla
                  child: GestureDetector(
                    onTap: () => homeController.goToMyBalance(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FittedBox(
                          // 👈 Hace que el texto se achique si no entra en el ancho
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
                                    fontSize: setSp(
                                        28), // Un poquito más chico por seguridad
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
    required this.categorys,
  });

  final List categorys;

  final List categorysIcon = [
    ProjectImages.snacksIcon,
    ProjectImages.galletitasIcon,
    ProjectImages.bebidaIcon,
    ProjectImages.golosinasIcon
  ];

  final HomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: categorys.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (_, index) {
        return Row(children: [
          CategoryItem(
              title: categorys[index],
              imageUrl: categorysIcon[index],
              onTap: () => controller.goToCategory(categorys[index])),
        ]);
      },
    );
  }
}

class NoOverscrollBehavior extends ScrollBehavior {
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    // Disable the glow effect on Android

    if (Platform.isAndroid) {
      return GlowingOverscrollIndicator(
        showLeading: false,
        showTrailing: false,
        axisDirection: axisDirection,
        color: Colors.transparent,
        child: child,
      );
    }

    return child;
  }
}
