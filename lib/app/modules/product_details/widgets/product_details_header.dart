import '../../../widgets/all_import.dart';

class ProductDetailsHeader extends StatelessWidget {
  final ProductDetailsController controller;
  final String? title;

  const ProductDetailsHeader({
    Key? key,
    required this.controller,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Get.find<ProductsController>().productDetails.value = false;
              Get.find<HomeController>().update();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColors.primaryColor,
            ),
            tooltip: 'Back to Products',
          ),
          SizedBox(width: 1.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? 'Product Details',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                ),
                if (controller.getDetailsData?.name != null)
                  Text(
                    controller.getDetailsData!.name!,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.greyColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          Obx(() => controller.isEditMode.value
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => controller.updateProductCategory(),
                      icon: Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                      tooltip: 'Save Changes',
                    ),
                    IconButton(
                      onPressed: () => controller.cancelEdit(),
                      icon: Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                      tooltip: 'Cancel',
                    ),
                  ],
                )
              : IconButton(
                  onPressed: () => controller.toggleEditMode(),
                  icon: Icon(
                    Icons.edit,
                    color: AppColors.primaryColor,
                  ),
                  tooltip: 'Edit Category',
                )),
        ],
      ),
    );
  }
}
