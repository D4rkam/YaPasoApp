import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:package_info_plus/package_info_plus.dart';


import 'package:prueba_buffet/core/models/user.dart';
import 'package:prueba_buffet/core/presentation/widgets/custom_bottom_bar.dart';
import 'package:prueba_buffet/core/presentation/widgets/mixins/responsive_mixin.dart';

import 'package:prueba_buffet/features/settings/presentation/pages/configuration_v2_page.dart';
import 'package:prueba_buffet/features/settings/presentation/pages/help_v2_page.dart';
import 'package:prueba_buffet/features/balance/presentation/pages/my_balance_v2_page.dart';
import 'package:prueba_buffet/features/category/presentation/pages/category_v2_page.dart';

import 'package:prueba_buffet/features/home/presentation/controllers/home_controller_v2.dart';
import 'package:prueba_buffet/features/home/presentation/pages/home_v2_content.dart';
import 'package:prueba_buffet/features/orders/presentation/pages/order_v2_content.dart';
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
                  HomeV2Content(),
                  OrderV2Content(),
                  MyBalanceV2Page(onBack: shellController.goToHome),
                  CategoryV2Page(onBack: shellController.goToHome),
                  const ProfileV2Content(),
                  const ConfigurationV2Page(),
                  const HelpV2Page(),
                ],
              )),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            // Reusamos el botom bar pasando cast dynamic
            child: FloatingBottomBar(controller: shellController),
          ),
        ],
      ),
    );
  }


}

class ShellDrawerV2 extends StatelessWidget with ResponsiveMixin {
  ShellDrawerV2({super.key});

  final MainShellControllerV2 shellController = Get.find<MainShellControllerV2>();
  
  User get userSession {
    return Get.find<HomeControllerV2>().userSession;
  }
  
  void signOut() {
    Get.find<HomeControllerV2>().signOut();
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


