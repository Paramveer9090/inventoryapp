import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';
import 'products_view_content.dart';
import 'products_view_header.dart';

class ProductsViewShell extends StatelessWidget {
  final ProductsController controller;

  const ProductsViewShell({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        utils.hideKeyboard(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.greyLightColor,
        body: Column(
          children: [
            ProductsViewHeader(controller: controller),
            Expanded(
              child: ProductsViewContent(controller: controller),
            ),
          ],
        ),
        floatingActionButton: Obx(
          () => !controller.isSelectionMode.value
              ? FloatingActionButton.extended(
                  onPressed: () {
                    Get.toNamed(Routes.ADD_PRODUCT);
                  },
                  backgroundColor: AppColors.primaryColor,
                  icon: Icon(Icons.add, color: AppColors.whiteColor),
                  label: Text(
                    'Add Product',
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
