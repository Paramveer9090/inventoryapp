import 'dart:io' show Platform;
import 'package:file_selector/file_selector.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:true_leaf_inventory_app/app/models/get_all_data_model.dart';
import '../../../widgets/all_import.dart';

class AddProductController extends GetxController {
  static const String _debugTag = "[AddProductFlow]";

  // Form Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController descriptionInvoiceController = TextEditingController();
  final TextEditingController descriptionWebsiteController = TextEditingController();
  final TextEditingController sellingPriceController = TextEditingController();
  final TextEditingController maximumSellingPriceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController boxSizeController = TextEditingController();
  
  // Dropdown data
  List<GetDataListResponseData> categoryList = <GetDataListResponseData>[];
  List<GetDataListResponseData> subCategoryList = <GetDataListResponseData>[];
  List<GetDataListResponseData> taxList = <GetDataListResponseData>[];
  
  // Selected values
  var selectedCategoryId = "".obs;
  var selectedSubCategoryId = "".obs;
  var selectedTaxId = "".obs;
  var selectedCategoryName = "".obs;
  var selectedSubCategoryName = "".obs;
  var selectedTaxName = "".obs;
  
  // Status
  var selectedStatus = "active".obs;
  var isLoading = false.obs;
  
  // Image
  var selectedImagePath = "".obs;
  var selectedImageName = "".obs;
  XFile? selectedImageFile; // Store XFile object for proper file handling

  @override
  void onInit() {
    super.onInit();
    getCategoriesAPI();
    getTaxesAPI();
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    descriptionInvoiceController.dispose();
    descriptionWebsiteController.dispose();
    sellingPriceController.dispose();
    maximumSellingPriceController.dispose();
    stockController.dispose();
    boxSizeController.dispose();
    super.onClose();
  }

  /// Get Categories
  getCategoriesAPI() async {
    final data = await APIFunction().apiCall(
      apiName: "${Constants.categories}/0",
      context: Get.context!,
      token: accessToken,
      type: "get",
      isLoading: false,
    );

    GetDataListResponseModel model = GetDataListResponseModel.fromJson(data);

    if (model.data!.isNotEmpty) {
      categoryList = model.data!;
      update();
    }
  }

  /// Get SubCategories for selected category
  getSubCategoriesAPI(String categoryId) async {
    if (categoryId.isEmpty) return;
    
    final data = await APIFunction().apiCall(
      apiName: "${Constants.categories}/$categoryId",
      context: Get.context!,
      token: accessToken,
      type: "get",
      isLoading: false,
    );

    GetDataListResponseModel model = GetDataListResponseModel.fromJson(data);

    if (model.data!.isNotEmpty) {
      subCategoryList = model.data!;
      update();
    } else {
      subCategoryList.clear();
      selectedSubCategoryId.value = "";
      selectedSubCategoryName.value = "";
      update();
    }
  }

  /// Get Taxes
  getTaxesAPI() async {
    final data = await APIFunction().apiCall(
      apiName: Constants.taxes,
      context: Get.context!,
      token: accessToken,
      type: "get",
      isLoading: false,
    );

    GetDataListResponseModel model = GetDataListResponseModel.fromJson(data);

    if (model.data!.isNotEmpty) {
      taxList = model.data!;
      update();
    }
  }

  /// Select Category
  void selectCategory(String id, String name) {
    selectedCategoryId.value = id;
    selectedCategoryName.value = name;
    
    // Reset subcategory when category changes
    selectedSubCategoryId.value = "";
    selectedSubCategoryName.value = "";
    subCategoryList.clear();
    
    // Load subcategories
    getSubCategoriesAPI(id);
    update();
  }

  /// Select SubCategory
  void selectSubCategory(String id, String name) {
    selectedSubCategoryId.value = id;
    selectedSubCategoryName.value = name;
    update();
  }

  /// Select Tax
  void selectTax(String id, String name) {
    selectedTaxId.value = id;
    selectedTaxName.value = name;
    update();
  }

