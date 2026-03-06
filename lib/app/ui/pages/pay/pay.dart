import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/app/controllers/pay_controller.dart';
import 'package:prueba_buffet/app/controllers/shopping_cart_controller.dart';
import 'package:prueba_buffet/utils/constants/image_strings.dart';
import 'package:prueba_buffet/app/ui/global_widgets/input.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';

class PayScreen extends StatefulWidget {
  const PayScreen({super.key});

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> with ResponsiveMixin {
  final PayController payController = Get.put(PayController());
  final ShoppingCartController shoppingCartController = Get.find();

  String? selectedMethod;
  DateTime? selectedDateTime;

  Future<void> _selectDateTime(BuildContext context) async {
    // Seleccionar la fecha
    final DateTime? pickedDate = await showDatePicker(
      barrierLabel: "Selecciona una fecha",
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year, 12, 31),
      locale: const Locale("es", ""),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFFFFE500)),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && context.mounted) {
      // Seleccionar la hora
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialEntryMode: TimePickerEntryMode.dial,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(primary: Color(0xFFFFE500)),
              buttonTheme: const ButtonThemeData(
                textTheme: ButtonTextTheme.primary,
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null && context.mounted) {
        // Combinar fecha y hora seleccionadas
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
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
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: setSp(30),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Pago',
            style:
                TextStyle(fontSize: setSp(25), fontWeight: FontWeight.normal),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              vertical: setHeight(30), horizontal: setWidth(20)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // Horario de Retiro
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDateTime(context),
                    child: AbsorbPointer(
                      child: InputWidget(
                        hintText: "Dia y hora de retiro",
                        withIcon: false,
                        textEditingController: TextEditingController(
                          text: selectedDateTime != null
                              ? '${selectedDateTime!.day}/${selectedDateTime!.month}/${selectedDateTime!.year} - ${selectedDateTime!.hour}:${selectedDateTime!.minute.toString().padLeft(2, '0')}'
                              : '',
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: setWidth(9)),
                  child: Container(
                    height: setHeight(60),
                    width: setWidth(60),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE500),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.timer_sharp,
                      color: Colors.black,
                      size: setSp(40),
                    ),
                  ),
                )
              ],
            ),

            SizedBox(height: setHeight(60)),
            Text(
              'Método de Pago',
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: setSp(30)),
            ),
            SizedBox(height: setHeight(32)),

            PaymentMethodTile(
              imageUrl: ProjectImages.yaPasoIcon,
              title: 'Tu saldo',
              value: 'saldo',
              groupValue: selectedMethod,
              isEnabled: payController.balanceSufficient,
              onChanged: (value) {
                setState(() {
                  selectedMethod = value;
                });
              },
            ),

            PaymentMethodTile(
              imageUrl: ProjectImages.pagoTransferenciaIcon,
              title: 'Mercado Pago',
              value: 'mercado_pago',
              groupValue: selectedMethod,
              isEnabled: true,
              onChanged: (value) {
                setState(() {
                  selectedMethod = value;
                });
              },
            ),

            SizedBox(height: setHeight(20)),
            const Spacer(),
            SizedBox(
              height: setHeight(80),
              child: ElevatedButton(
                onPressed: () {
                  if (selectedMethod != null && selectedDateTime != null) {
                    GetStorage()
                        .write("order_datetime", selectedDateTime.toString());
                    if (selectedMethod == "mercado_pago") {
                      payController.pay(shoppingCartController.cartItems);
                    }
                    if (selectedMethod == "saldo") {
                      payController.createOrder();
                      payController.pay_with_balance();
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Completa los campos requeridos'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  padding: EdgeInsets.symmetric(vertical: setHeight(16)),
                ),
                child: Text(
                  'Pagar',
                  style: TextStyle(fontSize: setSp(30)),
                ),
              ),
            ),
          ]),
        ));
  }
}

class PaymentMethodTile extends StatelessWidget with ResponsiveMixin {
  final String imageUrl;
  final String title;
  final String value;
  final String? groupValue;
  final bool isEnabled;
  final ValueChanged<String?> onChanged;

  const PaymentMethodTile({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? () => onChanged(value) : null,
      child: Container(
        height: setHeight(96),
        margin: EdgeInsets.only(bottom: setHeight(25)),
        decoration: BoxDecoration(
            color: (groupValue == value)
                ? const Color(0xFF2C2F3D)
                : isEnabled
                    ? Colors.white
                    : Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: setWidth(2),
                  spreadRadius: setWidth(0.1),
                  offset: Offset(0, setHeight(2)))
            ]),
        child: Row(
          children: [
            Padding(
                padding: EdgeInsets.all(setWidth(16.0)),
                child: Image.asset(
                  imageUrl,
                  height: setHeight(70),
                  width: setWidth(70),
                  color: (groupValue == value)
                      ? null
                      : isEnabled
                          ? null
                          : Colors.grey[400],
                )),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: (groupValue == value)
                      ? Colors.white
                      : isEnabled
                          ? Colors.black
                          : Colors.grey[400],
                  fontSize: setSp(25),
                ),
              ),
            ),
            Transform.scale(
              scale: setSp(1.5),
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
    );
  }
}
