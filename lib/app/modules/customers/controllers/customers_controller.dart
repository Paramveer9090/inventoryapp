import 'package:true_leaf_inventory_app/app/models/get_all_data_model.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class CustomersController extends GetxController {
  List<Customers> customerList = <Customers>[];
  List<Customers> filterList = [];
  var noData = "".obs;
  var id = "".obs;

  @override
  void onInit() {
    getCustomerAPI();
    super.onInit();
  }

  deleteCartAPI() async {
    final data = await APIFunction().apiCall(
      apiName: "${Constants.cart}/$customerCartId",
      context: Get.context!,
      token: accessToken,
      type: "delete",
    );
    cartLength = "0";
    Get.find<HomeController>().isCustomerDetails.value = true;
    Get.find<HomeController>().update();
    update();
  }

  /// get Customer API
  getCustomerAPI({bool isLoading = true}) async {
    final data = await APIFunction().apiCall(
      apiName: Constants.customers,
      context: Get.context!,
      token: accessToken,
      type: "get",
      isLoading: isLoading,
    );

    GetDataListResponseModel model = GetDataListResponseModel.fromJson(data);

    if (model.customers!.isNotEmpty) {
      customerList = model.customers!;
      filterList = model.customers!;
      for (int i = 0; i < customerList.length; i++) {
        if (json.encode(data["payment_arr"]).contains(customerList[i].id.toString())) {
          customerList[i].totalRevenue = data["payment_arr"]["${customerList[i].id}"].toString();
        }
      }
      update();
    } else {
      print("In else part");
    }
  }

  /// Search
  search({required String text}) async {
    if (text.trim().isEmpty) {
      customerList = filterList;
    } else {
      List<Customers> tempList = [];
      for (int i = 0; i < filterList.length; i++) {
        if (filterList[i].companyName!.toLowerCase().contains(text.toLowerCase()) || filterList[i].name!.toLowerCase().contains(text.toLowerCase()) || filterList[i].phoneNumber!.toLowerCase().contains(text.toLowerCase())) {
          tempList.add(filterList[i]);
          noData.value = "";
        } else if (tempList.isEmpty) {
          noData.value = "No result found";
        }
      }
      customerList = tempList;
    }
    update();
  }
}
