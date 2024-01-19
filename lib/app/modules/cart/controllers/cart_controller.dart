import 'package:true_leaf_inventory_app/app/modules/orders/controllers/orders_controller.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class CartController extends GetxController {
  List<OrderItemResponseData> myList = [];
  List<OrderItemResponseData> orderItem = [];

  @override
  void onInit() {
    getCartData();
    super.onInit();
  }

  getCartData() async {
    print("it's a cart data");
    print(getStorageData.readList(getStorageData.cartData));
    // myList = await cartStoreData.read<List<OrderItemResponseData>>(getStorageData.cartData) ?? [];
    myList = await getStorageData.readList(getStorageData.cartData) ?? [];

    if (myList.isNotEmpty) {
      for (int i = 0; i < myList.length; i++) {
        print(myList[i].quality!.text);
        print("myList[i].quality!.text");
        if (myList[i].quality!.text != "0") {
          orderItem.add(
            OrderItemResponseData(
              indexValue: i,
              category_id: myList[i].category_id,
              categoryName: myList[i].categoryName,
              sub_category_id: myList[i].sub_category_id,
              subCategoryName: myList[i].subCategoryName,
              product_id: myList[i].product_id.toString(),
              productName: myList[i].productName,
              sellingPrice: myList[i].sellingPrice.toString(),
              stock: myList[i].stock.toString(),
              tax: myList[i].tax,
              taxId: myList[i].taxId,
              taxName: myList[i].taxName,
              boxUnit: myList[i].boxUnit,
              productImage: myList[i].productImage,
              boxSize: myList[i].boxSize.toString(),
              quality: TextEditingController(text: myList[i].quality!.text),
            ),
          );
          update();
        }
      }
    }
  }
}
