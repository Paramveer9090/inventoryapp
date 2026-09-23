import '../../..//widgets/all_import.dart';
import '../controllers/dashboard_controller.dart';
import 'order_card.dart';

class RecentOrdersCard extends StatelessWidget {
  final DashboardController controller;

  const RecentOrdersCard({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.history, size: 20, color: AppColors.primaryColor),
                    SizedBox(width: 1.h),
                    AppText(
                      'Recent Orders',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: AppText('Last 5', fontSize: 10.sp, color: AppColors.primaryColor),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            if (controller.myOrderList.isEmpty) _buildEmptyState() else _buildOrdersList(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(3.h),
      child: Column(
        children: [
          Icon(Icons.inbox_outlined, size: 48, color: Colors.grey[400]),
          SizedBox(height: 1.h),
          AppText('No recent orders', fontSize: 14.sp, color: Colors.grey[600]!),
          AppText('Your recent orders will appear here', fontSize: 12.sp, color: Colors.grey[500]!),
        ],
      ),
    );
  }

  Widget _buildOrdersList() {
    return Column(
      children: controller.myOrderList.take(5).map((order) {
        DateTime currentDate = DateTime.now();
        DateTime dueDate = DateTime.parse(order.dueDate.toString());
        String statusText;
        Color statusColor;

        if (order.payment!.paymentStatus == "1") {
          statusText = "Closed";
          statusColor = AppColors.lightGreen;
        } else if (currentDate.isAfter(dueDate)) {
          int overdueDays = currentDate.difference(dueDate).inDays;
          statusText = "Overdue $overdueDays days";
          statusColor = AppColors.lightRed;
        } else {
          int daysLeft = dueDate.difference(currentDate).inDays;
          statusText = "$daysLeft days left";
          statusColor = AppColors.lightYellow;
        }

        return OrderCard(order: order, statusText: statusText, statusColor: statusColor, controller: controller);
      }).toList(),
    );
  }
}
