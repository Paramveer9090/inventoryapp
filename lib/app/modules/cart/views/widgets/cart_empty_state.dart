import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class CartEmptyState extends StatelessWidget {
  final String message;

  const CartEmptyState({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.greyColor.withValues(alpha: 0.05),
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              color: AppColors.greyColor,
            ),
          ),
          SizedBox(height: 2.h),
          AppText(
            message,
            fontSize: 13.sp,
            color: AppColors.greyColor,
            fontFamily: "Hellix-Regular",
          ),
        ],
      ),
    );
  }
}
