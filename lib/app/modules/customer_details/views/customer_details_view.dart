import 'package:true_leaf_inventory_app/app/modules/customer_details/controllers/customer_details_controller.dart';
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
        return Scaffold(
          backgroundColor: AppColors.greyLightColor,
          body: Column(
            children: [
              // Header Section
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.find<HomeController>().isCustomerDetails.value = false;
                        Get.find<HomeController>().update();
                        controller.update();
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: AppColors.primaryColor,
                          size: 20,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            'Customer Details',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor,
                          ),
                          if (controller.customerDetails != null)
                            AppText(
                              controller.customerDetails!.companyName.toString(),
                              fontSize: 12.sp,
                              color: Colors.grey[600]!,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content Area
              Expanded(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(1.h),
                  children: [
                    SizedBox(height: 1.h),
                    SizedBox(height: 1.h),
                    
                    // Statistics Cards
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                title: "Total Order",
                                value: "\$ ${controller.totalOrder.value}",
                                icon: Icons.shopping_cart_outlined,
                                color: AppColors.tableColor,
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: _StatCard(
                                title: "Paid",
                                value: "\$ ${controller.totalOrder.value}",
                                icon: Icons.paid_outlined,
                                color: AppColors.lightGreen,
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: _StatCard(
                                title: "Unpaid",
                                value: "\$ ${controller.unPaid.value}",
                                icon: Icons.money_off_outlined,
                                color: AppColors.lightRed,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 1.h),
                    SizedBox(height: 1.h),
                    
                    // Customer Information Card
                    if (controller.customerDetails != null)
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Theme(
                          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            initiallyExpanded: false,
                            maintainState: true,
                            expandedAlignment: Alignment.centerLeft,
                            backgroundColor: Colors.transparent,
                            collapsedBackgroundColor: Colors.transparent,
                            title: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Icon(
                                    Icons.business,
                                    color: AppColors.primaryColor,
                                    size: 24,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AppText(
                                        controller.customerDetails!.name.toString(),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.blackColor,
                                      ),
                                      AppText(
                                        controller.customerDetails!.companyName.toString(),
                                        fontSize: 12.sp,
                                        color: Colors.grey[600]!,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            children: [
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    if (controller.customerDetails?.contactName != null && 
                                        controller.customerDetails!.contactName!.isNotEmpty)
                                      _InfoRow(
                                        label: "Contact Person",
                                        value: controller.customerDetails!.contactName!,
                                        icon: Icons.person_outline,
                                      ),
                                    
                                    _InfoRow(
                                      label: "Address",
                                      value: controller.customerDetails!.address.toString(),
                                      icon: Icons.location_on_outlined,
                                    ),
                                    
                                    _InfoRow(
                                      label: "Postal Code",
                                      value: controller.customerDetails!.pincode.toString(),
                                      icon: Icons.markunread_mailbox_outlined,
                                    ),
                                    
                                    if (controller.customerDetails!.phoneNumber != null &&
                                        controller.customerDetails!.phoneNumber!.isNotEmpty)
                                      _InfoRow(
                                        label: "Phone Number",
                                        value: controller.customerDetails!.phoneNumber!,
                                        icon: Icons.phone_outlined,
                                      ),
                                    
                                    if (controller.customerDetails?.email != null &&
                                        controller.customerDetails!.email!.isNotEmpty)
                                      _InfoRow(
                                        label: "Email",
                                        value: controller.customerDetails!.email!,
                                        icon: Icons.email_outlined,
                                      ),
                                    
                                    _InfoRow(
                                      label: "Payment Terms",
                                      value: controller.customerDetails!.paymentTerms == "0"
                                          ? "15 Days"
                                          : controller.customerDetails!.paymentTerms == "1"
                                              ? "30 Days"
                                              : controller.customerDetails!.paymentTerms == "2"
                                                  ? "45 Days"
                                                  : "60 Days",
                                      icon: Icons.payment_outlined,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    
                    SizedBox(height: 1.h),
                    
                    // Create Order Button
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: AppButton(
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
                      ),
                    ),
                    
                    SizedBox(height: 1.h),
                    
                    // Past Orders Section
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.history,
                                  size: 20,
                                  color: AppColors.primaryColor,
                                ),
                                SizedBox(width: 8),
                                AppText(
                                  "Past Orders",
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                Spacer(),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: AppText(
                                    "${controller.myOrderList.length} orders",
                                    fontSize: 12.sp,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            
                            SizedBox(height: 12),
                            
                            // Orders Table
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
                                      color: WidgetStatePropertyAll(
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
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  // Helper Widget for Statistics Cards
  Widget _StatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.whiteColor,
            size: 20,
          ),
          SizedBox(height: 4),
          AppText(
            title,
            fontSize: 10.sp,
            color: AppColors.whiteColor,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2),
          AppText(
            value,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.whiteColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  // Helper Widget for Information Rows
  Widget _InfoRow({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: 16,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  label,
                  fontSize: 11.sp,
                  color: AppColors.arrowColor,
                ),
                SizedBox(height: 2),
                AppText(
                  value,
                  fontSize: 13.sp,
                  color: AppColors.blackColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}