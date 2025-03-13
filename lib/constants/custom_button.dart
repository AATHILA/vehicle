
import 'package:flutter/material.dart';

import '../main.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Color? color;
  final FontWeight? fontWeight;
  final double? fontSize;
  final VoidCallback? onPressed;
  final Decoration? decoration;
  final double? borderRadius;
  final Color? backgroundColor;
  final double height;
  final double? width;
   Alignment? alignment;



   CustomButton({
    super.key,
    required this.title,
     required this.height,
    this.width,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.onPressed,
    this.decoration,
    this.borderRadius,
    this.backgroundColor,
 this.alignment

  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height*0.09,
        width: width,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: decoration ??
            BoxDecoration(
              color: backgroundColor ?? Colors.blue,
              borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
            ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: color ?? Colors.white,
              fontWeight: fontWeight ?? FontWeight.bold,
              fontSize: fontSize ?? 16.0,
            ),
          ),
        ),
      ),
    );
  }
}
