import 'package:flutter/material.dart';

import 'package:get/get.dart';
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
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 1.5.h),
          children: [
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                    child: DashboardViewButton(
                  title: "Accepted Orders",
                  imageIcon: AppImages.accepted,
                  orderCount: controller.isAccepted.value,
                  boxColor: Color(0xffD2E4FF),
                )),
                Expanded(
                    child: DashboardViewButton(
                  title: "Under Review",
                  imageIcon: AppImages.underReview,
                  orderCount: controller.isReview.value,
                  boxColor: Color(0xffFFD9DF),
                  textColor: AppColors.secondPrimaryColor,
                )),
              ],
            ),
            SizedBox(height: 2.5.h),
            AppText(
              "My last 5 orders",
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 1.h),
            CustomTable(
              dataLength: controller.myOrderList.length,
              margin: EdgeInsets.zero,
              isBottom: false,
              columns: [
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
                DataColumn(
                    label: AppText(
                  'Action',
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                )),
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
                        DataCell(
                          CustomTableCellActionButtons(
                            showDeleteButton: false,
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
                              // Get.toNamed(Routes.ADD_ORDER, arguments: {
                              // "id": orderReport.value.id.toString(),
                              // })?.then((value) {
                              // controller.getOrderReportAPI(isLoading: false);
                              // });
                            },
                            onDelete: () {},
                          ),
                        ),
                      ],
                    );
                  },
                ).toList()
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppButton(
                  title: "My Orders",
                  isImage: true,
                  image: AppImages.orders,
                  onTap: () async {
                    Get.find<HomeController>().isSelected.value = 2;
                    Get.find<HomeController>().update();
                  },
                ),
              ],
            ),
            SizedBox(height: 2.h),
          ],
        );
      },
    );
  }
}

class DashboardViewButton extends StatelessWidget {
  final imageIcon;
  final orderCount;
  final title;
  final boxColor;
  final fontSize;
  final textColor;
  final isNext;
  final double? scale;

  const DashboardViewButton({
    super.key,
    this.imageIcon,
    this.orderCount,
    this.title,
    this.scale,
    this.boxColor,
    this.textColor,
    this.fontSize,
    this.isNext = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: boxColor,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              imageIcon,
              scale: scale,
              height: 3.2.h,
              width: 3.2.h,
            ),
            SizedBox(height: 1.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AppText(
                      orderCount,
                      maxLines: 1,
                      fontSize: fontSize ?? 25.sp,
                      color: textColor ?? AppColors.blackColor,
                    ),
                  ),
                  isNext
                      ? Icon(
                          Icons.arrow_forward,
                          color: AppColors.arrowColor,
                        )
                      : Container(),
                ],
              ),
            ),
            SizedBox(height: 0.5.h),
            AppText(
              title,
              fontSize: 10.sp,
              color: isNext == false ? AppColors.whiteColor : AppColors.arrowColor,
            ),
          ],
        ),
      ),
    );
  }
}
