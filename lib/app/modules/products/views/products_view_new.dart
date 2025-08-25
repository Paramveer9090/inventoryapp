import 'package:true_leaf_inventory_app/app/modules/product_details/views/product_details_view.dart';
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
              )
            : GestureDetector(
                onTap: () {
                  utils.hideKeyboard(context);
                },
                child: Scaffold(
                  backgroundColor: AppColors.greyLightColor,
                  body: Column(
                    children: [
                      // Header Section
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
                                controller.search(text: value);
                                controller.update();
                              },
                            ),
                            SizedBox(height: 1.h),
                            
                            // Action Bar
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Selection Controls (only show in selection mode)
                                Obx(() => controller.isSelectionMode.value
                                    ? Row(
                                        children: [
                                          Checkbox(
                                            value: controller.selectAll.value,
                                            onChanged: (value) {
                                              controller.toggleSelectAll();
                                            },
                                            activeColor: AppColors.primaryColor,
                                          ),
                                          Text(
                                            'Select All',
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(width: 2.w),
                                          Text(
                                            '(${controller.selectedProducts.length} selected)',
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              color: AppColors.greyColor,
                                            ),
                                          ),
                                        ],
                                      )
                                    : SizedBox.shrink()),
                                
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
                                        color: controller.isSelectionMode.value
                                            ? Colors.red
                                            : AppColors.primaryColor,
                                      ),
                                      tooltip: controller.isSelectionMode.value
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
                                          )
                                        : SizedBox.shrink()),
                                    
                                    // Share PDF (only show in selection mode)
                                    Obx(() => controller.isSelectionMode.value
                                        ? IconButton(
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
    return Padding(
      padding: EdgeInsets.all(1.h),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 1.h,
          mainAxisSpacing: 1.h,
        ),
        itemCount: controller.filterList.length,
        itemBuilder: (context, index) {
          final product = controller.filterList[index];
          
          // Update category and subcategory names
          for (int i = 0; i < controller.categoryList.length; i++) {
            if (controller.categoryList[i].id == product.categoryId) {
              product.categoryType = controller.categoryList[i].name!;
            }
            if (controller.categoryList[i].id == product.subCategoryId) {
              product.subCategoryType = controller.categoryList[i].name!;
            }
          }
          
          return Obx(() => _buildProductCard(controller, product, index));
        },
      ),
    );
  }

  Widget _buildListView(ProductsController controller) {
    return ListView.builder(
      padding: EdgeInsets.all(1.h),
      itemCount: controller.filterList.length,
      itemBuilder: (context, index) {
        final product = controller.filterList[index];
        
        // Update category and subcategory names
        for (int i = 0; i < controller.categoryList.length; i++) {
          if (controller.categoryList[i].id == product.categoryId) {
            product.categoryType = controller.categoryList[i].name!;
          }
          if (controller.categoryList[i].id == product.subCategoryId) {
            product.subCategoryType = controller.categoryList[i].name!;
          }
        }
        
        return Obx(() => _buildProductListItem(controller, product, index));
      },
    );
  }

  Widget _buildProductCard(ProductsController controller, dynamic product, int index) {
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
                // In selection mode, tap toggles selection
                controller.toggleProductSelection(product);
              } else {
                // Normal mode, tap opens product details
                controller.productDetails.value = true;
                Get.find<HomeController>().update();
                controller.update();
                controller.id.value = product.id.toString();
                controller.categoryType.value = product.categoryType ?? '';
                controller.subCategoryType.value = product.subCategoryType ?? '';
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image and Selection
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    color: AppColors.greyLightColor,
                  ),
                  child: Stack(
                    children: [
                      // Product Image
                      Center(
                        child: product.imageUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                                child: Image.network(
                                  '${Constants.imageBaseUrl}${product.imageUrl}',
                                  height: 100,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: AppColors.greyLightColor,
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                                      ),
                                      child: Icon(
                                        Icons.inventory_2_outlined,
                                        size: 40,
                                        color: AppColors.greyColor,
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  color: AppColors.greyLightColor,
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                                ),
                                child: Icon(
                                  Icons.inventory_2_outlined,
                                  size: 40,
                                  color: AppColors.greyColor,
                                ),
                              ),
                      ),
                      
                      // Selection Checkbox (only show in selection mode)
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
                                      color: Colors.black.withValues(alpha: 0.1),
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
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      
                      // Category
                      Text(
                        product.categoryType ?? 'No Category',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppColors.greyColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      SizedBox(height: 8),
                      
                      // Price and Stock
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '\$${product.sellingPrice ?? 0}',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: (product.stock ?? 0) > 0 
                                  ? Colors.green.withValues(alpha: 0.1)
                                  : Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Stock: ${product.stock ?? 0}',
                              style: TextStyle(
                                fontSize: 8.sp,
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
          
          // Selection Overlay
          Obx(() => controller.isSelectionMode.value && isSelected
              ? Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primaryColor,
                      width: 2,
                    ),
                  ),
                )
              : SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _buildProductListItem(ProductsController controller, dynamic product, int index) {
    final isSelected = controller.selectedProducts.contains(product);
    
    return Card(
      margin: EdgeInsets.only(bottom: 1.h),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          if (controller.isSelectionMode.value) {
            // In selection mode, tap toggles selection
            controller.toggleProductSelection(product);
          } else {
            // Normal mode, tap opens product details
            controller.productDetails.value = true;
            Get.find<HomeController>().update();
            controller.update();
            controller.id.value = product.id.toString();
            controller.categoryType.value = product.categoryType ?? '';
            controller.subCategoryType.value = product.subCategoryType ?? '';
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
                // Selection Checkbox (only show in selection mode)
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
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            '${Constants.imageBaseUrl}${product.imageUrl}',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.inventory_2_outlined,
                                size: 30,
                                color: AppColors.greyColor,
                              );
                            },
                          ),
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
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${product.categoryType ?? 'No Category'} • ${product.subCategoryType ?? 'No Sub-Category'}',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppColors.greyColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '\$${product.sellingPrice ?? 0}',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: (product.stock ?? 0) > 0 
                                  ? Colors.green.withValues(alpha: 0.1)
                                  : Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Stock: ${product.stock ?? 0}',
                              style: TextStyle(
                                fontSize: 9.sp,
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
                
                // View Button (only show when not in selection mode)
                Obx(() => !controller.isSelectionMode.value
                    ? IconButton(
                        onPressed: () {
                          controller.productDetails.value = true;
                          Get.find<HomeController>().update();
                          controller.update();
                          controller.id.value = product.id.toString();
                          controller.categoryType.value = product.categoryType ?? '';
                          controller.subCategoryType.value = product.subCategoryType ?? '';
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
