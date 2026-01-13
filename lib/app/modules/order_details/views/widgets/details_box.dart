import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class DetailsBox extends StatelessWidget {
  final String title;
  final String? value;

  const DetailsBox({Key? key, required this.title, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.all(1.5.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.greyLightColor,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.blackColor,
              ),
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            flex: 3,
            child: Text(
              value ?? 'N/A',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.normal,
                color: AppColors.greyColor,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
