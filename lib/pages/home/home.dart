import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/pages/category/category.dart';
import 'package:prueba_buffet/pages/home/home_controller.dart';
import 'package:prueba_buffet/utils/constants/image_strings.dart';
import 'package:prueba_buffet/widgets/carrusel.dart';
import 'package:prueba_buffet/widgets/category_item.dart';
import 'package:prueba_buffet/widgets/input_search.dart';
import 'package:prueba_buffet/widgets/navbar.dart';
import 'package:prueba_buffet/widgets/product_grid.dart';

//TODO: Utilizar MediaQuery para realizar un diseño responsive para todos los dispositivos moviles

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: CustomScrollView(
        scrollBehavior: NoOverscrollBehavior(),
        slivers: [
          AppBar(statusBarHeight: statusBarHeight, controller: controller),
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFFFFE500),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: InputSearchWidget(),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: CarruselWidget(),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Text('Categorías',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: SizedBox(
                height: 100,
                child: ListCategory(),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Text(
                'Todos los Productos',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ProductGrid()
        ],
      ),
      bottomNavigationBar: const NavBarWidget(),
    );
  }
}

class AppBar extends StatelessWidget {
  const AppBar({
    super.key,
    required this.statusBarHeight,
    required this.controller,
  });

  final double statusBarHeight;
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: false,
      pinned: true,
      automaticallyImplyLeading: false,
      expandedHeight: 120,
      stretch: true,
      backgroundColor: const Color(0xFFFFE500),
      flexibleSpace: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        var top = constraints.biggest.height;
        return FlexibleSpaceBar(
          titlePadding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: top < 85 + statusBarHeight
                  ? statusBarHeight
                  : 38 + statusBarHeight,
              bottom: top < 80 + statusBarHeight ? 10 : 0),
          expandedTitleScale: 1,
          // centerTitle: false,
          title: (top < 100 + statusBarHeight)
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Saldo',
                        style: TextStyle(color: Colors.black, fontSize: 20)),
                    SizedBox(width: 8),
                    Text('\$3000',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 25)),
                  ],
                )
              : const Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Saldo',
                            style:
                                TextStyle(color: Colors.black, fontSize: 20)),
                        Text('\$3000',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 25)),
                      ],
                    ),
                    SizedBox(width: 20),
                    Row(
                      children: [
                        Text(
                          "Mis movimientos",
                          style: TextStyle(
                              color: Colors.black38,
                              fontWeight: FontWeight.w400,
                              fontSize: 15),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.black38,
                          size: 18,
                        )
                      ],
                    )
                  ],
                ),
          background: Padding(
            padding: const EdgeInsets.only(top: 20, right: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => controller.signOut(),
                  child: const CircleAvatar(
                    backgroundImage:
                        AssetImage("assets/images/steve_person.png"),
                    minRadius: 35,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

// Widget carrusel() {
//   return
//
// }

Widget shoppingCart() {
  return Stack(
    children: [
      IconButton(
        onPressed: () {},
        icon: const Icon(Icons.shopping_cart),
        style: const ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.white),
          padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 20)),
        ),
      ),
      const Positioned(
        right: 1,
        top: 1,
        child: CircleAvatar(
          backgroundColor: Colors.black,
          radius: 11,
          child: Text("1",
              style: TextStyle(
                color: Colors.white,
              )),
        ),
      )
    ],
  );
}

class ListCategory extends StatelessWidget {
  const ListCategory({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 1,
      scrollDirection: Axis.horizontal,
      itemBuilder: (_, index) {
        return Row(children: [
          CategoryItem(
            title: 'Snacks',
            imageUrl: ProjectImages.snacksIcon,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const CategoryScreen(categoryTitle: "Snacks"),
              ),
            ),
          ),
          CategoryItem(
            title: 'Galletitas',
            imageUrl: ProjectImages.golosinasIcon,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const CategoryScreen(categoryTitle: "Galletitas"),
              ),
            ),
          ),
          CategoryItem(
            title: 'Gaseosas',
            imageUrl: ProjectImages.bebidaIcon,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const CategoryScreen(categoryTitle: "Gaseosas"),
              ),
            ),
          ),
          const CategoryItem(
            title: 'Galletitas',
            imageUrl: 'assets/images/categorias/snacks_categoria.png',
          ),
          const CategoryItem(
            title: 'Galletitas',
            imageUrl: 'assets/images/categorias/snacks_categoria.png',
          ),
        ]);
      },
    );
  }
}

class NoOverscrollBehavior extends ScrollBehavior {
  @override
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
    // Disable the bouncing effect on iOS
    return child;
  }
}
