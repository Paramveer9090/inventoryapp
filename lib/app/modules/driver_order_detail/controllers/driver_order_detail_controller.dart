import 'package:get/get.dart';
import 'package:true_leaf_inventory_app/app/models/get_all_data_model.dart';
import 'package:true_leaf_inventory_app/app/models/details_response_model.dart';
import 'package:true_leaf_inventory_app/app/modules/driver_order/controllers/driver_order_controller.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class DriverOrderDetailController extends GetxController {
  GetDataListResponseData? currentOrder;
  GetDetailsData? orderDetails;
  List<GetDataListResponseData> orderItems = [];
  var isLoading = true.obs;
  var orderId = "".obs;
  LoginSignUpData? loginData;

  @override
  void onInit() {
    super.onInit();
    // Get the order ID from arguments if available
    if (Get.arguments != null) {
      orderId.value = Get.arguments.toString();
      loadOrderDetails();
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  getLoginData() async {
    final data = await getStorageData.readObject(getStorageData.loginData);
    if (data != null) {
      loginData = LoginSignUpData.fromJson(data);
    }
    update();
  }

  void loadOrderData() {
    try {
      // Get the driver order controller to access order list
      final driverOrderController = Get.find<DriverOrderController>();
      
      // Find the specific order by ID
      if (orderId.value.isNotEmpty) {
        currentOrder = driverOrderController.orderList.firstWhereOrNull(
          (order) => order.id.toString() == orderId.value,
        );
      }
      
      update();
    } catch (e) {
      print('Error loading order data: $e');
    }
  }

  void loadOrderDetails() async {
    try {
      await getLoginData();
      isLoading.value = true;
      
      if (orderId.value.isEmpty) {
        print("Order ID is empty");
        isLoading.value = false;
        return;
      }

      // First load basic order data
      loadOrderData();
      
      // Then fetch detailed order with items
      final data = await APIFunction().apiCall(
        apiName: "${Constants.orders}/${orderId.value}",
        context: Get.context!,
        token: accessToken,
        type: "get",
        isLoading: false,
      );

      GetDetailsResponseModel model = GetDetailsResponseModel.fromJson(data);

      if (model.order != null) {
        orderDetails = model.order!;
        orderItems = model.order!.orderItem ?? [];
      }
      
      isLoading.value = false;
      update();
    } catch (e) {
      print('Error loading order details: $e');
      isLoading.value = false;
      update();
    }
  }

  void setOrderId(String id) {
    orderId.value = id;
    loadOrderDetails();
  }
}
