import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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

  final HomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final MainShellController shellController = Get.find();
    return NotificationListener<UserScrollNotification>(
      onNotification: (notification) {
        shellController.updateScrollDirection(notification.direction);
        return true;
      },
      child: RefreshIndicator(
        onRefresh: controller.refreshHome,
        color: Colors.black,
        backgroundColor: const Color(0xFFFFE500),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            CustomAppBar(),
            const ContainerInputSearch(),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: setHeight(40)),
                child: const CarruselWidget(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: setWidth(18), vertical: setHeight(10)),
                child: Text('Categorías',
                    style: TextStyle(
                        fontSize: setSp(22), fontWeight: FontWeight.w400)),
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
                    horizontal: setWidth(18), vertical: setHeight(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Todos los Productos',
                      style: TextStyle(
                          fontSize: setSp(22), fontWeight: FontWeight.w400),
                    ),
                    Text(
                      "Ver más",
                      style: TextStyle(
                          fontSize: setSp(17), color: const Color(0xFFB3B3B3)),
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
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget with ResponsiveMixin {
  CustomAppBar({
    super.key,
  });

  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Stack(children: [
        Container(
          height: setHeight(150),
          color: const Color(0xFFFFE500),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                  top: setHeight(10), left: setWidth(29), right: setWidth(29)),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      homeController.goToMyBalance();
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text('Saldo Disponible',
                                style: TextStyle(
                                    color: const Color(0xFF5E5400),
                                    fontSize: setSp(22))),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Color(0xFF5E5400),
                            )
                          ],
                        ),
                        Obx(
                          () => Text(
                            '\$${NumberFormat.decimalPatternDigits(locale: "es-AR", decimalDigits: 2).format(homeController.balanceUser.value)}',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: setSp(30)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const ShoppingCartButton()
                ],
              ),
            ),
          ),
        )
      ]),
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
