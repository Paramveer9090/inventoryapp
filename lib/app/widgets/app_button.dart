import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../utils/app_colors.dart';
import 'app_text.dart';

class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final Color? color;
  final double? fontSize;
  final String? image;
  final IconData? icon;
  final bool isImage;
  final bool isIcon;

  AppButton({
    required this.title,
    this.onTap,
    this.width,
    this.height,
    this.fontSize,
    this.color,
    this.image,
    this.icon,
    this.isImage = false,
    this.isIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(40);
    final minHeight = math.max(height ?? 0, 48).toDouble();

    return Semantics(
      button: true,
      label: title,
      enabled: onTap != null,
      onTap: onTap,
      child: ExcludeSemantics(
        child: Material(
          color: color ?? AppColors.secondPrimaryColor,
          borderRadius: borderRadius,
          child: InkWell(
            onTap: onTap,
            borderRadius: borderRadius,
            child: Container(
              width: width,
              constraints: BoxConstraints(minHeight: minHeight),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isIcon && icon != null)
                    Icon(icon, size: 24, color: AppColors.whiteColor)
                  else if (isImage && image != null)
                    Image.asset(
                      image!,
                      color: AppColors.whiteColor,
                      height: 24,
                      width: 24,
                    ),
                  if (isImage || isIcon) const SizedBox(width: 8),
                  Flexible(
                    child: AppText(
                      title,
                      color: AppColors.whiteColor,
                      fontSize: fontSize ?? 15.sp,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
