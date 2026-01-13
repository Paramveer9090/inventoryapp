import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:true_leaf_inventory_app/app/modules/product_details/views/product_details_view.dart';
import '../../../utils/responsive_helper.dart';
import '../../../widgets/all_import.dart';

class ProductsView extends GetView<ProductsController> {
  const ProductsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductsController>(
      init: ProductsController(),
      assignId: true,
      builder: (controller) {
        return controller.productDetails.value
            ? ProductDetailsView(
                id: controller.id.value,
                categoryName: controller.categoryType.value,
                subCategoryName: controller.subCategoryType.value,
                description: controller.descriptionText.value,
              )
            : GestureDetector(
                onTap: () {
                  utils.hideKeyboard(context);
                },
                child: Scaffold(
                  backgroundColor: AppColors.greyLightColor,
                  body: Column(
                    children: [
                      // Header Section (New Styling)
                      Container(
                        padding: EdgeInsets.all(1.5.h),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.1),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Search Bar
                            CustomSearchBar(
                              hint: 'Search products...',
                              onChanged: (value) {
                                controller.onSearchChanged(value);
                                controller.update();
                              },
                            ),
                            SizedBox(height: 1.h),

                            // Action Bar
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Selection Controls or Pagination Info
                                Expanded(
                                  child: Obx(() => controller
                                          .isSelectionMode.value
                                      ? Row(
                                          children: [
                                            Checkbox(
                                              value: controller.selectAll.value,
                                              onChanged: (value) {
                                                controller.toggleSelectAll();
                                              },
                                              activeColor:
                                                  AppColors.primaryColor,
                                            ),
                                            Text(
                                              'Select All',
                                              style: TextStyle(
                                                fontSize: ResponsiveHelper
                                                    .getResponsiveFontSize(
                                                        context, 11.sp, 14.sp),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(width: 2.w),
                                            Text(
                                              '(${controller.selectedProducts.length} selected)',
                                              style: TextStyle(
                                                fontSize: ResponsiveHelper
                                                    .getResponsiveFontSize(
                                                        context, 10.sp, 12.sp),
                                                color: AppColors.greyColor,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Text(
                                          'Showing ${controller.paginatedProductList.length} of ${controller.productList.length} products',
                                          style: TextStyle(
                                            fontSize: ResponsiveHelper
                                                .getResponsiveFontSize(
                                                    context, 10.sp, 12.sp),
                                            color: AppColors.greyColor,
                                          ),
                                        )),
                                ),

                                // Action Buttons
                                Row(
                                  children: [
                                    // Selection Mode Toggle
                                    Obx(() => IconButton(
                                          onPressed: () {
                                            controller.toggleSelectionMode();
                                          },
                                          icon: Icon(
                                            controller.isSelectionMode.value
                                                ? Icons.close
                                                : Icons.checklist,
                                            color:
                                                controller.isSelectionMode.value
                                                    ? Colors.red
                                                    : AppColors.primaryColor,
                                          ),
                                          tooltip:
                                              controller.isSelectionMode.value
                                                  ? 'Exit Selection'
                                                  : 'Select Mode',
                                        )),

                                    // View Toggle
                                    Obx(() => IconButton(
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
                                        )),

                                    // Export PDF (only show in selection mode)
                                    Obx(() => controller.isSelectionMode.value
                                        ? IconButton(
                                            onPressed: controller
                                                    .selectedProducts.isNotEmpty
                                                ? () {
                                                    controller
                                                        .exportSelectedProductsPdf();
                                                  }
                                                : null,
                                            icon: Icon(
                                              Icons.picture_as_pdf,
                                              color: controller.selectedProducts
                                                      .isNotEmpty
                                                  ? AppColors.primaryColor
                                                  : AppColors.greyColor,
                                            ),
                                            tooltip: 'Export PDF',
                                          )
                                        : SizedBox.shrink()),

                                    // Share PDF (only show in selection mode)
                                    Obx(() => controller.isSelectionMode.value
                                        ? IconButton(
                                            onPressed: controller
                                                    .selectedProducts.isNotEmpty
                                                ? () {
                                                    controller.sharePdf();
                                                  }
                                                : null,
                                            icon: Icon(
                                              Icons.share,
                                              color: controller.selectedProducts
                                                      .isNotEmpty
                                                  ? AppColors.primaryColor
                                                  : AppColors.greyColor,
                                            ),
                                            tooltip: 'Share PDF',
                                          )
                                        : SizedBox.shrink()),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Content Area
                      Expanded(
                        child: controller.noData.value != ""
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
                            : Obx(() => controller.isGridView.value
                                ? _buildGridView(controller)
                                : _buildListView(controller)),
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }

  Widget _buildGridView(ProductsController controller) {
    // Uses New Padding (1.h)
    return Padding(
      padding: EdgeInsets.all(1.h),
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          // Pagination Logic (Maintained)
          if (scrollInfo.metrics.pixels >=
              scrollInfo.metrics.maxScrollExtent * 0.8) {
            controller.loadMoreProducts();
          }
          return false;
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Responsive columns
            final crossAxisCount = constraints.maxWidth > 1200
                ? 6
                : constraints.maxWidth > 900
                    ? 5
                    : constraints.maxWidth > 600
                        ? 4
                        : 2;

            // Use DynamicHeightGridView to fix overflow errors
            return DynamicHeightGridView(
              physics: const AlwaysScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 1.h,
              mainAxisSpacing: 1.h,
              itemCount: controller.paginatedProductList.length +
                  (controller.hasMoreItems.value ? 1 : 0),
              builder: (context, index) {
                // Show loading indicator at the end
                if (index == controller.paginatedProductList.length) {
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }

                final product = controller.paginatedProductList[index];

                // Ensure category names are mapped (if not done in controller)
                if (product.categoryType == null ||
                    product.categoryType!.isEmpty) {
                  for (var cat in controller.categoryList) {
                    if (cat.id == product.categoryId)
                      product.categoryType = cat.name!;
                    if (cat.id == product.subCategoryId)
                      product.subCategoryType = cat.name!;
                  }
                }

                return Obx(() =>
                    _buildProductCard(context, controller, product, index));
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildListView(ProductsController controller) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        // Pagination Logic (Maintained)
        if (scrollInfo.metrics.pixels >=
            scrollInfo.metrics.maxScrollExtent * 0.8) {
          controller.loadMoreProducts();
        }
        return false;
      },
      child: ListView.builder(
        padding: EdgeInsets.all(1.h), // New padding
        itemCount: controller.paginatedProductList.length +
            (controller.hasMoreItems.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == controller.paginatedProductList.length) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          final product = controller.paginatedProductList[index];

          return Obx(
              () => _buildProductListItem(context, controller, product, index));
        },
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, ProductsController controller,
      dynamic product, int index) {
    final isSelected = controller.selectedProducts.contains(product);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              if (controller.isSelectionMode.value) {
                controller.toggleProductSelection(product);
              } else {
                // Navigate to details
                controller.productDetails.value = true;
                Get.find<HomeController>().update();
                controller.update();
                controller.id.value = product.id.toString();
                controller.categoryType.value = product.categoryType ?? '';
                controller.subCategoryType.value =
                    product.subCategoryType ?? '';
                controller.descriptionText.value =
                    (product.descriptionInvoice?.toString().trim().isNotEmpty ==
                            true)
                        ? product.descriptionInvoice!.toString().trim()
                        : (product.description?.toString().trim().isNotEmpty ==
                                true)
                            ? product.description!.toString().trim()
                            : (product.descriptionWebsite
                                        ?.toString()
                                        .trim()
                                        .isNotEmpty ==
                                    true)
                                ? product.descriptionWebsite!.toString().trim()
                                : '';
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image and Selection
                Container(
                  height: 110,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(12)),
                    color: AppColors.greyLightColor,
                  ),
                  child: Stack(
                    children: [
                      // Product Image
                      Center(
                        child: product.imageUrl != null
                            ? OptimizedNetworkImage(
                                imageUrl: product.imageUrl!,
                                height: 110,
                                width: double.infinity,
                                fit: BoxFit.contain,
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12)),
                              )
                            : Container(
                                height: 110,
                                decoration: BoxDecoration(
                                  color: AppColors.greyLightColor,
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(12)),
                                ),
                                child: Icon(
                                  Icons.inventory_2_outlined,
                                  size: 45,
                                  color: AppColors.greyColor,
                                ),
                              ),
                      ),

                      // Selection Checkbox
                      Obx(() => controller.isSelectionMode.value
                          ? Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 2,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Checkbox(
                                  value: isSelected,
                                  onChanged: (value) {
                                    controller.toggleProductSelection(product);
                                  },
                                  activeColor: AppColors.primaryColor,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                ),
                              ),
                            )
                          : SizedBox.shrink()),
                    ],
                  ),
                ),

                // Product Details
                Container(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Product Name
                      Text(
                        product.name ?? 'No Name',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context, 7.sp, 10.sp),
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),

                      // Invoice Description (Retained from original)
                      if (product.descriptionInvoice != null &&
                          product.descriptionInvoice!
                              .toString()
                              .trim()
                              .isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(bottom: 2),
                          child: Text(
                            product.descriptionInvoice!.toString(),
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                  context, 7.sp, 9.sp),
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                      // Category
                      Text(
                        product.categoryType ?? 'No Category',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context, 7.sp, 9.sp),
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 4),

                      // Price and Stock
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(
                              '\$${product.sellingPrice ?? 0}',
                              style: TextStyle(
                                fontSize:
                                    ResponsiveHelper.getResponsiveFontSize(
                                        context, 7.sp, 10.sp),
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: (product.stock ?? 0) > 0
                                  ? Colors.green.withValues(alpha: 0.1)
                                  : Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Stock: ${product.stock ?? 0}',
                              style: TextStyle(
                                fontSize:
                                    ResponsiveHelper.getResponsiveFontSize(
                                        context, 6.sp, 8.sp),
                                color: (product.stock ?? 0) > 0
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Selection Overlay (New Styling)
          Obx(() => controller.isSelectionMode.value && isSelected
              ? Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primaryColor,
                      width: 2, // Thinner border
                    ),
                  ),
                )
              : SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _buildProductListItem(BuildContext context,
      ProductsController controller, dynamic product, int index) {
    final isSelected = controller.selectedProducts.contains(product);

    return Card(
      margin: EdgeInsets.only(bottom: 1.h),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          if (controller.isSelectionMode.value) {
            controller.toggleProductSelection(product);
          } else {
            controller.productDetails.value = true;
            Get.find<HomeController>().update();
            controller.update();
            controller.id.value = product.id.toString();
            controller.categoryType.value = product.categoryType ?? '';
            controller.subCategoryType.value = product.subCategoryType ?? '';
            controller.descriptionText.value = (product.descriptionInvoice
                        ?.toString()
                        .trim()
                        .isNotEmpty ==
                    true)
                ? product.descriptionInvoice!.toString().trim()
                : (product.description?.toString().trim().isNotEmpty == true)
                    ? product.description!.toString().trim()
                    : (product.descriptionWebsite
                                ?.toString()
                                .trim()
                                .isNotEmpty ==
                            true)
                        ? product.descriptionWebsite!.toString().trim()
                        : '';
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: controller.isSelectionMode.value && isSelected
                ? Border.all(color: AppColors.primaryColor, width: 2)
                : null,
            color: controller.isSelectionMode.value && isSelected
                ? AppColors.primaryColor.withValues(alpha: 0.05)
                : null,
          ),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                // Selection Checkbox
                Obx(() => controller.isSelectionMode.value
                    ? Checkbox(
                        value: isSelected,
                        onChanged: (value) {
                          controller.toggleProductSelection(product);
                        },
                        activeColor: AppColors.primaryColor,
                      )
                    : SizedBox.shrink()),

                // Product Image
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.greyLightColor,
                  ),
                  child: product.imageUrl != null
                      ? OptimizedNetworkImage(
                          imageUrl: product.imageUrl!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.contain,
                          borderRadius: BorderRadius.circular(8),
                        )
                      : Icon(
                          Icons.inventory_2_outlined,
                          size: 30,
                          color: AppColors.greyColor,
                        ),
                ),

                SizedBox(width: 12),

                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name ?? 'No Name',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context, 10.sp, 13.sp),
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      // Invoice Description (Retained)
                      if (product.descriptionInvoice != null &&
                          product.descriptionInvoice!
                              .toString()
                              .trim()
                              .isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(bottom: 2),
                          child: Text(
                            product.descriptionInvoice!.toString(),
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                  context, 8.sp, 10.sp),
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      Text(
                        '${product.categoryType ?? 'No Category'} • ${product.subCategoryType ?? 'No Sub-Category'}',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context, 9.sp, 11.sp),
                          color: AppColors.greyColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              '\$${product.sellingPrice ?? 0}',
                              style: TextStyle(
                                fontSize:
                                    ResponsiveHelper.getResponsiveFontSize(
                                        context, 10.sp, 13.sp),
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: (product.stock ?? 0) > 0
                                  ? Colors.green.withValues(alpha: 0.1)
                                  : Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Stock: ${product.stock ?? 0}',
                              style: TextStyle(
                                fontSize:
                                    ResponsiveHelper.getResponsiveFontSize(
                                        context, 8.sp, 10.sp),
                                color: (product.stock ?? 0) > 0
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // View Button
                Obx(() => !controller.isSelectionMode.value
                    ? IconButton(
                        onPressed: () {
                          controller.productDetails.value = true;
                          Get.find<HomeController>().update();
                          controller.update();
                          controller.id.value = product.id.toString();
                          controller.categoryType.value =
                              product.categoryType ?? '';
                          controller.subCategoryType.value =
                              product.subCategoryType ?? '';
                          controller.descriptionText.value = (product
                                      .descriptionInvoice
                                      ?.toString()
                                      .trim()
                                      .isNotEmpty ==
                                  true)
                              ? product.descriptionInvoice!.toString().trim()
                              : (product.description
                                          ?.toString()
                                          .trim()
                                          .isNotEmpty ==
                                      true)
                                  ? product.description!.toString().trim()
                                  : (product.descriptionWebsite
                                              ?.toString()
                                              .trim()
                                              .isNotEmpty ==
                                          true)
                                      ? product.descriptionWebsite!
                                          .toString()
                                          .trim()
                                      : '';
                        },
                        icon: Icon(
                          Icons.visibility,
                          color: AppColors.primaryColor,
                        ),
                        tooltip: 'View Details',
                      )
                    : SizedBox.shrink()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
