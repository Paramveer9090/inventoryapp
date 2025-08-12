import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ConsistentIcon extends StatelessWidget {
  final String iconPath;
  final bool isSelected;
  final double? iconSize;
  final double? containerSize;

  const ConsistentIcon({
    Key? key,
    required this.iconPath,
    this.isSelected = false,
    this.iconSize,
    this.containerSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: containerSize ?? 4.h,
      height: containerSize ?? 4.h,
      padding: EdgeInsets.all(0.8.h), // Consistent padding
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isSelected 
          ? Colors.white.withOpacity(0.1) 
          : Colors.transparent,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
        ),
        child: FittedBox(
          fit: BoxFit.contain, // Ensures icon fits within container
          child: Image.asset(
            iconPath,
            width: iconSize ?? 3.h,
            height: iconSize ?? 3.h,
            filterQuality: FilterQuality.high,
            // Remove color filter to preserve original icon colors
          ),
        ),
      ),
    );
  }
}
