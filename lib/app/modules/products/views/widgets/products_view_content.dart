import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';

import 'package:true_leaf_inventory_app/app/models/get_all_data_model.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';
import 'products_product_tile.dart';

class ProductsViewContent extends StatelessWidget {
  final ProductsController controller;

  const ProductsViewContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return controller.noData.value != ''
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 60,
                  color: AppColors.greyColor,
                ),
                SizedBox(height: 2.h),
                AppText(
                  controller.noData.value,
                  fontSize: 13.sp,
                  color: AppColors.greyColor,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        : Obx(
            () => controller.isGridView.value
                ? _buildGridView(context)
                : _buildListView(context),
          );
  }

  Widget _buildGridView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(1.h),
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels >=
              scrollInfo.metrics.maxScrollExtent * 0.8) {
            controller.loadMoreProducts();
          }
          return false;
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 1200
                ? 6
                : constraints.maxWidth > 900
                    ? 5
                    : constraints.maxWidth > 600
                        ? 4
                        : 2;

            return DynamicHeightGridView(
              controller: controller.productsScrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 1.h,
              mainAxisSpacing: 1.h,
              itemCount: controller.paginatedProductList.length +
                  (controller.hasMoreItems.value ? 1 : 0),
              builder: (context, index) {
                if (index == controller.paginatedProductList.length) {
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );
                }

                final product = controller.paginatedProductList[index];
                _ensureCategoryNames(product);

                return ProductsProductTile(
                  context: context,
                  controller: controller,
                  product: product,
                  index: index,
                  isGridTile: true,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildListView(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels >=
            scrollInfo.metrics.maxScrollExtent * 0.8) {
          controller.loadMoreProducts();
        }
        return false;
      },
      child: ListView.builder(
        controller: controller.productsScrollController,
        padding: EdgeInsets.all(1.h),
        itemCount: controller.paginatedProductList.length +
            (controller.hasMoreItems.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == controller.paginatedProductList.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final product = controller.paginatedProductList[index];
          return ProductsProductTile(
            context: context,
            controller: controller,
            product: product,
            index: index,
            isGridTile: false,
          );
        },
      ),
    );
  }

  void _ensureCategoryNames(GetDataListResponseData product) {
    if (product.categoryType == null || product.categoryType!.isEmpty) {
      for (var cat in controller.categoryList) {
        if (cat.id == product.categoryId) product.categoryType = cat.name!;
        if (cat.id == product.subCategoryId)
          product.subCategoryType = cat.name!;
      }
    }
  }
}
