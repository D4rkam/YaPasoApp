import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:prueba_buffet/app/controllers/balance_controller.dart';
import 'package:prueba_buffet/app/controllers/category_controller.dart';
import 'package:prueba_buffet/app/controllers/home_controller.dart';
import 'package:prueba_buffet/app/data/models/user.dart';
import 'package:prueba_buffet/app/ui/global_widgets/custom_bottom_bar.dart';
// Mantengo import de list of products legacy temporalmente por el Category Content
import 'package:prueba_buffet/app/ui/global_widgets/list_of_products.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';
import 'package:prueba_buffet/app/ui/global_widgets/shopping_cart_button.dart';

import 'package:prueba_buffet/app/ui/pages/configuration/configuration.dart';
import 'package:prueba_buffet/app/ui/pages/help/help.dart';
import 'package:prueba_buffet/app/ui/pages/home/home.dart';
import 'package:prueba_buffet/app/ui/pages/my_balance/my_balance.dart';
import 'package:prueba_buffet/app/ui/pages/order/order.dart';
import 'package:prueba_buffet/app/ui/pages/perfil/perfil.dart';

import 'package:prueba_buffet/features/home/presentation/controllers/home_controller_v2.dart';
import 'package:prueba_buffet/features/home/presentation/pages/home_v2_content.dart';
import 'package:prueba_buffet/features/orders/presentation/bindings/order_binding_v2.dart';
import 'package:prueba_buffet/features/orders/presentation/pages/order_v2_content.dart';
import 'package:prueba_buffet/features/profile/presentation/bindings/profile_binding_v2.dart';
import 'package:prueba_buffet/features/profile/presentation/pages/profile_v2_content.dart';
import 'package:prueba_buffet/features/shell/presentation/controllers/main_shell_controller_v2.dart';

class MainShellV2 extends StatelessWidget {
  MainShellV2({super.key});

  final MainShellControllerV2 shellController = Get.find<MainShellControllerV2>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: ShellDrawerV2(),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Obx(() => IndexedStack(
                index: shellController.pageIndex.value,
                children: [
                  _buildHomeContent(),
                  _buildOrderContent(),
                  _MyBalanceContentView(), // Renombrado local para evitar conflicto si se copiaba, reusamos legacy o V2? Mantenemos el legacy temporal
                  _CategoryContentView(),
                  _buildProfileContent(),
                  const ConfiguracionContent(),
                  const AyudaContent(),
                ],
              )),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            // Reusamos el botom bar pasando cast dynamic
            child: FloatingBottomBar(controller: shellController as dynamic),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    final enableHomeV2 = GetStorage().read<bool>('enable_home_v2') ?? false;
    if (enableHomeV2) {
      return HomeV2Content();
    }
    return HomeContent();
  }

  Widget _buildOrderContent() {
    final enableOrdersV2 = GetStorage().read<bool>('enable_orders_v2') ?? false;
    if (enableOrdersV2) {
      OrderBindingV2().dependencies();
      return OrderV2Content();
    }
    return OrderContent();
  }

  Widget _buildProfileContent() {
    final enableProfileV2 =
        GetStorage().read<bool>('enable_profile_v2') ?? false;
    if (enableProfileV2) {
      ProfileBindingV2().dependencies();
      return const ProfileV2Content();
    }
    return const PerfilContent();
  }
}

class ShellDrawerV2 extends StatelessWidget with ResponsiveMixin {
  ShellDrawerV2({super.key});

  final MainShellControllerV2 shellController = Get.find<MainShellControllerV2>();
  
  User get userSession {
    final enableHomeV2 = GetStorage().read<bool>('enable_home_v2') ?? false;
    if (enableHomeV2) {
      return Get.find<HomeControllerV2>().userSession;
    } else {
      return Get.find<HomeController>().userSession;
    }
  }
  
  void signOut() {
    final enableHomeV2 = GetStorage().read<bool>('enable_home_v2') ?? false;
    if (enableHomeV2) {
      Get.find<HomeControllerV2>().signOut();
    } else {
      Get.find<HomeController>().signOut();
    }
  }

