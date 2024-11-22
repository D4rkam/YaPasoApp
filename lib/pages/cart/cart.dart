import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/pages/category/category.dart';
import 'package:prueba_buffet/pages/cart/cart_controller.dart';
import 'package:prueba_buffet/utils/constants/image_strings.dart';
import 'package:prueba_buffet/widgets/category_item.dart';
import 'package:prueba_buffet/widgets/cart_product_grid.dart';
import 'package:prueba_buffet/widgets/custom_elevated_buttom_widget.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});
  final CartController controller = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Carrito',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search), // Icono de lupa
            onPressed: () {
              // Acción al presionar el ícono de lupa
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list), // Icono de filtro
            onPressed: () {
              // Acción al presionar el ícono de filtro
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            // height: MediaQuery.of(context).size.height * 0.6,
            height: 490,
            child: CustomScrollView(
              scrollBehavior: NoOverscrollBehavior(),
              slivers: [
                CartProductGrid()
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey, // Color negro
                  width: 1.0,         // Ancho de 1 píxel
                ),
              ),
            ),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Text('Total a pagar',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF4d4d4d),
                          ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      // width: MediaQuery.of(context).size.width * 0.7,
                      child: Text('\$ 1750',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color:  Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: SizedBox(
                    width: 340.0,
                    child: CustomElevatedButton(
                      text: "Comprar",
                      onPressed: () {
                      },
                      backgroundColor: const Color(0xFFFFE500),
                      textColor: Colors.black,
                      fontSize: 35.0,
                      borderRadius: 20.0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                //IconButton(
                  //iconSize: 72,
                  //tooltip: 'Favorite',
                  //icon: const Icon(Icons.favorite),
                  //onPressed: () {},
                //),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
            imageUrl: ProjectImages.galletitasIcon,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                const CategoryScreen(categoryTitle: "Galletitas"),
              ),
            ),
          ),
          CategoryItem(
            title: 'Bebidas',
            imageUrl: ProjectImages.bebidaIcon,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                const CategoryScreen(categoryTitle: "Bebidas"),
              ),
            ),
          ),
          CategoryItem(
            title: 'Golosinas',
            imageUrl: ProjectImages.golosinasIcon,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                const CategoryScreen(categoryTitle: "Golosinas"),
              ),
            ),
          ),
          CategoryItem(
            title: 'Sandwiches',
            imageUrl: ProjectImages.sandwichIcon,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                const CategoryScreen(categoryTitle: "Sandwiches"),
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
