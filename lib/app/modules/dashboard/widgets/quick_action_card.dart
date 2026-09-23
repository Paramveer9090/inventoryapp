import '../../..//widgets/all_import.dart';
import 'package:true_leaf_inventory_app/app/widgets/app_button.dart';

class QuickActionCard extends StatelessWidget {
  const QuickActionCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: EdgeInsets.all(2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.flash_on, size: 20, color: AppColors.primaryColor),
                SizedBox(width: 1.h),
                AppText(
                  'Quick Actions',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                ),
              ],
            ),
            SizedBox(height: 2.h),
            AppButton(
              title: "View All Orders",
              isIcon: true,
              icon: Icons.list_alt,
              onTap: () {
                Get.find<HomeController>().isSelected.value = 2;
                Get.find<HomeController>().update();
              },
            ),
          ],
        ),
      ),
    );
  }
}
