import 'package:intl/intl.dart';
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
                            color: Colors.grey.withOpacity(0.1),
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
                                    // PAID BUTTON
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.isUnPaidSelected.value = false;
                                          controller.isOverDueSelected.value = false;
                                          controller.isPaidSelected.value =
                                              !controller.isPaidSelected.value;
                                          if (controller.isPaidSelected.value) {
                                            controller.statusFilter('Paid');
                                          } else {
                                            controller.myOrderList = controller.filterList;
                                          }
                                          controller.update();
                                        },
                                        child: Container(
                                          height: 4.h,
                                          decoration: BoxDecoration(
                                            color: controller.isPaidSelected.value
                                                ? AppColors.lightGreen
                                                : Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: AppText(
                                              "Paid",
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
                                    // OVERDUE BUTTON
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.isPaidSelected.value = false;
                                          controller.isUnPaidSelected.value = false;
                                          controller.isOverDueSelected.value =
                                              !controller.isOverDueSelected.value;
                                          if (controller.isOverDueSelected.value) {
                                            controller.statusFilter('Overdue');
                                          } else {
                                            controller.myOrderList = controller.filterList;
                                          }
                                          controller.update();
                                        },
                                        child: Container(
                                          height: 4.h,
                                          decoration: BoxDecoration(
                                            color: controller.isOverDueSelected.value
                                                ? AppColors.lightRed
                                                : Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: AppText(
                                              "Overdue",
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
                                    // UNPAID BUTTON
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.isPaidSelected.value = false;
                                          controller.isOverDueSelected.value = false;
                                          controller.isUnPaidSelected.value =
                                              !controller.isUnPaidSelected.value;
                                          if (controller.isUnPaidSelected.value) {
                                            controller.statusFilter('Unpaid');
                                          } else {
                                            controller.myOrderList = controller.filterList;
                                          }
                                          controller.update();
                                        },
                                        child: Container(
                                          height: 4.h,
                                          decoration: BoxDecoration(
                                            color: controller.isUnPaidSelected.value
                                                ? AppColors.lightYellow
                                                : Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: AppText(
                                              "Unpaid",
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

                              final dateText = order.orderDate?.split(' ').first ?? '';
                              final orderIdText = order.id.toString();
                              final customerName = controller
                                      .customerMap[order.customerId]?.name ??
                                  'Unknown Customer';
                              final amountText = '\$${order.orderTotal?.toStringAsFixed(2) ?? '0.00'}';
                              
                              // Dynamic status color calculation
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
                              
                              if (order.payment?.paymentStatus == "1") {
                                // Paid orders
                                statusColor = AppColors.lightGreen;
                                statusText = "Paid";
                                statusIcon = Icons.check_circle;
                              } else if (currentDate.isAfter(dueDate)) {
                                // Overdue orders
                                statusColor = AppColors.lightRed;
                                int differenceInDays = currentDate.difference(dueDate).inDays;
                                statusText = "Overdue $differenceInDays days";
                                statusIcon = Icons.error;
                              } else {
                                // Unpaid but not overdue
                                statusColor = AppColors.lightYellow;
                                int differenceInDays = dueDate.difference(currentDate).inDays;
                                statusText = "Due in $differenceInDays days";
                                statusIcon = Icons.schedule;
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
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: AppColors.primaryColor.withOpacity(0.1),
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
                                                        Get.find<HomeController>().isOrderDetails.value = true;
                                                        Get.find<HomeController>().update();
                                                        controller.update();
                                                      },
                                                      tooltip: 'View Order',
                                                    ),
                                                  ),
                                                  if (canEdit) ...[
                                                    SizedBox(width: 1.w),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.blue.withOpacity(0.1),
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
                                                  color: statusColor.withOpacity(0.2),
                                                  borderRadius: BorderRadius.circular(20),
                                                  border: Border.all(
                                                    color: statusColor.withOpacity(0.3),
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

  Widget? _getActiveFiltersText(MyOrdersController controller) {
    List<String> activeFilters = [];
    
    if (controller.isPaidSelected.value) activeFilters.add("Paid");
    if (controller.isOverDueSelected.value) activeFilters.add("Overdue");
    if (controller.isUnPaidSelected.value) activeFilters.add("Unpaid");
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
}
