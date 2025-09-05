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
  
  // Flag to prevent multiple simultaneous API calls
  bool _isLoadingData = false;
  DateTime? _lastRefreshTime;

  @override
  void onInit() {
    getCustomerDetailsAPI();
    getLoginData();
    super.onInit();
  }

  @override
  void onReady() {
    // Don't call refreshData here since onInit already called getCustomerDetailsAPI
    // refreshData();
    super.onReady();
  }

  // Check if enough time has passed since last refresh to avoid rate limiting
  bool _shouldRefreshData() {
    if (_lastRefreshTime == null) {
      return true;
    }
    
    // Only allow refresh if at least 5 seconds have passed
    return DateTime.now().difference(_lastRefreshTime!) > Duration(seconds: 5);
  }

  // Method to refresh data (can be called when returning from order details)
  refreshData() {
    // Only refresh if not already loading and enough time has passed
    if (!_isLoadingData && _shouldRefreshData()) {
      _lastRefreshTime = DateTime.now();
      getCustomerDetailsAPI(isLoading: false);
    }
  }

  getLoginData() async {
    final data = await getStorageData.readObject(getStorageData.loginData);
    if (data != null) {
      loginData = LoginSignUpData.fromJson(data);
    }
    update();
  }

  getCustomerDetailsAPI({var isLoading = true}) async {
    // Prevent multiple simultaneous API calls
    if (_isLoadingData) {
      return;
    }
    
    _isLoadingData = true;
    
    try {
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

      totalOrder.value = model.totalOrder != null ? double.parse(model.totalOrder.toString()).toStringAsFixed(2) : "0.00";
      paid.value = model.paid != null ? double.parse(model.paid.toString()).toStringAsFixed(2) : "0.00";
      unPaid.value = model.unpaid != null ? double.parse(model.unpaid.toString()).toStringAsFixed(2) : "0.00";
      update();
      
      if (model.orders!.isNotEmpty) {
        myOrderList = model.orders!;
        update();
      } else {
        print("In else part");
      }
    } catch (e) {
      print("Error loading customer details: $e");
    } finally {
      _isLoadingData = false;
    }
  }
}
