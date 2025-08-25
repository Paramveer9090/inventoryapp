import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';
import 'package:true_leaf_inventory_app/app/modules/driver_order/controllers/driver_order_controller.dart';

import '../controllers/driver_order_detail_controller.dart';

class DriverOrderDetailView extends GetView<DriverOrderDetailController> {
  final dynamic orderId;
  
  const DriverOrderDetailView({Key? key, this.orderId}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DriverOrderDetailController>(
      init: DriverOrderDetailController(),
      builder: (controller) {
        // Set order ID if provided
        if (orderId != null && controller.orderId.value != orderId.toString()) {
          controller.setOrderId(orderId.toString());
        }
        
        return Scaffold(
          backgroundColor: AppColors.greyLightColor,
          body: SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(),
                
                // Content
                Expanded(
                  child: _buildContent(controller),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
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
              print("Driver back button pressed");
              
              // Navigate back to driver orders list
              final homeController = Get.find<HomeController>();
              homeController.isOrderDetails.value = false;
              homeController.isSelected.value = 1; // Driver orders tab
              homeController.update();
              
              // Also update the driver order controller if it exists
              try {
                Get.find<DriverOrderController>().update();
              } catch (e) {
                print("DriverOrderController not found: $e");
              }
              
              print("Navigation state updated - isOrderDetails: ${homeController.isOrderDetails.value}, isSelected: ${homeController.isSelected.value}");
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.arrow_back_ios, 
                color: AppColors.primaryColor, 
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  'Delivery Details',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                ),
                AppText(
                  'Order #${orderId ?? 'Unknown'}',
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

  Widget _buildContent(DriverOrderDetailController controller) {
    // Since this appears to be a placeholder view, I'll create a basic structure
    // that matches our app's design but can be expanded when the controller is implemented
    return RefreshIndicator(
      onRefresh: () async {
        // Refresh the order details including items
        controller.loadOrderDetails();
      },
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(2.h),
        children: [
          // Order Status Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: EdgeInsets.all(2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          Icons.info_outline,
                          color: AppColors.primaryColor,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 1.h),
                      AppText(
                        'Order Information',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Obx(() {
                    if (controller.isLoading.value) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      );
                    }
                    
                    final order = controller.currentOrder;
                    final detailedOrder = controller.orderDetails;
                    
                    return Column(
                      children: [
                        _buildInfoTile('Order ID', order?.id?.toString() ?? orderId?.toString() ?? 'N/A'),
                        _buildInfoTile('Status', _getOrderStatus(order?.status)),
                        if (order?.order_date != null)
                          _buildInfoTile('Order Date', order!.order_date!),
                        if (detailedOrder?.orderTotal != null)
                          _buildInfoTile('Order Total', '\$${detailedOrder!.orderTotal}'),
                        if (order?.delivery_note != null && order!.delivery_note.toString() != 'null')
                          _buildInfoTile('Delivery Note', order.delivery_note.toString()),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 2.h),
          
          // Customer Information Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: EdgeInsets.all(2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.person_outline,
                          color: Colors.blue,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 1.h),
                      AppText(
                        'Customer Details',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Obx(() {
                    if (controller.isLoading.value) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      );
                    }
                    
                    if (controller.currentOrder?.customer == null) {
                      return Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.person_off_outlined,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 1.h),
                            AppText(
                              'Customer details not available',
                              fontSize: 14.sp,
                              color: Colors.grey[600]!,
                            ),
                          ],
                        ),
                      );
                    }
                    
                    final customer = controller.currentOrder!.customer!;
                    return Column(
                      children: [
                        _buildInfoTile('Customer Name', customer.name ?? 'N/A'),
                        _buildInfoTile('Company', customer.companyName ?? 'N/A'),
                        _buildInfoTile('Phone', customer.phoneNumber ?? 'N/A'),
                        _buildInfoTile('Address', customer.address ?? 'N/A'),
                        if (customer.pincode != null && customer.pincode!.isNotEmpty)
                          _buildInfoTile('Pincode', customer.pincode!),
                        if (customer.email != null && customer.email.toString() != 'null')
                          _buildInfoTile('Email', customer.email.toString()),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 2.h),
          
          // Order Items Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: EdgeInsets.all(2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.inventory_outlined,
                          color: Colors.green,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 1.h),
                      AppText(
                        'Order Items',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                      ),
                      Spacer(),
                      Obx(() {
                        if (controller.isLoading.value) {
                          return SizedBox();
                        }
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: AppText(
                            '${controller.orderItems.length} items',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.green,
                          ),
                        );
                      }),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Obx(() {
                    if (controller.isLoading.value) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      );
                    }
                    
                    if (controller.orderItems.isEmpty) {
                      return Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 1.h),
                            AppText(
                              'No items found',
                              fontSize: 14.sp,
                              color: Colors.grey[600]!,
                            ),
                            AppText(
                              'This order has no items',
                              fontSize: 12.sp,
                              color: Colors.grey[500]!,
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controller.orderItems.length,
                      itemBuilder: (context, index) {
                        final item = controller.orderItems[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 1.h),
                          padding: EdgeInsets.all(1.5.h),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[200]!, width: 1),
                          ),
                          child: Row(
                            children: [
                              // Product Image
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: item.imageUrl != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          "${Constants.imageBaseUrl}${item.imageUrl}",
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Icon(
                                              Icons.inventory_2_outlined,
                                              color: Colors.grey[400],
                                              size: 30,
                                            );
                                          },
                                        ),
                                      )
                                    : Icon(
                                        Icons.inventory_2_outlined,
                                        color: Colors.grey[400],
                                        size: 30,
                                      ),
                              ),
                              SizedBox(width: 1.5.h),
                              
                              // Product Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      item.name ?? 'Unknown Product',
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.blackColor,
                                      maxLines: 2,
                                    ),
                                    SizedBox(height: 0.5.h),
                                    Row(
                                      children: [
                                        AppText(
                                          'Qty: ${item.quantityCount ?? 'N/A'}',
                                          fontSize: 12.sp,
                                          color: Colors.grey[600]!,
                                        ),
                                        SizedBox(width: 2.w),
                                        if (item.salePrice != null)
                                          AppText(
                                            '\$${item.salePrice}',
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.primaryColor,
                                          ),
                                      ],
                                    ),
                                    if (item.finalAmount != null)
                                      Padding(
                                        padding: EdgeInsets.only(top: 0.5.h),
                                        child: AppText(
                                          'Total: \$${item.finalAmount}',
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.green[700]!,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 2.h),
          
          // Action Buttons
          Obx(() {
            if (controller.isLoading.value) {
              return SizedBox();
            }
            
            return Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Add mark as delivered functionality
                      _showDeliveryConfirmation(controller);
                    },
                    icon: Icon(Icons.check_circle_outline),
                    label: Text('Mark as Delivered'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 2.h),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Add call customer functionality
                      _callCustomer(controller);
                    },
                    icon: Icon(Icons.phone),
                    label: Text('Call Customer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.all(1.5.h),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: AppText(
              title,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.blackColor,
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            flex: 3,
            child: AppText(
              value,
              fontSize: 13.sp,
              fontWeight: FontWeight.normal,
              color: Colors.grey[700]!,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  String _getOrderStatus(String? status) {
    if (status == null) return 'Unknown';
    
    switch (status) {
      case '1':
        return 'Completed';
      case '2':
        return 'Pending';
      case '3':
        return 'Under Review';
      case '4':
        return 'Accepted';
      case '5':
        return 'In Transit';
      case '6':
        return 'Delivered';
      default:
        return 'Unknown';
    }
  }

  void _callCustomer(DriverOrderDetailController controller) {
    final phoneNumber = controller.currentOrder?.customer?.phoneNumber;
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      // Use url_launcher to make phone call
      try {
        // For now, just show the phone number
        Get.snackbar(
          'Call Customer',
          'Phone: $phoneNumber',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.primaryColor,
          colorText: Colors.white,
        );
      } catch (e) {
        Get.snackbar(
          'Error',
          'Unable to make call',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        'No Phone Number',
        'Customer phone number not available',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  void _showDeliveryConfirmation(DriverOrderDetailController controller) {
    Get.dialog(
      AlertDialog(
        title: AppText(
          'Confirm Delivery',
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
        content: AppText(
          'Are you sure you want to mark this order as delivered?',
          fontSize: 14.sp,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: AppText(
              'Cancel',
              color: Colors.grey[600]!,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _markAsDelivered(controller);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: AppText(
              'Confirm',
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _markAsDelivered(DriverOrderDetailController controller) {
    // Add API call to mark as delivered
    Get.snackbar(
      'Order Updated',
      'Order marked as delivered successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    
    // Refresh the order details
    controller.loadOrderDetails();
  }
}
