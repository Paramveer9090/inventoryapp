import 'package:true_leaf_inventory_app/app/modules/driver_order_detail/views/driver_order_detail_view.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

import '../controllers/driver_order_controller.dart';

class DriverOrderView extends GetView<DriverOrderController> {
  const DriverOrderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DriverOrderController>(
      assignId: true,
      init: DriverOrderController(),
      builder: (controller) {
        return Get.find<HomeController>().isOrderDetails.value
            ? DriverOrderDetailView(orderId: controller.id.value)
            : Scaffold(
                backgroundColor: AppColors.greyLightColor,
                body: SafeArea(
                  child: Column(
                    children: [
                      // Header
                      _buildDriverOrderHeader(),
                      SizedBox(height: 1.h),
                      
                      // Search Bar
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.h),
                        child: _buildSearchSection(controller),
                      ),
                      SizedBox(height: 2.h),
                      
                      // Orders List
                      Expanded(
                        child: _buildOrdersList(controller),
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }

  Widget _buildDriverOrderHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Get.find<HomeController>().isSelected.value = 0;
              Get.find<HomeController>().update();
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.arrow_back_ios, color: AppColors.primaryColor, size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  'Delivery Orders',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                ),
                AppText(
                  'Manage your delivery orders',
                  fontSize: 12.sp,
                  color: Colors.grey[600]!,
                ),
              ],
            ),
          ),
          Icon(Icons.local_shipping, color: AppColors.primaryColor, size: 24),
        ],
      ),
    );
  }

  Widget _buildSearchSection(DriverOrderController controller) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 1.5.h, vertical: 0.5.h),
        child: CustomSearchBar(
          hint: 'Search orders, customers, addresses...',
          onChanged: (value) {
            controller.search(text: value);
            controller.update();
          },
        ),
      ),
    );
  }

  Widget _buildOrdersList(DriverOrderController controller) {
    if (controller.noData.value.isNotEmpty) {
      return _buildEmptyState(controller.noData.value);
    }

    return RefreshIndicator(
      onRefresh: () async {
        await controller.getOrderAPI(isLoading: false);
      },
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 2.h),
        itemCount: controller.orderList.length,
        itemBuilder: (context, index) {
          final order = controller.orderList[index];
          return _DriverOrderListCard(
            order: order,
            controller: controller,
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: EdgeInsets.all(3.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
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
          AppText(
            'Try adjusting your search terms',
            fontSize: 12.sp,
            color: Colors.grey[500]!,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _DriverOrderListCard extends StatelessWidget {
  final dynamic order;
  final DriverOrderController controller;

  const _DriverOrderListCard({
    required this.order,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
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

    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 1.5.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          controller.id.value = order.id.toString();
          Get.find<HomeController>().isOrderDetails.value = true;
          Get.find<HomeController>().update();
          controller.update();
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(1.5.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.local_shipping,
                          color: AppColors.primaryColor,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 1.h),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            'Order #${order.id}',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor,
                          ),
                          AppText(
                            order.order_date ?? 'N/A',
                            fontSize: 11.sp,
                            color: Colors.grey[600]!,
                          ),
                        ],
                      ),
                    ],
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
              
              SizedBox(height: 1.5.h),
              
              // Customer Info
              if (order.customer != null) ...[
                _InfoTile(
                  icon: Icons.business,
                  title: 'Company',
                  value: order.customer!.companyName ?? 'N/A',
                ),
                SizedBox(height: 0.8.h),
                _InfoTile(
                  icon: Icons.person,
                  title: 'Contact',
                  value: order.customer!.contactName ?? order.customer!.name ?? 'N/A',
                ),
                SizedBox(height: 0.8.h),
                _InfoTile(
                  icon: Icons.location_on,
                  title: 'Address',
                  value: order.customer!.address ?? 'N/A',
                  maxLines: 2,
                ),
                SizedBox(height: 0.8.h),
                Row(
                  children: [
                    Expanded(
                      child: _InfoTile(
                        icon: Icons.phone,
                        title: 'Phone',
                        value: order.customer!.phoneNumber ?? 'N/A',
                      ),
                    ),
                    SizedBox(width: 2.h),
                    Expanded(
                      child: _InfoTile(
                        icon: Icons.location_city,
                        title: 'Postal',
                        value: order.customer!.pincode ?? 'N/A',
                      ),
                    ),
                  ],
                ),
              ],
              
              // Delivery Note
              if (order.delivery_note != null && order.delivery_note!.isNotEmpty) ...[
                SizedBox(height: 1.h),
                Container(
                  padding: EdgeInsets.all(1.h),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.note, size: 16, color: Colors.blue[600]),
                      SizedBox(width: 1.h),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              'Delivery Note',
                              fontSize: 11.sp,
                              color: Colors.blue[600]!,
                              fontWeight: FontWeight.w500,
                            ),
                            AppText(
                              order.delivery_note!,
                              fontSize: 12.sp,
                              color: Colors.blue[700]!,
                              maxLines: 2,
                            ),
                          ],
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

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final int maxLines;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[500]),
        SizedBox(width: 1.h),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                title,
                fontSize: 10.sp,
                color: Colors.grey[500]!,
                fontWeight: FontWeight.w500,
              ),
              AppText(
                value,
                fontSize: 12.sp,
                color: AppColors.blackColor,
                maxLines: maxLines,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
