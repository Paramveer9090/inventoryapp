import 'package:true_leaf_inventory_app/app/models/details_response_model.dart';
import 'package:true_leaf_inventory_app/app/models/get_all_data_model.dart';
import 'package:true_leaf_inventory_app/app/modules/order_details/controllers/order_details_controller.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class OrdersController extends GetxController {
  final customerId;

  OrdersController({this.customerId});

  List<GetDataListResponseData> categoryList = <GetDataListResponseData>[];
  List<GetDataListResponseData> productList = <GetDataListResponseData>[];
  List<GetDataListResponseData> tempProductList = <GetDataListResponseData>[];
  TextEditingController quantityText = TextEditingController();
  TextEditingController sellingPriceText = TextEditingController();
  LoginSignUpData? loginData;
  var isProduct = false.obs;
  var isSubCategory = false.obs;
  var isCategory = true.obs;
  var noData = "".obs;
  var isAddedData = false.obs;
  var isWrongData = false.obs;
  var isAddToCartButton = false.obs;

  /// API Data Params

  var categoryId = "".obs;
  var categoryName = "".obs;
  var subCategoryId = "".obs;
  var subCategoryName = "".obs;
  var customerIdValue = "".obs;
  var productName = "".obs;
  var productId = "".obs;

  GetDetailsData? getDetailsData;
  List<GetDataListResponseData> orderItem = [];

  @override
  void onInit() {
    getLoginData();
    getCategoriesAPI(categoryId: "0");
    getProductAPI();
    if (orderId != "0") {
      getAllOrderData();
    }
    print(customerId);
    print("customerId");
    update();

    super.onInit();
  }

  getLoginData() async {
    final data = getStorageData.readObject(getStorageData.loginData);
    if (data != null) {
      loginData = LoginSignUpData.fromJson(data);
    }
    update();
  }

  /// Get Category

  getCategoriesAPI({bool isLoading = true, required categoryId}) async {
    categoryList.clear();
    if (productList.isNotEmpty) {
      productList.clear();
    }
    update();
    final data = await APIFunction().apiCall(
      apiName: "${Constants.categories}/${categoryId}",
      context: Get.context!,
      token: accessToken,
      type: "get",
      isLoading: isLoading,
    );

    GetDataListResponseModel model = GetDataListResponseModel.fromJson(data);

    if (model.data!.isNotEmpty) {
      categoryList = model.data!;
      print("sub category get thy 6e");
      print("sub category length ${categoryList.length}");
      noData.value = "";
      update();
    } else {
      isSubCategory.value = false;
      isCategory.value = false;
      noData.value = "No data found";
      getProduct(subCategoryId: categoryId, type: "category");
      update();
    }
  }

  getProductAPI({bool isLoading = true}) async {
    final data = await APIFunction().apiCall(
      apiName: Constants.products,
      context: Get.context!,
      token: accessToken,
      type: "get",
      isLoading: isLoading,
    );

    GetDataListResponseModel model = GetDataListResponseModel.fromJson(data);

    if (model.data!.isNotEmpty) {
      tempProductList = model.data!;
      update();
    } else {
      print("In else part");
    }
  }

  getProduct({required var subCategoryId, type}) {
    isProduct.value = true;
    print("product get thy 6e");
    if (productList.isNotEmpty) {
      productList.clear();
    }
    if (categoryList.isNotEmpty) {
      categoryList.clear();
    }
    update();
    for (int i = 0; i < tempProductList.length; i++) {
      if (tempProductList[i].subCategoryId.toString() == subCategoryId.toString() && tempProductList[i].subCategoryId != null && type == "subCategory") {
        noData.value = "";
        productList.add(
          GetDataListResponseData(
            id: tempProductList[i].id,
            productId: tempProductList[i].id,
            name: tempProductList[i].name,
            sellingPrice: tempProductList[i].sellingPrice,
            stock: tempProductList[i].stock,
            createdAt: tempProductList[i].createdAt,
            updatedAt: tempProductList[i].updatedAt,
            deletedAt: tempProductList[i].deletedAt,
            categoryId: tempProductList[i].categoryId,
            maximumSellingPrice: tempProductList[i].maximumSellingPrice,
            boxSize: tempProductList[i].boxSize,
            isEdit: false,
            imageUrl: tempProductList[i].imageUrl,
            taxId: tempProductList[i].taxId,
            subCategoryId: tempProductList[i].subCategoryId,
            productImage: tempProductList[i].productImage,
            quantityCount: "0",
            isBox: tempProductList[i].isBox,
            isUnitSelected: 1,
            tax: tempProductList[i].taxDetail!.tax,
            taxDetail: Tax(
              tax: tempProductList[i].taxDetail!.tax,
            ),
          ),
        );

        update();
      } else if (tempProductList[i].categoryId.toString() == subCategoryId.toString() && tempProductList[i].categoryId != null && type == "category") {
        noData.value = "";
        productList.add(
          GetDataListResponseData(
            id: tempProductList[i].id,
            name: tempProductList[i].name,
            sellingPrice: tempProductList[i].sellingPrice,
            stock: tempProductList[i].stock,
            quantityCount: "0",
            isBox: tempProductList[i].isBox,
            productId: tempProductList[i].id,
            createdAt: tempProductList[i].createdAt,
            updatedAt: tempProductList[i].updatedAt,
            deletedAt: tempProductList[i].deletedAt,
            categoryId: tempProductList[i].categoryId,
            isEdit: false,
            maximumSellingPrice: tempProductList[i].maximumSellingPrice,
            boxSize: tempProductList[i].boxSize,
            imageUrl: tempProductList[i].imageUrl,
            taxId: tempProductList[i].taxId,
            subCategoryId: tempProductList[i].subCategoryId,
            isUnitSelected: 1,
            productImage: tempProductList[i].productImage,
            tax: tempProductList[i].taxDetail!.tax,
            taxDetail: Tax(
              tax: tempProductList[i].taxDetail!.tax,
            ),
          ),
        );

        update();
      }
    }
    if (productList.isEmpty) {
      noData.value = "No Data Found";
    }
    print("productList length");
    print(productList.length);
  }

  getAllOrderData() async {
    await getLoginData();
    final data = await APIFunction().apiCall(
      apiName: "${Constants.orders}/${orderId}",
      context: Get.context!,
      token: accessToken,
      type: "get",
      isLoading: false,
    );

    GetDetailsResponseModel model = GetDetailsResponseModel.fromJson(data);

    if (model.order != null) {
      getDetailsData = model.order!;
      orderItem = model.order!.orderItem!;
      print(orderItem.length);
      print("orderItem.length");
      update();
    } else {
      update();
    }
  }

  var orderTotal = "".obs;
  var orderTax = "".obs;
  var orderFinalTotal = "".obs;

  editOrderAPI() async {
    print("check length");
    print(orderItem.length);
    print(productList.length);

    int l = orderItem.length;
    int k = productList.length;
    bool whichListIsBig = l <= k;

    print(whichListIsBig);
    print("whichListIsBig");

    if (whichListIsBig) {
      print("productList big");
      for (int i = 0; i < productList.length; i++) {
        for (int j = 0; j < orderItem.length; j++) {
          if (await productList[i].quantityCount != "0") {
            print(productList[i].name);
            print(orderItem[j].name);
            print("orderItem[j].name");
            if (await productList[i].productId == orderItem[j].productId) {
              orderItem[j] = productList[i];
            } else {
              orderItem.add(productList[i]);
              // break;
            }
          } else {
            print("quantity value 0");
          }
        }
      }
    } else {
      print("orderItem big");
      for (int i = 0; i < orderItem.length; i++) {
        for (int j = 0; j < productList.length; j++) {
          if (await productList[j].quantityCount != "0") {
            if (orderItem.contains(productList[j])) {
              print("replace value");
              orderItem[i] = GetDataListResponseData();
              orderItem[i] = productList[j];
              break;
            } else {
              orderItem.add(productList[j]);
              break;
            }
          } else {
            print("quantity value 0");
          }
        }
        break;
      }
    }

    print(orderItem.length);
    print("orderItemorderItemorderItem");

    List categoryList = [];
    List subCategoryList = [];
    List productAPIList = [];
    List packageList = [];
    List quantityList = [];
    List salesPriceList = [];
    List taxList = [];
    List isBoxList = [];
    List isProductName = [];
    if (orderItem.isNotEmpty) {
      List<GetDataListResponseData> apiList = [];
      for (int js = 0; js < orderItem.length; js++) {
        apiList = orderItem.toSet().toList();
      }

      for (int k = 0; k < apiList.length; k++) {
        categoryList.add(apiList[k].categoryId);
        subCategoryList.add(apiList[k].subCategoryId);
        productAPIList.add(apiList[k].productId);
        packageList.add(apiList[k].boxSize);
        quantityList.add(apiList[k].quantityCount);
        salesPriceList.add(apiList[k].sellingPrice);
        isProductName.add(apiList[k].name);
        taxList.add(apiList[k].taxId);
        isBoxList.add(apiList[k].isBox);
        var amountTax;
        var amount;
        // if (apiList[k].isBox == 1) {
        //   amountTax = (((double.parse(apiList[k].boxSize.toString()) * double.parse(apiList[k].quantityCount!.toString())) * double.parse(apiList[k].sellingPrice!.toString())) * double.parse(apiList[k].tax.toString())) / 100;
        //   amount = (double.parse(apiList[k].boxSize.toString()) * double.parse(apiList[k].quantityCount!.toString())) * double.parse(apiList[k].sellingPrice!.toString());
        //   apiList[k].amountWithoutTax = amount.toString();
        //   apiList[k].amountOnlyTax = amountTax.toString();
        //   apiList[k].finalAmount = (amount + amountTax).toString();
        // } else {
        amountTax = ((double.parse(apiList[k].quantityCount.toString()) * double.parse(apiList[k].sellingPrice.toString())) * double.parse(apiList[k].tax.toString())) / 100;
        amount = (double.parse(apiList[k].quantityCount!.toString())) * double.parse(apiList[k].sellingPrice.toString());
        apiList[k].amountWithoutTax = amount.toString();
        apiList[k].amountOnlyTax = amountTax.toString();
        apiList[k].finalAmount = (amount + amountTax).toString();
        // }
      }

      orderTotal.value = (apiList.fold<double>(0, (sum, item) => sum + double.parse(item.amountWithoutTax.toString()))).toString();
      orderTax.value = (apiList.fold<double>(0, (sum, item) => sum + double.parse(item.amountOnlyTax.toString()))).toString();
      orderFinalTotal.value = (double.parse(orderTotal.value) + double.parse(orderTax.value)).toString();
    }
    update();

    print(categoryList);
    print(subCategoryList);
    print(productAPIList);
    print(packageList);
    print(quantityList);
    print(isProductName);
    print(salesPriceList);
    print(taxList);
    print(isBoxList);

    print("isBoxListisBoxListisBoxListisBoxListisBoxList");
    // print(getDetailsData!.orderTotalWithoutTax);
    // print(orderTotal.value);
    // print(getDetailsData!.orderTax);
    // print(orderTax.value);
    // print(getDetailsData!.orderTotal);
    // print(orderFinalTotal.value);
    // print(getDetailsData!.status);
    // print(getDetailsData!.discountType);
    // print(getDetailsData!.orderDate!.split(".").first);
    // print("categoryListcategoryListcategoryList");

    if (categoryList.isNotEmpty) {
      try {
        String rawData =
            '{"sales_manager_id": "${getDetailsData!.salesManagerId}","customer_id": ${getDetailsData!.customerId},"item_category": ${categoryList},"item_subcategory": ${subCategoryList},"item_name": ${productAPIList},"package_val": ${packageList},"item_quantity": ${quantityList},"item_sale_priec": ${salesPriceList},"item_tax_id": ${taxList},"is_box": ${isBoxList},"order_total_without_tax": ${orderTotal.value},"order_tax": ${orderTax.value},"discount_type": ${getDetailsData!.discountType},"extra_discount": "${getDetailsData!.extraDiscount}","order_total": "${orderFinalTotal.value}","comments": "${getDetailsData!.comments}","delivery_note": "${getDetailsData!.deliveryNote}","customer_sign": "${getDetailsData!.customerSign}","status": "${getDetailsData!.status}","order_date":"${getDetailsData!.orderDate!.split(".").first}"}';

        final data = await APIFunction().apiCall(
          apiName: "${Constants.orders}/${orderId}",
          context: Get.context!,
          token: accessToken,
          type: "put",
          rawData: rawData,
        );

        GetDetailsResponseModel model = GetDetailsResponseModel.fromJson(data);

        if (model.data != null) {
          Get.put(OrderDetailsController());
          Get.put(MyOrdersController());
          Get.find<OrderDetailsController>().isApiData.value = false;
          Get.find<OrderDetailsController>().update();
          Get.find<MyOrdersController>().id.value = orderId;
          Get.find<HomeController>().addOrder.value = false;
          Get.find<HomeController>().isSelected.value = 2;
          Get.find<HomeController>().isOrderDetails.value = true;
          Get.find<HomeController>().isOrderEdit.value = true;
          print(Get.find<MyOrdersController>().id.value);
          print("Get.find<MyOrdersController>().id.value");
          Get.find<HomeController>().update();
          update();
          Get.back();
        } else {
          print("In else part");
        }
      } on Exception catch (error) {
        utils.showSnackBar(context: Get.context!, message: "The name has already been taken.");
      }
    }
  }

  /// add to cart api

  addToCartAPI() async {
    print("call api");
    print(customerId);
    List productIdList = [];
    List priceList = [];
    List quantityList = [];
    List taxIdList = [];
    List isBoxList = [];
    List categoryList = [];
    List subCategoryList = [];
    for (int i = 0; i < productList.length; i++) {
      if (productList[i].quantityCount != "0") {
        productIdList.add(productList[i].id);
        priceList.add(productList[i].sellingPrice);
        quantityList.add(productList[i].quantityCount);
        taxIdList.add(productList[i].taxId);
        isBoxList.add(productList[i].isUnitSelected);
        categoryList.add(categoryId);
        subCategoryList.add(subCategoryId);
      }
    }

    print("productIdListproductIdList");
    print(productIdList);
    print(priceList);
    print(quantityList);
    print(taxIdList);
    print(isBoxList);
    print(categoryList);
    print(subCategoryList);

    if (productIdList.isNotEmpty) {
      try {
        String rawData = '{"customer_id": ${customerId},"sales_manager_id": ${loginData!.id},"category_id": ${categoryList},"sub_category_id": ${subCategoryList},"product_id": ${productIdList},"price": ${priceList},"quantity": ${quantityList},"tax_id": ${taxIdList},"is_box": ${isBoxList}}';

        final data = await APIFunction().apiCall(
          apiName: Constants.cart,
          context: Get.context!,
          token: accessToken,
          type: "expense",
          rawData: rawData,
        );

        GetDataListResponseModel model = GetDataListResponseModel.fromJson(data);

        if (model.data != null) {
          customerCartId = customerId;
          isAddedData.value = false;
          cartLength = model.data!.length.toString();
          Get.find<HomeController>().update();
          await getStorageData.saveString("customerId", customerCartId);
          // await getStorageData.saveObject("cartListFromAPI", model.data);
          isCategory.value = true;
          isSubCategory.value = false;
          isProduct.value = false;
          getCategoriesAPI(categoryId: "0");
          update();
          utils.showSnackBar(context: Get.context!, message: "Successfully added in to cart");
          update();
        } else {
          print("In else part");
        }
      } on Exception catch (error) {
        utils.showSnackBar(context: Get.context!, message: "Oops! Something want wrong");
      }
    } else {
      utils.showSnackBar(context: Get.context!, message: "Oops something went wrong");
    }
  }
}

// addProduct() async {
//     print(orderId);
//
//     /// edit order time add product
//     List productIdList = [];
//     List priceList = [];
//     List quantityList = [];
//     List taxIdList = [];
//     List isBoxList = [];
//     List categoryList = [];
//     List subCategoryList = [];
//
//     if (await orderId.isNotEmpty) {
//       print("order id empty nathi");
//       // Get.put(OrderDetailsController());
//       for (int i = 0; i < productList.length; i++) {
//         if (productList[i].quantityCount != "0") {}
//       }
//     }
//     update();
//     Get.find<OrderDetailsController>().isApiData.value = false;
//     Get.find<OrderDetailsController>().update();
//     Get.find<MyOrdersController>().id.value = orderId;
//     Get.find<HomeController>().addOrder.value = false;
//     Get.find<HomeController>().isSelected.value = 2;
//     Get.find<HomeController>().isOrderDetails.value = true;
//     Get.find<HomeController>().isOrderEdit.value = true;
//     print(Get.find<MyOrdersController>().id.value);
//     print("Get.find<MyOrdersController>().id.value");
//     Get.find<HomeController>().update();
//   }
