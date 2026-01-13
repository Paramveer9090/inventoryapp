import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';
import 'package:true_leaf_inventory_app/app/widgets/app_button.dart';

class AddProductButtonCard extends StatelessWidget {
  final dynamic id;

  const AddProductButtonCard({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final canEdit = homeController.isOrderDetails.value && homeController.isOrderEdit.value;
    if (!canEdit) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: AppButton(
          title: "Add Product",
          isIcon: true,
          icon: Icons.add,
          onTap: () {
            homeController.isOrderDetails.value = false;
            homeController.isCustomerDetails.value = false;
            homeController.isSelected.value = 5;
            homeController.isCustomerId.value = id;
            homeController.addOrder.value = true;
            homeController.update();
          },
        ),
      ),
    );
  }
}
