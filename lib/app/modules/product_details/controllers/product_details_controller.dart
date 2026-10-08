import 'dart:io' show Platform;
import 'package:file_selector/file_selector.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:true_leaf_inventory_app/app/models/details_response_model.dart';
import 'package:true_leaf_inventory_app/app/models/get_all_data_model.dart';
import 'package:true_leaf_inventory_app/app/modules/product_details/repositories/product_details_repository.dart';
import '../../../widgets/all_import.dart';

class ProductDetailsController extends GetxController {
  ProductDetailsController({this.id, ProductDetailsRepository? repository})
      : _repository = repository ?? ApiProductDetailsRepository();

  final id;
  final ProductDetailsRepository _repository;

  GetDetailsData? getDetailsData;
  var noData = "".obs;

  // Edit mode and category/subcategory lists
  var isEditMode = false.obs;
  List<GetDataListResponseData> categoryList = [];
  List<GetDataListResponseData> subCategoryList = [];
  var selectedCategoryId = "".obs;
  var selectedSubCategoryId = "".obs;

  // Image editing
  var selectedImagePath = "".obs;
  var selectedImageName = "".obs;
  var isImageChanged = false.obs;
  XFile? selectedImageFile; // Store XFile object for proper file handling

  @override
  void onInit() {
    productDetails();
    getCategoriesAPI();
    super.onInit();
  }

  /// Product Details
  productDetails() async {
    final model = await _repository.fetchProductDetails(id.toString());

    if (model.data != null) {
      getDetailsData = model.data!;
      // Set initial selected values
      selectedCategoryId.value = getDetailsData?.categoryId?.toString() ?? "";
        selectedSubCategoryId.value = getDetailsData?.subCategoryId?.toString() ?? "";
      noData.value = "";
      update();
    } else {
      noData.value = "No data found";
      update();
    }
  }

  /// Get Categories
  getCategoriesAPI() async {
    final model = await _repository.fetchCategories();

    if (model.data!.isNotEmpty) {
      categoryList = model.data!;
      update();
    }
  }

  /// Get SubCategories for selected category
  getSubCategoriesAPI(String categoryId) async {
    final model = await _repository.fetchSubCategories(categoryId);

    if (model.data!.isNotEmpty) {
      subCategoryList = model.data!;
      update();
    }
  }

  /// Update product category and subcategory
  updateProductCategory() async {
    if (selectedCategoryId.value.isEmpty) {
      EasyLoading.showError("Please select a category");
      return;
    }

    // If image has changed, update with image
    if (isImageChanged.value && selectedImagePath.value.isNotEmpty) {
      await updateProductWithImage();
    } else {
      // Update only category/subcategory
      await updateProductCategoryOnly();
    }
  }

