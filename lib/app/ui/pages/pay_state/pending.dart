import 'package:flutter/material.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';

class PendingScreen extends StatelessWidget with ResponsiveMixin {
  PendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pendiente", style: TextStyle(fontSize: setSp(20))),
      ),
      body: Center(
        child: Text("El pago se encuentra pendiente",
            style: TextStyle(fontSize: setSp(16))),
      ),
    );
  }
}
