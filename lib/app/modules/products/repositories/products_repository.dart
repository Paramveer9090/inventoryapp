import 'package:true_leaf_inventory_app/app/models/get_all_data_model.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

abstract class ProductsRepository {
  Future<GetDataListResponseModel> fetchProducts();
  Future<GetDataListResponseModel> fetchCategories();
}

class ApiProductsRepository implements ProductsRepository {
  @override
  Future<GetDataListResponseModel> fetchProducts() async {
    final data = await APIFunction().apiCall(
      apiName: Constants.products,
      context: Get.context!,
      token: accessToken,
      type: 'get',
      isLoading: true,
    );

    return GetDataListResponseModel.fromJson(data);
  }

  @override
  Future<GetDataListResponseModel> fetchCategories() async {
    final data = await APIFunction().apiCall(
      apiName: '${Constants.categories}/0',
      context: Get.context!,
      token: accessToken,
      type: 'get',
      isLoading: false,
    );

    return GetDataListResponseModel.fromJson(data);
  }
}
