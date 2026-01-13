import 'package:true_leaf_inventory_app/app/modules/order_details/views/order_details_view.dart';
import 'widgets/my_orders_filters.dart';
import 'widgets/my_order_card.dart';
import '../../../widgets/all_import.dart';

class MyOrdersView extends GetView<MyOrdersController> {
  const MyOrdersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyOrdersController>(
      assignId: true,
      init: MyOrdersController(),
      builder: (controller) {
        if (controller.loginData == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Get.find<HomeController>().isOrderDetails.value
            ? OrderDetailsView(id: controller.id.value)
            : GestureDetector(
                onTap: () => utils.hideKeyboard(context),
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 1.8.h),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    SizedBox(height: 2.h),
                    MyOrdersFilters(controller: controller),
                    controller.noData.value.isNotEmpty
                        ? _buildEmptyState(controller)
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.myOrderList.length,
                            itemBuilder: (context, index) {
                              final order = controller.myOrderList[index];
                              return MyOrderCard(
                                controller: controller,
                                order: order,
                              );
                            },
                          ),
                    SizedBox(height: 3.h),
                  ],
                ),
              );
      },
    );
  }

  Widget _buildEmptyState(MyOrdersController controller) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 2.h),
            AppText(
              controller.noData.value,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            AppText(
              "Try adjusting your filters or search terms",
              fontSize: 12.sp,
              color: Colors.grey.shade500,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
