import '../controllers/dashboard_controller.dart';
import 'package:true_leaf_inventory_app/app/modules/order_details/controllers/order_details_controller.dart';
import '../../..//widgets/all_import.dart';

class OrderCard extends StatelessWidget {
  final Orders order;
  final String statusText;
  final Color statusColor;
  final DashboardController controller;

  const OrderCard({
    Key? key,
    required this.order,
    required this.statusText,
    required this.statusColor,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.only(bottom: 1.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Get.put(MyOrdersController());
          Get.find<MyOrdersController>().id.value = order.id.toString();
          orderId = order.id.toString();
          var orderDetailsController = Get.put(OrderDetailsController(id: order.id.toString()));
          orderDetailsController.refreshOrderDetails();
          Get.find<HomeController>().isOrderDetails.value = true;
          Get.find<HomeController>().update();
          controller.update();
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(1.5.h),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 40,
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(width: 1.5.h),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: AppText(
                                order.customer?.name ?? 'Unknown Customer',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.blackColor,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 0.5.h),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: AppText(
                                statusText,
                                fontSize: 10.sp,
                                color: statusColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 0.5.h),
                        AppText(
                          'Order #${order.payment?.orderNumber ?? 'N/A'}',
                          fontSize: 12.sp,
                          color: Colors.grey[600]!,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: Colors.grey[500]),
                      SizedBox(width: 0.5.h),
                      AppText(
                        order.orderDate?.split(" ").first ?? 'N/A',
                        fontSize: 11.sp,
                        color: Colors.grey[600]!,
                      ),
                    ],
                  ),
                  AppText(
                    '\$${order.orderTotal ?? '0.00'}',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
