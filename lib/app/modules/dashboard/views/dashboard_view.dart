import 'package:true_leaf_inventory_app/app/modules/order_details/controllers/order_details_controller.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';
import 'package:true_leaf_inventory_app/app/widgets/app_button.dart';

import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      assignId: true,
      init: DashboardController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.greyLightColor,
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await controller.getOrderAPI(isLoading: false);
              },
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(2.h),
                children: [
                  // Header
                  _buildHeader(controller),
                  SizedBox(height: 3.h),

                  // Stats Cards
                  _buildStatsSection(controller),
                  SizedBox(height: 3.h),

                  // Recent Orders Section
                  _buildRecentOrdersSection(controller),
                  SizedBox(height: 2.h),

                  // Quick Action
                  _buildQuickActionSection(),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(DashboardController controller) {
    final userName = controller.loginData?.name ?? 'User';
    final userRole = controller.loginData?.roles?.isNotEmpty == true
        ? controller.loginData!.roles!.first.title
        : 'User';

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: EdgeInsets.all(2.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [
              AppColors.primaryColor,
              AppColors.primaryColor.withValues(alpha: 0.8)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.dashboard, color: Colors.white, size: 24),
            ),
            SizedBox(width: 2.h),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    'Welcome back,',
                    fontSize: 12.sp,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  AppText(
                    userName,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  AppText(
                    userRole ?? 'User',
                    fontSize: 11.sp,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ],
              ),
            ),
            Icon(Icons.notifications_outlined, color: Colors.white, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(DashboardController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.h),
          child: AppText(
            'Order Summary',
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
          ),
        ),
        SizedBox(height: 1.5.h),
        Row(
          children: [
            Expanded(
              child: _ModernStatsCard(
                title: "Accepted Orders",
                count: controller.isAccepted.value,
                icon: Icons.check_circle_outline,
                color: const Color(0xff4CAF50),
                backgroundColor: const Color(0xffE8F5E8),
              ),
            ),
            SizedBox(width: 2.h),
            Expanded(
              child: _ModernStatsCard(
                title: "Under Review",
                count: controller.isReview.value,
                icon: Icons.schedule_outlined,
                color: const Color(0xffFF9800),
                backgroundColor: const Color(0xffFFF3E0),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentOrdersSection(DashboardController controller) {
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
                    Icon(Icons.history,
                        size: 20, color: AppColors.primaryColor),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: AppText(
                    'Last 5',
                    fontSize: 10.sp,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            if (controller.myOrderList.isEmpty)
              _buildEmptyState()
            else
              _buildOrdersList(controller),
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
          Icon(
            Icons.inbox_outlined,
            size: 48,
            color: Colors.grey[400],
          ),
          SizedBox(height: 1.h),
          AppText(
            'No recent orders',
            fontSize: 14.sp,
            color: Colors.grey[600]!,
          ),
          AppText(
            'Your recent orders will appear here',
            fontSize: 12.sp,
            color: Colors.grey[500]!,
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(DashboardController controller) {
    return Column(
      children: controller.myOrderList.take(5).map((order) {
        // Status logic
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

        return _OrderCard(
          order: order,
          statusText: statusText,
          statusColor: statusColor,
          controller: controller,
        );
      }).toList(),
    );
  }

  Widget _buildQuickActionSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: EdgeInsets.all(2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.flash_on, size: 20, color: AppColors.primaryColor),
                SizedBox(width: 1.h),
                AppText(
                  'Quick Actions',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                ),
              ],
            ),
            SizedBox(height: 2.h),
            AppButton(
              title: "View All Orders",
              isIcon: true,
              icon: Icons.list_alt,
              onTap: () {
                Get.find<HomeController>().isSelected.value = 2;
                Get.find<HomeController>().update();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ModernStatsCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color color;
  final Color backgroundColor;

  const _ModernStatsCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: EdgeInsets.all(2.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: backgroundColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                Icon(Icons.trending_up,
                    color: color.withValues(alpha: 0.7), size: 16),
              ],
            ),
            SizedBox(height: 1.5.h),
            AppText(
              count,
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
            SizedBox(height: 0.5.h),
            AppText(
              title,
              fontSize: 12.sp,
              color: color.withValues(alpha: 0.8),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Orders order;
  final String statusText;
  final Color statusColor;
  final DashboardController controller;

  const _OrderCard({
    required this.order,
    required this.statusText,
    required this.statusColor,
    required this.controller,
  });

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
          // Set the global orderId for OrderDetailsController
          orderId = order.id.toString();
          // Also initialize OrderDetailsController with the correct ID
          var orderDetailsController =
              Get.put(OrderDetailsController(id: order.id.toString()));
          // Force refresh to ensure data is loaded
          orderDetailsController.refreshOrderDetails();
          // Don't change the selected tab when opening order details from dashboard
          // Get.find<HomeController>().isSelected.value = 2;
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
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
                      Icon(Icons.calendar_today,
                          size: 14, color: Colors.grey[500]),
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
