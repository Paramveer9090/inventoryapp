import 'package:true_leaf_inventory_app/app/modules/order_details/controllers/order_details_controller.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';
import 'package:true_leaf_inventory_app/app/widgets/app_button.dart';

class DeliveryAgentSelectorCard extends StatelessWidget {
  final OrderDetailsController controller;

  const DeliveryAgentSelectorCard({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.showDeliveryAgentSelector.value) {
        return const SizedBox.shrink();
      }

      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.local_shipping,
                    size: 20,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  AppText(
                    "Delivery Driver",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  const Spacer(),
                  if (controller.selectedDeliveryAgent.value != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle, size: 14, color: Colors.green),
                          const SizedBox(width: 4),
                          AppText(
                            "Assigned",
                            fontSize: 10.sp,
                            color: Colors.green[700]!,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: controller.isLoadingAgents.value
                    ? Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            const SizedBox(width: 8),
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
                            "Select a delivery driver",
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
                                        Icons.person,
                                        size: 16,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
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
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      title: "Update Driver",
                      onTap: controller.updateDeliveryAgent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
