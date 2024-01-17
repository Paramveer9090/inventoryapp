import 'package:true_leaf_inventory_app/app/modules/change_password/views/change_password_view.dart';
import 'package:true_leaf_inventory_app/app/modules/customers/views/customers_view.dart';
import 'package:true_leaf_inventory_app/app/modules/dashboard/views/dashboard_view.dart';
import 'package:true_leaf_inventory_app/app/modules/my_orders/views/my_orders_view.dart';
import '../../../widgets/all_import.dart';

var accessToken;

class HomeController extends GetxController {
  final GlobalKey<ScaffoldState> key = GlobalKey();

  LoginSignUpData? loginData;
  var isSelected = 0.obs;
  var isDrawerSelected = 0.obs;
  var addOrder = false.obs;

  List screens = [
    DashboardView(),
    CustomersView(),
    MyOrdersView(),
    ChangePasswordView(),
    Container(),
  ];

  List iconList = [
    AppImages.dashboard,
    AppImages.customer,
    AppImages.orders,
    AppImages.change_password,
    AppImages.menu,
  ];

  List selectedIconList = [
    AppImages.dashboard1,
    AppImages.customer1,
    AppImages.orders1,
    AppImages.change_password1,
    AppImages.menu1,
  ];
  List titleList = [
    AppStrings.dashboard,
    AppStrings.customers,
    AppStrings.myOrders,
    AppStrings.changePassword,
    AppStrings.product,
  ];
  List drawerList = [
    AppStrings.product,
    AppStrings.customers,
    AppStrings.myOrders,
    AppStrings.logout,
  ];
  List drawerImageList = [
    AppImages.products,
    AppImages.ic_customer,
    AppImages.my_order,
    AppImages.logout,
  ];

  getLoginData() async {
    final data = await getStorageData.readObject(getStorageData.loginData);
    accessToken = await getStorageData.readString(Constants.access_token);
    if (data != null) {
      loginData = LoginSignUpData.fromJson(data);
    }
    print("accessToken----------> $accessToken");

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
}
