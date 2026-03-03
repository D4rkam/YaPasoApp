import 'package:flutter/material.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';

class CustomInput extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData? icon;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? errorText;
  final Function(String)? onChanged;

  const CustomInput({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.icon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.onChanged,
  });

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> with ResponsiveMixin {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword; // Inicializa según si es password o no
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: widget.onChanged,
      controller: widget.controller,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      cursorColor: Colors.black,
      style: TextStyle(fontSize: setSp(16)),
      decoration: InputDecoration(
        errorText: widget.errorText,
        labelText: widget.label,
        labelStyle: const TextStyle(color: Color(0xFFB3B3B3)),
        floatingLabelStyle:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        prefixIcon: widget.icon != null
            ? Icon(widget.icon, color: Colors.black54)
            : null,

        // AGREGAMOS EL OJITO AQUÍ
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: const Color(0xFFB3B3B3),
                ),
                onPressed: () => setState(() => _obscureText = !_obscureText),
              )
            : null,

        contentPadding: EdgeInsets.symmetric(
            vertical: setHeight(18), horizontal: setWidth(16)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(setHeight(10)),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(setHeight(10)),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(setHeight(10)),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(setHeight(10)),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}
