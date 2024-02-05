import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class DashboardController extends GetxController {
  List<Orders> myOrderList = <Orders>[];
  var isAccepted = "0".obs;
  var isReview = "0".obs;
  LoginSignUpData? loginData;

  @override
  void onInit() {
    getOrderAPI();
    getLoginData();
    super.onInit();
  }

  getLoginData() async {
    final data = await getStorageData.readObject(getStorageData.loginData);
    if (data != null) {
      loginData = LoginSignUpData.fromJson(data);
    }
    update();
  }

  getOrderAPI({var isLoading = true}) async {
    final data = await APIFunction().apiCall(
      apiName: Constants.supplierDashboard,
      context: Get.context!,
      token: accessToken,
      type: "get",
      isLoading: isLoading,
    );

    ReportModel model = ReportModel.fromJson(data);

    if (model.orders!.isNotEmpty) {
      myOrderList = model.orders!;
      isAccepted.value = model.accept.toString();
      isReview.value = model.review.toString();
      update();
    } else {
      print("In else part");
    }
  }
}
