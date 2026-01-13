import 'package:true_leaf_inventory_app/app/modules/cart/controllers/cart_controller.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';
import 'package:true_leaf_inventory_app/app/widgets/app_button.dart';

class CartActions extends StatelessWidget {
  final CartController controller;

  const CartActions({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppButton(
              title: "Place order",
              isIcon: true,
              icon: Icons.shopping_cart,
              onTap: () {
                if (controller.isWrongData.value == false) {
                  controller.postOrderAPI();
                }
              },
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                final homeController = Get.find<HomeController>();
                homeController.isCart.value = false;
                homeController.isCustomerDetails.value = false;
                homeController.isSelected.value = 5;
                homeController.isCustomerId.value = controller.customerId.value;
                homeController.addOrder.value = true;
                homeController.update();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: AppColors.secondPrimaryColor,
                    width: 1.5,
                  ),
                ),
                child: AppText(
                  "Add new Item/product to cart",
                  fontSize: 13.sp,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
