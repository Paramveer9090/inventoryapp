import 'package:get_storage/get_storage.dart';
import 'package:true_leaf_inventory_app/app/models/get_all_data_model.dart';
import 'package:true_leaf_inventory_app/app/modules/orders/controllers/orders_controller.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class CartController extends GetxController {
  List<GetDataListResponseData> orderItem = [];
  List<dynamic> jsonDataList = [];

  @override
  void onInit() {
    getCartData();
    super.onInit();
  }

  getCartData() async {
    print("it's a cart data");
    print(getStorageData.readObject("cartValueList"));
    jsonDataList = await getStorageData.readObject("cartValueList");
    orderItem = jsonDataList.map((item) => GetDataListResponseData.fromJson(item)).toList();
    print(orderItem);
    print(orderItem.length);
    print("myListmyListmyListmyListmyList");
    update();
  }
}
