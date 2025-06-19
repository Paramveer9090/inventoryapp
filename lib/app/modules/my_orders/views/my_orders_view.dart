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
                      items: [
                        ...List.generate(controller.customerList.length,
                            (index) {
                          return Customers(
                            name: controller.customerList[index].name,
                            id: controller.customerList[index].id,
                          );
                        }),
                      ],
                      itemAsString: (Customers) => Customers.name.toString(),
                      label: AppStrings.selectCustomer,
                      validator: (value) => Validators.canNotBeEmpty(
                        value?.name,
                        message: 'Please Select Customer',
                      ),
                      onChanged: (GetDataListResponseData) async {
                        controller.customer_id.value =
                            await GetDataListResponseData!.id.toString();
                        controller.customerSearch(
                            id: controller.customer_id.value);
                        controller.update();
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
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (controller.isUnPaidSelected.value ||
                                    controller.isOverDueSelected.value) {
                                  controller.isUnPaidSelected.value = false;
                                  controller.isOverDueSelected.value = false;
                                }
                                controller.isPaidSelected.value =
                                    !controller.isPaidSelected.value;

                                if (controller.isPaidSelected.value) {
                                  controller.paidSearch(
                                      color: Color(0xFF28a745));
                                } else {
                                  controller.myOrderList =
                                      controller.filterList;
                                }
                                controller.update();
                              },
                              child: Container(
                                height: 5.h,
                                decoration: BoxDecoration(
                                  color: AppColors.lightGreen,
                                  borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(30),
                                  ),
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
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (controller.isPaidSelected.value ||
                                    controller.isUnPaidSelected.value) {
                                  controller.isPaidSelected.value = false;
                                  controller.isUnPaidSelected.value = false;
                                }
                                controller.isOverDueSelected.value =
                                    !controller.isOverDueSelected.value;

                                if (controller.isOverDueSelected.value) {
                                  controller.paidSearch(
                                      color: Color(0xFFdc3545));
                                } else {
                                  controller.myOrderList =
                                      controller.filterList;
                                }
                                controller.update();
                              },
                              child: Container(
                                height: 5.h,
                                decoration:
                                    BoxDecoration(color: AppColors.lightRed),
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
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (controller.isPaidSelected.value ||
                                    controller.isOverDueSelected.value) {
                                  controller.isPaidSelected.value = false;
                                  controller.isOverDueSelected.value = false;
                                }
                                controller.isUnPaidSelected.value =
                                    !controller.isUnPaidSelected.value;

                                if (controller.isUnPaidSelected.value) {
                                  controller.paidSearch(
                                      color: Color(0xFFffae12));
                                } else {
                                  controller.myOrderList =
                                      controller.filterList;
                                }
                                controller.update();
                              },
                              child: Container(
                                height: 5.h,
                                decoration: BoxDecoration(
                                  color: AppColors.lightYellow,
                                  borderRadius: BorderRadius.horizontal(
                                    right: Radius.circular(30),
                                  ),
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
                              // DataColumn(
                              //     label: AppText(
                              //   'Action',
                              //   color: const Color.fromARGB(255, 255, 255, 255),
                              //   fontWeight: FontWeight.w600,
                              //   fontSize: 12.sp,
                              // )),
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
                                final canEdit = order.status == '3' &&
                                    payStatus == '0' &&
                                    (controller.loginData?.id.toString() ==
                                        order.salesManagerId.toString());

                                final dateText =
                                    order.orderDate?.split(' ').first ?? '';
                                final orderIdText = order.id.toString();
                                final customerName = controller.customerList
                                        .firstWhere(
                                          (c) => c.id == order.customerId,
                                          orElse: () =>
                                              Customers(id: 0, name: ''),
                                        )
                                        .name ??
                                    '';
                                final amountText = order.orderTotal.toString();
                                final statusTime = order.statusTime ?? '';
                                final rowColor = order.statusColor;

                                return DataRow(
                                  color: MaterialStatePropertyAll(rowColor),
                                  cells: [
                                    // DataCell(
                                    //   CustomTableCellActionButtons(
                                    //     showDeleteButton: false,
                                    //     isWhite: true,
                                    //     showEditButton: canEdit,
                                    //     onView: () {
                                    //       controller.id.value = orderIdText;
                                    //       Get.find<HomeController>()
                                    //           .isOrderDetails
                                    //           .value = true;
                                    //       Get.find<HomeController>().update();
                                    //       controller.update();
                                    //     },
                                    //     onEdit: () {
                                    //       controller.id.value = orderIdText;
                                    //       orderId = orderIdText;
                                    //       final home =
                                    //           Get.find<HomeController>();
                                    //       home.isOrderDetails.value = true;
                                    //       home.isOrderEdit.value = true;
                                    //       home.isCustomerId.value =
                                    //           order.customerId.toString();
                                    //       home.update();
                                    //       controller.update();
                                    //     },
                                    //     onDelete: () {},
                                    //   ),
                                    // ),
                                    DataCell(AppText(customerName,
                                        color: const Color.fromARGB(
                                            128, 22, 179, 8),
                                        fontSize: 11.sp)),
                                    DataCell(AppText(dateText,
                                        color: const Color.fromARGB(
                                            128, 22, 179, 8),
                                        fontSize: 11.sp)),
                                    DataCell(AppText(orderIdText,
                                        color: const Color.fromARGB(
                                            128, 22, 179, 8),
                                        fontSize: 11.sp)),
                                    DataCell(AppText(amountText,
                                        color: const Color.fromARGB(
                                            128, 22, 179, 8),
                                        fontSize: 11.sp)),
                                    DataCell(AppText(statusTime,
                                        color: const Color.fromARGB(
                                            128, 22, 179, 8),
                                        fontSize: 11.sp)),
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
