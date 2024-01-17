import 'package:flutter/material.dart';
import 'package:true_leaf_inventory_app/app/utils/app_images.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class CustomDatePicker extends StatelessWidget {
  final String? initialValue;
  final String hint;
  final String? Function(String?)? validator;
  final void Function()? onTap;

  const CustomDatePicker({
    super.key,
    required this.initialValue,
    this.hint = 'Select Date',
    this.validator,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      initialValue: initialValue,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppColors.textFillColor,
        hintStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
        suffixIcon: Padding(
          padding: EdgeInsets.only(right: 2, top: 2, bottom: 2),
          child: Image.asset(
            AppImages.ic_pickDate,
            height: 2.5.h,
            width: 2.5.h,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.transparent,
            )),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.transparent,
            )),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.transparent,
            )),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.transparent,
            )),
      ),
      validator: validator,
      onTap: onTap,
    );
  }
}
