import 'package:true_leaf_inventory_app/app/modules/customer_details/controllers/customer_details_controller.dart';
import 'package:true_leaf_inventory_app/app/modules/customer_details/views/widgets/create_order_button_card.dart';
import 'package:true_leaf_inventory_app/app/modules/customer_details/views/widgets/customer_details_header.dart';
import 'package:true_leaf_inventory_app/app/modules/customer_details/views/widgets/customer_info_tile.dart';
import 'package:true_leaf_inventory_app/app/modules/customer_details/views/widgets/past_orders_section.dart';
import 'package:true_leaf_inventory_app/app/modules/customer_details/views/widgets/stat_cards_row.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class CustomerDetailsView extends GetView<CustomerDetailsController> {
  final id;

  const CustomerDetailsView({this.id, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomerDetailsController>(
      init: CustomerDetailsController(id: id),
      assignId: true,
      builder: (controller) {
        return GetBuilder<HomeController>(
          builder: (homeController) {
            // Only refresh data when coming back from order details
            // The controller will handle rate limiting internally
            if (!homeController.isOrderDetails.value &&
                !homeController.addOrder.value) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                controller.refreshData();
              });
            }

            return Scaffold(
              backgroundColor: AppColors.greyLightColor,
              body: Column(
                children: [
                  CustomerDetailsHeader(controller: controller, id: id),
                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.all(1.h),
                      children: [
                        SizedBox(height: 1.h),
                        StatCardsRow(controller: controller),
                        SizedBox(height: 1.h),
                        CustomerInfoTile(controller: controller),
                        SizedBox(height: 1.h),
                        CreateOrderButtonCard(id: id),
                        SizedBox(height: 1.h),
                        PastOrdersSection(controller: controller),
                        SizedBox(height: 2.h),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
