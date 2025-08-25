import 'package:intl/intl.dart';
import 'package:true_leaf_inventory_app/app/modules/order_details/controllers/order_details_controller.dart';
import 'package:true_leaf_inventory_app/app/modules/order_details/views/order_details_view.dart';

import '../../../widgets/all_import.dart';

class MyOrdersView extends GetView<MyOrdersController> {
  const MyOrdersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyOrdersController());
    return GetBuilder<MyOrdersController>(
      assignId: true,
      builder: (ctrl) {
        if (ctrl.loginData == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Get.find<HomeController>().isOrderDetails.value
            ? OrderDetailsView(id: controller.id.value)
            : GestureDetector(
                onTap: () {
                  utils.hideKeyboard(context);
                },
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 1.8.h),
                  physics: BouncingScrollPhysics(),
                  children: [
                    SizedBox(height: 2.h),
                    
                    // Compact Search Bar
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.1),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: (value) {
                          controller.search(text: value);
                        },
                        decoration: InputDecoration(
                          hintText: 'Search orders...',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 13.sp,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey.shade500,
                            size: 20,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 1.5.h),
                    
                    // Expandable Filter Section
                    GetBuilder<MyOrdersController>(
                      builder: (ctrl) => ExpansionTile(
                        initiallyExpanded: false,
                        tilePadding: EdgeInsets.symmetric(horizontal: 12),
                        backgroundColor: Colors.white,
                        collapsedBackgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        collapsedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        leading: Icon(
                          Icons.filter_list,
                          color: AppColors.primaryColor,
                        ),
                        title: AppText(
                          "Filters",
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                        subtitle: _getActiveFiltersText(controller),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: [
                                // Customer Filter
                                CustomDropDownSearch<Customers>(
                                  items: controller.customerList,
                                  itemAsString: (customer) => customer.name ?? '',
                                  label: AppStrings.selectCustomer,
                                  validator: (value) => Validators.canNotBeEmpty(
                                    value?.name,
                                    message: 'Please Select Customer',
                                  ),
                                  onChanged: (selectedCustomer) async {
                                    if (selectedCustomer == null) {
                                      controller.clearCustomerFilter();
                                    } else if (selectedCustomer.id != null) {
                                      controller.customer_id.value =
                                          selectedCustomer.id!.toString();
                                      controller.customerSearch(
                                          id: controller.customer_id.value);
                                      controller.update();
                                    }
                                  },
                                ),
                                
                                SizedBox(height: 2.h),
                                
                                // Date Range
                                Row(
                                  children: [
                                    Expanded(
                                      child: KeyedSubtree(
                                        key: ValueKey(controller.fromDateString.value),
                                        child: CustomDatePicker(
                                          initialValue: controller.fromDateString.value,
                                          hint: 'From',
                                          onTap: () async {
                                            DateTime? pickedDate = await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(-1000),
                                              lastDate: DateTime(3000),
                                              initialEntryMode:
                                                  DatePickerEntryMode.calendarOnly,
                                            );
                                            if (pickedDate != null) {
                                              controller.fromDateString.value =
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(pickedDate);
                                              if (controller.fromDateString.value != "" &&
                                                  controller.toDateString.value != "") {
                                                controller.dateFilter(
                                                    startDate: DateTime.parse(
                                                        controller.fromDateString.value),
                                                    endDate: DateTime.parse(
                                                        controller.toDateString.value));
                                              }
                                            }
                                            controller.update();
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 1.h),
                                    Expanded(
                                      child: KeyedSubtree(
                                        key: ValueKey(controller.toDateString.value),
                                        child: CustomDatePicker(
                                          initialValue: controller.toDateString.value,
                                          hint: 'To',
                                          onTap: () async {
                                            DateTime? pickedDate = await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(-1000),
                                              lastDate: DateTime(3000),
                                              initialEntryMode:
                                                  DatePickerEntryMode.calendarOnly,
                                            );
                                            if (pickedDate != null) {
                                              controller.toDateString.value =
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(pickedDate);
                                              if (controller.fromDateString.value != "" &&
                                                  controller.toDateString.value != "") {
                                                controller.dateFilter(
                                                    startDate: DateTime.parse(
                                                        controller.fromDateString.value),
                                                    endDate: DateTime.parse(
                                                        controller.toDateString.value));
                                              }
                                            }
                                            controller.update();
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                
                                SizedBox(height: 2.h),
                                
                                // Status Filter Buttons - More Compact
                                Row(
                                  children: [
                                    // PENDING BUTTON
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.isUnPaidSelected.value = false;
                                          controller.isOverDueSelected.value = false;
                                          controller.isPaidSelected.value =
                                              !controller.isPaidSelected.value;
                                          if (controller.isPaidSelected.value) {
                                            controller.statusFilter('Pending');
                                          } else {
                                            controller.myOrderList = controller.filterList;
                                          }
                                          controller.update();
                                        },
                                        child: Container(
                                          height: 4.h,
                                          decoration: BoxDecoration(
                                            color: controller.isPaidSelected.value
                                                ? Colors.orange
                                                : Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: AppText(
                                              "Pending",
                                              fontWeight: FontWeight.w600,
                                              color: controller.isPaidSelected.value
                                                  ? AppColors.whiteColor
                                                  : Colors.grey.shade600,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 1.w),
                                    // READY BUTTON
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.isPaidSelected.value = false;
                                          controller.isUnPaidSelected.value = false;
                                          controller.isOverDueSelected.value =
                                              !controller.isOverDueSelected.value;
                                          if (controller.isOverDueSelected.value) {
                                            controller.statusFilter('Ready');
                                          } else {
                                            controller.myOrderList = controller.filterList;
                                          }
                                          controller.update();
                                        },
                                        child: Container(
                                          height: 4.h,
                                          decoration: BoxDecoration(
                                            color: controller.isOverDueSelected.value
                                                ? Colors.blue
                                                : Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: AppText(
                                              "Ready",
                                              fontWeight: FontWeight.w600,
                                              color: controller.isOverDueSelected.value
                                                  ? AppColors.whiteColor
                                                  : Colors.grey.shade600,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 1.w),
                                    // DELIVERED BUTTON
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.isPaidSelected.value = false;
                                          controller.isOverDueSelected.value = false;
                                          controller.isUnPaidSelected.value =
                                              !controller.isUnPaidSelected.value;
                                          if (controller.isUnPaidSelected.value) {
                                            controller.statusFilter('Delivered');
                                          } else {
                                            controller.myOrderList = controller.filterList;
                                          }
                                          controller.update();
                                        },
                                        child: Container(
                                          height: 4.h,
                                          decoration: BoxDecoration(
                                            color: controller.isUnPaidSelected.value
                                                ? AppColors.lightGreen
                                                : Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: AppText(
                                              "Delivered",
                                              fontWeight: FontWeight.w600,
                                              color: controller.isUnPaidSelected.value
                                                  ? AppColors.whiteColor
                                                  : Colors.grey.shade600,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                
                                SizedBox(height: 1.5.h),
                                
                                // Clear All Filters
                                TextButton.icon(
                                  onPressed: () {
                                    controller.clearAllFilters();
                                  },
                                  icon: Icon(Icons.clear_all, size: 16),
                                  label: Text(
                                    'Clear All Filters',
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 2.h),
                    controller.noData.value != ""
                        ? Container(
                            padding: EdgeInsets.all(32),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.inbox_outlined,
                                    size: 64,
                                    color: Colors.grey.shade400,
                                  ),
                                  SizedBox(height: 2.h),
                                  AppText(
                                    controller.noData.value,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade600,
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 1.h),
                                  AppText(
                                    "Try adjusting your filters or search terms",
                                    fontSize: 12.sp,
                                    color: Colors.grey.shade500,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: controller.myOrderList.length,
                            itemBuilder: (context, index) {
                              final order = controller.myOrderList[index];
                              
                              // Safe‐guard nested nulls:
                              final canEdit = (order.status == "3") &&
                                  (controller.loginData?.id == order.salesManagerId);
                              final canAccept = (order.status == "3") &&
                                  (controller.loginData?.roles?.first.title == "Admin" || 
                                   controller.loginData?.roles?.first.title == "Website Admin");
                              final canAssignDelivery = (order.status == "4" || order.status == "1");

                              final dateText = order.orderDate?.split(' ').first ?? '';
                              final orderIdText = order.id.toString();
                              final customerName = controller
                                      .customerMap[order.customerId]?.name ??
                                  'Unknown Customer';
                              final amountText = '\$${order.orderTotal?.toStringAsFixed(2) ?? '0.00'}';
                              
                              // Enhanced status logic based on backend controller
                              Color statusColor;
                              String statusText;
                              IconData statusIcon;
                              
                              DateTime currentDate = DateTime.now();
                              DateTime? dueDate;
                              
                              try {
                                dueDate = DateTime.parse(order.dueDate.toString());
                              } catch (e) {
                                dueDate = currentDate.add(Duration(days: 30)); // Default
                              }
                              
                              // Status mapping based on backend logic
                              switch (order.status) {
                                case "1":
                                  // Completed/Delivered
                                  statusColor = AppColors.lightGreen;
                                  statusText = "Delivered";
                                  statusIcon = Icons.check_circle;
                                  break;
                                case "3":
                                  // Pending approval
                                  statusColor = Colors.orange;
                                  statusText = "Pending Approval";
                                  statusIcon = Icons.pending;
                                  break;
                                case "4":
                                  // Accepted, ready for delivery
                                  statusColor = Colors.blue;
                                  statusText = "Ready for Delivery";
                                  statusIcon = Icons.local_shipping;
                                  break;
                                default:
                                  // Check payment status for other cases
                                  if (order.payment?.paymentStatus == "1") {
                                    statusColor = AppColors.lightGreen;
                                    statusText = "Paid";
                                    statusIcon = Icons.check_circle;
                                  } else if (currentDate.isAfter(dueDate)) {
                                    statusColor = AppColors.lightRed;
                                    int differenceInDays = currentDate.difference(dueDate).inDays;
                                    statusText = "Overdue $differenceInDays days";
                                    statusIcon = Icons.error;
                                  } else {
                                    statusColor = AppColors.lightYellow;
                                    int differenceInDays = dueDate.difference(currentDate).inDays;
                                    statusText = "Due in $differenceInDays days";
                                    statusIcon = Icons.schedule;
                                  }
                              }

                              return Container(
                                margin: EdgeInsets.only(bottom: 1.5.h),
                                child: Card(
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.white,
                                          Colors.grey.shade50,
                                        ],
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Header Row
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    AppText(
                                                      "Order #$orderIdText",
                                                      fontSize: 16.sp,
                                                      fontWeight: FontWeight.bold,
                                                      color: AppColors.primaryColor,
                                                    ),
                                                    SizedBox(height: 0.5.h),
                                                    AppText(
                                                      customerName,
                                                      fontSize: 14.sp,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.grey.shade700,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // Action Buttons
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  // View Button
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: AppColors.primaryColor.withValues(alpha: 0.1),
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: IconButton(
                                                      icon: Icon(
                                                        Icons.visibility,
                                                        color: AppColors.primaryColor,
                                                        size: 20,
                                                      ),
                                                      onPressed: () {
                                                        controller.id.value = orderIdText;
                                                        // Ensure OrderDetailsController is properly initialized
                                                        orderId = orderIdText;
                                                        var orderDetailsController = Get.put(OrderDetailsController(id: orderIdText));
                                                        orderDetailsController.refreshOrderDetails();
                                                        Get.find<HomeController>().isOrderDetails.value = true;
                                                        Get.find<HomeController>().update();
                                                        controller.update();
                                                      },
                                                      tooltip: 'View Order',
                                                    ),
                                                  ),
                                                  
                                                  // Edit Button (for pending orders by sales manager)
                                                  if (canEdit) ...[
                                                    SizedBox(width: 1.w),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.blue.withValues(alpha: 0.1),
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      child: IconButton(
                                                        icon: Icon(
                                                          Icons.edit,
                                                          color: Colors.blue,
                                                          size: 20,
                                                        ),
                                                        onPressed: () {
                                                          controller.id.value = orderIdText;
                                                          orderId = orderIdText;
                                                          final home = Get.find<HomeController>();
                                                          home.isOrderDetails.value = true;
                                                          home.isOrderEdit.value = true;
                                                          home.isCustomerId.value = order.customerId.toString();
                                                          home.update();
                                                          controller.update();
                                                        },
                                                        tooltip: 'Edit Order',
                                                      ),
                                                    ),
                                                  ],
                                                  
                                                  // Accept Button (for admins on pending orders)
                                                  if (canAccept) ...[
                                                    SizedBox(width: 1.w),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.green.withValues(alpha: 0.1),
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      child: IconButton(
                                                        icon: Icon(
                                                          Icons.check,
                                                          color: Colors.green,
                                                          size: 20,
                                                        ),
                                                        onPressed: () {
                                                          _showAcceptOrderDialog(context, controller, orderIdText);
                                                        },
                                                        tooltip: 'Accept Order',
                                                      ),
                                                    ),
                                                  ],
                                                  
                                                  // Download Invoice Button
                                                  if (order.status == "1" || order.status == "4") ...[
                                                    SizedBox(width: 1.w),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.purple.withValues(alpha: 0.1),
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      child: IconButton(
                                                        icon: Icon(
                                                          Icons.download,
                                                          color: Colors.purple,
                                                          size: 20,
                                                        ),
                                                        onPressed: () {
                                                          _downloadOrderSummary(orderIdText);
                                                        },
                                                        tooltip: 'Download Invoice',
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ],
                                          ),
                                          
                                          SizedBox(height: 1.5.h),
                                          
                                          // Order Details Row
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.calendar_today,
                                                          size: 16,
                                                          color: Colors.grey.shade600,
                                                        ),
                                                        SizedBox(width: 0.5.w),
                                                        AppText(
                                                          "Date: $dateText",
                                                          fontSize: 12.sp,
                                                          color: Colors.grey.shade600,
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 0.5.h),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.attach_money,
                                                          size: 16,
                                                          color: Colors.grey.shade600,
                                                        ),
                                                        SizedBox(width: 0.5.w),
                                                        AppText(
                                                          "Amount: $amountText",
                                                          fontSize: 12.sp,
                                                          fontWeight: FontWeight.w600,
                                                          color: AppColors.primaryColor,
                                                        ),
                                                      ],
                                                    ),
                                                    // Show delivery agent info if assigned
                                                    if (canAssignDelivery && order.deliveryAgentId != null) ...[
                                                      SizedBox(height: 0.5.h),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.local_shipping,
                                                            size: 16,
                                                            color: Colors.grey.shade600,
                                                          ),
                                                          SizedBox(width: 0.5.w),
                                                          Expanded(
                                                            child: AppText(
                                                              "Delivery Agent: ${_getDeliveryAgentName(order.deliveryAgentId)}",
                                                              fontSize: 11.sp,
                                                              color: Colors.grey.shade600,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                    // Show due date for pending payments
                                                    if (order.status != "1" && order.payment?.paymentStatus != "1") ...[
                                                      SizedBox(height: 0.5.h),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.schedule,
                                                            size: 16,
                                                            color: Colors.grey.shade600,
                                                          ),
                                                          SizedBox(width: 0.5.w),
                                                          AppText(
                                                            "Due: ${DateFormat('MMM dd, yyyy').format(dueDate)}",
                                                            fontSize: 11.sp,
                                                            color: Colors.grey.shade600,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ),
                                              
                                              // Status Badge
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 6,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: statusColor.withValues(alpha: 0.2),
                                                  borderRadius: BorderRadius.circular(20),
                                                  border: Border.all(
                                                    color: statusColor.withValues(alpha: 0.3),
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      statusIcon,
                                                      size: 14,
                                                      color: statusColor,
                                                    ),
                                                    SizedBox(width: 0.5.w),
                                                    AppText(
                                                      statusText,
                                                      fontSize: 11.sp,
                                                      fontWeight: FontWeight.w600,
                                                      color: statusColor,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                    SizedBox(height: 3.h),
                  ],
                ),
              );
      },
    );
  }

  String _getDeliveryAgentName(int? deliveryAgentId) {
    if (deliveryAgentId == null) return "Not Assigned";
    
    // This would ideally come from a delivery agents list in the controller
    // For now, return a placeholder - this should be enhanced to fetch from API
    return "Delivery Agent #$deliveryAgentId";
  }

  Widget? _getActiveFiltersText(MyOrdersController controller) {
    List<String> activeFilters = [];
    
    if (controller.isPaidSelected.value) activeFilters.add("Pending");
    if (controller.isOverDueSelected.value) activeFilters.add("Ready");
    if (controller.isUnPaidSelected.value) activeFilters.add("Delivered");
    if (controller.customer_id.value.isNotEmpty) activeFilters.add("Customer");
    if (controller.fromDateString.value.isNotEmpty || controller.toDateString.value.isNotEmpty) {
      activeFilters.add("Date Range");
    }
    
    if (activeFilters.isEmpty) {
      return AppText(
        "No filters applied",
        fontSize: 11.sp,
        color: Colors.grey.shade500,
      );
    }
    
    return AppText(
      "${activeFilters.length} filter${activeFilters.length > 1 ? 's' : ''} applied: ${activeFilters.join(', ')}",
      fontSize: 11.sp,
      color: AppColors.primaryColor,
    );
  }

  void _showAcceptOrderDialog(BuildContext context, MyOrdersController controller, String orderId) {
    Get.dialog(
      AlertDialog(
        title: AppText(
          "Accept Order",
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
        content: AppText(
          "Are you sure you want to accept order #$orderId?\n\nThis will change the status to 'Ready for Delivery' and allow delivery agent assignment.",
          fontSize: 13.sp,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: AppText(
              "Cancel",
              color: Colors.grey.shade600,
              fontSize: 13.sp,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _acceptOrder(controller, orderId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: AppText(
              "Accept",
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _acceptOrder(MyOrdersController controller, String orderId) async {
    try {
      // This would need to be implemented in the controller
      // For now, we'll show a placeholder
      Get.snackbar(
        "Order Accepted",
        "Order #$orderId has been accepted and is ready for delivery",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      
      // Refresh the orders list
      controller.getOrderReportAPI(isLoading: false);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to accept order: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void _downloadOrderSummary(String orderId) async {
    try {
      // This would integrate with the backend's order_summary endpoint
      Get.snackbar(
        "Download Started",
        "Invoice for order #$orderId is being prepared...",
        backgroundColor: AppColors.primaryColor,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      
      // TODO: Implement actual PDF download using the backend endpoint:
      // GET /api/v1/orders/order_summary/{id}
      
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to download invoice: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}