  /// Upload Image to Digital Ocean
  Future<String?> uploadImageAPI() async {
    try {
      if (selectedImageFile == null) {
        throw Exception("No image selected");
      }

      print("Uploading image to Digital Ocean: ${selectedImageName.value}");
      final imageUrl = await _repository.uploadProductImage(
        selectedImageFile!,
        selectedImageName.value,
      );

      if (imageUrl != null && imageUrl.isNotEmpty) {
        print("Image uploaded successfully: $imageUrl");
        return imageUrl;
      } else {
        throw Exception("Invalid response from image upload");
      }
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  /// Update product category without image
  Future<void> updateProductCategoryOnly() async {
    final body = {
      "category_id": selectedCategoryId.value,
        "sub_category_id": selectedSubCategoryId.value.isEmpty ? null : selectedSubCategoryId.value,
    };

    final data = await _repository.updateProduct(id.toString(), body);

    if (data != null) {
      EasyLoading.showSuccess("Product updated successfully");
      isEditMode.value = false;
      isImageChanged.value = false;
      selectedImagePath.value = "";
      selectedImageName.value = "";
      // Refresh product details to show updated data
      productDetails();
      // Refresh products list if controller exists
      if (Get.isRegistered<ProductsController>()) {
        Get.find<ProductsController>().getProductAPI(isLoading: false);
      }
      update();
    }
  }

  /// Update product with image
  Future<void> updateProductWithImage() async {
    try {
      // Step 1: Upload image first and get the image_url
      EasyLoading.show(status: 'Uploading image...');
      String? uploadedImageUrl = await uploadImageAPI();

      if (uploadedImageUrl == null || uploadedImageUrl.isEmpty) {
        throw Exception("Failed to upload image");
      }

      print("Image URL received: $uploadedImageUrl");

      // Step 2: Update product with category and uploaded image URL
      EasyLoading.show(status: 'Updating product...');

      final body = {
        "category_id": selectedCategoryId.value,
        "image_url": uploadedImageUrl, // Use the uploaded image filename
      };

      // Add subcategory if selected
      if (selectedSubCategoryId.value.isNotEmpty) {
        body["sub_category_id"] = selectedSubCategoryId.value;
      }

      final data = await _repository.updateProduct(
        id.toString(),
        body,
        isLoading: false,
      );

      EasyLoading.dismiss();

      if (data != null) {
        EasyLoading.showSuccess("Product updated with new image!");
        isEditMode.value = false;
        isImageChanged.value = false;
        selectedImageFile = null;
        selectedImagePath.value = "";
        selectedImageName.value = "";
        // Refresh product details to show updated data
        productDetails();
        // Refresh products list if controller exists
        if (Get.isRegistered<ProductsController>()) {
          Get.find<ProductsController>().getProductAPI(isLoading: false);
        }
        update();
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("Error updating product with image: $e");

      String errorMessage = "Failed to update product image";
      if (e.toString().contains("Failed to upload image")) {
        errorMessage = "Failed to upload image to server";
      }

      EasyLoading.showError(errorMessage);
    }
  }

  /// Toggle edit mode
  toggleEditMode() {
    isEditMode.value = !isEditMode.value;
    if (isEditMode.value && selectedCategoryId.value.isNotEmpty) {
      // Load subcategories for current category
      getSubCategoriesAPI(selectedCategoryId.value);
    }
    update();
  }

  /// Cancel edit mode and reset selections
  cancelEdit() {
    isEditMode.value = false;
    selectedCategoryId.value = getDetailsData?.categoryId?.toString() ?? "";
    selectedSubCategoryId.value = getDetailsData?.subCategoryId?.toString() ?? "";
    selectedImageFile = null;
    selectedImagePath.value = "";
    selectedImageName.value = "";
    isImageChanged.value = false;
    subCategoryList.clear();
    update();
  }

  /// Handle category selection change
  onCategoryChanged(String categoryId) {
    selectedCategoryId.value = categoryId;
    selectedSubCategoryId.value = ""; // Reset subcategory
    subCategoryList.clear();
    if (categoryId.isNotEmpty) {
      getSubCategoriesAPI(categoryId);
    }
    update();
  }

  /// Handle subcategory selection change
  onSubCategoryChanged(String subCategoryId) {
    selectedSubCategoryId.value = subCategoryId;
    update();
  }

  /// Select new image for product (Platform-aware: mobile vs desktop)
  Future<void> selectProductImage() async {
    try {
      XFile? picked;

      // Check if running on mobile (Android/iOS)
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        // Use image_picker for mobile
        final ImagePicker picker = ImagePicker();

        // Show options to pick from gallery or camera
        final ImageSource? source = await _showImageSourceDialog();
        if (source == null) return; // User cancelled

        picked = await picker.pickImage(
          source: source,
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 85,
        );
      } else {
        // Use file_selector for desktop/web
        final typeGroup = XTypeGroup(
          label: 'images',
          extensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'],
        );
        picked = await openFile(acceptedTypeGroups: [typeGroup]);
      }

      if (picked != null) {
        selectedImageFile = picked; // Store the XFile object
        selectedImagePath.value = picked.path;
        selectedImageName.value = picked.name;
        isImageChanged.value = true;
        update();
      }
    } catch (e) {
      print("Error selecting image: $e");
      EasyLoading.showError("Failed to select image");
    }
  }

  /// Show dialog to choose image source (Gallery or Camera) - for mobile only
  Future<ImageSource?> _showImageSourceDialog() async {
    return await Get.dialog<ImageSource>(
      AlertDialog(
        title: Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library, color: AppColors.primaryColor),
              title: Text('Gallery'),
              onTap: () => Get.back(result: ImageSource.gallery),
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: AppColors.primaryColor),
              title: Text('Camera'),
              onTap: () => Get.back(result: ImageSource.camera),
            ),
          ],
        ),
      ),
    );
  }

  /// Remove selected image
  void removeSelectedImage() {
    selectedImageFile = null;
    selectedImagePath.value = "";
    selectedImageName.value = "";
    isImageChanged.value = false;
    update();
  }
}