  String _getInitials(String name, String lastName) {
    String firstInitial =
        name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '';
    String lastInitial =
        lastName.trim().isNotEmpty ? lastName.trim()[0].toUpperCase() : '';
    return '$firstInitial$lastInitial';
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: setWidth(230),
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  margin: const EdgeInsets.only(bottom: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: setHeight(32),
                        backgroundColor: Colors.black,
                        child: Text(
                          _getInitials(userSession.name, userSession.lastName),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: setSp(22),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: setHeight(10)),
                      Flexible(
                        child: Text(
                          "${userSession.username}",
                          style: TextStyle(
                              fontSize: setSp(20), fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          "${userSession.name} ${userSession.lastName}",
                          style: TextStyle(fontSize: setSp(16)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(() => ListTile(
                      selected: shellController.tabIndex.value == 1,
                      selectedTileColor: const Color(0xFFFFE500),
                      leading: Icon(
                        Icons.person,
                        color: shellController.tabIndex.value == 1
                            ? Colors.black
                            : const Color(0xFFFFE500),
                        size: setSp(30),
                      ),
                      title: const Text('Perfil',
                          style: TextStyle(fontWeight: FontWeight.normal)),
                      onTap: () {
                        shellController.tabIndex.value = 1;
                        shellController.goToPerfil();
                      },
                    )),
                ListTile(
                  selected: shellController.tabIndex.value == 2,
                  selectedTileColor: const Color(0xFFFFE500),
                  leading: Icon(
                    Icons.settings,
                    color: shellController.tabIndex.value == 2
                        ? Colors.black
                        : const Color(0xFFFFE500),
                    size: setSp(30),
                  ),
                  title: const Text('Configuración',
                      style: TextStyle(fontWeight: FontWeight.normal)),
                  onTap: () {
                    shellController.tabIndex.value = 2;
                    shellController.goToConfiguracion();
                  },
                ),
                ListTile(
                  selected: shellController.tabIndex.value == 3,
                  selectedTileColor: const Color(0xFFFFE500),
                  leading: Icon(
                    Icons.chat,
                    color: shellController.tabIndex.value == 3
                        ? Colors.black
                        : const Color(0xFFFFE500),
                    size: setSp(30),
                  ),
                  title: const Text('Ayuda',
                      style: TextStyle(fontWeight: FontWeight.normal)),
                  onTap: () {
                    shellController.tabIndex.value = 3;
                    shellController.goToHelp();
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: const Color(0xFFFFE500),
                    size: setSp(30),
                  ),
                  title: const Text('Cerrar sesión',
                      style: TextStyle(fontWeight: FontWeight.normal)),
                  onTap: () {
                    signOut();
                  },
                ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding:
                  EdgeInsets.only(bottom: setHeight(15), top: setHeight(10)),
              child: FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      'Versión ${snapshot.data!.version}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: setSp(14),
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MyBalanceContentView extends StatelessWidget with ResponsiveMixin {
  final ScrollController _scrollController = ScrollController();

  _MyBalanceContentView() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (Get.isRegistered<BalanceController>()) {
          Get.find<BalanceController>().getMoreTransactions();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final MainShellControllerV2 shell = Get.find();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: setSp(30)),
          onPressed: () => shell.goToHome(),
        ),
        title: Text(
          'Mi Saldo',
          style: TextStyle(fontSize: setSp(25), fontWeight: FontWeight.normal),
        ),
      ),
      body: Get.isRegistered<BalanceController>()
          ? _buildBody()
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildBody() {
    final controller = Get.find<BalanceController>();
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Flexible(
              flex: 0,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: setHeight(10)),
                    TarjetaYaPaso(controller: controller),
                    SizedBox(height: setHeight(40)),
                    Padding(
                      padding: EdgeInsets.only(
                          left: setWidth(20), bottom: setHeight(10)),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Mi actividad",
                          style: TextStyle(
                            fontSize: setSp(22),
                            fontWeight: FontWeight.normal,
                            color: const Color.fromARGB(255, 107, 107, 107),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: setWidth(20)),
                child: TransactionsPage(
                  controller: controller,
                  scrollController: _scrollController,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CategoryContentView extends StatelessWidget with ResponsiveMixin {
  _CategoryContentView();

  @override
  Widget build(BuildContext context) {
    final MainShellControllerV2 shell = Get.find();

    return Obx(() {
      final categoryTitle = shell.selectedCategory.value;

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
            icon: Icon(Icons.arrow_back_ios_new_rounded, size: setSp(30)),
            onPressed: () => shell.goToHome(),
          ),
          title: Text(
            categoryTitle,
            style:
                TextStyle(fontSize: setSp(25), fontWeight: FontWeight.normal),
          ),
        ),
        body: Get.isRegistered<CategoryController>()
            ? GetBuilder<CategoryController>(
                builder: (controller) => CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: SizedBox(height: setHeight(30))),
                    ListOfProducts(controller: controller),
                  ],
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      );
    });
  }
}
