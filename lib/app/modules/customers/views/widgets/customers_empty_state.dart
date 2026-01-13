import 'package:true_leaf_inventory_app/app/utils/responsive_helper.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class CustomersEmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const CustomersEmptyState({Key? key, required this.icon, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 60,
            color: AppColors.greyColor,
          ),
          SizedBox(height: 2.h),
          AppText(
            message,
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, 10.sp, 13.sp),
            color: AppColors.greyColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
