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
import 'package:prueba_buffet/widgets/input_search.dart';
import 'package:prueba_buffet/widgets/navbar.dart';
import 'package:prueba_buffet/widgets/product_grid.dart';

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
    if (homeController.categoryProducts.isEmpty) {
      homeController.getCategoryOfProducts();
    }
    return Scaffold(
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
      bottomNavigationBar: NavBarWidget(homeController: homeController),
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
                  GestureDetector(
                    onTap: () {
                      homeController.goToShoppingCart();
                    },
                    child: Container(
                      width: 70,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "2",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 24),
                          ),
                          Icon(
                            Icons.shopping_cart,
                            size: 26,
                          ),
                        ],
                      ),
                    ),
                  )
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
            height: 30,
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
              child: const InputSearchWidget(),
            ),
          ),
        ],
      ),
    );
  }
}

// class CustomAppBar extends StatelessWidget {
//   const CustomAppBar({
//     super.key,
//     required this.statusBarHeight,
//     required this.controller,
//   });

//   final double statusBarHeight;
//   final HomeController controller;

//   @override
//   Widget build(BuildContext context) {
//     return SliverAppBar(
//       floating: false,
//       pinned: true,
//       automaticallyImplyLeading: false,
//       expandedHeight: 110 + statusBarHeight,
//       elevation: 0,
//       stretch: true,
//       backgroundColor: const Color(0xFFFFE500),
//       flexibleSpace: ClipRRect(
//         borderRadius: BorderRadius.circular(30),
//         child: FlexibleSpaceBar(
//           expandedTitleScale: 1,
//           title: (true)
//               ? SafeArea(
//                   child: Padding(
//                     padding:
//                         const EdgeInsets.only(top: 10, left: 29, right: 29),
//                     child: Row(
//                       // mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             log("Saldo");
//                           },
//                           child: const Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Row(
//                                 children: [
//                                   Text('Saldo Disponible',
//                                       style: TextStyle(
//                                           color: Color(0xFF5E5400),
//                                           fontSize: 22)),
//                                   Icon(
//                                     Icons.arrow_forward_ios_rounded,
//                                     color: Color(0xFF5E5400),
//                                   )
//                                 ],
//                               ),
//                               Text('\$3550',
//                                   style: TextStyle(
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 30)),
//                             ],
//                           ),
//                         ),
//                         const Spacer(),
//                         GestureDetector(
//                           onTap: () => controller.goToShoppingCart(),
//                           child: Container(
//                             width: 70,
//                             height: 48,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               color: Colors.white,
//                             ),
//                             child: const Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   "2",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 24),
//                                 ),
//                                 Icon(
//                                   Icons.shopping_cart,
//                                   size: 26,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 )
//               : GestureDetector(
//                   onTap: () {
//                     controller.signOut();
//                   },
//                   child: Row(
//                     // mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Column(
//                         // mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Row(
//                             children: [
//                               Text('Disponible',
//                                   style: TextStyle(
//                                       color: Colors.black, fontSize: 20)),
//                               Icon(
//                                 Icons.arrow_forward_ios_rounded,
//                                 color: Colors.black87,
//                               )
//                             ],
//                           ),
//                           Text('\$${controller.getBalance()}',
//                               style: const TextStyle(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 25)),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//         ),
//       ),
//     );
//   }
// }

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
