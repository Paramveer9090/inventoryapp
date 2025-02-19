import 'package:intl/intl.dart';
import 'package:true_leaf_inventory_app/app/modules/order_details/views/order_details_view.dart';

import '../../../widgets/all_import.dart';

class MyOrdersView extends GetView<MyOrdersController> {
  const MyOrdersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyOrdersController>(
      init: MyOrdersController(),
      assignId: true,
      builder: (controller) {
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
                        ...List.generate(controller.customerList.length, (index) {
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
                        controller.customer_id.value = await GetDataListResponseData!.id.toString();
                        controller.customerSearch(id: controller.customer_id.value);
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
                                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                                );
                                if (pickedDate != null) {
                                  controller.fromDateString.value = DateFormat('yyyy-MM-dd').format(pickedDate);
                                  if (controller.fromDateString.value != "" && controller.toDateString.value != "") {
                                    controller.dateFilter(startDate: DateTime.parse(controller.fromDateString.value), endDate: DateTime.parse(controller.toDateString.value));
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
                                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                                );
                                if (pickedDate != null) {
                                  controller.toDateString.value = DateFormat('yyyy-MM-dd').format(pickedDate);
                                  if (controller.fromDateString.value != "" && controller.toDateString.value != "") {
                                    controller.dateFilter(startDate: DateTime.parse(controller.fromDateString.value), endDate: DateTime.parse(controller.toDateString.value));
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
                                if (controller.isUnPaidSelected.value || controller.isOverDueSelected.value) {
                                  controller.isUnPaidSelected.value = false;
                                  controller.isOverDueSelected.value = false;
                                }
                                controller.isPaidSelected.value = !controller.isPaidSelected.value;

                                if (controller.isPaidSelected.value) {
                                  controller.paidSearch(color: Color(0xFF28a745));
                                } else {
                                  controller.myOrderList = controller.filterList;
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
                                if (controller.isPaidSelected.value || controller.isUnPaidSelected.value) {
                                  controller.isPaidSelected.value = false;
                                  controller.isUnPaidSelected.value = false;
                                }
                                controller.isOverDueSelected.value = !controller.isOverDueSelected.value;

                                if (controller.isOverDueSelected.value) {
                                  controller.paidSearch(color: Color(0xFFdc3545));
                                } else {
                                  controller.myOrderList = controller.filterList;
                                }
                                controller.update();
                              },
                              child: Container(
                                height: 5.h,
                                decoration: BoxDecoration(color: AppColors.lightRed),
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
                                if (controller.isPaidSelected.value || controller.isOverDueSelected.value) {
                                  controller.isPaidSelected.value = false;
                                  controller.isOverDueSelected.value = false;
                                }
                                controller.isUnPaidSelected.value = !controller.isUnPaidSelected.value;

                                if (controller.isUnPaidSelected.value) {
                                  controller.paidSearch(color: Color(0xFFffae12));
                                } else {
                                  controller.myOrderList = controller.filterList;
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
                              DataColumn(
                                  label: AppText(
                                'Action',
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                              )),
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
                                  'Customer',
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
                              ...controller.myOrderList.asMap().entries.map(
                                (orderReport) {
                                  DateTime currentDate;
                                  DateTime date1 = DateTime.parse(orderReport.value.dueDate.toString());
                                  currentDate = DateTime.now();

                                  for (int i = 0; i < controller.myOrderList.length; i++) {
                                    if (orderReport.value.payment!.paymentStatus == "1") {
                                      orderReport.value.statusTime = "Closed";
                                      orderReport.value.statusColor = AppColors.lightGreen;
                                    } else if (currentDate.isAfter(date1)) {
                                      // Calculate the difference in days between dateTime1 and dateTime2
                                      int differenceInDays = currentDate.difference(date1).inDays;
                                      orderReport.value.statusTime = "Overdue $differenceInDays days";
                                      orderReport.value.statusColor = AppColors.lightRed;
                                    } else {
                                      // Calculate the difference in days between dateTime1 and dateTime2
                                      int differenceInDays = int.parse(currentDate.difference(date1).inDays.toString().split("-").last);
                                      orderReport.value.statusTime = "Overdue $differenceInDays days";
                                      orderReport.value.statusColor = AppColors.lightYellow;
                                    }
                                  }

                                  return DataRow(
                                    color: MaterialStatePropertyAll(
                                      orderReport.value.statusColor,
                                    ),
                                    cells: [
                                      DataCell(
                                        CustomTableCellActionButtons(
                                          showDeleteButton: false,
                                          isWhite: true,
                                          showEditButton: (orderReport.value.status == "3") && (orderReport.value.payment!.paymentStatus == "0" && controller.loginData!.id == orderReport.value.salesManagerId) ? true : false,
                                          // showEditButton: orderReport.value.payment!.paymentStatus == "0" && controller.loginData!.id == orderReport.value.salesManagerId ? true : false,
                                          onView: () {
                                            controller.id.value = orderReport.value.id.toString();
                                            Get.find<HomeController>().isOrderDetails.value = true;
                                            Get.find<HomeController>().update();
                                            controller.update();
                                          },
                                          onEdit: () {
                                            controller.id.value = orderReport.value.id.toString();
                                            orderId = orderReport.value.id.toString();

                                            Get.find<HomeController>().isOrderDetails.value = true;
                                            Get.find<HomeController>().isOrderEdit.value = true;
                                            Get.find<HomeController>().isCustomerId.value = orderReport.value.customerId.toString();

                                            Get.find<HomeController>().update();
                                            controller.update();
                                          },
                                          onDelete: () {},
                                        ),
                                      ),
                                      DataCell(AppText(
                                        orderReport.value.orderDate!.split(" ").first,
                                        color: AppColors.whiteColor,
                                        fontSize: 11.sp,
                                      )),
                                      DataCell(AppText(
                                        orderReport.value.id.toString(),
                                        color: AppColors.whiteColor,
                                        fontSize: 11.sp,
                                      )),
                                      DataCell(AppText(
                                        orderReport.value.customer == null ? "" : orderReport.value.customer!.name.toString(),
                                        color: AppColors.whiteColor,
                                        fontSize: 11.sp,
                                      )),
                                      DataCell(AppText(
                                        orderReport.value.orderTotal.toString(),
                                        color: AppColors.whiteColor,
                                        fontSize: 11.sp,
                                      )),
                                      DataCell(AppText(
                                        orderReport.value.statusTime.toString(),
                                        color: AppColors.whiteColor,
                                        fontSize: 11.sp,
                                      )),
                                    ],
                                  );
                                },
                              ).toList()
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
