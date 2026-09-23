import 'package:true_leaf_inventory_app/app/modules/product_details/views/product_details_view.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';
import 'widgets/products_view_shell.dart';

class ProductsView extends GetView<ProductsController> {
  const ProductsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductsController>(
      builder: (controller) {
        if (!controller.productDetails.value) {
          controller.restoreScrollPosition();
        }

        return controller.productDetails.value
            ? ProductDetailsView(
                id: controller.id.value,
                categoryName: controller.categoryType.value,
                subCategoryName: controller.subCategoryType.value,
                description: controller.descriptionText.value,
              )
            : ProductsViewShell(controller: controller);
      },
    );
  }
}
