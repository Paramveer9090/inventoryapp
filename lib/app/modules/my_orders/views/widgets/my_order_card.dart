import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

import '../../../../utils/responsive_helper.dart';
import '../../../../widgets/all_import.dart';
import '../../../order_details/controllers/order_details_controller.dart';

class MyOrderCard extends StatelessWidget {
  final MyOrdersController controller;
  final dynamic order;

  const MyOrderCard({Key? key, required this.controller, required this.order})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final canEdit = (order.status == "3") &&
        (controller.loginData?.id == order.salesManagerId);
    final canAccept = (order.status == "3") &&
        (controller.loginData?.roles?.first.title == "Admin" ||
            controller.loginData?.roles?.first.title == "Website Admin");
    final canAssignDelivery = (order.status == "4" || order.status == "1");

    final dateText = order.orderDate?.split(' ').first ?? '';
    final orderIdText = order.id.toString();
    final customerName =
        controller.customerMap[order.customerId]?.name ?? 'Unknown Customer';
    final amountText = '\$${order.orderTotal?.toStringAsFixed(2) ?? '0.00'}';

    final statusMeta = _statusFor(order);

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
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(context, customerName, orderIdText, canEdit, canAccept,
                    canAssignDelivery, statusMeta),
                SizedBox(height: 1.5.h),
                _details(context, dateText, amountText, canAssignDelivery,
                    statusMeta.dueDate),
                _statusBadge(statusMeta),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(
    BuildContext context,
    String customerName,
    String orderIdText,
    bool canEdit,
    bool canAccept,
    bool canAssignDelivery,
    _StatusMeta statusMeta,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                customerName,
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context, 11.sp, 14.sp),
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
              SizedBox(height: 0.5.h),
              AppText(
                "Order #$orderIdText",
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context, 9.sp, 11.sp),
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _iconAction(
              icon: Icons.visibility,
              color: AppColors.primaryColor,
              tooltip: 'View Order',
              onTap: () {
                controller.id.value = orderIdText;
                orderId = orderIdText;
                final orderDetailsController =
                    Get.put(OrderDetailsController(id: orderIdText));
                orderDetailsController.refreshOrderDetails();
                final home = Get.find<HomeController>();
                home.isOrderDetails.value = true;
                home.update();
                controller.update();
              },
            ),
            if (canEdit) ...[
              SizedBox(width: 1.w),
              _iconAction(
                icon: Icons.edit,
                color: Colors.blue,
                tooltip: 'Edit Order',
                onTap: () {
                  controller.id.value = orderIdText;
                  orderId = orderIdText;
                  final home = Get.find<HomeController>();
                  home.isOrderDetails.value = true;
                  home.isOrderEdit.value = true;
                  home.isCustomerId.value = order.customerId.toString();
                  home.update();
                  controller.update();
                },
                background: Colors.blue.withValues(alpha: 0.1),
              ),
            ],
            if (canAccept) ...[
              SizedBox(width: 1.w),
              _iconAction(
                icon: Icons.check,
                color: Colors.green,
                tooltip: 'Accept Order',
                onTap: () => _showAcceptOrderDialog(context, orderIdText),
                background: Colors.green.withValues(alpha: 0.1),
              ),
            ],
            if (order.status == "1" || order.status == "4") ...[
              SizedBox(width: 1.w),
              _iconAction(
                icon: Icons.download,
                color: Colors.purple,
                tooltip: 'Download Invoice',
                onTap: () => _downloadOrderSummary(context, orderIdText),
                background: Colors.purple.withValues(alpha: 0.1),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _details(BuildContext context, String dateText, String amountText,
      bool canAssignDelivery, DateTime dueDate) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 0.5.w),
                  AppText(
                    "Date: $dateText",
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context, 12.sp, 13.sp),
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
              SizedBox(height: 0.5.h),
              Row(
                children: [
                  const Icon(
                    Icons.attach_money,
                    size: 16,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 0.5.w),
                  AppText(
                    "Amount: $amountText",
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context, 12.sp, 13.sp),
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ],
              ),
              if (canAssignDelivery && order.deliveryAgentId != null) ...[
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    const Icon(
                      Icons.local_shipping,
                      size: 16,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 0.5.w),
                    Expanded(
                      child: AppText(
                        "Delivery Agent: ${_getDeliveryAgentName(order.deliveryAgentId)}",
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context, 11.sp, 12.sp),
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
              if (order.status != "1" &&
                  order.payment?.paymentStatus != "1") ...[
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    const Icon(
                      Icons.schedule,
                      size: 16,
                      color: Colors.grey,
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
      ],
    );
  }

  Widget _statusBadge(_StatusMeta statusMeta) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusMeta.color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: statusMeta.color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusMeta.icon,
            size: 14,
            color: statusMeta.color,
          ),
          SizedBox(width: 0.5.w),
          AppText(
            statusMeta.text,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: statusMeta.color,
          ),
        ],
      ),
    );
  }

  Widget _iconAction({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onTap,
    Color? background,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: background ?? color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon, color: color, size: 22),
        onPressed: onTap,
        tooltip: tooltip,
      ),
    );
  }

  _StatusMeta _statusFor(dynamic order) {
    Color statusColor;
    String statusText;
    IconData statusIcon;
    DateTime currentDate = DateTime.now();
    DateTime dueDate;

    try {
      dueDate = DateTime.parse(order.dueDate.toString());
    } catch (_) {
      dueDate = currentDate.add(const Duration(days: 30));
    }

    switch (order.status) {
      case "1":
        statusColor = AppColors.lightGreen;
        statusText = "Delivered";
        statusIcon = Icons.check_circle;
        break;
      case "3":
        statusColor = Colors.orange;
        statusText = "Pending Approval";
        statusIcon = Icons.pending;
        break;
      case "4":
        statusColor = Colors.blue;
        statusText = "Ready for Delivery";
        statusIcon = Icons.local_shipping;
        break;
      default:
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

    return _StatusMeta(statusColor, statusText, statusIcon, dueDate);
  }

  String _getDeliveryAgentName(int? deliveryAgentId) {
    if (deliveryAgentId == null) return "Not Assigned";
    return "Delivery Agent #$deliveryAgentId";
  }

  void _showAcceptOrderDialog(BuildContext context, String orderId) {
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
              _acceptOrder(orderId);
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

  void _acceptOrder(String orderId) async {
    try {
      Get.snackbar(
        "Order Accepted",
        "Order #$orderId has been accepted and is ready for delivery",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
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

  Future<void> _downloadOrderSummary(
      BuildContext context, String orderId) async {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
              ),
              const SizedBox(height: 16),
              AppText(
                "Generating Invoice...",
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 8),
              AppText(
                "Please wait while we prepare your invoice",
                fontSize: 12.sp,
                color: Colors.grey.shade600,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    try {
      final orderDetailsController = OrderDetailsController(id: orderId);
      await orderDetailsController.orderDetails();

      if (orderDetailsController.getDetailsData == null ||
          orderDetailsController.orderItem.isEmpty) {
        throw Exception("Unable to load order details for invoice generation");
      }

      final pdfData = await orderDetailsController.generateInvoicePdf();
      Get.back();
      await Printing.sharePdf(
        bytes: pdfData,
        filename: orderDetailsController.documentFileName('Invoice'),
      );

      Get.snackbar(
        "Success",
        "Invoice for order #$orderId has been generated successfully!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    } catch (e) {
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      Get.snackbar(
        "Error",
        "Failed to generate invoice: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    }
  }
}

class _StatusMeta {
  final Color color;
  final String text;
  final IconData icon;
  final DateTime dueDate;

  _StatusMeta(this.color, this.text, this.icon, this.dueDate);
}
