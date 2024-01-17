import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class CustomTextFormField extends StatefulWidget {
  final String? label;
  final Function(String)? onChanged;
  final void Function()? onTap;
  final String? Function(String?)? validator;
  final String initialValue;
  final int maxLines;
  final TextInputType? keyboardType;
  final bool readOnly;
  final bool suffixVisibility;
  final Widget? prefixIcon;
  final AutovalidateMode? autovalidateMode;
  final TextEditingController? controller;
  final FloatingLabelBehavior? floatingLabelBehavior;
  Color? fillColor;
  final String? hintText;
  bool? obscureText;

  CustomTextFormField({
    super.key,
    this.label,
    this.prefixIcon,
    this.suffixVisibility = false,
    this.onChanged,
    this.onTap,
    this.fillColor,
    this.obscureText = false,
    this.validator,
    this.initialValue = '',
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.autovalidateMode,
    this.controller,
    this.floatingLabelBehavior,
    this.hintText,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  toggle() {
    setState(() {
      widget.obscureText = !widget.obscureText!;
    });
  }

  @override
  Widget build(BuildContext context) {
    FocusNode myFocusNode = new FocusNode();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: AppColors.greyLightColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            autovalidateMode: widget.autovalidateMode,
            cursorColor: Colors.indigo.withOpacity(0.6),
            controller: widget.controller,
            obscureText: widget.obscureText!,
            decoration: InputDecoration(
              prefixIcon: widget.prefixIcon,
              alignLabelWithHint: true,
              floatingLabelBehavior: widget.floatingLabelBehavior ?? FloatingLabelBehavior.always,
              labelText: widget.label == null ? null : widget.label!,
              hintText: widget.hintText,
              filled: true,
              fillColor: widget.fillColor ?? AppColors.textFillColor,
              labelStyle: TextStyle(color: myFocusNode.hasFocus ? Colors.red : Colors.black),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              suffixIcon: Visibility(
                visible: widget.suffixVisibility,
                child: widget.suffixVisibility == true
                    ? GestureDetector(
                  onTap: toggle,
                  child: Container(
                    margin: EdgeInsets.only(right: 1.h, top: 1.h, bottom: 1.h),
                    child: Image.asset(
                      widget.obscureText! ? AppImages.ic_hide : AppImages.ic_eye,
                      height: 1.h,
                      width: 1.h,
                      color: Color(0xff43474e),
                    ),
                  ),
                )
                    : SizedBox(),
              ),
            ),
            // validator: validator,
            onChanged: widget.onChanged,
            onTap: widget.onTap,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            readOnly: widget.readOnly,
          ),
        ),
        // SizedBox(height: 1.h),
        // AppText(
        //   validator.toString(),
        //   fontSize: 13.sp,
        //   color: AppColors.whiteColor,
        // ),
      ],
    );
  }
}
