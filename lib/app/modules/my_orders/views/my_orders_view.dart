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
                    SizedBox(height: 3.h),
                    CustomDropDownSearch<Customers>(
                      items: controller.customerList,
                      itemAsString: (customer) => customer.name ?? '',
                      label: AppStrings.selectCustomer,
                      // Add clear button

                      validator: (value) => Validators.canNotBeEmpty(
                        value?.name,
                        message: 'Please Select Customer',
                      ),
                      onChanged: (selectedCustomer) async {
                        if (selectedCustomer == null) {
                          // Clear customer filter when dropdown is cleared
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
                    Container(
                      child: Row(
                        children: [
                          // PAID BUTTON
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                // Reset other filters
                                controller.isUnPaidSelected.value = false;
                                controller.isOverDueSelected.value = false;

                                // Toggle paid filter
                                controller.isPaidSelected.value =
                                    !controller.isPaidSelected.value;

                                if (controller.isPaidSelected.value) {
                                  // Filter for PAID orders
                                  controller.statusFilter('Paid');
                                } else {
                                  // Reset to show all orders
                                  controller.myOrderList =
                                      controller.filterList;
                                }
                                controller.update();
                              },
                              child: Container(
                                height: 5.h,
                                decoration: BoxDecoration(
                                  color: controller.isPaidSelected.value
                                      ? AppColors.lightGreen.withValues(alpha: 0.8)
                                      : AppColors.lightGreen,
                                  borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(30),
                                  ),
                                  border: controller.isPaidSelected.value
                                      ? Border.all(
                                          color: Colors.white, width: 2)
                                      : null,
                                ),
                                child: Center(
                                  child: AppText(
                                    "Paid",
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.whiteColor,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 0.2.h),

                          // OVERDUE BUTTON
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                // Reset other filters
                                controller.isPaidSelected.value = false;
                                controller.isUnPaidSelected.value = false;

                                // Toggle overdue filter
                                controller.isOverDueSelected.value =
                                    !controller.isOverDueSelected.value;

                                if (controller.isOverDueSelected.value) {
                                  // Filter for OVERDUE orders
                                  controller.statusFilter('Overdue');
                                } else {
                                  // Reset to show all orders
                                  controller.myOrderList =
                                      controller.filterList;
                                }
                                controller.update();
                              },
                              child: Container(
                                height: 5.h,
                                decoration: BoxDecoration(
                                  color: controller.isOverDueSelected.value
                                      ? AppColors.lightRed.withValues(alpha: 0.8)
                                      : AppColors.lightRed,
                                  border: controller.isOverDueSelected.value
                                      ? Border.all(
                                          color: Colors.white, width: 2)
                                      : null,
                                ),
                                child: Center(
                                  child: AppText(
                                    "Overdue",
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.whiteColor,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 0.2.h),

                          // UNPAID BUTTON
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                // Reset other filters
                                controller.isPaidSelected.value = false;
                                controller.isOverDueSelected.value = false;

                                // Toggle unpaid filter
                                controller.isUnPaidSelected.value =
                                    !controller.isUnPaidSelected.value;

                                if (controller.isUnPaidSelected.value) {
                                  // Filter for UNPAID orders
                                  controller.statusFilter('Unpaid');
                                } else {
                                  // Reset to show all orders
                                  controller.myOrderList =
                                      controller.filterList;
                                }
                                controller.update();
                              },
                              child: Container(
                                height: 5.h,
                                decoration: BoxDecoration(
                                  color: controller.isUnPaidSelected.value
                                      ? AppColors.lightYellow.withValues(
                                          alpha: 0.8,
                                        )
                                      : AppColors.lightYellow,
                                  borderRadius: BorderRadius.horizontal(
                                    right: Radius.circular(30),
                                  ),
                                  border: controller.isUnPaidSelected.value
                                      ? Border.all(
                                          color: Colors.white, width: 2)
                                      : null,
                                ),
                                child: Center(
                                  child: AppText(
                                    "Unpaid",
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.whiteColor,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            controller.clearAllFilters();
                          },
                          icon: Icon(Icons.clear_all, size: 16),
                          label: Text('Clear All Filters'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[600],
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    controller.noData.value != ""
                        ? Padding(
                            padding: EdgeInsets.all(18.0),
                            child: Center(
                                child: AppText(
                              controller.noData.value,
                              fontSize: 13.sp,
                              color: AppColors.greyColor,
                            )),
                          )
                        : CustomTable(
                            dataLength: controller.myOrderList.length,
                            margin: EdgeInsets.zero,
                            columns: [
                              DataColumn(
                                  label: AppText(
                                'Action',
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                              )),
                              DataColumn(
                                label: AppText(
                                  'Customer',
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp,
                                ),
                              ),
                              DataColumn(
                                label: AppText(
                                  'Order Date',
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.whiteColor,
                                  fontSize: 12.sp,
                                ),
                              ),
                              DataColumn(
                                label: AppText(
                                  'No.',
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp,
                                ),
                              ),
                              DataColumn(
                                label: AppText(
                                  'Amount',
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp,
                                ),
                              ),
                              DataColumn(
                                label: AppText(
                                  'Status',
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                            rows: [
                              ...controller.myOrderList
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                final order = entry.value;

                                // Safe‐guard nested nulls:
                                final payStatus =
                                    order.payment?.paymentStatus ?? '';
                                final canEdit = (order.status == "3") &&
                                    (controller.loginData?.id == order.salesManagerId);

                                final dateText =
                                    order.orderDate?.split(' ').first ?? '';
                                final orderIdText = order.id.toString();
                                final customerName = controller
                                        .customerMap[order.customerId]?.name ??
                                    '';
                                final amountText = order.orderTotal.toString();
                                
                                // Dynamic row color calculation (same as Dashboard)
                                Color? rowColor;
                                DateTime currentDate = DateTime.now();
                                DateTime dueDate = DateTime.parse(order.dueDate.toString());
                                
                                if (order.payment?.paymentStatus == "1") {
                                  // Paid orders - Green
                                  rowColor = AppColors.lightGreen;
                                } else if (currentDate.isAfter(dueDate)) {
                                  // Overdue orders - Red  
                                  rowColor = AppColors.lightRed;
                                } else {
                                  // Unpaid but not overdue - Yellow
                                  rowColor = AppColors.lightYellow;
                                }

                                // Dynamic status text calculation (same as Dashboard)
                                String statusTime;
                                if (order.payment?.paymentStatus == "1") {
                                  statusTime = "Closed";
                                } else if (currentDate.isAfter(dueDate)) {
                                  int differenceInDays = currentDate.difference(dueDate).inDays;
                                  statusTime = "Overdue $differenceInDays days";
                                } else {
                                  int differenceInDays = dueDate.difference(currentDate).inDays;
                                  statusTime = "Due in $differenceInDays days";
                                }

                                return DataRow(
                                  color: WidgetStatePropertyAll(rowColor),
                                  cells: [
                                    DataCell(
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.visibility,
                                              color: AppColors.whiteColor, // White icon
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
                                          if (canEdit)
                                            IconButton(
                                              icon: Icon(
                                                Icons.edit,
                                                color: AppColors.whiteColor, // White icon
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
                                        ],
                                      ),
                                    ),
                                    // All text cells with white color
                                    DataCell(Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8),
                                      child: AppText(customerName, fontSize: 11.sp, color: AppColors.whiteColor),
                                    )),
                                    DataCell(Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8),
                                      child: AppText(dateText, fontSize: 11.sp, color: AppColors.whiteColor),
                                    )),
                                    DataCell(Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8),
                                      child: AppText(orderIdText, fontSize: 11.sp, color: AppColors.whiteColor),
                                    )),
                                    DataCell(Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8),
                                      child: AppText(amountText, fontSize: 11.sp, color: AppColors.whiteColor),
                                    )),
                                    DataCell(
                                      AppText(
                                        statusTime,
                                        color: AppColors.whiteColor, // White status text
                                        fontSize: 11.sp,
                                      ),
                                    ),
                                  ],
                                );
                              }).toList()
                            ],
                          ),
                    SizedBox(height: 3.h),
                  ],
                ),
              );
      },
    );
  }
}
