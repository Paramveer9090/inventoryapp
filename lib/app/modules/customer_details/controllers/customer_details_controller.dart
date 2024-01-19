import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class CustomerDetailsController extends GetxController {
  final id;

  CustomerDetailsController({this.id});

  List<Orders> myOrderList = <Orders>[];
  CustomerDetails? customerDetails;
  var totalOrder = "".obs;
  var paid = "".obs;
  var unPaid = "".obs;

  @override
  void onInit() {
    getCustomerDetailsAPI();
    super.onInit();
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

    if (model.orders!.isNotEmpty) {
      myOrderList = model.orders!;
      totalOrder.value = model.totalOrder.toString();
      paid.value = model.paid.toString();
      unPaid.value = model.unpaid.toString();
      customerDetails = model.customerDetails;
      update();
    } else {
      print("In else part");
    }
  }
}
