import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class OrderDetailsHeader extends StatelessWidget {
  final dynamic id;

  const OrderDetailsHeader({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  'Order Details',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                ),
                AppText(
                  'Order ID: $id',
                  fontSize: 12.sp,
                  color: Colors.grey[600]!,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
