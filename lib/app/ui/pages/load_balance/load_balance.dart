import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/balance_controller.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';

class LoadBalanceScreen extends StatelessWidget with ResponsiveMixin {
  LoadBalanceScreen({super.key});

  final BalanceController controller = Get.find<BalanceController>();
  final TextEditingController amountController = TextEditingController();

  void _setQuickAmount(String value) {
    amountController.text = value;
    amountController.selection = TextSelection.fromPosition(
      TextPosition(offset: value.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              size: setSp(22), color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: setWidth(24)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: setHeight(10)),
                        Text(
                          "¿Cuánto dinero queres\ncargar?",
                          style: TextStyle(
                            fontSize: setSp(26),
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: setHeight(60)),
                        TextField(
                          controller: amountController,
                          textAlign: TextAlign.center,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          autofocus: true,
                          style: TextStyle(
                              fontSize: setSp(60),
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                          decoration: InputDecoration(
                            prefixText: "\$ ",
                            prefixStyle: TextStyle(
                                fontSize: setSp(35),
                                color: Colors.grey.shade400),
                            border: InputBorder.none,
                            hintText: "500",
                            hintStyle: TextStyle(
                                fontSize: setSp(60),
                                color: Colors.grey.shade300),
                          ),
                        ),
                        SizedBox(height: setHeight(30)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildQuickButton("500"),
                            SizedBox(width: setWidth(15)),
                            _buildQuickButton("1000"),
                            SizedBox(width: setWidth(15)),
                            _buildQuickButton("10000"),
                          ],
                        ),
                        const Spacer(),
                        Padding(
                          padding: EdgeInsets.only(bottom: setHeight(20)),
                          child: Obx(() => SizedBox(
                                width: double.infinity,
                                height: setHeight(55),
                                child: ElevatedButton(
                                  onPressed: controller.isLoading.value
                                      ? null
                                      : () {
                                          FocusScope.of(context).unfocus();
                                          controller.confirmLoadBalance(
                                            amountController.text.trim(),
                                          );
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFFE500),
                                    foregroundColor: Colors.black,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(setHeight(15)),
                                    ),
                                  ),
                                  child: controller.isLoading.value
                                      ? SizedBox(
                                          width: setHeight(24),
                                          height: setHeight(24),
                                          child:
                                              const CircularProgressIndicator(
                                                  color: Colors.black,
                                                  strokeWidth: 2.5),
                                        )
                                      : Text(
                                          "Continuar",
                                          style: TextStyle(
                                              fontSize: setSp(18),
                                              fontWeight: FontWeight.normal),
                                        ),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildQuickButton(String amount) {
    return InkWell(
      onTap: () => _setQuickAmount(amount),
      borderRadius: BorderRadius.circular(setHeight(8)),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: setWidth(18), vertical: setHeight(10)),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(setHeight(8)),
        ),
        child: Text(
          "\$$amount",
          style: TextStyle(
            fontSize: setSp(16),
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
