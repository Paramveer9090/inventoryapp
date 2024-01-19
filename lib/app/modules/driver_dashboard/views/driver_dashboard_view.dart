import 'package:true_leaf_inventory_app/app/modules/dashboard/views/dashboard_view.dart';
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
        return controller.noData.value != ""
            ? Padding(
                padding: EdgeInsets.all(18.0),
                child: Center(
                    child: AppText(
                  controller.noData.value,
                  fontSize: 13.sp,
                  color: AppColors.greyColor,
                )),
              )
            : Padding(
                padding: EdgeInsets.only(
                  top: 2.h,
                ),
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 0.5.h),
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.5.h),
                      child: Row(
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
                            title: "Delivered",
                            imageIcon: AppImages.pending,
                            isNext: false,
                            orderCount: "\$ ${controller.delivered.value}",
                            boxColor: AppColors.lightGreen,
                            fontSize: 18.sp,
                            textColor: AppColors.whiteColor,
                          )),
                          Expanded(
                              child: DashboardViewButton(
                            title: "Pending",
                            imageIcon: AppImages.deliverd,
                            isNext: false,
                            orderCount: "\$ ${controller.pending.value}",
                            fontSize: 18.sp,
                            textColor: AppColors.whiteColor,
                            boxColor: AppColors.lightYellow,
                          )),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: AppText(
                        'Orders',
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                    CustomTable(
                      dataLength: controller.orderList.length,
                      columns: [
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
                            'Order Date',
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                          ),
                        ),
                        DataColumn(
                          label: AppText(
                            'Company Name',
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                          ),
                        ),
                        DataColumn(
                          label: AppText(
                            'Contact Person',
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                          ),
                        ),
                        DataColumn(
                          label: AppText(
                            'Customer Name',
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                          ),
                        ),
                        DataColumn(
                          label: AppText(
                            'Address',
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                          ),
                        ),
                        DataColumn(
                          label: AppText(
                            'Postal Code',
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                          ),
                        ),
                        DataColumn(
                          label: AppText(
                            'Phone Number',
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
                            'Delivery Note',
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                          ),
                        ),
                        DataColumn(
                            label: AppText(
                          'Action',
                          color: AppColors.whiteColor,
                          fontSize: 11.sp,
                        )),
                      ],
                      rows: [
                        ...controller.orderList.asMap().entries.map(
                          (order) {
                            return DataRow(
                              color: MaterialStatePropertyAll(
                                order.key.isEven ? AppColors.greyLightColor : AppColors.whiteColor,
                              ),
                              cells: [
                                DataCell(
                                  AppText(order.value.id.toString()),
                                ),
                                DataCell(
                                  AppText(order.value.order_date!),
                                ),
                                DataCell(
                                  AppText(order.value.customer == null ? "" : order.value.customer!.companyName.toString()),
                                ),
                                DataCell(
                                  AppText(order.value.customer == null ? "" : order.value.customer!.contactName ?? ""),
                                ),
                                DataCell(
                                  AppText(order.value.customer == null ? "" : order.value.customer!.name ?? ""),
                                ),
                                DataCell(
                                  AppText(order.value.customer == null ? "" : order.value.customer!.address ?? ""),
                                ),
                                DataCell(
                                  AppText(order.value.customer == null ? "" : order.value.customer!.pincode ?? ""),
                                ),
                                DataCell(
                                  AppText(order.value.customer == null ? "" : order.value.customer!.phoneNumber ?? ""),
                                ),
                                DataCell(
                                  Text(order.value.status == "4"
                                      ? AppStrings.accepted
                                      : order.value.status == "1"
                                          ? AppStrings.completed
                                          : AppStrings.review),
                                ),
                                DataCell(
                                  Text(order.value.delivery_note ?? ""),
                                ),
                                DataCell(
                                  CustomTableCellActionButtons(
                                    showEditButton: false,
                                    showDeleteButton: false,
                                    onViewDetails: () {},
                                    onView: () {
                                      Get.put(DriverOrderController());
                                      Get.find<DriverOrderController>().id.value = order.value.id.toString();
                                      Get.find<HomeController>().isSelected.value = 1;
                                      Get.find<HomeController>().isOrderDetails.value = true;
                                      Get.find<HomeController>().update();
                                      controller.update();
                                    },
                                    onEdit: () {},
                                    onDelete: () {},
                                  ),
                                ),
                              ],
                            );
                          },
                        ).toList()
                      ],
                    ),
                  ],
                ),
              );
      },
    );
  }
}
