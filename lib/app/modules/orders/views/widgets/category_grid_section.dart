import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';

import '../../controllers/orders_controller.dart';
import '../../../../widgets/all_import.dart';

class CategoryGridSection extends StatelessWidget {
  final OrdersController controller;

  const CategoryGridSection({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      key: ValueKey('categories_${controller.categoryList.length}'),
      builder: (BuildContext context, BoxConstraints constraints) {
        final crossAxisCount = constraints.maxWidth > 1200
            ? 6
            : constraints.maxWidth > 900
                ? 5
                : constraints.maxWidth > 600
                    ? 4
                    : 2;

        return DynamicHeightGridView(
          itemCount: controller.categoryList.length,
          physics: const BouncingScrollPhysics(),
          crossAxisCount: crossAxisCount,
          builder: (ctx, index) {
            final category = controller.categoryList[index];
            return GestureDetector(
              onTap: () async {
                if (controller.isSubCategory.value) {
                  controller.subCategoryName.value = category.name.toString();
                  controller.subCategoryId.value = category.id.toString();
                  controller.currentSubCategoryId.value = category.id.toString();
                  controller.getProduct(
                      subCategoryId: category.id, type: "subCategory");
                } else {
                  controller.isSubCategory.value = true;
                  controller.categoryName.value = category.name.toString();
                  controller.categoryId.value = category.id.toString();
                  controller.parentCategoryId.value = category.id.toString();
                  controller.currentCategoryId.value = category.id.toString();
                  controller.getCategoriesAPI(categoryId: category.id.toString());
                }
                controller.update();
              },
              child: Card(
                elevation: 3,
                color: AppColors.whiteColor,
                child: SizedBox(
                  height: 250,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: OptimizedNetworkImage(
                            imageUrl: category.imageUrl != null
                                ? "${Constants.imageBaseUrl}${category.imageUrl}"
                                : AppImages.dummy,
                            fit: BoxFit.contain,
                            width: double.infinity,
                            height: 150,
                          ),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1.5.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: AppText(
                                category.name.toString(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                fontSize: 12.sp,
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward,
                              color: AppColors.arrowColor,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 1.h),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
