import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/app/controllers/home_controller.dart';
import 'package:prueba_buffet/app/data/models/user.dart';
import 'package:prueba_buffet/app/routes/routes.dart';
import 'package:prueba_buffet/app/ui/global_widgets/custom_toast.dart';
import 'package:prueba_buffet/app/ui/global_widgets/input.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';
import 'package:prueba_buffet/features/balance/presentation/controllers/balance_controller_v2.dart';
import 'package:prueba_buffet/features/cart/presentation/controllers/shopping_cart_controller_v2.dart';
import 'package:prueba_buffet/features/payments/presentation/controllers/payments_controller_v2.dart';

class PayV2Page extends StatefulWidget {
  const PayV2Page({super.key});

  @override
  State<PayV2Page> createState() => _PayV2PageState();
}

class _PayV2PageState extends State<PayV2Page> with ResponsiveMixin {
  final PaymentsControllerV2 _paymentsController =
      Get.find<PaymentsControllerV2>();
  final ShoppingCartController _shoppingCartController =
      Get.find<ShoppingCartController>();

  String? selectedMethod;
  DateTime? selectedDateTime;
  String displayRetiroText = '';

  final Map<String, List<Map<String, dynamic>>> _horariosPorTurno = {
    'Manana': [
      {'label': '1er Recreo (09:30)', 'hour': 9, 'minute': 30},
      {'label': '2do Recreo (10:40)', 'hour': 10, 'minute': 40},
    ],
    'Tarde': [
      {'label': '1er Recreo (15:15)', 'hour': 15, 'minute': 15},
      {'label': '2do Recreo (16:25)', 'hour': 16, 'minute': 25},
    ],
  };

  bool get _balanceSufficient {
    final userSession = User.safeFromStorage();
    final userBalance = userSession.balance ?? 0.0;
    return userBalance >= _shoppingCartController.totalPrice;
  }

