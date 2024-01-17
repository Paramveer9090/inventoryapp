import 'package:true_leaf_inventory_app/app/models/get_all_data_model.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class ProductsController extends GetxController {
  List<GetDataListResponseData> productList = <GetDataListResponseData>[];
  List<GetDataListResponseData> categoryList = <GetDataListResponseData>[];

  List<GetDataListResponseData> filterList = [];
  var productDetails = false.obs;
  var noData = "".obs;

  ///for sendData
  var categoryType = "".obs;
  var subCategoryType = "".obs;
  var id = "".obs;

  @override
  void onInit() {
    getProductAPI();
    getCategoriesAPI();
    super.onInit();
  }

  /// Search
  search({required String text}) async {
    if (text.trim().isEmpty) {
      productList = filterList;
    } else {
      List<GetDataListResponseData> tempList = [];
      for (int i = 0; i < filterList.length; i++) {
        if (filterList[i].name.toString().toLowerCase().contains(text.toLowerCase()) || filterList[i].categoryType!.toLowerCase().contains(text.toLowerCase()) || filterList[i].subCategoryType!.toLowerCase().contains(text.toLowerCase())) {
          tempList.add(filterList[i]);
          noData.value = "";
        } else if (tempList.isEmpty) {
          noData.value = "No result found";
        }
      }
      productList = tempList;
    }
    update();
  }

  /// Get Products
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
      productList = model.data!;
      filterList = model.data!;

      update();
    } else {
      print("In else part");
    }
  }

  /// Get Category
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
    } else {
      print("In else part");
    }
  }
}
