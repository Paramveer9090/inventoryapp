import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:true_leaf_inventory_app/app/modules/orders/controllers/orders_controller.dart';
import 'package:true_leaf_inventory_app/app/widgets/custom_image.dart';
import '../../../widgets/all_import.dart';

class OrdersView extends GetView<OrdersController> {
  const OrdersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdersController>(
      assignId: true,
      init: OrdersController(),
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.5.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.5.h),
              child: AppText(
                controller.isSubCategory.value ? "${"Sub Categories"} (${controller.categoryName.value})" : "Categories",
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            controller.categoryList.isEmpty
                ? Expanded(
                    child: Center(
                      child: AppText(
                        controller.noData.value,
                        fontSize: 13.sp,
                        color: AppColors.greyColor,
                      ),
                    ),
                  )
                : Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1.5.h),
                      child: controller.productList.isNotEmpty
                          ? DynamicHeightGridView(
                              itemCount: controller.productList.length,
                              physics: BouncingScrollPhysics(),
                              crossAxisCount: 2,
                              builder: (ctx, index) {
                                return GestureDetector(
                                  onTap: () {
                                    controller.isSubCategory.value = true;
                                    controller.getCategoriesAPI(categoryId: controller.categoryList[index].id);
                                    controller.categoryName.value = controller.categoryList[index].name.toString();
                                    controller.update();
                                  },
                                  child: Card(
                                      elevation: 3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: Container(
                                              height: 25.h,
                                              child: CustomImageView(
                                                imagePath: controller.productList[index].imageUrl != null ? "${Constants.imageBaseUrl}${controller.categoryList[index].imageUrl}" : AppImages.dummy,
                                                fit: BoxFit.cover,
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
                                                    controller.productList[index].name.toString(),
                                                    maxLines: 10,
                                                    fontSize: 12.sp,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.arrow_forward,
                                                  color: AppColors.arrowColor,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 1.h),
                                        ],
                                      )),
                                );
                              },
                            )
                          : DynamicHeightGridView(
                              itemCount: controller.categoryList.length,
                              physics: BouncingScrollPhysics(),
                              crossAxisCount: 2,
                              builder: (ctx, index) {
                                return GestureDetector(
                                  onTap: () {
                                    controller.isSubCategory.value = true;
                                    controller.getCategoriesAPI(categoryId: controller.categoryList[index].id);
                                    controller.categoryName.value = controller.categoryList[index].name.toString();
                                    controller.update();
                                  },
                                  child: Card(
                                      elevation: 3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: Container(
                                              height: 25.h,
                                              child: CustomImageView(
                                                imagePath: controller.categoryList[index].imageUrl != null ? "${Constants.imageBaseUrl}${controller.categoryList[index].imageUrl}" : AppImages.dummy,
                                                fit: BoxFit.cover,
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
                                                    controller.categoryList[index].name.toString(),
                                                    maxLines: 10,
                                                    fontSize: 12.sp,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.arrow_forward,
                                                  color: AppColors.arrowColor,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 1.h),
                                        ],
                                      )),
                                );
                              },
                            ),
                    ),
                  )
          ],
        );
      },
    );
  }
}
