import 'package:flutter/material.dart';
import 'package:prueba_buffet/app/ui/global_widgets/input.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';

class ContainerInputSearch extends StatelessWidget with ResponsiveMixin {
  final Function(String)? onChanged;
  final TextEditingController? textController;
  final FocusNode? focusNode;

  const ContainerInputSearch({
    super.key,
    this.onChanged,
    this.textController,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            height: setHeight(40),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              color: Color(0xFFFFE500),
            ),
          ),
          Positioned(
            bottom: -20,
            left: 29,
            right: 29,
            child: Material(
              shadowColor: const Color(0xFFE6E6E6),
              borderRadius: BorderRadius.circular(20),
              child: InputWidget(
                hintText: "Buscar producto",
                icon: Icons.search,
                withIcon: true,
                onChanged: onChanged,
                textEditingController: textController,
                focusNode: focusNode,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
