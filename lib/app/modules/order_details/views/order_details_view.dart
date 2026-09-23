import 'package:intl/intl.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';
import '../controllers/order_details_controller.dart';
import 'widgets/add_product_button_card.dart';
import 'widgets/customer_info_card.dart';
import 'widgets/delivery_agent_items_list.dart';
import 'widgets/delivery_agent_selector_card.dart';
import 'widgets/delivery_agent_signature_section.dart';
import 'widgets/invoice_package_buttons.dart';
import 'widgets/order_details_header.dart';
import 'widgets/order_totals_section.dart';
import 'widgets/sales_manager_items_list.dart';

class OrderDetailsView extends GetView<OrderDetailsController> {
  final dynamic id;

  const OrderDetailsView({this.id, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderDetailsController>(
      assignId: true,
      init: OrderDetailsController(id: id),
      builder: (controller) {
        if (controller.getDetailsData == null) {
          return const SizedBox.shrink();
        }

        return Scaffold(
          backgroundColor: AppColors.greyLightColor,
          body: Column(
            children: [
              OrderDetailsHeader(id: id),
              Expanded(
                child: GestureDetector(
                  onTap: () => utils.hideKeyboard(context),
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.all(1.h),
                    children: [
                      SizedBox(height: 0.5.h),
                      Container(
                        padding: EdgeInsets.all(1.2.h),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withValues(alpha: 0.22)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              'Due ${DateFormat('MMM d, yyyy').format(DateTime.now().add(const Duration(days: 30)))}',
                              fontSize: 14.sp,
                              color: AppColors.blackColor,
                            ),
                            SizedBox(height: 0.5.h),
                            AppText(
                              controller.getDetailsData?.customer?.name ?? 'Customer',
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.blackColor,
                            ),
                            SizedBox(height: 0.5.h),
                            AppText(
                              '\$${controller.getDetailsData?.orderTotal ?? '0.00'}',
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.blackColor,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 1.h),
                      CustomerInfoCard(controller: controller),
                      SizedBox(height: 1.h),
                      AddProductButtonCard(id: id),
                      SizedBox(height: 1.h),
                      SalesManagerItemsList(controller: controller),
                      SizedBox(height: 1.h),
                      OrderTotalsSection(controller: controller),
                      SizedBox(height: 1.h),
                      DeliveryAgentSelectorCard(controller: controller),
                      SizedBox(height: 1.h),
                      DeliveryAgentItemsList(controller: controller),
                      DeliveryAgentSignatureSection(controller: controller),
                      InvoicePackageButtons(controller: controller),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
