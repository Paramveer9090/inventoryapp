import '../../../widgets/all_import.dart';

class MyOrdersController extends GetxController {
  List<Orders> myOrderList = <Orders>[];
  List<Customers> customerList = <Customers>[];
  var customer_id = "".obs;
  var noData = "".obs;
  var isPaidSelected = false.obs;
  var isUnPaidSelected = false.obs;
  var isOverDueSelected = false.obs;
  var fromDateString = "".obs;
  var toDateString = "".obs;
  LoginSignUpData? loginData;
  var id = "".obs;

  // Add customerMap to the controller
  Map<int, Customers> customerMap = {};

  @override
  void onInit() {
    super.onInit();
    // nothing here
  }

  @override
  void onReady() {
    super.onReady();
    _loadMyOrders();
  }

  Future<void> _loadMyOrders() async {
    await getLoginData();
    if (loginData == null) {
      // nothing to fetch if we don't have an ID
      noData.value = "Please log in first";
      update();
      return;
    }
    await getOrderReportAPI();
  }

  Future<void> getLoginData() async {
    final data = await getStorageData.readObject(getStorageData.loginData);
    if (data != null) {
      loginData = LoginSignUpData.fromJson(data);
    }
    update();
  }

  /// Search
  search({required String text}) async {
    if (text.trim().isEmpty) {
      myOrderList = filterList;
      noData.value = "";
    } else {
      List<Orders> tempList = [];
      
      for (int i = 0; i < filterList.length; i++) {
        if (filterList[i].id.toString().contains(text.toLowerCase()) ||
            filterList[i].orderTotal.toString().toLowerCase().contains(text.toLowerCase())) {
          tempList.add(filterList[i]);
        }
      }
      
      if (tempList.isNotEmpty) {
        myOrderList = tempList;
        noData.value = "";
      } else {
        myOrderList = [];
        noData.value = "No result found";
      }
    }
    
    update();
  }

  /// Date Filter
  dateFilter({var startDate, endDate}) async {
    List<Orders> tempList = [];
    for (int i = 0; i < filterList.length; i++) {
      var itemDate = await DateTime.parse(filterList[i].orderDate.toString());

      if (itemDate.compareTo(startDate) > 0 &&
          itemDate.compareTo(endDate) < 0) {
        tempList.add(filterList[i]);
        noData.value = "";
      } else if (tempList.isEmpty) {
        noData.value = "No result found";
      }
    }
    myOrderList = tempList;
    update();
  }

  List<Orders> filterList = [];

  paidSearch({var color}) async {
    List<Orders> tempList = [];
    for (int i = 0; i < filterList.length; i++) {
      if (filterList[i].statusColor.toString() == color.toString()) {
        tempList.add(filterList[i]);
      }

      myOrderList = tempList;
    }

    update();
  }

  customerSearch({var id}) async {
    List<Orders> tempList = [];
    
    print('=== CUSTOMER SEARCH DEBUG ===');
    print('Selected customer ID: $id');
    print('Total orders to search: ${filterList.length}');
    
    for (int i = 0; i < filterList.length; i++) {
      print('Order ${filterList[i].id}: customerId=${filterList[i].customerId}, customer.id=${filterList[i].customer?.id}');
      
      // Try both customerId field and customer.id field
      bool matches = false;
      if (filterList[i].customerId?.toString() == id.toString()) {
        matches = true;
        print('  → Match found via customerId');
      } else if (filterList[i].customer?.id?.toString() == id.toString()) {
        matches = true;
        print('  → Match found via customer.id');
      }
      
      if (matches) {
        tempList.add(filterList[i]);
      }
    }
    
    print('Matching orders found: ${tempList.length}');
    print('==============================');
    
    if (tempList.isNotEmpty) {
      myOrderList = tempList;
      noData.value = "";
    } else {
      myOrderList = [];
      noData.value = "No result found";
    }
    
    update();
  }

  void statusFilter(String status) {
    print('Filtering by status: $status');
    print('Total orders before filter: ${filterList.length}');

    myOrderList = filterList.where((order) {
      String orderStatus = order.status?.toString() ?? '';

      print('Order ${order.id}: status = "$orderStatus"');

      // Map text status to numeric values
      bool matches = false;
      switch (status.toLowerCase()) {
        case 'paid':
          matches = orderStatus == '1'; // Assuming 1 = Paid
          break;
        case 'overdue':
          matches = orderStatus == '3'; // Assuming 2 = Overdue
          break;
        case 'unpaid':
          matches = orderStatus == '4' ; // Assuming 3,4 = Unpaid
          break;
      }

      return matches;
    }).toList();

    print('Orders after filter: ${myOrderList.length}');
    update();
  }

  Future<void> getOrderReportAPI({bool isLoading = true}) async {
    if (loginData == null) {
      noData.value = "Please log in first";
      update();
      return;
    }
    final payload = {
      'sales_person_id': loginData!.id.toString(),
      // add more parameters here if needed...
    };

    final data = await APIFunction().apiCall(
      apiName: Constants.get_sales_person_orderreport,
      context: Get.context!,
      token: accessToken,
      type: "post", // ← must be POST
      rawData: jsonEncode(payload), // ← send your body
      isLoading: isLoading,
    );

    final model = ReportModel.fromJson(data);
    if (model.orders?.isNotEmpty == true) {
      myOrderList = model.orders!;
      filterList = model.orders!;
      customerList = model.customers!;

      // Populate customerMap after fetching customerList
      customerMap = {for (var c in customerList) c.id!: c};

      update(); // rebuild the view
    } else {
      noData.value = "No orders found";
      update();
    }
  }

  void clearAllFilters() {
    // Reset all filter states
    isPaidSelected.value = false;
    isUnPaidSelected.value = false;
    isOverDueSelected.value = false;
    customer_id.value = "";
    fromDateString.value = "";
    toDateString.value = "";
    
    // Reset order list to show all orders
    myOrderList = filterList;
    noData.value = "";
    
    print('All filters cleared. Showing ${myOrderList.length} orders');
    update();
  }

  void clearCustomerFilter() {
    customer_id.value = "";
    myOrderList = filterList;
    noData.value = "";
    update();
  }

  void clearDateFilter() {
    fromDateString.value = "";
    toDateString.value = "";
    myOrderList = filterList;
    noData.value = "";
    update();
  }

  void clearStatusFilter() {
    isPaidSelected.value = false;
    isUnPaidSelected.value = false;
    isOverDueSelected.value = false;
    myOrderList = filterList;
    noData.value = "";
    update();
  }
}
