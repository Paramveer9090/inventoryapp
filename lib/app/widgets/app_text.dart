import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class AppText extends StatelessWidget {
  final String text;
  final String? fontFamily;
  final double fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final double? letterSpacing;
  final double? height;
  final TextDecoration textDecoration;
  final TextAlign textAlign;
  final int maxLines;
  final FontStyle? fontStyle;
  final TextOverflow? overflow;

  AppText(
    this.text, {
    this.fontSize = 15,
    this.color,
    this.fontWeight,
    this.fontFamily,
    this.letterSpacing,
    this.overflow,
    this.textDecoration = TextDecoration.none,
    this.textAlign = TextAlign.start,
    this.height = 0,
    this.maxLines = 100,
    this.fontStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        height: height,
        color: color ?? AppColors.primaryColor,
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
        decoration: textDecoration,
        overflow: overflow,
      ),
    );
  }
}
