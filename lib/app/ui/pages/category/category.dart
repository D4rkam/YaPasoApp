import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/category_controller.dart';
import 'package:prueba_buffet/app/ui/global_widgets/list_of_products.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';
import 'package:prueba_buffet/app/ui/global_widgets/shopping_cart_button.dart';

class CategoryScreen extends GetView<CategoryController> with ResponsiveMixin {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos el título de los argumentos de la ruta
    final String categoryTitle =
        ModalRoute.of(context)?.settings.arguments as String? ?? "Categoría";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: setHeight(100),
        backgroundColor: const Color(0xFFFFE500),
        titleSpacing: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: setWidth(30)),
            child: const ShoppingCartButton(),
          )
        ],
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: setSp(30),
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          categoryTitle,
          style: TextStyle(
            fontSize: setSp(25),
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: GetBuilder<CategoryController>(
          builder: (controller) {
            // Manejo de estado de carga y lista vacía para evitar errores visuales
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFFFE500)),
              );
            }

            if (controller.products.isEmpty) {
              return Center(
                child: Text(
                  'No hay productos en esta categoría',
                  style: TextStyle(
                    fontSize: setSp(18),
                    color: Colors.grey,
                  ),
                ),
              );
            }

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(height: setHeight(30)),
                ),
                // Asumiendo que ListOfProducts devuelve un SliverList o SliverGrid
                ListOfProducts(controller: controller),

                // Espacio extra al final para que el último producto no quede pegado al borde
                SliverToBoxAdapter(
                  child: SizedBox(height: setHeight(40)),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
