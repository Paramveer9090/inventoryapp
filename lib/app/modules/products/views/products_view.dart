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
                        padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.5.h),
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
                                // Selection Controls or Pagination Info
                                Expanded(
                                  child: Obx(() => controller.isSelectionMode.value
                                      ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Checkbox(
                                              value: controller.selectAll.value,
                                              onChanged: (value) {
                                                controller.toggleSelectAll();
                                              },
                                              activeColor: AppColors.primaryColor,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    'Select All',
                                                    style: TextStyle(
                                                      fontSize: 11.sp,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  Text(
                                                    '(${controller.selectedProducts.length} selected)',
                                                    style: TextStyle(
                                                      fontSize: 9.sp,
                                                      color: AppColors.greyColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      : Obx(() => Text(
                                          'Showing ${controller.paginatedProductList.length} of ${controller.productList.length} products',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.grey[600],
                                          ),
                                        ))),
                                ),
                                
                                // Action Buttons
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Selection Mode Toggle
                                    Obx(() => IconButton(
                                      onPressed: () {
                                        print('🎯 Selection Mode Toggle pressed');
                                        print('🎯 Current selection mode: ${controller.isSelectionMode.value}');
                                        controller.toggleSelectionMode();
                                        print('🎯 New selection mode: ${controller.isSelectionMode.value}');
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
      padding: EdgeInsets.symmetric(horizontal: 1.5.h, vertical: 1.h),
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          // Load more when user scrolls to 80% of the content
          if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent * 0.8) {
            controller.loadMoreProducts();
          }
          return false;
        },
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.65,
            crossAxisSpacing: 1.5.h,
            mainAxisSpacing: 1.5.h,
          ),
          itemCount: controller.paginatedProductList.length + (controller.hasMoreItems.value ? 1 : 0),
          itemBuilder: (context, index) {
            // Show loading indicator at the end if there are more items
            if (index == controller.paginatedProductList.length) {
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }
            
            final product = controller.paginatedProductList[index];
            
            // Update category and subcategory names
            for (int i = 0; i < controller.categoryList.length; i++) {
              if (controller.categoryList[i].id == product.categoryId) {
                product.categoryType = controller.categoryList[i].name!;
              }
              if (controller.categoryList[i].id == product.subCategoryId) {
                product.subCategoryType = controller.categoryList[i].name!;
              }
            }
            
            return _buildProductCard(controller, product, index);
          },
        ),
      ),
    );
  }

  Widget _buildListView(ProductsController controller) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        // Load more when user scrolls to 80% of the content
        if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent * 0.8) {
          controller.loadMoreProducts();
        }
        return false;
      },
      child: ListView.builder(
        padding: EdgeInsets.all(1.h),
        itemCount: controller.paginatedProductList.length + (controller.hasMoreItems.value ? 1 : 0),
        itemBuilder: (context, index) {
          // Show loading indicator at the end if there are more items
          if (index == controller.paginatedProductList.length) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          
          final product = controller.paginatedProductList[index];
          
          // Update category and subcategory names
          for (int i = 0; i < controller.categoryList.length; i++) {
            if (controller.categoryList[i].id == product.categoryId) {
              product.categoryType = controller.categoryList[i].name!;
            }
            if (controller.categoryList[i].id == product.subCategoryId) {
              product.subCategoryType = controller.categoryList[i].name!;
            }
          }
          
          return _buildProductListItem(controller, product, index);
        },
      ),
    );
  }

  Widget _buildProductCard(ProductsController controller, dynamic product, int index) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              print('🔥 Grid Card Tapped - Product: ${product.name}');
              print('🔥 Selection Mode: ${controller.isSelectionMode.value}');
              if (controller.isSelectionMode.value) {
                // In selection mode, tap toggles selection
                print('🔥 Before toggle - Selected products count: ${controller.selectedProducts.length}');
                print('🔥 Product selected before toggle: ${controller.selectedProducts.contains(product)}');
                controller.toggleProductSelection(product);
                print('🔥 After toggle - Selected products count: ${controller.selectedProducts.length}');
                print('🔥 Product selected after toggle: ${controller.selectedProducts.contains(product)}');
              } else {
                // Normal mode, tap opens product details
                print('🔥 Opening product details for: ${product.name}');
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
                      Obx(() {
                        final isSelected = controller.selectedProducts.contains(product);
                        return controller.isSelectionMode.value
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
                                    print('🔄 Grid Checkbox tapped - Product: ${product.name}');
                                    print('🔄 Checkbox value: $value');
                                    controller.toggleProductSelection(product);
                                  },
                                  activeColor: AppColors.primaryColor,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                ),
                              ),
                            )
                          : SizedBox.shrink();
                      }),
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
          Obx(() {
            final isSelected = controller.selectedProducts.contains(product);
            print('🎨 Grid Selection Overlay - Product: ${product.name}, Selected: $isSelected, SelectionMode: ${controller.isSelectionMode.value}');
            return controller.isSelectionMode.value && isSelected
              ? IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primaryColor,
                        width: 3,
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildProductListItem(ProductsController controller, dynamic product, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 1.h),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          print('🚀 List Item Tapped - Product: ${product.name}');
          print('🚀 Selection Mode: ${controller.isSelectionMode.value}');
          if (controller.isSelectionMode.value) {
            // In selection mode, tap toggles selection
            print('🚀 Before toggle - Selected products count: ${controller.selectedProducts.length}');
            print('🚀 Product selected before toggle: ${controller.selectedProducts.contains(product)}');
            controller.toggleProductSelection(product);
            print('🚀 After toggle - Selected products count: ${controller.selectedProducts.length}');
            print('🚀 Product selected after toggle: ${controller.selectedProducts.contains(product)}');
          } else {
            // Normal mode, tap opens product details
            print('🚀 Opening product details for: ${product.name}');
            controller.productDetails.value = true;
            Get.find<HomeController>().update();
            controller.update();
            controller.id.value = product.id.toString();
            controller.categoryType.value = product.categoryType ?? '';
            controller.subCategoryType.value = product.subCategoryType ?? '';
          }
        },
        child: Obx(() {
          final isSelected = controller.selectedProducts.contains(product);
          print('🎨 List Selection Border - Product: ${product.name}, Selected: $isSelected, SelectionMode: ${controller.isSelectionMode.value}');
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: controller.isSelectionMode.value && isSelected
                  ? Border.all(color: AppColors.primaryColor, width: 3)
                  : null,
              color: controller.isSelectionMode.value && isSelected
                  ? AppColors.primaryColor.withValues(alpha: 0.1)
                  : null,
            ),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  // Selection Checkbox (only show in selection mode)
                  Obx(() {
                    final isSelected = controller.selectedProducts.contains(product);
                    return controller.isSelectionMode.value
                      ? Checkbox(
                          value: isSelected,
                          onChanged: (value) {
                            print('✅ List Checkbox tapped - Product: ${product.name}');
                            print('✅ Checkbox value: $value');
                            controller.toggleProductSelection(product);
                          },
                          activeColor: AppColors.primaryColor,
                        )
                      : SizedBox.shrink();
                  }),
                
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
          );
        }),
      ),
    );
  }
}
