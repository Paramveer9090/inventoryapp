import 'package:true_leaf_inventory_app/app/utils/responsive_helper.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class ProductsViewHeader extends StatelessWidget {
  final ProductsController controller;

  const ProductsViewHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(1.5.h),
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
      child: Column(
        children: [
          CustomSearchBar(
            hint: 'Search products...',
            onChanged: (value) {
              controller.onSearchChanged(value);
              controller.update();
            },
          ),
          SizedBox(height: 1.h),
          LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Obx(
                      () => controller.isSelectionMode.value
                          ? Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Checkbox(
                                  value: controller.selectAll.value,
                                  onChanged: (value) {
                                    controller.toggleSelectAll();
                                  },
                                  activeColor: AppColors.primaryColor,
                                ),
                                Flexible(
                                  child: Text(
                                    'Select All',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: ResponsiveHelper
                                          .getResponsiveFontSize(
                                        context,
                                        11.sp,
                                        14.sp,
                                      ),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Flexible(
                                  child: Text(
                                    '(${controller.selectedProducts.length} selected)',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: ResponsiveHelper
                                          .getResponsiveFontSize(
                                        context,
                                        10.sp,
                                        12.sp,
                                      ),
                                      color: AppColors.greyColor,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              'Showing ${controller.paginatedProductList.length} of ${controller.productList.length} products',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize:
                                    ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  10.sp,
                                  12.sp,
                                ),
                                color: AppColors.greyColor,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Obx(
                    () => FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              controller.toggleSelectionMode();
                            },
                            icon: Icon(
                              controller.isSelectionMode.value
                                  ? Icons.close
                                  : Icons.checklist,
                              color: controller.isSelectionMode.value
                                  ? Colors.red
                                  : AppColors.primaryColor,
                            ),
                            tooltip: controller.isSelectionMode.value
                                ? 'Exit Selection'
                                : 'Select Mode',
                          ),
                          Obx(
                            () => IconButton(
                              onPressed: controller.isDownloadingProductImages.value
                                  ? null
                                  : () => controller.downloadAllProductImages(),
                              icon: controller.isDownloadingProductImages.value
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Icon(Icons.download, color: AppColors.primaryColor),
                              tooltip: 'Download all product photos',
                            ),
                          ),
                          PopupMenuButton<ProductSortMode>(
                            tooltip: 'Sort products',
                            initialValue: controller.productSortMode.value,
                            onSelected: controller.setProductSortMode,
                            icon: Icon(
                              controller.productSortMode.value == ProductSortMode.category
                                  ? Icons.category_outlined
                                  : Icons.sort_by_alpha,
                              color: AppColors.primaryColor,
                            ),
                            itemBuilder: (context) => [
                              CheckedPopupMenuItem<ProductSortMode>(
                                value: ProductSortMode.name,
                                checked:
                                    controller.productSortMode.value == ProductSortMode.name,
                                child: const Text('Sort by Name'),
                              ),
                              CheckedPopupMenuItem<ProductSortMode>(
                                value: ProductSortMode.category,
                                checked:
                                    controller.productSortMode.value == ProductSortMode.category,
                                child: const Text('Sort by Category'),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              controller.toggleViewMode();
                            },
                            icon: Icon(
                              controller.isGridView.value
                                  ? Icons.view_list
                                  : Icons.grid_view,
                              color: AppColors.primaryColor,
                            ),
                            tooltip: controller.isGridView.value
                                ? 'List View'
                                : 'Grid View',
                          ),
                          if (controller.isSelectionMode.value)
                            IconButton(
                              onPressed: controller.selectedProducts.isNotEmpty
                                  ? () {
                                      controller.exportSelectedProductsPdf();
                                    }
                                  : null,
                              icon: Icon(
                                Icons.picture_as_pdf,
                                color: controller.selectedProducts.isNotEmpty
                                    ? AppColors.primaryColor
                                    : AppColors.greyColor,
                              ),
                              tooltip: 'Export PDF',
                            ),
                          if (controller.isSelectionMode.value)
                            IconButton(
                              onPressed: controller.selectedProducts.isNotEmpty
                                  ? () {
                                      controller.sharePdf();
                                    }
                                  : null,
                              icon: Icon(
                                Icons.share,
                                color: controller.selectedProducts.isNotEmpty
                                    ? AppColors.primaryColor
                                    : AppColors.greyColor,
                              ),
                              tooltip: 'Share PDF',
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
