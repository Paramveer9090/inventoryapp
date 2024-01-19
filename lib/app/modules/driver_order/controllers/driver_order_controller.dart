import 'package:true_leaf_inventory_app/app/models/get_all_data_model.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class DriverOrderController extends GetxController {
  List<GetDataListResponseData> orderList = <GetDataListResponseData>[];
  LoginSignUpData? loginData;
  var noData = "".obs;
  var fromDateString = "".obs;
  var toDateString = "".obs;
  var id = "".obs;

  @override
  void onInit() {
    getOrderAPI();
    super.onInit();
  }

  getLoginData() async {
    final data = getStorageData.readObject(getStorageData.loginData);
    if (data != null) {
      loginData = LoginSignUpData.fromJson(data);
    }
    update();
  }

  List<GetDataListResponseData> filterList = [];

  search({required String text}) async {
    if (text.trim().isEmpty) {
      orderList = filterList;
    } else {
      List<GetDataListResponseData> tempList = [];
      for (int i = 0; i < filterList.length; i++) {
        if (filterList[i].customer != null) {
          if (filterList[i].id.toString().toLowerCase().contains(text.toLowerCase()) ||
                  filterList[i].customer!.companyName.toString().toLowerCase().contains(text.toLowerCase()) ||
                  filterList[i].customer!.contactName.toString().toLowerCase().contains(text.toLowerCase()) ||
                  filterList[i].customer!.name.toString().toLowerCase().contains(text.toLowerCase()) ||
                  filterList[i].customer!.address.toString().toLowerCase().contains(text.toLowerCase()) ||
                  filterList[i].customer!.pincode.toString().toLowerCase().contains(text.toLowerCase()) ||
                  filterList[i].delivery_note.toString().toLowerCase().contains(text.toLowerCase()) ||
                  filterList[i].customer!.phoneNumber.toString().toLowerCase().contains(text
                      .toLowerCase()) /* ||
                  filterList[i].status == "4"
              ? AppStrings.accepted.toString().toLowerCase().contains(text.toLowerCase())
              : filterList[i].status == "1"
                  ? AppStrings.completed.toString().toLowerCase().contains(text.toLowerCase())
                  : AppStrings.review.toString().toLowerCase().contains(text.toLowerCase())*/
              ) {
            tempList.add(filterList[i]);
            noData.value = "";
          } else if (tempList.isEmpty) {
            noData.value = "No result found";
          }
        } else {
          if (filterList[i].id.toString().toLowerCase().contains(text.toLowerCase()) ||
                  filterList[i].delivery_note.toString().toLowerCase().contains(text
                      .toLowerCase()) /*filterList[i].status == "4"
              ? AppStrings.accepted.toString().toLowerCase().contains(text.toLowerCase())
              : filterList[i].status == "1"
                  ? AppStrings.completed.toString().toLowerCase().contains(text.toLowerCase())
                  : AppStrings.review.toString().toLowerCase().contains(text.toLowerCase())*/
              ) {
            tempList.add(filterList[i]);
            noData.value = "";
          } else if (tempList.isEmpty) {
            noData.value = "No result found";
          }
        }
      }
      orderList = tempList;
    }
    update();
  }

  getOrderAPI({bool isLoading = true}) async {
    await getLoginData();
    final data = await APIFunction().apiCall(
      apiName: Constants.orders,
      context: Get.context!,
      token: accessToken,
      type: "get",
      isLoading: isLoading,
    );

    GetDataListResponseModel model = GetDataListResponseModel.fromJson(data);

    if (model.data!.isNotEmpty) {
      orderList = model.data!;
      filterList = model.data!;
      update();
    } else {
      print("In else part");
    }
  }
}
