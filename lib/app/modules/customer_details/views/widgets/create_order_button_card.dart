import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';
import 'package:true_leaf_inventory_app/app/widgets/app_button.dart';

class CreateOrderButtonCard extends StatelessWidget {
  final dynamic id;

  const CreateOrderButtonCard({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: AppButton(
          title: "Create Order",
          isIcon: true,
          icon: Icons.add,
          onTap: () {
            final home = Get.find<HomeController>();
            home.isCustomerDetails.value = false;
            home.isSelected.value = 5;
            home.isCustomerId.value = "";
            home.addOrder.value = true;
            home.update();
          },
        ),
      ),
    );
  }
}
