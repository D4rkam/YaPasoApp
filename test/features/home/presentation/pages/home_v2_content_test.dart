import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prueba_buffet/core/models/product.dart';
import 'package:prueba_buffet/core/models/category.dart';
import 'package:prueba_buffet/features/cart/presentation/controllers/shopping_cart_controller_v2.dart';
import 'package:prueba_buffet/features/balance/presentation/controllers/balance_controller_v2.dart';
import 'package:prueba_buffet/features/home/presentation/controllers/home_controller_v2.dart';
import 'package:prueba_buffet/features/home/presentation/pages/home_v2_content.dart';
import 'package:prueba_buffet/features/shell/presentation/controllers/main_shell_controller_v2.dart';

abstract class MockGetxController extends Mock implements GetxController {
  @override
  InternalFinalCallback<void> get onStart =>
      InternalFinalCallback<void>(callback: () {});
  @override
  InternalFinalCallback<void> get onDelete =>
      InternalFinalCallback<void>(callback: () {});
  @override
  VoidCallback addListener(VoidCallback listener) => () {};
  @override
  void removeListener(VoidCallback listener) {}
  @override
  void update([List<Object>? ids, bool condition = true]) {}
}

class MockHomeControllerV2 extends MockGetxController
    implements HomeControllerV2 {}

class MockBalanceControllerV2 extends MockGetxController
    implements BalanceControllerV2 {}

class MockMainShellControllerV2 extends MockGetxController
    implements MainShellControllerV2 {}

class MockShoppingCartControllerV2 extends MockGetxController
    implements ShoppingCartControllerV2 {}

void main() {
  late MockHomeControllerV2 mockHome;
  late MockBalanceControllerV2 mockBalance;
  late MockMainShellControllerV2 mockShell;
  late MockShoppingCartControllerV2 mockCart;
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    Get.testMode = true;
  });
  setUp(() {
    // Configurar el tamaño de la pantalla para evitar overflows
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.views.first.physicalSize =
        const Size(1080, 1920);
    binding.platformDispatcher.views.first.devicePixelRatio = 1.0;
    mockHome = MockHomeControllerV2();
    mockBalance = MockBalanceControllerV2();
    mockShell = MockMainShellControllerV2();
    mockCart = MockShoppingCartControllerV2();
    Get.put<HomeControllerV2>(mockHome);
    Get.put<BalanceControllerV2>(mockBalance);
    Get.put<MainShellControllerV2>(mockShell);
    Get.put<ShoppingCartControllerV2>(mockCart);
    // Comportamientos por defecto
    when(() => mockBalance.balance).thenReturn(1500.0.obs);
    when(() => mockHome.isInitialLoading).thenReturn(false.obs);
    when(() => mockHome.isSearchingApi).thenReturn(false.obs);
    when(() => mockHome.hasConnectionError).thenReturn(false.obs);
    when(() => mockHome.isLoadingCategories).thenReturn(false.obs);
    when(() => mockHome.listaCategorias).thenReturn(<Category>[].obs);
    when(() => mockHome.filteredProducts).thenReturn(<Product>[].obs);
    when(() => mockHome.searchController).thenReturn(TextEditingController());
    when(() => mockHome.searchFocusNode).thenReturn(FocusNode());
    when(() => mockHome.isSearchFocused).thenReturn(false.obs);
    when(() => mockHome.searchSuggestions).thenReturn(<Product>[]);
    when(() => mockCart.cartItems).thenReturn(<ProductForCart>[].obs);
    when(() => mockHome.refreshHome()).thenAnswer((_) async {});
  });
  tearDown(() {
    Get.reset();
  });
  Widget buildTestableWidget() {
    return ScreenUtilInit(
      designSize: const Size(393, 852), // iPhone 14 size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(body: HomeV2Content()),
        );
      },
    );
  }

  void setupErrorReporting(WidgetTester tester) {
    final originalOnError = FlutterError.onError;
    addTearDown(() => FlutterError.onError = originalOnError);
    FlutterError.onError = (details) {
      if (details.exception is FlutterError &&
          details.exception.toString().contains('RenderFlex overflowed')) {
        return; // Silenciamos overflows en tests
      }
      originalOnError?.call(details);
    };
  }

  group('HomeV2Content Widget Tests', () {
    testWidgets('should show loading indicator when isInitialLoading is true',
        (WidgetTester tester) async {
      setupErrorReporting(tester);
      when(() => mockHome.isInitialLoading).thenReturn(true.obs);
      await tester.pumpWidget(buildTestableWidget());
      await tester.pump(); // Frame inicial de ScreenUtil
      await tester.pump(); // Frame de Obx
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });
    testWidgets('should show error state when hasConnectionError is true',
        (WidgetTester tester) async {
      setupErrorReporting(tester);
      when(() => mockHome.hasConnectionError).thenReturn(true.obs);
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();
      expect(find.text('¡Ups! Problemas de conexión'), findsOneWidget);
    });
  });
}
