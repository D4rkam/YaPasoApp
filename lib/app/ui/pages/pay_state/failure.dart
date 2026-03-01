import 'package:flutter/material.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';

class FailureScreen extends StatelessWidget with ResponsiveMixin {
  FailureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Error", style: TextStyle(fontSize: setSp(20))),
      ),
      body: Center(
        child: Text("Error al realizar el pago",
            style: TextStyle(fontSize: setSp(16))),
      ),
    );
  }
}
