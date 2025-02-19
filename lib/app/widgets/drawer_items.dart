import 'package:flutter_svg/svg.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class NavigationGroup extends StatelessWidget {
  NavigationGroup({
    required this.label,
    required this.items,
    this.icon,
    this.initiallyExpanded = false,
  });

  final String label;
  final bool initiallyExpanded;
  final String? icon;
  final List<NavigationItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ExpansionTile(
        maintainState: true,
        iconColor: AppColors.whiteColor,
        collapsedIconColor: AppColors.whiteColor,
        initiallyExpanded: initiallyExpanded,
        collapsedBackgroundColor: Colors.transparent,
        backgroundColor: Color(0xff373737),
        title: ListTile(
          contentPadding: EdgeInsets.only(left: 1.5.w),
          title: Row(
            children: [
              Container(
                height: 20,
                width: 20,
                child: SvgPicture.asset(
                  "${icon}",
                  width: 18.0,
                  color: AppColors.whiteColor.withOpacity(0.6),
                  height: 18.0,
                ),
              ),
              SizedBox(width: 2.w),
              AppText(
                label,
                fontSize: 13.sp,
                color: AppColors.whiteColor,
              ),
            ],
          ),
        ),
        children: items.map((e) => e.build(context)).toList(),
      ),
    );
  }
}

class NavigationItem extends StatelessWidget {
  NavigationItem({
    required this.label,
    this.onTap,
    this.tileColor,
    this.icon,
    this.isSelectedColor = false,
  });

  final bool isSelectedColor;
  final String label;
  final String? icon;
  final Color? tileColor;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return label == ""
        ? Container()
        : Container(
            margin: EdgeInsets.only(bottom: 1.h, left: 1.h, right: 1.h),
            decoration: BoxDecoration(
                color: isSelectedColor ? AppColors.menuColor : Colors.transparent,
                border: Border.all(
                  color: isSelectedColor ? AppColors.whiteColor : Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(30)),
            child: ListTile(
              tileColor: tileColor,
              onTap: onTap,
              title: Row(
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    child: SvgPicture.asset(
                      "${icon}",
                      width: 18.0,
                      color: AppColors.whiteColor.withOpacity(0.6),
                      height: 18.0,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  AppText(
                    label,
                    fontSize: 13.sp,
                    color: AppColors.whiteColor,
                  ),
                ],
              ),
            ),
          );
  }
}
