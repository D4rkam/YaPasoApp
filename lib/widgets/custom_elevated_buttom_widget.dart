import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final Color? textColor;
  final FontWeight? textFontWeight;
  final double? fontSize;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final MainAxisSize? mainAxisSize;

  const CustomElevatedButton(
      {super.key,
        required this.text,
        required this.onPressed,
        this.backgroundColor,
        this.textStyle,
        this.textColor,
        this.textFontWeight,
        this.fontSize,
        this.borderRadius,
        this.padding,
        this.leadingIcon,
        this.trailingIcon,
        this.mainAxisSize});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        overlayColor: Colors.black,
        backgroundColor: const Color(0xFFFFE500),
        padding: padding ??
                      // width: MediaQuery.of
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 20.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: mainAxisSize ?? MainAxisSize.max,
        children: [
          if (leadingIcon != null) ...[
            leadingIcon!,
            const SizedBox(width: 8.0),
          ],
          Text(
            text,
            style: textStyle ??
                TextStyle(
                  color: textColor ?? Colors.black,
                  fontSize: fontSize ?? 40.0,
                  fontWeight: textFontWeight ?? FontWeight.w400,
                ),
          ),
          if (trailingIcon != null) ...[
            const SizedBox(width: 8.0),
            trailingIcon!,
          ],
        ],
      ),
    );
  }
}
