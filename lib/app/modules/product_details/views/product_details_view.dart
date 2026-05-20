import 'dart:io';

import '../../../widgets/all_import.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  final String? id;
  final String? categoryName;
  final String? subCategoryName;
  final String? description; // optional routed description (e.g., description_invoice)

  const ProductDetailsView({
    Key? key, 
    this.id, 
    this.categoryName, 
    this.subCategoryName,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductDetailsController>(
      init: ProductDetailsController(id: id),
      assignId: true,
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.greyLightColor,
          body: SafeArea(
            child: Column(
              children: [
                // Header with Back Button
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
                        onPressed: () {
                          // Go back to products list
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
                              'Product Details',
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
                      // Edit/Save/Cancel buttons
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
                          ),
                      ),
                    ],
                  ),
                ),
                
                // Content Area
                Expanded(
                  child: controller.getDetailsData == null
                      ? _buildLoadingState()
                      : _buildProductDetails(controller),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primaryColor,
          ),
          SizedBox(height: 2.h),
          Text(
            'Loading product details...',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.greyColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetails(ProductDetailsController controller) {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 2.h),
      children: [
        // Product Image Card
        Obx(() => Stack(
          children: [
            GestureDetector(
              onTap: controller.isEditMode.value 
                ? null  // Disable tap in edit mode
                : () {
                    // Show full-screen image viewer (only for current image)
                    if (controller.getDetailsData?.imageUrl != null && !controller.isImageChanged.value) {
                      showDialog(
                        context: Get.context!,
                        builder: (BuildContext dialogContext) {
                          return Dialog(
                            backgroundColor: Colors.black,
                            insetPadding: EdgeInsets.zero,
                            child: Stack(
                              children: [
                                // Full screen image with zoom capability
                                Center(
                                  child: InteractiveViewer(
                                    minScale: 0.5,
                                    maxScale: 4.0,
                                    child: OptimizedNetworkImage(
                                      imageUrl: '${Constants.imageBaseUrl}${controller.getDetailsData!.imageUrl}',
                                      width: double.infinity,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                // Close button
                                Positioned(
                                  top: 40,
                                  right: 20,
                                  child: IconButton(
                                    icon: Icon(Icons.close, color: Colors.white, size: 30),
                                    onPressed: () => Navigator.of(dialogContext).pop(),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Container(
                  height: 25.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.greyLightColor,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: controller.isImageChanged.value && controller.selectedImagePath.value.isNotEmpty
                      ? Stack(
                          children: [
                            Image.file(
                              File(controller.selectedImagePath.value),
                              width: double.infinity,
                              height: 25.h,
                              fit: BoxFit.contain,
                            ),
                            // New image indicator
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'NEW IMAGE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : (controller.getDetailsData?.imageUrl != null)
                          ? OptimizedNetworkImage(
                              imageUrl: '${Constants.imageBaseUrl}${controller.getDetailsData!.imageUrl}',
                              width: double.infinity,
                              height: 25.h,
                              fit: BoxFit.contain,
                            )
                          : Container(
                              width: double.infinity,
                              height: 25.h,
                              color: AppColors.greyLightColor,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 60,
                                    color: AppColors.greyColor,
                                  ),
                                  SizedBox(height: 1.h),
                                  Text(
                                    'No Image',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.greyColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  if (controller.isEditMode.value)
                                    Padding(
                                      padding: EdgeInsets.only(top: 0.5.h),
                                      child: Text(
                                        'Click "Add Image" below',
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          color: AppColors.greyColor,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                  ),
                ),
              ),
            ),
            // Edit/Remove/Add image buttons (only in edit mode)
            if (controller.isEditMode.value)
              Positioned(
                bottom: 16,
                right: 16,
                child: Row(
                  children: [
                    // Remove new image button (only if new image selected)
                    if (controller.isImageChanged.value && controller.selectedImagePath.value.isNotEmpty)
                      FloatingActionButton.small(
                        heroTag: 'remove_image',
                        onPressed: () => controller.removeSelectedImage(),
                        backgroundColor: Colors.red,
                        child: Icon(Icons.close, color: Colors.white),
                      ),
                    SizedBox(width: 8),
                    // Add/Change/Edit image button
                    FloatingActionButton.extended(
                      heroTag: 'select_image',
                      onPressed: () => controller.selectProductImage(),
                      backgroundColor: AppColors.primaryColor,
                      icon: Icon(
                        controller.getDetailsData?.imageUrl == null
                          ? Icons.add_photo_alternate
                          : (controller.isImageChanged.value ? Icons.refresh : Icons.edit),
                        color: Colors.white,
                      ),
                      label: Text(
                        controller.getDetailsData?.imageUrl == null
                          ? 'Add Image'
                          : (controller.isImageChanged.value ? 'Change Image' : 'Edit Image'),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        )),

        SizedBox(height: 2.h),

        // Product Information Cards
        _buildInfoCard('Basic Information', [
          _buildInfoRow('Name', controller.getDetailsData?.name ?? 'N/A'),
          _buildCategorySection(controller),
        ]),

        SizedBox(height: 1.h),

        _buildInfoCard('Pricing & Stock', [
          _buildInfoRow(
            'Price', 
            '\$${controller.getDetailsData?.sellingPrice?.toString() ?? 'N/A'}',
          ),
          _buildInfoRow(
            'Stock', 
            controller.getDetailsData?.stock?.toString() ?? 'N/A',
            valueColor: (controller.getDetailsData?.stock ?? 0) > 0 
                ? Colors.green 
                : Colors.red,
          ),
          _buildInfoRow(
            'Box Size', 
            controller.getDetailsData?.boxSize?.toString() ?? 'N/A',
          ),
        ]),

        SizedBox(height: 3.h),
      ],
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(height: 1.h),
            Divider(color: AppColors.greyLightColor),
            SizedBox(height: 1.h),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label, 
    String value, {
    Color? valueColor,
    bool isPrice = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
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
            child: Text(
              value,
              style: TextStyle(
                fontSize: isPrice ? 14.sp : 13.sp,
                fontWeight: isPrice ? FontWeight.w600 : FontWeight.normal,
                color: valueColor ?? AppColors.greyColor,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(ProductDetailsController controller) {
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
            if (categoryName != null && categoryName!.isNotEmpty)
              _buildInfoRow('Category', categoryName!),
            _buildInfoRow(
              'Description',
              () {
                final routed = description?.trim();
                if (routed != null && routed.isNotEmpty) return routed; // prefer description_invoice routed in
                final apiDesc = controller.getDetailsData?.description?.trim();
                if (apiDesc != null && apiDesc.isNotEmpty) return apiDesc;
                return 'N/A';
              }(),
            ),
          ],
        ),
    );
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
                  value: controller.selectedCategoryId.value.isEmpty 
                    ? null 
                    : controller.selectedCategoryId.value,
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
                  value: controller.selectedSubCategoryId.value.isEmpty 
                    ? null 
                    : controller.selectedSubCategoryId.value,
                  hint: Text(
                    controller.subCategoryList.isEmpty 
                      ? 'Select category first' 
                      : 'Select Sub Category',
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
