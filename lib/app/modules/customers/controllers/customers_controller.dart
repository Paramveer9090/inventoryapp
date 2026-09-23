import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';

import 'package:true_leaf_inventory_app/app/api_repository/api_function.dart';
import 'package:true_leaf_inventory_app/app/models/get_all_data_model.dart';
import 'package:true_leaf_inventory_app/app/models/report_model.dart';
import 'package:true_leaf_inventory_app/app/modules/home/controllers/home_controller.dart';
import 'package:true_leaf_inventory_app/app/utils/app_constant.dart';

class CustomersController extends GetxController {
  List<Customers> customerList = <Customers>[];
  List<Customers> filterList = [];
  var noData = "".obs;
  var id = "".obs;
  var searchText = "".obs; // Track current search text

  // Debouncing for search
  Timer? _debounce;

  @override
  void onInit() {
    getCustomerAPI();
    super.onInit();
  }

  // Reset search when coming back from customer details
  void resetSearch() {
    searchText.value = "";
    noData.value = "";
    customerList = filterList;
    update();
  }

  /// Debounced search - only runs after user stops typing
  void onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      search(text: value);
    });
  }

  deleteCartAPI() async {
    await APIFunction().apiCall(
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
        if (json
            .encode(data["payment_arr"])
            .contains(customerList[i].id.toString())) {
          customerList[i].totalRevenue =
              data["payment_arr"]["${customerList[i].id}"].toString();
        }
      }
      update();
    }
  }

  /// Search
  search({required String text}) async {
    searchText.value = text; // Track the search text
    noData.value = ""; // Reset no data message

    if (text.trim().isEmpty) {
      customerList = filterList;
    } else {
      List<Customers> tempList = [];
      for (int i = 0; i < filterList.length; i++) {
        if (filterList[i]
                .companyName!
                .toLowerCase()
                .contains(text.toLowerCase()) ||
            filterList[i].name!.toLowerCase().contains(text.toLowerCase()) ||
            filterList[i]
                .phoneNumber!
                .toLowerCase()
                .contains(text.toLowerCase())) {
          tempList.add(filterList[i]);
        }
      }

      if (tempList.isEmpty) {
        noData.value = "No customers found matching '$text'";
      }

      customerList = tempList;
    }
    update();
  }
}
