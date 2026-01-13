import 'package:true_leaf_inventory_app/app/modules/customer_details/controllers/customer_details_controller.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class PastOrdersSection extends StatelessWidget {
  final CustomerDetailsController controller;

  const PastOrdersSection({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  Icons.history,
                  size: 20,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(width: 8),
                AppText(
                  "Past Orders",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: AppText(
                    "${controller.myOrderList.length} orders",
                    fontSize: 12.sp,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ..._buildGroupedOrders(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildGroupedOrders(BuildContext context) {
    final groupedOrders = <String, List<dynamic>>{};

    for (var entry in controller.myOrderList.asMap().entries) {
      final order = entry.value;
      final currentDate = DateTime.now();
      final dueDate = DateTime.parse(order.dueDate.toString());

      String status;
      Color statusColor;

      if (order.payment!.paymentStatus == "1") {
        status = "Completed";
        statusColor = AppColors.lightGreen;
      } else if (currentDate.isAfter(dueDate)) {
        final overdueDays = currentDate.difference(dueDate).inDays;
        status = "Overdue";
        statusColor = AppColors.lightRed;
        order.statusTime = "Overdue $overdueDays days";
      } else {
        status = "Active";
        statusColor = AppColors.lightYellow;
        final daysLeft = dueDate.difference(currentDate).inDays;
        order.statusTime = "Due in $daysLeft days";
      }

      order.statusColor = statusColor;
      groupedOrders.putIfAbsent(status, () => []);
      groupedOrders[status]!.add(order);
    }

    final statusOrder = ["Active", "Overdue", "Completed"];
    final widgets = <Widget>[];

    for (final status in statusOrder) {
      final orders = groupedOrders[status];
      if (orders == null || orders.isEmpty) continue;

      final groupColor = status == "Active"
          ? AppColors.lightYellow
          : status == "Overdue"
              ? AppColors.lightRed
              : AppColors.lightGreen;
      final groupIcon = status == "Active"
          ? Icons.pending_actions
          : status == "Overdue"
              ? Icons.warning_amber
              : Icons.check_circle;

      widgets.add(
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            border: Border.all(color: groupColor.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              initiallyExpanded: status == "Active" || status == "Overdue",
              backgroundColor: Colors.transparent,
              collapsedBackgroundColor: Colors.transparent,
              title: Row(
                children: [
                  Icon(
                    groupIcon,
                    color: groupColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  AppText(
                    "$status Orders",
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: groupColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: AppText(
                      "${orders.length}",
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: groupColor,
                    ),
                  ),
                ],
              ),
              children: [
                ...orders.map((order) => _OrderRow(order: order, groupColor: groupColor)).toList(),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      );
    }

    return widgets;
  }
}

class _OrderRow extends StatelessWidget {
  final dynamic order;
  final Color groupColor;

  const _OrderRow({Key? key, required this.order, required this.groupColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  "#${order.payment!.orderNumber}",
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                ),
                AppText(
                  order.orderDate!.split(" ").first,
                  fontSize: 10.sp,
                  color: Colors.grey[600]!,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  "\$${order.orderTotal}",
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                ),
                AppText(
                  order.statusTime ?? "",
                  fontSize: 10.sp,
                  color: groupColor,
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  Get.put(MyOrdersController());
                  Get.find<MyOrdersController>().id.value = order.id.toString();
                  final home = Get.find<HomeController>();
                  home.isSelected.value = 2;
                  home.isOrderDetails.value = true;
                  home.update();
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    Icons.visibility,
                    size: 16,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              if ((order.status == "3") &&
                  (order.payment!.paymentStatus == "0" && Get.find<CustomerDetailsController>().loginData!.id == order.salesManagerId))
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: InkWell(
                    onTap: () {
                      Get.put(MyOrdersController());
                      Get.find<MyOrdersController>().id.value = order.id.toString();
                      final home = Get.find<HomeController>();
                      home.isSelected.value = 2;
                      home.isOrderDetails.value = true;
                      home.isOrderEdit.value = true;
                      home.update();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 16,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