  /// Validate Form
  bool validateForm() {
    _debugLog("Validating form", data: {
      "name": nameController.text.trim(),
      "category_id": selectedCategoryId.value,
      "sub_category_id": selectedSubCategoryId.value,
      "tax_id": selectedTaxId.value,
      "selling_price": sellingPriceController.text.trim(),
      "stock": stockController.text.trim(),
      "image_name": selectedImageName.value,
      "image_path": selectedImagePath.value,
    });

    if (nameController.text.trim().isEmpty) {
      _debugLog("Validation failed: product name is empty");
      _showError("Please enter product name");
      return false;
    }
    
    if (selectedCategoryId.value.isEmpty) {
      _debugLog("Validation failed: category not selected");
      _showError("Please select a category");
      return false;
    }
    
    if (sellingPriceController.text.trim().isEmpty) {
      _debugLog("Validation failed: selling price is empty");
      _showError("Please enter selling price");
      return false;
    }
    
    if (stockController.text.trim().isEmpty) {
      _debugLog("Validation failed: stock is empty");
      _showError("Please enter stock quantity");
      return false;
    }

    // Validate numeric fields
    if (double.tryParse(sellingPriceController.text) == null) {
      _debugLog("Validation failed: selling price is not numeric", data: {
        "selling_price": sellingPriceController.text,
      });
      _showError("Selling price must be a valid number");
      return false;
    }

    if (int.tryParse(stockController.text) == null) {
      _debugLog("Validation failed: stock is not numeric", data: {
        "stock": stockController.text,
      });
      _showError("Stock must be a valid number");
      return false;
    }
    
    // Check if image is selected
    if (selectedImagePath.value.isEmpty) {
      _debugLog("Validation failed: image not selected");
      _showError("Please select a product image");
      return false;
    }

    _debugLog("Form validation passed");

    return true;
  }
  
  /// Show error message with better formatting
  void _showError(String message) {
    EasyLoading.showError(message, duration: Duration(seconds: 2));
  }

