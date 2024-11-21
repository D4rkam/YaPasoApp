import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/pages/category/category.dart';
import 'package:prueba_buffet/pages/home/home_controller.dart';
import 'package:prueba_buffet/utils/constants/image_strings.dart';
import 'package:prueba_buffet/widgets/carrusel.dart';
import 'package:prueba_buffet/widgets/category_item.dart';
import 'package:prueba_buffet/widgets/input.dart';
import 'package:prueba_buffet/widgets/navbar.dart';
import 'package:prueba_buffet/widgets/product_grid.dart';
import 'package:prueba_buffet/widgets/shopping_cart_button.dart';

//TODO: Utilizar MediaQuery para realizar un diseño responsive para todos los dispositivos moviles

class HomeScreen extends StatefulWidget {
  HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final HomeController homeController = Get.put(HomeController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late AnimationController animationController;
  late Animation<Offset> slideAnimation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  // Método para abrir o cerrar el Drawer
  void toggleDrawer() {
    if (animationController.isDismissed) {
      animationController.forward(); // Abrir el Drawer
    } else {
      animationController.reverse(); // Cerrar el Drawer
    }
  }

  @override
  Widget build(BuildContext context) {
    if (homeController.productsFromApi.isEmpty) {
      homeController.getProducts();
    }
    if (homeController.categoryProducts.isEmpty) {
      homeController.getCategoryOfProducts();
    }
    return Scaffold(
      drawer: SideMenu(
          animationController: animationController,
          slideAnimation: slideAnimation),
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
                  categorys: homeController.categoryProducts,
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
      bottomNavigationBar: NavBarWidget(scaffoldKey: _scaffoldKey),
    );
  }
}

class SideMenu extends StatefulWidget {
  const SideMenu({
    super.key,
    required this.animationController,
    required this.slideAnimation,
  });

  final AnimationController animationController;
  final Animation<Offset> slideAnimation;

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: widget.animationController,
        builder: (context, child) {
          return Transform.translate(
              offset: widget.slideAnimation.value,
              child: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    const DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                      ),
                      child: Text(
                        'Menú Lateral',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.account_balance_wallet),
                      title: const Text('Saldo Disponible'),
                      onTap: () {
                        // Acción al hacer clic en "Saldo Disponible"
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('Configuración'),
                      onTap: () {
                        // Acción al hacer clic en "Configuración"
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.help),
                      title: const Text('Ayuda'),
                      onTap: () {
                        // Acción al hacer clic en "Ayuda"
                      },
                    ),
                  ],
                ),
              ));
        });
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
                      log("Saldo");
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

class ContainerInputSearch extends StatelessWidget {
  const ContainerInputSearch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            height: 40,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              color: Color(0xFFFFE500),
            ),
          ),
          Positioned(
            bottom: -20,
            left: 29,
            right: 29,
            child: Material(
              // elevation: 2,
              shadowColor: const Color(0xFFE6E6E6),
              borderRadius: BorderRadius.circular(20),
              child: InputWidget(
                hintText: "Buscar producto",
                icon: Icons.search,
                withIcon: true,
              ),
            ),
          ),
        ],
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

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
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
      ),
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
