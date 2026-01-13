import 'package:true_leaf_inventory_app/app/modules/cart/controllers/cart_controller.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class CartTotalsSection extends StatelessWidget {
  final CartController controller;

  const CartTotalsSection({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                "Total",
                fontSize: 13.sp,
                color: const Color(0XFF44474d),
              ),
              AppText(
                "\$ ${controller.orderTotal.value}",
                fontSize: 14.sp,
                color: const Color(0XFF44474d),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                "Taxes & charges",
                fontSize: 13.sp,
                color: const Color(0XFF44474d),
              ),
              AppText(
                "\$ ${controller.orderTax.value}",
                fontSize: 14.sp,
                color: const Color(0XFF44474d),
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                "Grand Total",
                color: AppColors.primaryColor,
                fontSize: 14.sp,
              ),
              AppText(
                "\$ ${controller.orderFinalTotal.value}",
                fontSize: 15.sp,
              ),
            ],
          ),
          SizedBox(height: 5.h),
        ],
      ),
    );
  }
}
