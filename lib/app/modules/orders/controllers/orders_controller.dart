import 'package:true_leaf_inventory_app/app/models/get_all_data_model.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class OrdersController extends GetxController {
  List<GetDataListResponseData> categoryList = <GetDataListResponseData>[];
  List<GetDataListResponseData> productList = <GetDataListResponseData>[];
  List<GetDataListResponseData> tempProductList = <GetDataListResponseData>[];

  var isSubCategory = false.obs;
  var categoryName = "".obs;
  var noData = "".obs;

  @override
  void onInit() {
    getCategoriesAPI(categoryId: "0");
    getProductAPI();
    super.onInit();
  }

  /// Get Category

  getCategoriesAPI({bool isLoading = true, required categoryId}) async {
    categoryList.clear();
    update();
    final data = await APIFunction().apiCall(
      apiName: "${Constants.categories}/${categoryId}",
      context: Get.context!,
      token: accessToken,
      type: "get",
      isLoading: isLoading,
    );

    GetDataListResponseModel model = GetDataListResponseModel.fromJson(data);

    if (model.data!.isNotEmpty) {
      categoryList = model.data!;
      noData.value = "";
      update();
    } else {
      noData.value = "No data found";
      getProduct(subCategoryId: categoryId, type: "category");
      update();
    }
  }

  getProductAPI({bool isLoading = true}) async {
    final data = await APIFunction().apiCall(
      apiName: Constants.products,
      context: Get.context!,
      token: accessToken,
      type: "get",
      isLoading: isLoading,
    );

    GetDataListResponseModel model = GetDataListResponseModel.fromJson(data);

    if (model.data!.isNotEmpty) {
      tempProductList = model.data!;
      update();
    } else {
      print("In else part");
    }
  }

  getProduct({required var subCategoryId, type}) {
    print(subCategoryId);
    print(type);
    print("productListproductListproductList");
    if (productList.isNotEmpty) {
      productList.clear();
    }
    print("tempProductList $tempProductList");
    for (int i = 0; i < tempProductList.length; i++) {
      if (tempProductList[i].subCategoryId.toString() == subCategoryId.toString() && tempProductList[i].subCategoryId != null && type == "subCategory") {
        productList.add(
          GetDataListResponseData(
            id: tempProductList[i].id,
            name: tempProductList[i].name,
            sellingPrice: tempProductList[i].sellingPrice,
            stock: tempProductList[i].stock,
            createdAt: tempProductList[i].createdAt,
            updatedAt: tempProductList[i].updatedAt,
            deletedAt: tempProductList[i].deletedAt,
            categoryId: tempProductList[i].categoryId,
            maximumSellingPrice: tempProductList[i].maximumSellingPrice,
            boxSize: tempProductList[i].boxSize,
            imageUrl: tempProductList[i].imageUrl,
            taxId: tempProductList[i].taxId,
            subCategoryId: tempProductList[i].subCategoryId,
            productImage: tempProductList[i].productImage,
          ),
        );
        update();
      } else if (tempProductList[i].categoryId.toString() == subCategoryId.toString() && tempProductList[i].categoryId != null && type == "category") {
        productList.add(
          GetDataListResponseData(
            id: tempProductList[i].id,
            name: tempProductList[i].name,
            sellingPrice: tempProductList[i].sellingPrice,
            stock: tempProductList[i].stock,
            createdAt: tempProductList[i].createdAt,
            updatedAt: tempProductList[i].updatedAt,
            deletedAt: tempProductList[i].deletedAt,
            categoryId: tempProductList[i].categoryId,
            maximumSellingPrice: tempProductList[i].maximumSellingPrice,
            boxSize: tempProductList[i].boxSize,
            imageUrl: tempProductList[i].imageUrl,
            taxId: tempProductList[i].taxId,
            subCategoryId: tempProductList[i].subCategoryId,
            productImage: tempProductList[i].productImage,
          ),
        );
        update();
      }
    }
    print(productList.length);
    print("productListproductList");
  }
}
