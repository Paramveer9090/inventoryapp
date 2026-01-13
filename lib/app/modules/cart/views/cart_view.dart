import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';
import '../controllers/cart_controller.dart';
import 'widgets/cart_actions.dart';
import 'widgets/cart_congratulations_section.dart';
import 'widgets/cart_empty_state.dart';
import 'widgets/cart_item_card.dart';
import 'widgets/cart_totals_section.dart';
import 'widgets/delivery_driver_selector.dart';
import 'widgets/order_notes_field.dart';

class CartView extends GetView<CartController> {
  const CartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: GetBuilder<CartController>(
        assignId: true,
        init: CartController(),
        builder: (controller) {
          if (controller.isCongratulations.value) {
            return const CartCongratulationsSection();
          }

          if (controller.orderItemList.isEmpty) {
            return CartEmptyState(message: controller.noData.value);
          }

          return Padding(
            padding: EdgeInsets.only(top: 1.5.h),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                ListView.builder(
                  itemCount: controller.orderItemList.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 2.h),
                  itemBuilder: (context, index) {
                    final data = controller.orderItemList[index];
                    return CartItemCard(
                      controller: controller,
                      data: data,
                      index: index,
                    );
                  },
                ),
                CartTotalsSection(controller: controller),
                DeliveryDriverSelector(controller: controller),
                OrderNotesField(controller: controller),
                CartActions(controller: controller),
              ],
            ),
          );
        },
      ),
    );
  }
}
