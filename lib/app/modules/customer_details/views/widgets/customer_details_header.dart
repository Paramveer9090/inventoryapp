import 'package:true_leaf_inventory_app/app/modules/customer_details/controllers/customer_details_controller.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class CustomerDetailsHeader extends StatelessWidget {
  final CustomerDetailsController controller;
  final dynamic id;

  const CustomerDetailsHeader({Key? key, required this.controller, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Get.find<HomeController>().isCustomerDetails.value = false;
              Get.find<HomeController>().update();
              controller.update();
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.arrow_back_ios,
                color: AppColors.primaryColor,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  'Customer Details',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                ),
                if (controller.customerDetails != null)
                  AppText(
                    controller.customerDetails!.companyName.toString(),
                    fontSize: 12.sp,
                    color: Colors.grey[600]!,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
