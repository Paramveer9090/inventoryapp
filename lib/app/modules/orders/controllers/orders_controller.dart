import 'package:true_leaf_inventory_app/app/models/get_all_data_model.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class OrdersController extends GetxController {
  List<GetDataListResponseData> categoryList = <GetDataListResponseData>[];
  List<GetDataListResponseData> productList = <GetDataListResponseData>[];
  List<GetDataListResponseData> tempProductList = <GetDataListResponseData>[];
  List<OrderItemResponseData> orderItemList = <OrderItemResponseData>[];

  var isProduct = false.obs;
  var isSubCategory = false.obs;
  var isCategory = true.obs;
  var categoryName = "".obs;
  var noData = "".obs;
  var orderTotal = "".obs;
  var orderTax = "".obs;
  var orderFinalTotal = "".obs;

  @override
  void onInit() {
    getCategoriesAPI(categoryId: "0");
    getProductAPI();
    super.onInit();
  }

  /// Get Category

  getCategoriesAPI({bool isLoading = true, required categoryId}) async {
    categoryList.clear();
    if (productList.isNotEmpty) {
      productList.clear();
    }
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
      print("sub category get thy 6e");
      noData.value = "";
      update();
    } else {
      isSubCategory.value = false;
      isCategory.value = false;
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
    isProduct.value = true;
    print("product get thy 6e");
    if (productList.isNotEmpty) {
      productList.clear();
    }
    if (categoryList.isNotEmpty) {
      categoryList.clear();
    }
    update();
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
            isEdit: false,
            imageUrl: tempProductList[i].imageUrl,
            taxId: tempProductList[i].taxId,
            subCategoryId: tempProductList[i].subCategoryId,
            productImage: tempProductList[i].productImage,
            quantityCount: TextEditingController(text: "0"),
            isUnitSelected: 1,
            taxDetail: Tax(
              tax: tempProductList[i].taxDetail!.tax,
            ),
          ),
        );
        orderItemList.add(OrderItemResponseData(
          boxUnit: tempProductList[i].isUnitSelected,
        ));
        update();
      } else if (tempProductList[i].categoryId.toString() == subCategoryId.toString() && tempProductList[i].categoryId != null && type == "category") {
        productList.add(
          GetDataListResponseData(
            id: tempProductList[i].id,
            name: tempProductList[i].name,
            sellingPrice: tempProductList[i].sellingPrice,
            stock: tempProductList[i].stock,
            quantityCount: TextEditingController(text: "0"),
            createdAt: tempProductList[i].createdAt,
            updatedAt: tempProductList[i].updatedAt,
            deletedAt: tempProductList[i].deletedAt,
            categoryId: tempProductList[i].categoryId,
            isEdit: false,
            maximumSellingPrice: tempProductList[i].maximumSellingPrice,
            boxSize: tempProductList[i].boxSize,
            imageUrl: tempProductList[i].imageUrl,
            taxId: tempProductList[i].taxId,
            subCategoryId: tempProductList[i].subCategoryId,
            isUnitSelected: 1,
            productImage: tempProductList[i].productImage,
            taxDetail: Tax(
              tax: tempProductList[i].taxDetail!.tax,
            ),
          ),
        );
        orderItemList.add(OrderItemResponseData(
          boxUnit: tempProductList[i].isUnitSelected,
        ));
        update();
      }
    }
  }
}

/// model
class OrderItemResponseData {
  String? categoryName;
  String? category_id;
  String? subCategoryName;
  String? sub_category_id;
  String? productName;
  String? product_id;
  String? boxSize;
  TextEditingController? stock;
  TextEditingController? quality;
  TextEditingController? salesPrice;
  TextEditingController? minSellingPrice;
  TextEditingController? maxSellingPrice;
  int boxUnit;
  int? tax;
  String? taxId;
  String? taxData;
  String? amountWithoutTax;
  String? amountOnlyTax;

  OrderItemResponseData({
    this.categoryName,
    this.category_id,
    this.amountWithoutTax,
    this.subCategoryName,
    this.amountOnlyTax,
    this.stock,
    this.product_id,
    this.boxSize,
    this.taxData,
    this.sub_category_id,
    this.productName,
    this.taxId,
    this.minSellingPrice,
    this.maxSellingPrice,
    this.boxUnit = 1,
    this.quality,
    this.salesPrice,
    this.tax,
  });
}
