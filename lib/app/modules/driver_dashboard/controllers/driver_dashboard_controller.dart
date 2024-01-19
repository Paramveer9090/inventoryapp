import 'package:true_leaf_inventory_app/app/models/get_all_data_model.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class DriverDashboardController extends GetxController {
  List<GetDataListResponseData> orderList = <GetDataListResponseData>[];
  var noData = "".obs;
  var totalOrder = "".obs;
  var delivered = "".obs;
  var pending = "".obs;

  @override
  void onInit() {
    getOrderAPI();
    super.onInit();
  }

  getOrderAPI({bool isLoading = true}) async {
    final data = await APIFunction().apiCall(
      apiName: Constants.driverDashboard,
      context: Get.context!,
      token: accessToken,
      type: "get",
      isLoading: isLoading,
    );

    GetDataListResponseModel model = GetDataListResponseModel.fromJson(data);

    if (model.data!.isNotEmpty) {
      totalOrder.value = model.totalOrder.toString();
      delivered.value = model.deliver.toString();
      pending.value = model.pending.toString();
      orderList = model.data!;
      update();
    } else {
      print("In else part");
    }
  }
}
