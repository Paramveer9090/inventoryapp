import 'package:true_leaf_inventory_app/app/modules/orders/controllers/orders_controller.dart';
import 'widgets/product_grid_section.dart';
import 'widgets/category_grid_section.dart';
import '../../../utils/responsive_helper.dart';
import '../../../widgets/all_import.dart';

class OrdersView extends GetView<OrdersController> {
  final customerId;

  const OrdersView({this.customerId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: GetBuilder<OrdersController>(
        assignId: true,
        init: OrdersController(customerId: customerId),
        builder: (controller) {
          return GestureDetector(
            onTap: () {
              // Dismiss keyboard when tapping outside
              FocusScope.of(context).unfocus();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2.5.h),
                GestureDetector(
                  onTap: () async {
                    if (controller.isSubCategory.value &&
                        controller.isProduct.value == false) {
                      // Going back from subcategories to categories
                      controller.isSubCategory.value = false;
                      controller.isCategory.value = true;
                      controller.isAddToCartButton.value = false;
                      controller.getCategoriesAPI(
                          categoryId: "0"); // Always go to root categories
                      controller.update();
                    }
                    if (controller.isProduct.value) {
                      if (controller
                          .cameFromCategoryWithNoSubcategories.value) {
                        // Go back to main categories
                        controller.isCategory.value = true;
                        controller.isSubCategory.value = false;
                        controller.isProduct.value = false;
                        controller.isAddToCartButton.value = false;
                        controller.getCategoriesAPI(categoryId: "0");
                        controller.update();
                      } else {
                        // Usual logic: go back to subcategories
                        controller.isCategory.value = false;
                        controller.isSubCategory.value = true;
                        controller.isProduct.value = false;
                        controller.isAddToCartButton.value = false;
                        controller.getCategoriesAPI(
                            categoryId: controller.parentCategoryId.value);
                        controller.update();
                      }
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.5.h),
                    child: Row(
                      children: [
                        controller.isProduct.value ||
                                controller.isSubCategory.value
                            ? const Icon(
                                Icons.arrow_back_ios_sharp,
                                size: 15,
                              )
                            : Container(),
                        SizedBox(
                            width: controller.isProduct.value ||
                                    controller.isSubCategory.value
                                ? 1.h
                                : 0),
                        AppText(
                          controller.isProduct.value
                              ? "Go back to sub categories" // Updated text
                              : controller.isSubCategory.value
                                  ? "${"Sub Categories"} (${controller.categoryName.value})"
                                  : "Categories",
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context, 13.sp, 16.sp),
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                ),
                // Add Search Field for Sub-Category and Product views
                Obx(() {
                  if (controller.isSubCategory.value ||
                      controller.isProduct.value) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.5.h, vertical: 1.h),
                      child: CustomSearchBar(
                        hint: controller.isProduct.value
                            ? 'Search products...'
                            : 'Search sub-categories...',
                        onChanged: (value) {
                          if (controller.isProduct.value) {
                            // Search products
                            controller.searchProducts(text: value);
                          } else {
                            // Search sub-categories
                            controller.searchSubCategories(text: value);
                          }
                        },
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
                SizedBox(height: 1.h),
                (controller.categoryList.isEmpty &&
                            controller.productList.isEmpty) ||
                        (controller.productList.length == 0 &&
                            controller.isProduct.value)
                    ? Expanded(
                        child: Center(
                          child: AppText(
                            (controller.productList.length == 0 &&
                                    controller.isProduct.value)
                                ? "No Product found"
                                : controller.noData.value,
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context, 13.sp, 16.sp),
                            color: AppColors.greyColor,
                          ),
                        ),
                      )
                    : Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1.5.h),
                          child: controller.isProduct.value
                              ? ProductGridSection(
                                  controller: controller,
                                  customerId: customerId,
                                )
                              : CategoryGridSection(controller: controller),
                        ),
                      )
              ],
            ),
          );
        },
      ),
    );
  }
}
