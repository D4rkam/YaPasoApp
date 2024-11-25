import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/pages/category/category.dart';
import 'package:prueba_buffet/pages/home/home_controller.dart';
import 'package:prueba_buffet/utils/constants/image_strings.dart';
import 'package:prueba_buffet/widgets/carrusel.dart';
import 'package:prueba_buffet/widgets/category_item.dart';
import 'package:prueba_buffet/widgets/container_input.dart';
import 'package:prueba_buffet/widgets/input.dart';
import 'package:prueba_buffet/widgets/navbar.dart';
import 'package:prueba_buffet/widgets/product_grid.dart';
import 'package:prueba_buffet/widgets/shopping_cart_button.dart';

//TODO: Utilizar MediaQuery para realizar un diseño responsive para todos los dispositivos moviles

class HomeScreen extends StatelessWidget {
  HomeScreen({
    super.key,
  });

  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    if (homeController.productsFromApi.isEmpty) {
      homeController.getProducts();
    }
    return Scaffold(
      drawer: CustomSideMenu(homeController: homeController),
      backgroundColor: Colors.white,
      body: CustomScrollView(
        scrollBehavior: NoOverscrollBehavior(),
        slivers: [
          CustomAppBar(homeController: homeController),
          const ContainerInputSearch(),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 40),
              child: CarruselWidget(),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Text('Categorías',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400)),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: SizedBox(
                height: 100,
                child: ListCategory(
                  categorys: homeController.listaCategorias,
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Todos los Productos',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "Ver más",
                    style: TextStyle(fontSize: 17, color: Color(0xFFB3B3B3)),
                  )
                ],
              ),
            ),
          ),
          const ProductGrid()
        ],
      ),
      bottomNavigationBar: const NavBarWidget(),
    );
  }
}

class CustomSideMenu extends StatelessWidget {
  const CustomSideMenu({
    super.key,
    required this.homeController,
  });

  final HomeController homeController;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 230,
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            margin: EdgeInsets.only(bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(
                      'assets/images/steve_person.png'), // Cambia esto por la ruta de tu imagen
                ),
                SizedBox(height: 10),
                Text("Darkam",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(
                  "Thomas Linares",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          ListTile(
            selected: true,
            selectedTileColor: const Color(0xFFFFE500),
            leading: const Icon(
              Icons.home,
              color: Colors.black,
              size: 30,
            ),
            title: const Text(
              'Inicio',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.assignment_rounded,
              color: Color(0xFFFFE500),
              size: 30,
            ),
            title: const Text(
              'Mis Pedidos',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              homeController.goToMisPedidos();
              Scaffold.of(context).closeDrawer();
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.account_balance_wallet_rounded,
              color: Color(0xFFFFE500),
              size: 30,
            ),
            title: const Text(
              'Mi Saldo',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              homeController.goToMyBalance();
              Scaffold.of(context).closeDrawer();
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Color(0xFFFFE500),
              size: 30,
            ),
            title: const Text(
              'Cerrar sesión',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              homeController.signOut();
            },
          ),
        ],
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    required this.homeController,
  });

  final HomeController homeController;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Stack(children: [
        Container(
          height: 150,
          color: const Color(0xFFFFE500),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 10, left: 29, right: 29),
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
                        const Row(
                          children: [
                            Text('Saldo Disponible',
                                style: TextStyle(
                                    color: Color(0xFF5E5400), fontSize: 22)),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Color(0xFF5E5400),
                            )
                          ],
                        ),
                        Text('\$${homeController.getBalance()}',
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 30)),
                      ],
                    ),
                  ),
                  const Spacer(),
                  ShoppingCartButton(homeController: homeController)
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
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CategoryScreen(categoryTitle: categorys[index]),
              ),
            ),
          ),
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
