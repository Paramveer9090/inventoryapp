import 'package:true_leaf_inventory_app/app/modules/customer_details/controllers/customer_details_controller.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class StatCardsRow extends StatelessWidget {
  final CustomerDetailsController controller;

  const StatCardsRow({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: const [
            Expanded(
              child: _StatCard(
                title: "Total Order",
                icon: Icons.shopping_cart_outlined,
                color: AppColors.tableColor,
                valueKey: _StatValue.total,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _StatCard(
                title: "Paid",
                icon: Icons.paid_outlined,
                color: AppColors.lightGreen,
                valueKey: _StatValue.paid,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _StatCard(
                title: "Unpaid",
                icon: Icons.money_off_outlined,
                color: AppColors.lightRed,
                valueKey: _StatValue.unpaid,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _StatValue { total, paid, unpaid }

class _StatCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final _StatValue valueKey;

  const _StatCard({Key? key, required this.title, required this.icon, required this.color, required this.valueKey}) : super(key: key);

  String _resolveValue(CustomerDetailsController controller) {
    switch (valueKey) {
      case _StatValue.total:
        return "\$ ${controller.totalOrder.value}";
      case _StatValue.paid:
        return "\$ ${controller.totalOrder.value}";
      case _StatValue.unpaid:
        return "\$ ${controller.unPaid.value}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CustomerDetailsController>();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.whiteColor,
            size: 20,
          ),
          const SizedBox(height: 4),
          AppText(
            title,
            fontSize: 10.sp,
            color: AppColors.whiteColor,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          AppText(
            _resolveValue(controller),
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.whiteColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
