import 'package:true_leaf_inventory_app/app/models/details_response_model.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class CartController extends GetxController {
  TextEditingController quantityText = TextEditingController();
  List<CartDetails> orderItemList = [];
  GetDetailsData? getDetailsData;
  var isCongratulations = false.obs;
  var amountTax;
  var amount;
  var orderTotal = "".obs;
  var orderTax = "".obs;
  var orderFinalTotal = "".obs;
  LoginSignUpData? loginData;
  var isAddedData = false.obs;
  var isWrongData = false.obs;
  var productName = "".obs;
  var productId = "".obs;
  var customerId = "".obs;
  var noData = "".obs;
  
  // Delivery Agent Selection
  List<LoginSignUpData> deliveryAgents = [];
  var selectedDeliveryAgent = Rxn<LoginSignUpData>();
  var isLoadingAgents = false.obs;
  var showDeliveryAgentSelector = false.obs;

  @override
  void onInit() {
    getLoginData();
    getCartData();
    loadDeliveryAgents();
    super.onInit();
  }

  getLoginData() async {
    final data = getStorageData.readObject(getStorageData.loginData);
    if (data != null) {
      loginData = LoginSignUpData.fromJson(data);
      // Check if current user is a delivery agent
      if (loginData?.roles?.isNotEmpty == true && 
          loginData!.roles![0].title == "Delivery Agent") {
        showDeliveryAgentSelector.value = false;
      } else {
        showDeliveryAgentSelector.value = true;
      }
    }
    update();
  }

  // Load delivery agents from API
  loadDeliveryAgents() async {
    try {
      isLoadingAgents.value = true;
      
      final data = await APIFunction().apiCall(
        apiName: Constants.users,
        context: Get.context!,
        token: accessToken,
        type: "get",
        isLoading: false,
      );

      if (data != null && data['data'] != null) {
        List<dynamic> users = data['data'];
        deliveryAgents.clear();
        
        for (var user in users) {
          try {
            LoginSignUpData userData = LoginSignUpData.fromJson(user);
            // Filter only delivery agents
            if (userData.roles?.isNotEmpty == true && 
                userData.roles![0].title == "Delivery Agent") {
              deliveryAgents.add(userData);
            }
          } catch (e) {
            print('Error parsing user data: $e');
          }
        }
        
        print('Found ${deliveryAgents.length} delivery agents');
      }
      
      isLoadingAgents.value = false;
      update();
    } catch (e) {
      print('Error loading delivery agents: $e');
      isLoadingAgents.value = false;
      update();
    }
  }

  // Set selected delivery agent
  void selectDeliveryAgent(LoginSignUpData? agent) {
    selectedDeliveryAgent.value = agent;
    update();
  }

  deleteCartAPI({id, index}) async {
    Get.back();
    print(customerCartId);
    print(id);
    await APIFunction().apiCall(
      apiName: "${Constants.cart}/$customerCartId/$id",
      context: Get.context!,
      token: accessToken,
      type: "delete",
    );
    await orderItemList.removeAt(index);

    for (int i = 0; i < orderItemList.length; i++) {
      // if (orderItemList[i].isBox == 1) {
      //   amountTax = (((double.parse(orderItemList[i].boxSize.toString()) * double.parse(orderItemList[i].quantity!.toString())) * double.parse(orderItemList[i].price!.toString())) * double.parse(orderItemList[i].tax.toString())) / 100;
      //   amount = (double.parse(orderItemList[i].boxSize.toString()) * double.parse(orderItemList[i].quantity!.toString())) * double.parse(orderItemList[i].price!.toString());
      //   orderItemList[i].amountWithoutTax = amount.toString();
      //   orderItemList[i].amountOnlyTax = amountTax.toString();
      //   orderItemList[i].finalAmount = (amount + amountTax).toString();
      // } else {
      amountTax = ((double.parse(orderItemList[i].quantity.toString()) * double.parse(orderItemList[i].price.toString())) * double.parse(orderItemList[i].tax.toString())) / 100;
      amount = (double.parse(orderItemList[i].quantity!.toString())) * double.parse(orderItemList[i].price.toString());
      orderItemList[i].amountWithoutTax = amount.toString();
      orderItemList[i].amountOnlyTax = amountTax.toString();
      orderItemList[i].finalAmount = (amount + amountTax).toString();
      // }
    }

    orderTotal.value = (orderItemList.fold<double>(0, (sum, item) => sum + double.parse(item.amountWithoutTax.toString()))).toString();
    orderTax.value = (orderItemList.fold<double>(0, (sum, item) => sum + double.parse(item.amountOnlyTax.toString()))).toString();
    orderFinalTotal.value = (double.parse(orderTotal.value) + double.parse(orderTax.value)).toString();

    cartLength = (int.parse(cartLength) - 1).toString();
    update();
  }

  deleteCartListAPI({var isBack = false}) async {
    await APIFunction().apiCall(
      apiName: "${Constants.cart}/$customerCartId",
      context: Get.context!,
      token: accessToken,
      type: "delete",
    );
    cartLength = "0";
    if (isBack) {
      Get.back();
      if (Get.find<HomeController>().isSelected.value == 5) {
        Get.find<HomeController>().isSelected.value = 0;
      }
      Get.find<HomeController>().isSelected.value = 0;
      Future.delayed(
        Duration(milliseconds: 1),
        () {
          Get.find<HomeController>().isCart.value = false;
          Get.find<HomeController>().update();
        },
      );
      Get.find<HomeController>().update();
    }
    update();
  }

  getCartData() async {
    if (await customerCartId.isEmpty) {
      customerCartId = "0";
    } else {
      customerCartId = customerCartId;
    }
    update();
    final data = await APIFunction().apiCall(
      apiName: "${Constants.cart}/${customerCartId}",
      context: Get.context!,
      token: accessToken,
      type: "get",
    );

    GetDetailsResponseModel model = GetDetailsResponseModel.fromJson(data);

    if (model.data!.cartDetails!.isNotEmpty) {
      noData.value = "";
      getDetailsData = await model.data!;
      orderItemList = await model.data!.cartDetails!;
      customerId.value = await model.data!.customerId!;

      for (int i = 0; i < orderItemList.length; i++) {
        print("orderItemList[i].quantity");
        print(orderItemList[i].quantity);
        print(orderItemList[i].price);
        print(orderItemList[i].tax);
        // if (orderItemList[i].isBox == 1) {
        //   amountTax = (((double.parse(orderItemList[i].boxSize.toString()) * double.parse(orderItemList[i].quantity!.toString())) * double.parse(orderItemList[i].price!.toString())) * double.parse(orderItemList[i].tax.toString())) / 100;
        //   amount = (double.parse(orderItemList[i].boxSize.toString()) * double.parse(orderItemList[i].quantity!.toString())) * double.parse(orderItemList[i].price!.toString());
        //   orderItemList[i].amountWithoutTax = amount.toString();
        //   orderItemList[i].amountOnlyTax = amountTax.toString();
        //   orderItemList[i].finalAmount = (amount + amountTax).toString();
        // } else {
        amountTax = ((double.parse(orderItemList[i].quantity.toString()) * double.parse(orderItemList[i].price.toString())) * double.parse(orderItemList[i].tax.toString())) / 100;
        amount = (double.parse(orderItemList[i].quantity!.toString())) * double.parse(orderItemList[i].price.toString());
        orderItemList[i].amountWithoutTax = amount.toString();
        orderItemList[i].amountOnlyTax = amountTax.toString();
        orderItemList[i].finalAmount = (amount + amountTax).toString();
        // }
      }

      orderTotal.value = (orderItemList.fold<double>(0, (sum, item) => sum + double.parse(item.amountWithoutTax.toString()))).toString();
      orderTax.value = (orderItemList.fold<double>(0, (sum, item) => sum + double.parse(item.amountOnlyTax.toString()))).toString();
      orderFinalTotal.value = (double.parse(orderTotal.value) + double.parse(orderTax.value)).toString();
      print("orderTotalvalueorderTotalvalueorderTotalvalue");
      print(orderTotal.value);
      print(orderTax.value);
      print(orderFinalTotal.value);
      update();
    } else {
      noData.value = "No products in the cart.";
      print("In else part");
      update();
    }
  }

  postOrderAPI() async {
    List categoryList = [];
    List subCategoryList = [];
    List productList = [];
    List packageList = [];
    List quantityList = [];
    List salesPriceList = [];
    List taxList = [];
    List isBoxList = [];
    List descriptionList = [];
    List commentList = [];
    for (int i = 0; i < orderItemList.length; i++) {
      categoryList.add(orderItemList[i].categoryId);
      subCategoryList.add(orderItemList[i].subCategoryId);
      productList.add(orderItemList[i].productId);
      packageList.add(orderItemList[i].boxSize);
      quantityList.add(orderItemList[i].quantity);
      salesPriceList.add(orderItemList[i].price);
      taxList.add(orderItemList[i].taxId);
      isBoxList.add(orderItemList[i].isBox);
      commentList.add(orderItemList[i].comment?.text);
      descriptionList.add(orderItemList[i].description!.text);
    }

    if (categoryList.isNotEmpty) {
      try {
        // Include delivery agent ID in order data
        String deliveryAgentId = selectedDeliveryAgent.value?.id?.toString() ?? "null";
        
        String rawData =
            '{"sales_manager_id": ${loginData!.id},"customer_id": "${getDetailsData!.customerId}","delivery_agent_id": ${deliveryAgentId},"item_category": ${categoryList},"item_subcategory": ${subCategoryList},"item_name": ${productList},"package_val": ${packageList},"item_quantity": ${quantityList},"item_sale_priec": ${salesPriceList},"item_tax_id": ${taxList},"is_box": ${isBoxList},"order_total_without_tax": ${orderTotal.value},"order_tax": ${orderTax.value},"discount_type": ${0},"extra_discount": "${0}","order_total": "${orderFinalTotal.value}","comment":  ${jsonEncode(commentList)},"delivery_note": "${getDetailsData!.deliveryNote}","customer_sign": "${getDetailsData!.customerSign}","status": "1","order_date":"${DateTime.now().toString().split(".").first}"}';

        final data = await APIFunction().apiCall(
          apiName: Constants.orders,
          context: Get.context!,
          token: accessToken,
          type: "expense",
          rawData: rawData,
        );

        GetDetailsResponseModel model = GetDetailsResponseModel.fromJson(data);

        if (model.data != null) {
          isCongratulations.value = true;
          deleteCartListAPI();
          update();
        } else {
          print("In else part");
        }
      } on Exception {
        utils.showSnackBar(context: Get.context!, message: "The name has already been taken.");
      }
    }
  }
}
