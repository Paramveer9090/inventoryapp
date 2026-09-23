import '../../../widgets/all_import.dart';
import 'info_row.dart';

class CategorySection extends StatelessWidget {
  final ProductDetailsController controller;
  final String? categoryName;
  final String? routedDescription;

  const CategorySection({
    Key? key,
    required this.controller,
    this.categoryName,
    this.routedDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isEditMode.value
        ? Column(
            children: [
              _buildCategoryDropdown(controller),
              SizedBox(height: 1.h),
              _buildSubCategoryDropdown(controller),
            ],
          )
        : Column(
            children: [
              if (categoryName != null && categoryName!.isNotEmpty) InfoRow('Category', categoryName!),
              InfoRow(
                'Description',
                () {
                  final routed = routedDescription?.trim();
                  if (routed != null && routed.isNotEmpty) return routed;
                  final apiDesc = controller.getDetailsData?.description?.trim();
                  if (apiDesc != null && apiDesc.isNotEmpty) return apiDesc;
                  return 'N/A';
                }(),
              ),
            ],
          ));
  }

  Widget _buildCategoryDropdown(ProductDetailsController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Category',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.blackColor,
              ),
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            flex: 3,
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.greyColor.withValues(alpha: 0.3)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: controller.selectedCategoryId.value.isEmpty ? null : controller.selectedCategoryId.value,
                  hint: Text(
                    'Select Category',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.greyColor,
                    ),
                  ),
                  isExpanded: true,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  items: controller.categoryList.map((category) {
                    return DropdownMenuItem<String>(
                      value: category.id.toString(),
                      child: Text(
                        category.name ?? 'Unknown Category',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.blackColor,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    if (value != null) {
                      controller.onCategoryChanged(value);
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubCategoryDropdown(ProductDetailsController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Sub Category',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.blackColor,
              ),
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            flex: 3,
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.greyColor.withValues(alpha: 0.3)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: controller.selectedSubCategoryId.value.isEmpty ? null : controller.selectedSubCategoryId.value,
                  hint: Text(
                    controller.subCategoryList.isEmpty ? 'Select category first' : 'Select Sub Category',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.greyColor,
                    ),
                  ),
                  isExpanded: true,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  items: controller.subCategoryList.map((subCategory) {
                    return DropdownMenuItem<String>(
                      value: subCategory.id.toString(),
                      child: Text(
                        subCategory.name ?? 'Unknown Sub Category',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.blackColor,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: controller.subCategoryList.isEmpty
                      ? null
                      : (String? value) {
                          if (value != null) {
                            controller.onSubCategoryChanged(value);
                          }
                        },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
