import 'package:true_leaf_inventory_app/app/modules/cart/controllers/cart_controller.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class OrderNotesField extends StatelessWidget {
  final CartController controller;

  const OrderNotesField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            "Order Notes (Optional)",
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
          ),
          SizedBox(height: 1.h),
          TextFormField(
            controller: controller.orderNotesController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Add any special instructions or notes for this order...",
              hintStyle: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey[400],
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.grey[300]!,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.grey[300]!,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.primaryColor,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.blackColor,
            ),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