  void _seleccionarHorarioFijo(BuildContext context) {
    final hoy = DateTime.now();
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(setWidth(24)),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: setHeight(20)),
              Text(
                'En que momento vas a retirar?',
                style: TextStyle(
                  fontSize: setSp(20),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: setHeight(20)),
              ..._horariosPorTurno.entries.map((turno) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Turno ${turno.key}',
                      style: TextStyle(
                        fontSize: setSp(16),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF999999),
                      ),
                    ),
                    SizedBox(height: setHeight(10)),
                    ...turno.value.map((recreo) {
                      final slotTime = DateTime(
                        hoy.year,
                        hoy.month,
                        hoy.day,
                        recreo['hour'],
                        recreo['minute'],
                      );
                      final cutoffTime =
                          slotTime.subtract(const Duration(minutes: 5));
                      final isDisabled = hoy.isAfter(cutoffTime);

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.timer_outlined,
                          color: isDisabled ? Colors.grey : Colors.black,
                        ),
                        title: Text(
                          recreo['label'],
                          style: TextStyle(
                            fontSize: setSp(18),
                            color: isDisabled ? Colors.grey : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: isDisabled
                            ? null
                            : () {
                                setState(() {
                                  selectedDateTime = slotTime;
                                  displayRetiroText =
                                      'Hoy - ${turno.key} (${recreo['label']})';
                                });
                                Get.back();
                              },
                      );
                    }),
                    SizedBox(height: setHeight(15)),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitPayment() async {
    if (selectedMethod == null || selectedDateTime == null) {
      CustomToast.showError(
        title: 'No seleccionaste metodo de pago',
        message:
            'Por favor, selecciona un metodo de pago y un horario de retiro para continuar.',
      );
      return;
    }

    await _paymentsController.setOrderDateTime(selectedDateTime!);

    late final bool success;
    if (selectedMethod == 'mercado_pago') {
      success = await _paymentsController.executeMercadoPagoFlow();
    } else {
      success = await _paymentsController.executeBalanceFlow();
    }

    if (!success) {
      final error = _paymentsController.errorMessage.value;
      CustomToast.showError(
        title: 'Error',
        message: (error == null || error.isEmpty)
            ? 'No se pudo procesar el pago.'
            : error,
      );
      return;
    }

    if (selectedMethod == 'saldo') {
      await _paymentsController.clearState();
      _shoppingCartController.clearCart();

      if (Get.isRegistered<BalanceController>()) {
        await Get.find<BalanceController>().fetchBalance();
      }
      if (Get.isRegistered<HomeController>()) {
        await Get.find<HomeController>().getProducts();
      }

      final enablePayStateV2 =
          GetStorage().read<bool>('enable_pay_state_v2') ?? false;
      Get.offNamed(
        enablePayStateV2 ? Routes.SUCCESS_PAY_V2 : Routes.SUCCESS_PAY,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: setSp(30)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Pago',
          style: TextStyle(
            fontSize: setSp(25),
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                vertical: setHeight(20),
                horizontal: setWidth(20),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - setHeight(40),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _seleccionarHorarioFijo(context),
                                child: AbsorbPointer(
                                  child: InputWidget(
                                    hintText: 'Seleccionar recreo',
                                    withIcon: false,
                                    textEditingController:
                                        TextEditingController(
                                      text: displayRetiroText,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: setWidth(10)),
                              child: GestureDetector(
                                onTap: () => _seleccionarHorarioFijo(context),
                                child: Container(
                                  height: setHeight(60),
                                  width: setWidth(60),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFE500),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Icon(
                                    Icons.timer_sharp,
                                    color: Colors.black,
                                    size: setSp(35),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: setHeight(40)),
                        Text(
                          'Metodo de Pago',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: setSp(28),
                          ),
                        ),
                        SizedBox(height: setHeight(25)),
                        PaymentMethodTileV2(
                          imageUrl: 'assets/images/y_yapaso.webp',
                          title: 'Tu saldo',
                          value: 'saldo',
                          groupValue: selectedMethod,
                          isEnabled: _balanceSufficient,
                          isEnabledImage: 'assets/images/logo-negativo.webp',
                          onChanged: (value) =>
                              setState(() => selectedMethod = value),
                        ),
                        PaymentMethodTileV2(
                          imageUrl: 'assets/images/mercado_pago.webp',
                          title: 'Mercado Pago',
                          value: 'mercado_pago',
                          groupValue: selectedMethod,
                          isEnabled: true,
                          onChanged: (value) =>
                              setState(() => selectedMethod = value),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: setHeight(20)),
                      child: SizedBox(
                        height: setHeight(65),
                        child: Obx(
                          () => ElevatedButton(
                            onPressed: _paymentsController.isLoading.value
                                ? null
                                : _submitPayment,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFE500),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: _paymentsController.isLoading.value
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  )
                                : Text(
                                    'Pagar',
                                    style: TextStyle(
                                      fontSize: setSp(25),
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class PaymentMethodTileV2 extends StatelessWidget with ResponsiveMixin {
  final String imageUrl;
  final String title;
  final String value;
  final String? groupValue;
  final bool isEnabled;
  final String? isEnabledImage;
  final ValueChanged<String?> onChanged;

  const PaymentMethodTileV2({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.isEnabled,
    this.isEnabledImage,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = groupValue == value;
    return GestureDetector(
      onTap: isEnabled ? () => onChanged(value) : null,
      child: Container(
        margin: EdgeInsets.only(bottom: setHeight(20)),
        padding: EdgeInsets.symmetric(
          horizontal: setWidth(15),
          vertical: setHeight(15),
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF2C2F3D)
              : isEnabled
                  ? Colors.white
                  : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: setWidth(10),
              offset: Offset(0, setHeight(2)),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Image.asset(
                isSelected ? (isEnabledImage ?? imageUrl) : imageUrl,
                height: setHeight(50),
                width: setWidth(50),
                color: (isSelected || isEnabled) ? null : Colors.grey[400],
              ),
              SizedBox(width: setWidth(15)),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: isSelected
                        ? Colors.white
                        : isEnabled
                            ? Colors.black
                            : Colors.grey[400],
                    fontSize: setSp(22),
                  ),
                ),
              ),
              Transform.scale(
                scale: 1.2,
                child: Radio<String>(
                  value: value,
                  groupValue: groupValue,
                  onChanged: isEnabled ? onChanged : null,
                  activeColor: const Color(0xFFFFE500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
