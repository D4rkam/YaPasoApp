import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/pages/category/category.dart';
import 'package:prueba_buffet/pages/cart/cart_controller.dart';
import 'package:prueba_buffet/utils/constants/image_strings.dart';
import 'package:prueba_buffet/widgets/category_item.dart';
import 'package:prueba_buffet/widgets/cart_product_grid.dart';
import 'package:prueba_buffet/widgets/custom_elevated_buttom_widget.dart';

//TODO: Utilizar MediaQuery para realizar un diseño responsive para todos los dispositivos moviles

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
        title: const Text('Producto',
            style: TextStyle(
              fontWeight: FontWeight.w500,
            )),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_rounded),
            onPressed: () {
              // Acción al presionar el ícono del carrito
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            // height: MediaQuery.of(context).size.height * 0.6,
            height: 600,
            child: CustomScrollView(
              scrollBehavior: NoOverscrollBehavior(),
              slivers: [
                CartProductGrid()
              ],
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Text('Total a pagar ',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(color: Colors.black)
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      // width: MediaQuery.of(context).size.width * 0.7,
                      child: Text('\$ 1200',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(color: Colors.black)
                      ),
                    ),
                  ],
                ),
                CustomElevatedButton(text: "Comprar", onPressed: () {},)
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
