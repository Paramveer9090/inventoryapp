import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class CustomDropDownSearch<T> extends StatelessWidget {
  const CustomDropDownSearch({
    super.key,
    required this.items,
    required this.label,
    this.itemAsString,
    this.onChanged,
    this.initialValue,
    this.validator,
    this.enabled = true,
  });

  final List<T> items;
  final String label;
  final bool enabled;
  final String Function(T)? itemAsString;
  final void Function(T?)? onChanged;
  final T? initialValue;
  final String? Function(T?)? validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: enabled ? AppColors.textFillColor : AppColors.greyLightColor,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.all(5),
      child: DropdownSearch<T>(
        items: items,
        enabled: enabled,
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            // labelText: label,
            hintText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: enabled ? BorderSide() : BorderSide(color: AppColors.blackColor),
            ),
            labelStyle: TextStyle(color: Colors.black.withValues(alpha: 0.7)),
            filled: true,
            fillColor: enabled ? AppColors.textFillColor : AppColors.greyLightColor,
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
        ),
        popupProps: PopupProps.menu(
          showSearchBox: true,
          fit: FlexFit.loose,
          searchFieldProps: const TextFieldProps(
            decoration: InputDecoration(prefixIcon: Icon(Icons.search), labelText: 'Search'),
          ),
          menuProps: MenuProps(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        validator: validator,
        selectedItem: initialValue,
        itemAsString: itemAsString,
        onChanged: onChanged,
      ),
    );
  }
}
