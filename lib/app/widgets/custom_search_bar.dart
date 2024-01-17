import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class CustomSearchBar extends StatelessWidget {
  final String hint;
  final void Function(String)? onChanged;

  const CustomSearchBar({
    super.key,
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: AppColors.textFillColor,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Colors.transparent,
            )),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Colors.transparent,
            )),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Colors.transparent,
            )),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Colors.transparent,
            )),
        suffixIcon: Icon(
          Icons.search,
          color: Color(0XFF44474d),
        ),
        hintText: hint,
      ),
      onChanged: onChanged,
    );
  }
}
