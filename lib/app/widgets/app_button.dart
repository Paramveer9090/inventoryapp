import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class AppButton extends StatelessWidget {
  final String title;
  final Function()? onTap;
  final double? width;
  final double? height;
  final Color? color;
  final double? fontSize;
  final String? image;
  final bool? isImage;

  AppButton({
    required this.title,
    this.onTap,
    this.width,
    this.height,
    this.fontSize,
    this.color,
    this.image,
    this.isImage = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(horizontal: 3.h, vertical: 1.5.h),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color ?? AppColors.secondPrimaryColor,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isImage!
                ? Image.asset(
                    image!,
                    color: AppColors.whiteColor,
                    height: 4.h,
                    width: 4.h,
                  )
                : Container(),
            SizedBox(width: 2.h),
            Center(
              child: AppText(
                title,
                color: AppColors.whiteColor,
                fontSize: fontSize ?? 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
