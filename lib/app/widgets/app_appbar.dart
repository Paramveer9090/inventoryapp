
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool? isBack;
  final Widget? leading;
  final Color? backgroundColor;
  final Color? appBarTitleText;
  final Widget? action;
  final Widget? titleWidgets;
  final Object? tag;
  final double? fontSize;
  final String? title;
  final GestureTapCallback? backTap;

  const CustomAppBar({
    Key? key,
    this.isBack = false,
    this.action,
    this.fontSize,
    this.backgroundColor = Colors.transparent,
    this.appBarTitleText = Colors.black,
    this.title = "",
    this.leading,
    this.tag,
    this.titleWidgets,
    this.backTap,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 80.h,
      padding: EdgeInsets.only(bottom: 1.h, top: 0.5.h),
      color: backgroundColor,
      child: SafeArea(
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isBack!
                ? GestureDetector(
                    onTap: backTap ??
                        () {
                          Get.back();
                        },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1.5.h),
                      child: Icon(Icons.arrow_back_ios),
                    ),
                  )
                : leading != null
                    ? leading!
                    : Container(
                        width: 5.h,
                        height: 5.h,
                      ),
            SizedBox(width: 2.h),
            titleWidgets ??
                AppText(
                  title!,
                  fontSize: fontSize ?? 19.sp,
                  color: Colors.black,
                ),
            Spacer(),
            action == null
                ? Container(
                    width: 5.h,
                    height: 5.h,
                  )
                : action!,
          ],
        ),
      ),
    );
  }
}
