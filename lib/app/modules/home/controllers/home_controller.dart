import 'package:true_leaf_inventory_app/app/models/details_response_model.dart';
import 'package:true_leaf_inventory_app/app/models/get_all_data_model.dart';
import 'package:true_leaf_inventory_app/app/modules/change_password/views/change_password_view.dart';
import 'package:true_leaf_inventory_app/app/modules/customers/views/customers_view.dart';
import 'package:true_leaf_inventory_app/app/modules/dashboard/views/dashboard_view.dart';
import 'package:true_leaf_inventory_app/app/modules/driver_dashboard/views/driver_dashboard_view.dart';
import 'package:true_leaf_inventory_app/app/modules/driver_order/views/driver_order_view.dart';
import 'package:true_leaf_inventory_app/app/modules/my_orders/views/my_orders_view.dart';
import 'package:true_leaf_inventory_app/app/modules/products/views/products_view.dart';
import '../../../widgets/all_import.dart';

var accessToken;
var cartLength = "0";
var customerCartId = "0";
var orderId = "0";

class HomeController extends GetxController {
  final GlobalKey<ScaffoldState> key = GlobalKey();
  var isCart = false.obs;
  LoginSignUpData? loginData;
  var isSelected = 0.obs;
  var isDrawerSelected = 0.obs;
  var isCustomerId = "".obs;
  var addOrder = false.obs;
  var isCustomerDetails = false.obs;
  var isOrderDetails = false.obs;
  var isOrderEdit = false.obs;

  /// Sales
  List screens = [
    DashboardView(),
    CustomersView(),
    MyOrdersView(),
    ProductsView(),
    ChangePasswordView(),
  ];

  List iconList = [
    AppImages.dashboard,
    AppImages.customer,
    AppImages.orders,
    AppImages.products,
    AppImages.menu,
  ];

  List selectedIconList = [
    AppImages.dashboard1,
    AppImages.customer1,
    AppImages.orders1,
    AppImages.products1, // Use products1 for selected state
    AppImages.menu1,
  ];
  List titleList = [
    AppStrings.dashboard,
    AppStrings.customers,
    AppStrings.myOrders,
    AppStrings.product,
    AppStrings.changePassword,
  ];
  List drawerList = [
    AppStrings.changePassword,
    AppStrings.customers,
    AppStrings.myOrders,
    AppStrings.logout,
  ];
  List drawerImageList = [
    AppImages.change_password2,
    AppImages.ic_customer,
    AppImages.my_order,
    AppImages.logout,
  ];

  /// Delivery
  List screensDelivery = [
    DriverDashboardView(),
    DriverOrderView(),
    ChangePasswordView(),
  ];
  List iconDeliveryList = [
    AppImages.dashboard,
    AppImages.orders,
    AppImages.change_password,
  ];
  List selectedDeliveryIconList = [
    AppImages.dashboard1,
    AppImages.orders1,
    AppImages.change_password1,
  ];
  List titleDeliveryList = [
    AppStrings.dashboard,
    AppStrings.order,
    AppStrings.changePassword,
  ];

  GetDataListResponseData? cartData;

  getLoginData() async {
    final data = await getStorageData.readObject(getStorageData.loginData);
    accessToken = await getStorageData.readString(Constants.access_token);
    customerCartId = await getStorageData.readString("customerId") ?? "0";

    if (data != null) {
      loginData = LoginSignUpData.fromJson(data);
      if (loginData!.roles![0].title != "Delivery Agent") {
        if (customerCartId.isEmpty) {
          getCartData(id: 0);
        } else {
          getCartData(id: customerCartId);
        }
      }
    }

    update();
  }

  @override
  void onInit() {
    getLoginData();
    super.onInit();
  }

  logout() async {
    await getStorageData.removeData(getStorageData.loginData);
    Get.offAllNamed(Routes.LOGIN);
  }

  getCartData({id}) async {
    final data = await APIFunction().apiCall(
      apiName: "${Constants.cart}/${id}",
      context: Get.context!,
      token: accessToken,
      type: "get",
      isLoading: false,
    );

    GetDetailsResponseModel model = GetDetailsResponseModel.fromJson(data);

    if (model.data!.cartDetails != null) {
      cartLength = model.data!.cartDetails!.length.toString();
      update();
    } else {
      print("In else part");
    }
  }
}
