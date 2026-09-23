import 'dart:io';

import 'package:true_leaf_inventory_app/app/utils/responsive_helper.dart';
import 'package:true_leaf_inventory_app/app/models/get_all_data_model.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class ProductsProductTile extends StatelessWidget {
  final BuildContext context;
  final ProductsController controller;
  final GetDataListResponseData product;
  final int index;
  final bool isGridTile;

  const ProductsProductTile({
    super.key,
    required this.context,
    required this.controller,
    required this.product,
    required this.index,
    required this.isGridTile,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final isSelected = controller.selectedProducts.contains(product);

        return isGridTile
            ? _buildGridTile(isSelected)
            : _buildListTile(isSelected);
      },
    );
  }

  Widget _buildGridTile(bool isSelected) {
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
                _openDetails();
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 110,
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    color: AppColors.greyLightColor,
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: product.imageUrl != null
                            ? FutureBuilder<String?>(
                                future: controller.getLocalProductImagePath(product.imageUrl),
                                builder: (context, snapshot) {
                                  final localPath = snapshot.data;
                                  if (localPath != null && localPath.isNotEmpty) {
                                    final file = File(localPath);
                                    if (file.existsSync()) {
                                      try {
                                        return ClipRRect(
                                          borderRadius: const BorderRadius.vertical(
                                            top: Radius.circular(12),
                                          ),
                                          child: Image.file(
                                            file,
                                            height: 110,
                                            width: double.infinity,
                                            fit: BoxFit.contain,
                                            errorBuilder: (context, error, stackTrace) {
                                              return OptimizedNetworkImage(
                                                imageUrl: product.imageUrl!,
                                                height: 110,
                                                width: double.infinity,
                                                fit: BoxFit.contain,
                                                borderRadius: const BorderRadius.vertical(
                                                  top: Radius.circular(12),
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      } catch (_) {
                                        // Fall back safely if the file cannot be decoded.
                                      }
                                    }
                                  }

                                  return OptimizedNetworkImage(
                                    imageUrl: product.imageUrl!,
                                    height: 110,
                                    width: double.infinity,
                                    fit: BoxFit.contain,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                  );
                                },
                              )
                            : Container(
                                height: 110,
                                decoration: BoxDecoration(
                                  color: AppColors.greyLightColor,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                ),
                                child: Icon(
                                  Icons.inventory_2_outlined,
                                  size: 45,
                                  color: AppColors.greyColor,
                                ),
                              ),
                      ),
                      Obx(
                        () => controller.isSelectionMode.value
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
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Checkbox(
                                    value: isSelected,
                                    onChanged: (value) {
                                      controller
                                          .toggleProductSelection(product);
                                    },
                                    activeColor: AppColors.primaryColor,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (controller.productSortMode.value == ProductSortMode.category)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: _buildCategoryBadge(context),
                        ),
                      Text(
                        product.name ?? 'No Name',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            7.sp,
                            10.sp,
                          ),
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      if (product.descriptionInvoice != null &&
                          product.descriptionInvoice!
                              .toString()
                              .trim()
                              .isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text(
                            product.descriptionInvoice!.toString(),
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                7.sp,
                                9.sp,
                              ),
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      Text(
                        product.categoryType ?? 'No Category',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            7.sp,
                            9.sp,
                          ),
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '\$ ',
                                style: TextStyle(
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${product.sellingPrice ?? 0}',
                                  style: TextStyle(
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: (product.stock ?? 0) > 0
                                  ? Colors.green.withValues(alpha: 0.1)
                                  : Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Stock: ${product.stock ?? 0}',
                              style: TextStyle(
                                fontSize: 7.sp,
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
          Obx(
            () => controller.isSelectionMode.value && isSelected
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
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(bool isSelected) {
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
            _openDetails();
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
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Obx(
                  () => controller.isSelectionMode.value
                      ? Checkbox(
                          value: isSelected,
                          onChanged: (value) {
                            controller.toggleProductSelection(product);
                          },
                          activeColor: AppColors.primaryColor,
                        )
                      : const SizedBox.shrink(),
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.greyLightColor,
                  ),
                  child: product.imageUrl != null
                      ? FutureBuilder<String?>(
                          future: controller.getLocalProductImagePath(product.imageUrl),
                          builder: (context, snapshot) {
                            final localPath = snapshot.data;
                            if (localPath != null && localPath.isNotEmpty) {
                              final file = File(localPath);
                              if (file.existsSync()) {
                                try {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      file,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) {
                                        return OptimizedNetworkImage(
                                          imageUrl: product.imageUrl!,
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.contain,
                                          borderRadius: BorderRadius.circular(8),
                                        );
                                      },
                                    ),
                                  );
                                } catch (_) {
                                  // Fall back safely if the file cannot be decoded.
                                }
                              }
                            }

                            return OptimizedNetworkImage(
                              imageUrl: product.imageUrl!,
                              width: 60,
                              height: 60,
                              fit: BoxFit.contain,
                              borderRadius: BorderRadius.circular(8),
                            );
                          },
                        )
                      : Icon(
                          Icons.inventory_2_outlined,
                          size: 30,
                          color: AppColors.greyColor,
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (controller.productSortMode.value == ProductSortMode.category)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: _buildCategoryBadge(context),
                        ),
                      Text(
                        product.name ?? 'No Name',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            10.sp,
                            13.sp,
                          ),
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      if (product.descriptionInvoice != null &&
                          product.descriptionInvoice!
                              .toString()
                              .trim()
                              .isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text(
                            product.descriptionInvoice!.toString(),
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                8.sp,
                                10.sp,
                              ),
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
                            context,
                            9.sp,
                            11.sp,
                          ),
                          color: AppColors.greyColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              '\$${product.sellingPrice ?? 0}',
                              style: TextStyle(
                                fontSize:
                                    ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  10.sp,
                                  13.sp,
                                ),
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
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
                                  context,
                                  8.sp,
                                  10.sp,
                                ),
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
                Obx(
                  () => !controller.isSelectionMode.value
                      ? IconButton(
                          onPressed: _openDetails,
                          icon: Icon(
                            Icons.visibility,
                            color: AppColors.primaryColor,
                          ),
                          tooltip: 'View Details',
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openDetails() {
    controller.saveScrollPosition();
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
            : (product.descriptionWebsite?.toString().trim().isNotEmpty == true)
                ? product.descriptionWebsite!.toString().trim()
                : '';
  }

  Widget _buildCategoryBadge(BuildContext context) {
    final categoryName = (product.categoryType ?? '').trim().isNotEmpty
        ? product.categoryType!.trim()
        : 'No Category';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        categoryName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: ResponsiveHelper.getResponsiveFontSize(
            context,
            7.sp,
            9.sp,
          ),
          fontWeight: FontWeight.w600,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}
