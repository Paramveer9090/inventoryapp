import 'package:true_leaf_inventory_app/app/utils/responsive_helper.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';
import '../../controllers/customers_controller.dart';

class CustomerListTile extends StatelessWidget {
  final Customers data;
  final CustomersController controller;

  const CustomerListTile({Key? key, required this.data, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 1.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          controller.id.value = data.id.toString();
          controller.update();

          if (controller.id.value == customerCartId || cartLength == "" || cartLength == "0") {
            controller.id.value = data.id.toString();
            controller.update();
            Get.find<HomeController>().isCustomerDetails.value = true;
            Get.find<HomeController>().update();
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return DeletePopup(
                  isDelete: true,
                  isConfirmation: true,
                  confirmationText: "You want to change customer",
                  onTap: () {
                    Get.back();
                    controller.deleteCartAPI();
                  },
                );
              },
            );
          }
        },
        child: Container(
          padding: EdgeInsets.all(1.h),
          child: Row(
            children: [
              Container(
                width: 5.h,
                height: 5.h,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.5.h),
                ),
                child: Icon(
                  Icons.business,
                  color: AppColors.primaryColor,
                  size: 2.4.h,
                ),
              ),
              SizedBox(width: 1.2.h),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      data.companyName.toString(),
                      fontWeight: FontWeight.w600,
                      fontSize: ResponsiveHelper.getResponsiveFontSize(context, 11.sp, 14.sp),
                      maxLines: 2,
                      color: AppColors.blackColor,
                    ),
                    SizedBox(height: 0.4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 1.4.h,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 0.4.h),
                        Expanded(
                          child: AppText(
                            data.name.toString(),
                            fontSize: ResponsiveHelper.getResponsiveFontSize(context, 9.sp, 12.sp),
                            maxLines: 1,
                            color: Colors.grey[600]!,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 4),
                        AppText(
                          data.phoneNumber.toString(),
                          color: Colors.grey[600]!,
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, 9.sp, 12.sp),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.primaryColor,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