  /// Select Image (Platform-aware: mobile vs desktop)
  Future<void> selectImage() async {
    try {
      _debugLog("Starting image selection", data: {
        "is_web": kIsWeb,
        "is_android": !kIsWeb && Platform.isAndroid,
        "is_ios": !kIsWeb && Platform.isIOS,
        "is_desktop": !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux),
      });

      XFile? picked;
      
      // Check if running on mobile (Android/iOS)
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        // Use image_picker for mobile
        final ImagePicker picker = ImagePicker();
        
        // Show options to pick from gallery or camera
        final ImageSource? source = await _showImageSourceDialog();
        if (source == null) {
          _debugLog("Image selection cancelled: no source selected");
          return;
        }
        _debugLog("Image source selected", data: {"source": source.name});
        
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

        int? fileSize;
        try {
          fileSize = (await picked.readAsBytes()).length;
        } catch (_) {
          fileSize = null;
        }

        _debugLog("Image selected", data: {
          "name": picked.name,
          "path": picked.path,
          "size_bytes": fileSize,
        });

        update();
      } else {
        _debugLog("Image selection returned null file");
      }
    } catch (e, stackTrace) {
      _debugLog("Error selecting image", data: {
        "error_type": e.runtimeType.toString(),
        "error": e.toString(),
        "stack_trace": stackTrace.toString(),
      });
      _showError("Failed to select image");
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
  void removeImage() {
    selectedImageFile = null;
    selectedImagePath.value = "";
    selectedImageName.value = "";
    update();
  }

  /// Upload Image to Digital Ocean
  Future<String?> uploadImageAPI() async {
    try {
      _debugLog("Starting image upload", data: {
        "image_name": selectedImageName.value,
        "image_path": selectedImagePath.value,
      });

      if (selectedImageFile == null) {
        _debugLog("Upload aborted: selectedImageFile is null");
        throw Exception("No image selected");
      }

      // Read image bytes properly for all platforms
      final bytes = await selectedImageFile!.readAsBytes();
      _debugLog("Image bytes ready", data: {
        "image_name": selectedImageName.value,
        "bytes_length": bytes.length,
      });

      final imageFile = MultipartFile.fromBytes(
        bytes,
        filename: selectedImageName.value,
      );

      FormData formData = FormData.fromMap({
        "upload_image": imageFile,
      });

      _debugLog("Sending upload request", data: {
        "endpoint": Constants.uploadImage,
        "multipart_fields": formData.fields,
        "multipart_files_count": formData.files.length,
      });

      final data = await APIFunction().apiCall(
        apiName: Constants.uploadImage,
        context: Get.context!,
        token: accessToken,
        params: formData,
        isLoading: false,
      );

      if (data != null && data['data'] != null && data['data']['image_url'] != null) {
        String imageUrl = data['data']['image_url'];
        _debugLog("Image upload success", data: {
          "image_url": imageUrl,
          "raw_response": data,
        });
        return imageUrl;
      } else {
        _debugLog("Image upload response missing image_url", data: {
          "raw_response": data,
        });
        throw Exception("Invalid response from image upload");
      }
    } on DioError catch (e, stackTrace) {
      _debugLog("Dio error while uploading image", data: {
        "status_code": e.response?.statusCode,
        "status_message": e.response?.statusMessage,
        "response_data": e.response?.data,
        "request_path": e.requestOptions.path,
        "error": e.toString(),
        "stack_trace": stackTrace.toString(),
      });
      return null;
    } catch (e, stackTrace) {
      _debugLog("Error uploading image", data: {
        "error_type": e.runtimeType.toString(),
        "error": e.toString(),
        "stack_trace": stackTrace.toString(),
      });
      return null;
    }
  }

  /// Add Product API
  Future<void> addProductAPI() async {
    _debugLog("Add product flow triggered");
    if (!validateForm()) {
      _debugLog("Add product flow stopped: form invalid");
      return;
    }

    try {
      isLoading.value = true;
      _debugLog("Add product flow started");
      
      // Step 1: Upload image first and get the image_url
      EasyLoading.show(status: 'Uploading image...');
      String? uploadedImageUrl = await uploadImageAPI();
      
      if (uploadedImageUrl == null || uploadedImageUrl.isEmpty) {
        _debugLog("Add product flow failed: upload returned empty url");
        throw Exception("Failed to upload image");
      }
      
      _debugLog("Image URL received", data: {"image_url": uploadedImageUrl});
      
      // Step 2: Prepare product data with the uploaded image URL
      EasyLoading.show(status: 'Creating product...');
      
      FormData formData = FormData.fromMap({
        "name": nameController.text.trim(),
        "category_id": selectedCategoryId.value,
        "selling_price": sellingPriceController.text,
        "stock": stockController.text,
        "status": selectedStatus.value,
        "product_image": uploadedImageUrl,
        "image_url": uploadedImageUrl,
      });

      // Add optional fields if they have values
      if (selectedSubCategoryId.value.isNotEmpty) {
        formData.fields.add(MapEntry("sub_category_id", selectedSubCategoryId.value));
      }
      
      if (selectedTaxId.value.isNotEmpty) {
        formData.fields.add(MapEntry("tax_id", selectedTaxId.value));
      }
      
      if (descriptionController.text.trim().isNotEmpty) {
        formData.fields.add(MapEntry("description", descriptionController.text.trim()));
      }
      
      if (descriptionInvoiceController.text.trim().isNotEmpty) {
        formData.fields.add(MapEntry("description_invoice", descriptionInvoiceController.text.trim()));
      }
      
      if (descriptionWebsiteController.text.trim().isNotEmpty) {
        formData.fields.add(MapEntry("description_website", descriptionWebsiteController.text.trim()));
      }
      
      if (maximumSellingPriceController.text.trim().isNotEmpty) {
        formData.fields.add(MapEntry("maximum_selling_price", maximumSellingPriceController.text));
      }
      
      if (boxSizeController.text.trim().isNotEmpty) {
        formData.fields.add(MapEntry("box_size", boxSizeController.text));
      }

      _debugLog("Sending product create request", data: {
        "endpoint": Constants.products,
        "fields": formData.fields,
        "files_count": formData.files.length,
      });

      final data = await APIFunction().apiCall(
        apiName: Constants.products,
        context: Get.context!,
        token: accessToken,
        params: formData,
        isLoading: false,
      );

      isLoading.value = false;
      EasyLoading.dismiss();

      if (data != null) {
        _debugLog("Product creation success", data: {
          "raw_response": data,
        });

        final dynamic serverImage = data["data"]?["product_image"];
        if (serverImage == null || serverImage.toString().trim().isEmpty) {
          _debugLog("Warning: product created but image not persisted by server", data: {
            "server_product_image": serverImage,
            "sent_product_image": uploadedImageUrl,
            "sent_image_url": uploadedImageUrl,
          });
        }

        EasyLoading.showSuccess(
          "Product added successfully!",
          duration: Duration(seconds: 2),
        );
        
        // Navigate back and refresh product list
        Get.back();
        
        // Refresh products list if controller exists
        if (Get.isRegistered<ProductsController>()) {
          Get.find<ProductsController>().getProductAPI(isLoading: false);
        }
      } else {
        _debugLog("Product creation returned null response");
      }
    } on DioError catch (e, stackTrace) {
      isLoading.value = false;
      EasyLoading.dismiss();
      _debugLog("Dio error while creating product", data: {
        "status_code": e.response?.statusCode,
        "status_message": e.response?.statusMessage,
        "response_data": e.response?.data,
        "request_path": e.requestOptions.path,
        "error": e.toString(),
        "stack_trace": stackTrace.toString(),
      });
      
      String errorMessage = "Failed to add product";
      final String responseData = e.response?.data?.toString().toLowerCase() ?? "";
      if (responseData.contains("image") || e.requestOptions.path.contains(Constants.uploadImage)) {
        errorMessage = "Failed to upload image to server";
      } else if (e.response?.statusCode == 422 || responseData.contains("validation")) {
        errorMessage = "Please check all required fields";
      } else if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout ||
          responseData.contains("network")) {
        errorMessage = "Network error. Please try again";
      }

      EasyLoading.showError(
        errorMessage,
        duration: Duration(seconds: 3),
      );
    } catch (e, stackTrace) {
      isLoading.value = false;
      EasyLoading.dismiss();
      _debugLog("Error adding product", data: {
        "error_type": e.runtimeType.toString(),
        "error": e.toString(),
        "stack_trace": stackTrace.toString(),
      });
      
      String errorMessage = "Failed to add product";
      if (e.toString().contains("Failed to upload image")) {
        errorMessage = "Failed to upload image to server";
      } else if (e.toString().contains("422")) {
        errorMessage = "Please check all required fields";
      } else if (e.toString().contains("network")) {
        errorMessage = "Network error. Please try again";
      }
      
      EasyLoading.showError(
        errorMessage,
        duration: Duration(seconds: 3),
      );
    }
  }

  void _debugLog(String message, {Map<String, dynamic>? data}) {
    debugPrint("$_debugTag $message");
    if (data != null && data.isNotEmpty) {
      data.forEach((key, value) {
        debugPrint("$_debugTag   $key: $value");
      });
    }
  }

  /// Clear Form
  void clearForm() {
    nameController.clear();
    descriptionController.clear();
    descriptionInvoiceController.clear();
    descriptionWebsiteController.clear();
    sellingPriceController.clear();
    maximumSellingPriceController.clear();
    stockController.clear();
    boxSizeController.clear();
    selectedCategoryId.value = "";
    selectedSubCategoryId.value = "";
    selectedTaxId.value = "";
    selectedCategoryName.value = "";
    selectedSubCategoryName.value = "";
    selectedTaxName.value = "";
    selectedStatus.value = "active";
    selectedImageFile = null;
    selectedImagePath.value = "";
    selectedImageName.value = "";
    subCategoryList.clear();
    update();
  }
}
