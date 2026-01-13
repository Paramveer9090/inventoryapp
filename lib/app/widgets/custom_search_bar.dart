import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class CustomSearchBar extends StatelessWidget {
  final String hint;
  final void Function(String)? onChanged;
  final TextEditingController? controller;

  const CustomSearchBar({
    super.key,
    required this.hint,
    required this.onChanged,
    this.controller,
  });
//
  @override
  Widget build(BuildContext context) {
    // Get responsive sizing
    final borderRadius = 3.h;
    final iconSize = 2.4.h;

    return TextFormField(
      controller: controller,
      cursorColor: AppColors.textFillColor,
      style: TextStyle(fontSize: 14.sp),
      decoration: InputDecoration(
        alignLabelWithHint: true,
        filled: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.4.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: Colors.transparent,
            )),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: Colors.transparent,
            )),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: Colors.transparent,
            )),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: Colors.transparent,
            )),
        suffixIcon: Icon(
          Icons.search,
          color: Color(0XFF44474d),
          size: iconSize,
        ),
        hintText: hint,
        hintStyle: TextStyle(fontSize: 14.sp),
      ),
      onChanged: onChanged,
    );
  }
}

//
//
//
//
