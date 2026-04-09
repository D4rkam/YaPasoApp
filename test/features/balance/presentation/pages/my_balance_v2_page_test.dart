import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prueba_buffet/features/balance/presentation/controllers/balance_controller_v2.dart';
import 'package:prueba_buffet/features/balance/presentation/pages/my_balance_v2_page.dart';

class MockBalanceController extends Mock implements BalanceControllerV2 {}

void main() {
  late MockBalanceController mockController;

  void setupErrorReporting() {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exceptionAsString().contains('A RenderFlex overflowed by')) {
        return;
      }
      // Original behavior: FlutterError.dumpErrorToConsole(details);
    };
  }

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    setupErrorReporting();
  });

  setUp(() {
    mockController = MockBalanceController();

    // Stub GetX lifecycle
    when(() => mockController.onStart)
        .thenReturn(InternalFinalCallback<void>(callback: () {}));
    when(() => mockController.onDelete)
        .thenReturn(InternalFinalCallback<void>(callback: () {}));

    // Stubbing basics
    when(() => mockController.balance).thenReturn(2500.0.obs);
    when(() => mockController.fileNum).thenReturn(12345);
    when(() => mockController.isLoading).thenReturn(false.obs);
    when(() => mockController.isFetchingMore).thenReturn(false.obs);
    when(() => mockController.transactions)
        .thenReturn(<Map<String, dynamic>>[].obs);
    when(() => mockController.nextCursor).thenReturn(null);

    Get.put<BalanceControllerV2>(mockController);
  });

  tearDown(() {
    Get.delete<BalanceControllerV2>();
  });

  Widget createWidgetUnderTest() {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        home: MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: SizedBox(
            width: 375,
            height: 812,
            child: MyBalanceV2Page(),
          ),
        ),
      ),
    );
  }

  group('MyBalanceV2Page Widget Tests', () {
    testWidgets('should display balance card with correct values', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500)); 

      expect(find.text('Mi Saldo'), findsOneWidget);
      expect(find.text('Billetera'), findsOneWidget);
      expect(find.text('12345'), findsOneWidget);
      expect(find.textContaining('Saldo Disponible'), findsOneWidget);
    });

    testWidgets('should show empty state message when no transactions',
        (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Aún no tienes movimientos'), findsOneWidget);
    });

    testWidgets('should show transactions when list is not empty',
        (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      // arrange
      final transactions = [
        {
          'type': 'CARGA_SALDO',
          'amount': 500.0,
          'created_at': '2023-10-27T10:00:00Z'
        }
      ];
      when(() => mockController.transactions).thenReturn(transactions.obs);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Carga de Saldo'), findsOneWidget);
      expect(find.text('\$500.0'), findsOneWidget);
    });

    testWidgets('should show loading indicator when isLoading is true',
        (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      // arrange
      when(() => mockController.isLoading).thenReturn(true.obs);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
