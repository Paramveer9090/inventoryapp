import 'package:true_leaf_inventory_app/app/modules/customer_details/controllers/customer_details_controller.dart';
import 'package:true_leaf_inventory_app/app/modules/dashboard/views/dashboard_view.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';
import 'package:true_leaf_inventory_app/app/widgets/app_button.dart';

class CustomerDetailsView extends GetView<CustomerDetailsController> {
  final id;

  const CustomerDetailsView({this.id, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomerDetailsController>(
      init: CustomerDetailsController(id: id),
      assignId: true,
      builder: (controller) {
        return /*controller.customerDetails == null
            ? Container()
            :*/
            ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 1.5.h),
          children: [
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                    child: DashboardViewButton(
                  title: "Total Order",
                  imageIcon: AppImages.total_order,
                  orderCount: "\$ ${controller.totalOrder.value}",
                  boxColor: AppColors.tableColor,
                  fontSize: 17.sp,
                  scale: 4,
                  textColor: AppColors.whiteColor,
                  isNext: false,
                )),
                Expanded(
                    child: DashboardViewButton(
                  title: "Paid",
                  imageIcon: AppImages.ic_paid,
                  isNext: false,
                  orderCount: "\$ ${controller.totalOrder.value}",
                  boxColor: AppColors.lightGreen,
                  fontSize: 18.sp,
                  textColor: AppColors.whiteColor,
                )),
                Expanded(
                    child: DashboardViewButton(
                  title: "Unpaid",
                  imageIcon: AppImages.ic_unpaid,
                  isNext: false,
                  orderCount: "\$ ${controller.unPaid.value}",
                  fontSize: 18.sp,
                  textColor: AppColors.whiteColor,
                  boxColor: AppColors.lightRed,
                )),
              ],
            ),
            SizedBox(height: 2.5.h),
            controller.customerDetails == null
                ? Container()
                : ExpansionTile(
                    maintainState: true,
                    expandedAlignment: Alignment.centerLeft,
                    title: ListTile(
                      contentPadding: EdgeInsets.only(left: 1.5.w),
                      title: Row(
                        children: [
                          // SizedBox(width: 2.w),
                          Expanded(
                            child: Container(
                              width: 100,
                              child: AppText(
                                controller.customerDetails!.name.toString(),
                                fontSize: 13.sp,
                                maxLines: 2,
                                fontWeight: FontWeight.w600,
                                color: AppColors.blackColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              controller.customerDetails?.contactName != null ? "Contact Person" : "",
                              fontSize: 11.sp,
                              color: AppColors.arrowColor,
                            ),
                            AppText(
                              controller.customerDetails?.contactName ?? "",
                              fontSize: 14.sp,
                            ),
                            controller.customerDetails?.contactName != null ? const Divider() : Container(),
                            AppText(
                              "Customer Name",
                              fontSize: 11.sp,
                              color: AppColors.arrowColor,
                            ),
                            AppText(
                              controller.customerDetails!.companyName.toString(),
                              fontSize: 14.sp,
                            ),
                            const Divider(),
                            AppText(
                              "Address",
                              fontSize: 11.sp,
                              color: AppColors.arrowColor,
                            ),
                            AppText(
                              controller.customerDetails!.address.toString(),
                              fontSize: 14.sp,
                            ),
                            const Divider(),
                            AppText(
                              "Postal Code",
                              fontSize: 11.sp,
                              color: AppColors.arrowColor,
                            ),
                            AppText(
                              controller.customerDetails!.pincode.toString(),
                              fontSize: 14.sp,
                            ),
                            const Divider(),
                            controller.customerDetails!.phoneNumber != ""
                                ? AppText(
                                    "Phone Number",
                                    fontSize: 11.sp,
                                    color: AppColors.arrowColor,
                                  )
                                : Container(),
                            AppText(
                              controller.customerDetails!.phoneNumber.toString(),
                              fontSize: 14.sp,
                            ),
                            controller.customerDetails!.phoneNumber != "" ? const Divider() : Container(),
                            AppText(
                              controller.customerDetails?.email != "" ? "Email" : "",
                              fontSize: 11.sp,
                              color: AppColors.arrowColor,
                            ),
                            AppText(
                              controller.customerDetails?.email ?? "",
                              fontSize: 14.sp,
                            ),
                            controller.customerDetails?.email != "" ? const Divider() : Container(),
                            AppText(
                              "Payment Terms",
                              fontSize: 11.sp,
                              color: AppColors.arrowColor,
                            ),
                            AppText(
                              controller.customerDetails!.paymentTerms == "0"
                                  ? "15 Days"
                                  : controller.customerDetails!.paymentTerms == "1"
                                      ? "30 Days"
                                      : controller.customerDetails!.paymentTerms == "2"
                                          ? "45 Days"
                                          : "60 Days",
                              fontSize: 14.sp,
                            ),
                            const Divider(),
                          ],
                        ),
                      ),
                    ],
                  ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppButton(
                  title: "Create Order",
                  isIcon: true,
                  icon: Icons.add,
                  onTap: () {
                    Get.find<HomeController>().isCustomerDetails.value = false;
                    Get.find<HomeController>().isSelected.value = 5;
                    print("customer id $id");
                    Get.find<HomeController>().isCustomerId.value = id;

                    print("home customer id ${Get.find<HomeController>().isCustomerId.value}");
                    if (Get.find<HomeController>().isCustomerId.value.isNotEmpty) {
                      Get.find<HomeController>().addOrder.value = true;
                    }
                    Get.find<HomeController>().update();
                    controller.update();
                  },
                ),
              ],
            ),
            SizedBox(height: 2.5.h),
            AppText(
              "Past Orders",
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 1.h),
            CustomTable(
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
                            showEditButton: (orderReport.value.status == "3") && (orderReport.value.payment!.paymentStatus == "0" && controller.loginData!.id == orderReport.value.salesManagerId) ? true : false,
                            // showEditButton: orderReport.value.payment!.paymentStatus == "0" && controller.loginData!.id == orderReport.value.salesManagerId ? true : false,
                            isWhite: true,
                            onView: () {
                              Get.put(MyOrdersController());
                              Get.find<MyOrdersController>().id.value = orderReport.value.id.toString();
                              Get.find<HomeController>().isSelected.value = 2;
                              Get.find<HomeController>().isOrderDetails.value = true;
                              Get.find<HomeController>().update();
                              controller.update();
                            },
                            onEdit: () {
                              Get.put(MyOrdersController());
                              Get.find<MyOrdersController>().id.value = orderReport.value.id.toString();
                              Get.find<HomeController>().isSelected.value = 2;
                              Get.find<HomeController>().isOrderDetails.value = true;
                              Get.find<HomeController>().isOrderEdit.value = true;
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
                          orderReport.value.payment!.orderNumber.toString(),
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
            SizedBox(height: 2.h),
          ],
        );
      },
    );
  }
}
