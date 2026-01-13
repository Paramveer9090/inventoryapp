import 'package:true_leaf_inventory_app/app/modules/cart/controllers/cart_controller.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class DeliveryDriverSelector extends StatelessWidget {
  final CartController controller;

  const DeliveryDriverSelector({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.showDeliveryAgentSelector.value) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              "Select Delivery Driver",
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryColor,
            ),
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 1.5.h, vertical: 0.5.h),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: controller.isLoadingAgents.value
                  ? Padding(
                      padding: EdgeInsets.all(1.h),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          SizedBox(width: 1.h),
                          AppText(
                            "Loading drivers...",
                            fontSize: 12.sp,
                            color: Colors.grey[600]!,
                          ),
                        ],
                      ),
                    )
                  : DropdownButtonHideUnderline(
                      child: DropdownButton<LoginSignUpData>(
                        isExpanded: true,
                        hint: AppText(
                          "Choose a delivery driver",
                          fontSize: 12.sp,
                          color: Colors.grey[600]!,
                        ),
                        value: controller.selectedDeliveryAgent.value,
                        onChanged: (LoginSignUpData? newValue) {
                          controller.selectDeliveryAgent(newValue);
                        },
                        items: [
                          DropdownMenuItem<LoginSignUpData>(
                            value: null,
                            child: AppText(
                              "No driver assigned",
                              fontSize: 12.sp,
                              color: Colors.grey[600]!,
                            ),
                          ),
                          ...controller.deliveryAgents.map((LoginSignUpData agent) {
                            return DropdownMenuItem<LoginSignUpData>(
                              value: agent,
                              child: Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: const Icon(
                                      Icons.local_shipping,
                                      size: 16,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  SizedBox(width: 1.h),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        AppText(
                                          agent.name ?? "Unknown Driver",
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          maxLines: 1,
                                        ),
                                        AppText(
                                          agent.email ?? "No email",
                                          fontSize: 10.sp,
                                          color: Colors.grey[600]!,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
            ),
            SizedBox(height: 3.h),
          ],
        ),
      );
    });
  }
}
