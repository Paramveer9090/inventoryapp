import 'package:true_leaf_inventory_app/app/models/details_response_model.dart';
import 'package:true_leaf_inventory_app/app/models/get_all_data_model.dart';
import '../../../widgets/all_import.dart';

class ProductDetailsController extends GetxController {
  final id;

  ProductDetailsController({this.id});

  GetDetailsData? getDetailsData;
  var noData = "".obs;
  
  // Edit mode and category/subcategory lists
  var isEditMode = false.obs;
  List<GetDataListResponseData> categoryList = [];
  List<GetDataListResponseData> subCategoryList = [];
  var selectedCategoryId = "".obs;
  var selectedSubCategoryId = "".obs;

  @override         
  void onInit() {
    productDetails();
    getCategoriesAPI();
    super.onInit();
  }

  /// Product Details
  productDetails() async {
    final data = await APIFunction().apiCall(
      apiName: "${Constants.products}/${id}",
      context: Get.context!,
      token: accessToken,
      type: "get",
      isLoading: false,
    );

    GetDetailsResponseModel model = GetDetailsResponseModel.fromJson(data);

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
    final data = await APIFunction().apiCall(
      apiName: "${Constants.categories}/${categoryId}",
      context: Get.context!,
      token: accessToken,
      type: "get",
      isLoading: false,
    );

    GetDataListResponseModel model = GetDataListResponseModel.fromJson(data);

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

    final body = {
      "category_id": selectedCategoryId.value,
      "sub_category_id": selectedSubCategoryId.value.isEmpty ? null : selectedSubCategoryId.value,
    };

    final data = await APIFunction().apiCall(
      apiName: "${Constants.products}/${id}",
      context: Get.context!,
      token: accessToken,
      type: "put",
      rawData: jsonEncode(body),
      isLoading: true,
    );

    if (data != null) {
      EasyLoading.showSuccess("Product updated successfully");
      isEditMode.value = false;
      // Refresh product details to show updated data
      productDetails();
      update();
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
}
