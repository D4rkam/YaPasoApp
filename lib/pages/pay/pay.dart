import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/pages/pay/pay_controller.dart';
import 'package:prueba_buffet/pages/shopping_cart/shopping_cart_controller.dart';
import 'package:prueba_buffet/utils/constants/image_strings.dart';
import 'package:prueba_buffet/widgets/input.dart';

class PayScreen extends StatefulWidget {
  const PayScreen({super.key});

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
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
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Color(0xFFFFE500),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      // Seleccionar la hora
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(primaryColor: Color(0xFFFFE500)),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
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
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Pago',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
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
                  padding: const EdgeInsets.only(left: 9),
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE500),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.timer_sharp,
                      color: Colors.black,
                      size: 40,
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(height: 60),
            const Text(
              'Método de Pago',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            const SizedBox(height: 32),
            // Método de pago: Saldo
            PaymentMethodTile(
              imageUrl: ProjectImages.yaPasoIcon,
              title: 'Tu saldo',
              value: 'saldo',
              groupValue: selectedMethod,
              isEnabled: false,
              onChanged: (value) {
                setState(() {
                  selectedMethod = value;
                });
              },
            ),
            // Método de pago: Transferencia
            PaymentMethodTile(
              imageUrl: ProjectImages.pagoTransferenciaIcon,
              title: 'Transferencia',
              value: 'transferencia',
              groupValue: selectedMethod,
              isEnabled: true,
              onChanged: (value) {
                setState(() {
                  selectedMethod = value;
                });
              },
            ),
            // Método de pago: Efectivo
            PaymentMethodTile(
              imageUrl: ProjectImages.pagoEfectivoIcon,
              title: 'Efectivo',
              value: 'efectivo',
              groupValue: selectedMethod,
              isEnabled: true,
              onChanged: (value) {
                setState(() {
                  selectedMethod = value;
                });
              },
            ),
            const SizedBox(height: 20),
            const Spacer(),
            SizedBox(
              height: 80,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedMethod != null && selectedDateTime != null) {
                    if (selectedMethod == "transferencia") {
                      payController.pay(shoppingCartController.cartItems);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Método: $selectedMethod, Fecha: $selectedDateTime',
                        ),
                      ),
                    );
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
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Pagar',
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ),
          ]),
        ));
  }
}

class PaymentMethodTile extends StatelessWidget {
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
        height: 96,
        margin: const EdgeInsets.only(bottom: 25),
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
                  blurRadius: 2,
                  spreadRadius: 0.1,
                  offset: const Offset(0, 2))
            ]),
        child: Row(
          children: [
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset(
                  imageUrl,
                  height: 70,
                  width: 70,
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
                  fontSize: 25,
                ),
              ),
            ),
            Transform.scale(
              scale: 1.5,
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
