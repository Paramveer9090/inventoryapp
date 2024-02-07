import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class CustomerDetailsController extends GetxController {
  final id;

  CustomerDetailsController({this.id});

  List<Orders> myOrderList = <Orders>[];
  CustomerDetails? customerDetails;
  var totalOrder = "0".obs;
  var paid = "0".obs;
  var unPaid = "0".obs;
  LoginSignUpData? loginData;

  @override
  void onInit() {
    getCustomerDetailsAPI();
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

  getCustomerDetailsAPI({var isLoading = true}) async {
    final data = await APIFunction().apiCall(
      apiName: "${Constants.customers}/${id}",
      context: Get.context!,
      token: accessToken,
      type: "get",
      isLoading: isLoading,
    );

    ReportModel model = ReportModel.fromJson(data);

    if (model.customerDetails != null) {
      customerDetails = model.customerDetails;
      update();
    }

    totalOrder.value = model.totalOrder.toString();
    paid.value = model.paid.toString();
    unPaid.value = model.unpaid.toString();
    update();
    if (model.orders!.isNotEmpty) {
      myOrderList = model.orders!;

      update();
    } else {
      print("In else part");
    }
  }
}
