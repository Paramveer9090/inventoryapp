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
  var id = "".obs;

  @override
  void onInit() {
    getOrderReportAPI();
    super.onInit();
  }

  /// Search
  search({required String text}) async {
    if (text.trim().isEmpty) {
      myOrderList = filterList;
    } else {
      List<Orders> tempList = [];
      for (int i = 0; i < filterList.length; i++) {
        if (filterList[i].payment!.orderNumber.toString().toLowerCase().contains(text.toLowerCase()) ||
            // filterList[i].customer!.name!.toLowerCase().contains(text.toLowerCase()) ||
            filterList[i].orderTotal.toString().toLowerCase().contains(text.toLowerCase())) {
          tempList.add(filterList[i]);
          noData.value = "";
        } else if (tempList.isEmpty) {
          noData.value = "No result found";
        }
      }
      myOrderList = tempList;
    }
    update();
  }

  /// Date Filter
  dateFilter({var startDate, endDate}) async {
    List<Orders> tempList = [];
    for (int i = 0; i < filterList.length; i++) {
      var itemDate = await DateTime.parse(filterList[i].orderDate.toString());

      if (itemDate.compareTo(startDate) > 0 && itemDate.compareTo(endDate) < 0) {
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
    for (int i = 0; i < filterList.length; i++) {
      if (filterList[i].customer!.id.toString() == id.toString()) {
        tempList.add(filterList[i]);
        noData.value = "";
      } else if (tempList.isEmpty) {
        noData.value = "No result found";
      }
      myOrderList = tempList;
    }

    update();
  }

  getOrderReportAPI({var isLoading = true}) async {
    final data = await APIFunction().apiCall(
      apiName: Constants.get_sales_person_orderreport,
      context: Get.context!,
      token: accessToken,
      type: "get",
      isLoading: isLoading,
    );

    ReportModel model = ReportModel.fromJson(data);

    if (model.orders!.isNotEmpty) {
      myOrderList = model.orders!;
      filterList = model.orders!;
      customerList = model.customers!;
      // Future.delayed(
      //   Duration(milliseconds: 50),
      //   () {
      //     if (isDashboard == true && isPaidSelected.value) {
      //       paidSearch(color: Color(0xFF75dc75));
      //     } else if (isDashboard == true && isUnPaidSelected.value) {
      //       paidSearch(color: Color(0xFFffab00));
      //     } else if (isDashboard == true && isOverDueSelected.value) {
      //       paidSearch(color: Color(0xFFff5050));
      //     }
      //   },
      // );
      update();
    } else {
      print("In else part");
    }
  }
}
