import 'package:true_leaf_inventory_app/app/modules/driver_order/controllers/driver_order_controller.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

import '../controllers/driver_dashboard_controller.dart';

class DriverDashboardView extends GetView<DriverDashboardController> {
  const DriverDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DriverDashboardController>(
      assignId: true,
      init: DriverDashboardController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.greyLightColor,
          body: SafeArea(
            child: controller.noData.value != ""
                ? _buildEmptyState(controller.noData.value)
                : RefreshIndicator(
                    onRefresh: () async {
                      await controller.getOrderAPI(isLoading: false);
                    },
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.all(2.h),
                      children: [
                        // Header
                        _buildDriverHeader(controller),
                        SizedBox(height: 3.h),
                        
                        // Stats Cards
                        _buildDriverStatsSection(controller),
                        SizedBox(height: 3.h),
                        
                        // Orders Section
                        _buildDriverOrdersSection(controller),
                        SizedBox(height: 2.h),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: EdgeInsets.all(3.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_shipping_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 2.h),
          AppText(
            message,
            fontSize: 16.sp,
            color: AppColors.greyColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDriverHeader(DriverDashboardController controller) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: EdgeInsets.all(2.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [AppColors.tableColor, AppColors.tableColor.withValues(alpha: 0.8)],
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
              child: Icon(Icons.local_shipping, color: Colors.white, size: 24),
            ),
            SizedBox(width: 2.h),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    'Driver Dashboard',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  AppText(
                    'Delivery Management',
                    fontSize: 12.sp,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ],
              ),
            ),
            Icon(Icons.route_outlined, color: Colors.white, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverStatsSection(DriverDashboardController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.h),
          child: AppText(
            'Delivery Summary',
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
          ),
        ),
        SizedBox(height: 1.5.h),
        Row(
          children: [
            Expanded(
              child: _ModernDriverStatsCard(
                title: "Total Orders",
                count: "\$${controller.totalOrder.value}",
                icon: Icons.assignment_outlined,
                color: AppColors.tableColor,
                backgroundColor: AppColors.tableColor.withValues(alpha: 0.1),
              ),
            ),
            SizedBox(width: 1.h),
            Expanded(
              child: _ModernDriverStatsCard(
                title: "Delivered",
                count: "\$${controller.delivered.value}",
                icon: Icons.check_circle_outline,
                color: const Color(0xff4CAF50),
                backgroundColor: const Color(0xffE8F5E8),
              ),
            ),
            SizedBox(width: 1.h),
            Expanded(
              child: _ModernDriverStatsCard(
                title: "Pending",
                count: "\$${controller.pending.value}",
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

  Widget _buildDriverOrdersSection(DriverDashboardController controller) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.list_alt, size: 20, color: AppColors.primaryColor),
                SizedBox(width: 1.h),
                AppText(
                  'Delivery Orders',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: AppText(
                    '${controller.orderList.length} orders',
                    fontSize: 10.sp,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            if (controller.orderList.isEmpty)
              _buildEmptyOrdersState()
            else
              _buildDriverOrdersList(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyOrdersState() {
    return Container(
      padding: EdgeInsets.all(3.h),
      child: Column(
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 48,
            color: Colors.grey[400],
          ),
          SizedBox(height: 1.h),
          AppText(
            'No delivery orders',
            fontSize: 14.sp,
            color: Colors.grey[600]!,
          ),
          AppText(
            'Your delivery orders will appear here',
            fontSize: 12.sp,
            color: Colors.grey[500]!,
          ),
        ],
      ),
    );
  }

  Widget _buildDriverOrdersList(DriverDashboardController controller) {
    return Column(
      children: controller.orderList.map((order) {
        String statusText = order.status == "4"
            ? "Accepted"
            : order.status == "1"
                ? "Completed"
                : "Under Review";
                
        Color statusColor = order.status == "4"
            ? AppColors.lightYellow
            : order.status == "1"
                ? AppColors.lightGreen
                : AppColors.lightRed;

        return _DriverOrderCard(
          order: order,
          statusText: statusText,
          statusColor: statusColor,
          controller: controller,
        );
      }).toList(),
    );
  }
}

class _ModernDriverStatsCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color color;
  final Color backgroundColor;

  const _ModernDriverStatsCard({
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.all(1.5.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: backgroundColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            SizedBox(height: 1.h),
            AppText(
              count,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: color,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 0.5.h),
            AppText(
              title,
              fontSize: 10.sp,
              color: color.withValues(alpha: 0.8),
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _DriverOrderCard extends StatelessWidget {
  final dynamic order;
  final String statusText;
  final Color statusColor;
  final DriverDashboardController controller;

  const _DriverOrderCard({
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
          Get.put(DriverOrderController());
          Get.find<DriverOrderController>().id.value = order.id.toString();
          Get.find<HomeController>().isSelected.value = 1;
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
                    height: 50,
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
                            AppText(
                              'Order #${order.id}',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blackColor,
                            ),
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
                          order.customer?.companyName ?? order.customer?.name ?? 'Unknown Customer',
                          fontSize: 12.sp,
                          color: Colors.grey[600]!,
                          maxLines: 1,
                        ),
                        if (order.customer?.address != null) ...[
                          SizedBox(height: 0.3.h),
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 12, color: Colors.grey[500]),
                              SizedBox(width: 0.5.h),
                              Expanded(
                                child: AppText(
                                  order.customer!.address!,
                                  fontSize: 11.sp,
                                  color: Colors.grey[500]!,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ],
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
                        order.order_date ?? 'N/A',
                        fontSize: 11.sp,
                        color: Colors.grey[600]!,
                      ),
                    ],
                  ),
                  if (order.customer?.phoneNumber != null)
                    Row(
                      children: [
                        Icon(Icons.phone, size: 14, color: Colors.grey[500]),
                        SizedBox(width: 0.5.h),
                        AppText(
                          order.customer!.phoneNumber!,
                          fontSize: 11.sp,
                          color: Colors.grey[600]!,
                        ),
                      ],
                    ),
                ],
              ),
              if (order.delivery_note != null && order.delivery_note!.isNotEmpty) ...[
                SizedBox(height: 0.5.h),
                Container(
                  padding: EdgeInsets.all(1.h),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.note, size: 14, color: Colors.blue[600]),
                      SizedBox(width: 0.5.h),
                      Expanded(
                        child: AppText(
                          order.delivery_note!,
                          fontSize: 11.sp,
                          color: Colors.blue[600]!,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
