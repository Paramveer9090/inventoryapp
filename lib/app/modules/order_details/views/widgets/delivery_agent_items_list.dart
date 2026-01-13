import 'package:true_leaf_inventory_app/app/modules/order_details/controllers/order_details_controller.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class DeliveryAgentItemsList extends StatelessWidget {
  final OrderDetailsController controller;

  const DeliveryAgentItemsList({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDeliveryAgent = controller.loginData?.roles?[0].title == "Delivery Agent";
    if (!isDeliveryAgent) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        ...List.generate(
          controller.orderItem.length,
          (index) => Card(
            elevation: 3,
            color: AppColors.whiteColor,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: OptimizedNetworkImage(
                        imageUrl: controller.orderItem[index].imageUrl != null
                            ? "${Constants.imageBaseUrl}${controller.orderItem[index].imageUrl}"
                            : AppImages.dummy,
                        fit: BoxFit.contain,
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                  SizedBox(width: 2.h),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          controller.orderItem[index].name.toString(),
                          fontSize: 15.sp,
                          maxLines: 2,
                        ),
                        SizedBox(height: 1.h),
                        AppText(
                          "Qty.: ${controller.orderItem[index].quantity.toString()}",
                          fontSize: 13.sp,
                          color: const Color(0XFF44474d),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
