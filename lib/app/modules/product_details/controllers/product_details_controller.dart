import 'package:true_leaf_inventory_app/app/models/details_response_model.dart';
import '../../../widgets/all_import.dart';

class ProductDetailsController extends GetxController {
  final id;

  ProductDetailsController({this.id});

  GetDetailsData? getDetailsData;
  var noData = "".obs;

  @override
  void onInit() {
    productDetails();
    super.onInit();
  }

  /// Supplier Expense
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
      noData.value = "";
      update();
    } else {
      noData.value = "No data found";
      update();
    }
  }
}
