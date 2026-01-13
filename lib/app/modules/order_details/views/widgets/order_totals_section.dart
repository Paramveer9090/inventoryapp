import 'package:true_leaf_inventory_app/app/modules/order_details/controllers/order_details_controller.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';
import 'package:true_leaf_inventory_app/app/widgets/app_button.dart';

class OrderTotalsSection extends StatelessWidget {
  final OrderDetailsController controller;

  const OrderTotalsSection({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSalesManager = controller.loginData?.roles?[0].title == "Sales Manager";
    if (!isSalesManager) {
      return const SizedBox.shrink();
    }

    final homeController = Get.find<HomeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              "Total",
              fontSize: 13.sp,
              color: const Color(0XFF44474d),
            ),
            AppText(
              "\$ ${controller.getDetailsData!.orderTotalWithoutTax.toString()}",
              fontSize: 14.sp,
              color: const Color(0XFF44474d),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              "Taxes & charges",
              fontSize: 13.sp,
              color: const Color(0XFF44474d),
            ),
            AppText(
              "\$ ${controller.getDetailsData!.orderTax.toString()}",
              fontSize: 14.sp,
              color: const Color(0XFF44474d),
            ),
          ],
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              "Grand Total",
              color: AppColors.primaryColor,
              fontSize: 14.sp,
            ),
            AppText(
              "\$ ${controller.getDetailsData!.orderTotal.toString()}",
              fontSize: 15.sp,
            ),
          ],
        ),
        SizedBox(height: 5.h),
        if (controller.getDetailsData?.comments != null &&
            controller.getDetailsData!.comments.toString().isNotEmpty &&
            controller.getDetailsData!.comments.toString() != 'null')
          ...[
            const Divider(),
            AppText(
              "Order Notes",
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
              color: AppColors.primaryColor,
            ),
            SizedBox(height: 1.h),
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.greyColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.greyColor.withValues(alpha: 0.3),
                ),
              ),
              child: AppText(
                controller.getDetailsData!.comments.toString(),
                fontSize: 13.sp,
                color: const Color(0XFF44474d),
              ),
            ),
            SizedBox(height: 5.h),
          ],
        homeController.isOrderDetails.value && homeController.isOrderEdit.value
            ? Row(
                children: [
                  Expanded(
                    child: AppButton(
                      color: AppColors.secondButtonColor,
                      title: 'Cancel',
                      onTap: () {
                        homeController.isOrderEdit.value = false;
                        homeController.isOrderDetails.value = false;
                        if (homeController.isSelected.value == 2) {
                          try {
                            Get.find<MyOrdersController>().update();
                          } catch (e) {
                            // controller optional
                          }
                        }
                        homeController.update();
                      },
                    ),
                  ),
                  SizedBox(width: 4.h),
                  Expanded(
                    child: AppButton(
                      onTap: () async {
                        if (controller.isWrongData.value == false) {
                          controller.editOrderAPI();
                        }
                      },
                      title: 'Update',
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppButton(
                    title: "Edit Order",
                    isIcon: true,
                    icon: Icons.edit,
                    onTap: () {
                      homeController.isOrderEdit.value = true;
                      homeController.update();
                      controller.update();
                    },
                  ),
                ],
              ),
      ],
    );
  }
}
