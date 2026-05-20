import 'dart:io';

import '../../../utils/responsive_helper.dart';
import '../../../widgets/all_import.dart';
import '../controllers/add_product_controller.dart';

class AddProductView extends GetView<AddProductController> {
  const AddProductView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddProductController>(
      init: AddProductController(),
      builder: (controller) {
        return GestureDetector(
          onTap: () => utils.hideKeyboard(context),
          child: Scaffold(
            backgroundColor: AppColors.greyLightColor,
            body: SafeArea(
              child: Column(
                children: [
                  // Header
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
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: AppColors.blackColor),
                          onPressed: () => Get.back(),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          AppStrings.addProduct,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context, 14.sp, 18.sp),
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Form Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(2.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Name (Required)
                          _buildSectionTitle("Product Information", required: true),
                          SizedBox(height: 1.h),
                          _buildTextField(
                            controller: controller.nameController,
                            label: "Product Name *",
                            hint: "Enter product name",
                            icon: Icons.inventory_2_outlined,
                          ),
                          SizedBox(height: 2.h),

                          // Product Image (Required)
                          _buildSectionTitle("Product Image *", required: true),
                          SizedBox(height: 1.h),
                          Obx(() => GestureDetector(
                            onTap: () => controller.selectImage(),
                            child: Container(
                              padding: EdgeInsets.all(2.h),
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: controller.selectedImagePath.value.isEmpty
                                      ? AppColors.greyColor.withValues(alpha: 0.3)
                                      : AppColors.primaryColor,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withValues(alpha: 0.1),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                              child: controller.selectedImagePath.value.isEmpty
                                  ? Column(
                                      children: [
                                        Icon(
                                          Icons.add_photo_alternate_outlined,
                                          size: 50,
                                          color: AppColors.primaryColor,
                                        ),
                                        SizedBox(height: 1.h),
                                        Text(
                                          "Tap to select product image",
                                          style: TextStyle(
                                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                                                context, 11.sp, 13.sp),
                                            color: AppColors.greyColor,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Stack(
                                      children: [
                                        Column(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
                                              child: Image.file(
                                                File(controller.selectedImagePath.value),
                                                height: 150,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            SizedBox(height: 1.h),
                                            Text(
                                              controller.selectedImageName.value,
                                              style: TextStyle(
                                                fontSize: ResponsiveHelper.getResponsiveFontSize(
                                                    context, 10.sp, 12.sp),
                                                color: AppColors.blackColor,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: GestureDetector(
                                            onTap: () => controller.removeImage(),
                                            child: Container(
                                              padding: EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          )),
                          SizedBox(height: 2.h),

                          // Category Selection (Required)
                          _buildSectionTitle("Category *", required: true),
                          SizedBox(height: 1.h),
                          Obx(() => _buildDropdownField(
                            context: context,
                            label: "Select Category *",
                            value: controller.selectedCategoryName.value.isEmpty
                                ? null
                                : controller.selectedCategoryName.value,
                            icon: Icons.category_outlined,
                            onTap: () => _showCategoryDialog(context, controller),
                          )),
                          SizedBox(height: 2.h),

                          // SubCategory Selection (Optional)
                          Obx(() {
                            if (controller.selectedCategoryId.value.isNotEmpty &&
                                controller.subCategoryList.isNotEmpty) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSectionTitle("Sub Category (Optional)"),
                                  SizedBox(height: 1.h),
                                  _buildDropdownField(
                                    context: context,
                                    label: "Select Sub Category",
                                    value: controller.selectedSubCategoryName.value.isEmpty
                                        ? null
                                        : controller.selectedSubCategoryName.value,
                                    icon: Icons.subdirectory_arrow_right,
                                    onTap: () => _showSubCategoryDialog(context, controller),
                                  ),
                                  SizedBox(height: 2.h),
                                ],
                              );
                            }
                            return SizedBox.shrink();
                          }),

                          // Pricing Information
                          _buildSectionTitle("Pricing & Stock *", required: true),
                          SizedBox(height: 1.h),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  controller: controller.sellingPriceController,
                                  label: "Selling Price *",
                                  hint: "0.00",
                                  icon: Icons.attach_money,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                child: _buildTextField(
                                  controller: controller.maximumSellingPriceController,
                                  label: "Max Price",
                                  hint: "0.00",
                                  icon: Icons.price_change_outlined,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),

                          // Stock & Box Size
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  controller: controller.stockController,
                                  label: "Stock Quantity *",
                                  hint: "0",
                                  icon: Icons.inventory_outlined,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                child: _buildTextField(
                                  controller: controller.boxSizeController,
                                  label: "Box Size",
                                  hint: "0",
                                  icon: Icons.shopping_bag_outlined,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),

                          // Tax Selection
                          _buildSectionTitle("Tax (Optional)"),
                          SizedBox(height: 1.h),
                          Obx(() => _buildDropdownField(
                            context: context,
                            label: "Select Tax",
                            value: controller.selectedTaxName.value.isEmpty
                                ? null
                                : controller.selectedTaxName.value,
                            icon: Icons.percent,
                            onTap: () => _showTaxDialog(context, controller),
                          )),
                          SizedBox(height: 2.h),

                          // Descriptions
                          _buildSectionTitle("Descriptions (Optional)"),
                          SizedBox(height: 1.h),
                          _buildTextField(
                            controller: controller.descriptionController,
                            label: "Description",
                            hint: "Enter product description",
                            icon: Icons.description_outlined,
                            maxLines: 3,
                          ),
                          SizedBox(height: 2.h),
                          
                          _buildTextField(
                            controller: controller.descriptionInvoiceController,
                            label: "Invoice Description",
                            hint: "Description for invoices",
                            icon: Icons.receipt_outlined,
                            maxLines: 2,
                          ),
                          SizedBox(height: 2.h),
                          
                          _buildTextField(
                            controller: controller.descriptionWebsiteController,
                            label: "Website Description",
                            hint: "Description for website",
                            icon: Icons.web_outlined,
                            maxLines: 2,
                          ),
                          SizedBox(height: 2.h),

                          // Status
                          _buildSectionTitle("Status"),
                          SizedBox(height: 1.h),
                          Obx(() => Container(
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.1),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                            child: SwitchListTile(
                              title: Text(
                                controller.selectedStatus.value == "active"
                                    ? "Active"
                                    : "Inactive",
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                                      context, 11.sp, 14.sp),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                "Product will be ${controller.selectedStatus.value == 'active' ? 'visible' : 'hidden'} in inventory",
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                                      context, 9.sp, 11.sp),
                                  color: AppColors.greyColor,
                                ),
                              ),
                              value: controller.selectedStatus.value == "active",
                              onChanged: (value) {
                                controller.selectedStatus.value =
                                    value ? "active" : "inactive";
                              },
                              activeThumbColor: AppColors.primaryColor,
                            ),
                          )),
                          SizedBox(height: 3.h),

                          // Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    controller.clearForm();
                                  },
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    side: BorderSide(color: AppColors.greyColor),
                                  ),
                                  child: Text(
                                    "Clear",
                                    style: TextStyle(
                                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                                          context, 11.sp, 14.sp),
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.greyColor,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                flex: 2,
                                child: Obx(() => ElevatedButton(
                                  onPressed: controller.isLoading.value
                                      ? null
                                      : () => controller.addProductAPI(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 2,
                                  ),
                                  child: controller.isLoading.value
                                      ? SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                                AppColors.whiteColor),
                                          ),
                                        )
                                      : Text(
                                          "Add Product",
                                          style: TextStyle(
                                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                                                context, 11.sp, 14.sp),
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.whiteColor,
                                          ),
                                        ),
                                )),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, {bool required = false}) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.blackColor,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: AppColors.primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppColors.whiteColor,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required BuildContext context,
    required String label,
    required String? value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 3,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryColor),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                value ?? label,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context, 11.sp, 14.sp),
                  color: value == null ? AppColors.greyColor : AppColors.blackColor,
                  fontWeight: value == null ? FontWeight.w400 : FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.arrow_drop_down, color: AppColors.greyColor),
          ],
        ),
      ),
    );
  }

  void _showCategoryDialog(BuildContext context, AddProductController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Category"),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: controller.categoryList.length,
              itemBuilder: (context, index) {
                final category = controller.categoryList[index];
                return ListTile(
                  title: Text(category.name ?? ""),
                  onTap: () {
                    controller.selectCategory(
                      category.id.toString(),
                      category.name ?? "",
                    );
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showSubCategoryDialog(BuildContext context, AddProductController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Sub Category"),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: controller.subCategoryList.length,
              itemBuilder: (context, index) {
                final subCategory = controller.subCategoryList[index];
                return ListTile(
                  title: Text(subCategory.name ?? ""),
                  onTap: () {
                    controller.selectSubCategory(
                      subCategory.id.toString(),
                      subCategory.name ?? "",
                    );
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showTaxDialog(BuildContext context, AddProductController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Tax"),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: controller.taxList.length,
              itemBuilder: (context, index) {
                final tax = controller.taxList[index];
                return ListTile(
                  title: Text(tax.title ?? ""),
                  subtitle: Text("${tax.tax}%"),
                  onTap: () {
                    controller.selectTax(
                      tax.id.toString(),
                      "${tax.title} (${tax.tax}%)",
                    );
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
