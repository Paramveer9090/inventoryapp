import 'dart:io';

import '../../../widgets/all_import.dart';

class ProductImageCard extends StatelessWidget {
  final ProductDetailsController controller;

  const ProductImageCard({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Stack(
          children: [
            GestureDetector(
              onTap: controller.isEditMode.value
                  ? null
                  : () {
                      if (controller.getDetailsData?.imageUrl != null && !controller.isImageChanged.value) {
                        showDialog(
                          context: Get.context!,
                          builder: (BuildContext dialogContext) {
                            return Dialog(
                              backgroundColor: Colors.black,
                              insetPadding: EdgeInsets.zero,
                              child: Stack(
                                children: [
                                  Center(
                                    child: OptimizedNetworkImage(
                                      imageUrl: '${Constants.imageBaseUrl}${controller.getDetailsData!.imageUrl}',
                                      width: double.infinity,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
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
            if (controller.isEditMode.value)
              Positioned(
                bottom: 16,
                right: 16,
                child: Row(
                  children: [
                    if (controller.isImageChanged.value && controller.selectedImagePath.value.isNotEmpty)
                      FloatingActionButton.small(
                        heroTag: 'remove_image',
                        onPressed: () => controller.removeSelectedImage(),
                        backgroundColor: Colors.red,
                        child: Icon(Icons.close, color: Colors.white),
                      ),
                    SizedBox(width: 8),
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
        ));
  }
}
