import 'package:true_leaf_inventory_app/app/models/details_response_model.dart';
import 'package:true_leaf_inventory_app/app/models/get_all_data_model.dart';
import 'package:true_leaf_inventory_app/app/utils/price_calculator.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';
// Add this for jsonEncode

enum ViewLevel { categories, subCategories, products }

class OrdersController extends GetxController {
  var customerId;

  OrdersController({this.customerId});

  List<GetDataListResponseData> categoryList = <GetDataListResponseData>[];
  List<GetDataListResponseData> productList = <GetDataListResponseData>[];
  List<GetDataListResponseData> tempProductList = <GetDataListResponseData>[];
  List<GetDataListResponseData> tempCategoryList = <GetDataListResponseData>[];
  List<GetDataListResponseData> currentSubCategoryProducts =
      <GetDataListResponseData>[]; // Products for current subcategory only
  TextEditingController quantityText = TextEditingController();
  TextEditingController sellingPriceText = TextEditingController();
  LoginSignUpData? loginData;
  var isProduct = false.obs;
  var isSubCategory = false.obs;
  var isCategory = true.obs;
  var currentView = ViewLevel.categories.obs;
  var noData = "".obs;
  var isAddedData = false.obs;
  var isAddToCartButton = false.obs;
  var cameFromCategoryWithNoSubcategories = false.obs; // <-- Added variable

  /// API Data Params

  var categoryId = "".obs;
  var categoryName = "".obs;
  var subCategoryId = "".obs;
  var subCategoryName = "".obs;
  var customerIdValue = "".obs;
  var productName = "".obs;
  var productId = "".obs;

  // Add these for proper navigation tracking
  var parentCategoryId = "".obs;
  var currentCategoryId = "".obs;
  var currentSubCategoryId = "".obs;

  // Pre-grouped products for fast lookups
  Map<String, List<GetDataListResponseData>> productsBySubCategory = {};
  Map<String, List<GetDataListResponseData>> productsByCategory = {};

  // ─── 3) Convenience getters ─────────────────────────────────────────────
  bool get inProducts => currentView.value == ViewLevel.products;
  bool get inSubCategories => currentView.value == ViewLevel.subCategories;

  // ─── 4) Central reset helper ────────────────────────────────────────────
  void resetToCategories() {
    currentView.value = ViewLevel.categories;
    isAddedData.value = false;
    isAddToCartButton.value = false;
    getCategoriesAPI(categoryId: "0");
    update();
  }

  GetDetailsData? getDetailsData;
  List<GetDataListResponseData> orderItem = [];

  @override
  void onInit() {
    getLoginData();
    getCategoriesAPI(categoryId: "0");
    getProductAPI();

    // Make sure we have order data when editing
    final homeController = Get.find<HomeController>();
    if (homeController.isOrderEdit.value && orderId != "0") {
      getAllOrderData();

      // Ensure customer ID is set from order data
      if (getDetailsData?.customerId != null) {
        homeController.isCustomerId.value =
            getDetailsData!.customerId.toString();
        customerId = getDetailsData!.customerId.toString();
      }
    }

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
      tempCategoryList = model.data!;

      noData.value = "";
      update();
    } else {
      isSubCategory.value = false;
      isCategory.value = false;
      noData.value = "No data found";
      getProduct(subCategoryId: categoryId, type: "category");
      update();
    }

    // In your getCategoriesAPI or wherever you load subcategories
    if (categoryList.isEmpty) {
      // No subcategories, go directly to products
      cameFromCategoryWithNoSubcategories.value = true;
      getProduct(subCategoryId: currentCategoryId.value, type: "category");
    } else {
      cameFromCategoryWithNoSubcategories.value = false;
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

      // Pre-group products by subcategory and category for fast lookups
      productsBySubCategory.clear();
      productsByCategory.clear();

      for (var product in tempProductList) {
        if (product.subCategoryId != null) {
          String key = product.subCategoryId.toString();
          if (!productsBySubCategory.containsKey(key)) {
            productsBySubCategory[key] = [];
          }
          productsBySubCategory[key]!.add(product);
        }

        if (product.categoryId != null) {
          String key = product.categoryId.toString();
          if (!productsByCategory.containsKey(key)) {
            productsByCategory[key] = [];
          }
          productsByCategory[key]!.add(product);
        }
      }

      update();
    }
  }

  getProduct({required var subCategoryId, type}) {
    isProduct.value = true;

    if (productList.isNotEmpty) {
      productList.clear();
    }
    if (categoryList.isNotEmpty) {
      categoryList.clear();
    }
    update();

    // Use pre-grouped products for fast O(1) lookup instead of O(n) loop
    List<GetDataListResponseData>? matchedProducts;
    if (type == "subCategory") {
      matchedProducts = productsBySubCategory[subCategoryId.toString()];
    } else if (type == "category") {
      matchedProducts = productsByCategory[subCategoryId.toString()];
    }

    if (matchedProducts != null && matchedProducts.isNotEmpty) {
      noData.value = "";

      for (var tempProduct in matchedProducts) {
        if (tempProduct.stock != 0) {
          final taxValue = tempProduct.taxDetail?.tax ??
              (tempProduct.tax is int ? tempProduct.tax as int : 0);

          productList.add(
            GetDataListResponseData(
              id: tempProduct.id,
              productId: tempProduct.id,
              name: tempProduct.name,
              sellingPrice: tempProduct.sellingPrice,
              stock: tempProduct.stock,
              createdAt: tempProduct.createdAt,
              updatedAt: tempProduct.updatedAt,
              deletedAt: tempProduct.deletedAt,
              categoryId: tempProduct.categoryId,
              maximumSellingPrice: tempProduct.maximumSellingPrice,
              boxSize: tempProduct.boxSize,
              isEdit: false,
              imageUrl: tempProduct.imageUrl,
              taxId: tempProduct.taxId,
              subCategoryId: tempProduct.subCategoryId,
              productImage: tempProduct.productImage,
              quantityCount: "0",
              isBox: tempProduct.isBox,
              isUnitSelected: 1,
              tax: taxValue,
              descriptionInvoice: tempProduct.descriptionInvoice,
              taxDetail: tempProduct.taxDetail ?? Tax(tax: taxValue),
            ),
          );
        }
      }
    }

    // Sort products alphabetically by name
    productList.sort((a, b) =>
        (a.name ?? '').toLowerCase().compareTo((b.name ?? '').toLowerCase()));

    if (productList.isEmpty) {
      noData.value = "No products found";
    }

    // Backup the current subcategory's products for search
    currentSubCategoryProducts = List.from(productList);

    update();
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

      // Set customer ID immediately
      final homeController = Get.find<HomeController>();
      if (getDetailsData!.customerId != null) {
        homeController.isCustomerId.value =
            getDetailsData!.customerId.toString();
        customerId = getDetailsData!.customerId.toString();
      }

      print(orderItem.length);

      update();
    } else {
      update();
    }
  }

  var orderTotal = "".obs;
  var orderTax = "".obs;
  var orderFinalTotal = "".obs;

  /// work edit order
  // editOrderAPI() async {
  //
  //   print(orderItem.length);
  //   print(productList.length);
  //
  //   int l = orderItem.length;
  //   int k = productList.length;
  //   bool whichListIsBig = l <= k;
  //
  //   print(whichListIsBig);
  //
  //
  //   if (whichListIsBig) {
  //
  //     for (int i = 0; i < productList.length; i++) {
  //       for (int j = 0; j < orderItem.length; j++) {
  //         if (await productList[i].quantityCount != "0") {
  //           print(productList[i].name);
  //
  //           if (await productList[i].productId == orderItem[j].productId) {
  //             orderItem[j] = productList[i];
  //           } else {
  //             orderItem.add(productList[i]);
  //             // break;
  //           }
  //         } else {
  //
  //         }
  //       }
  //     }
  //   } else {
  //
  //     for (int i = 0; i < orderItem.length; i++) {
  //       for (int j = 0; j < productList.length; j++) {
  //         if (await productList[j].quantityCount != "0") {
  //           print(productList[j].name);
  //
  //           if (await productList[j].productId == orderItem[i].productId) {
  //
  //             orderItem[i] = productList[j];
  //           } else {
  //
  //             orderItem.add(productList[j]);
  //             // break;
  //           }
  //         } else {
  //
  //         }
  //         // if (await productList[j].quantityCount != "0") {
  //         //   if (orderItem.contains(productList[j])) {
  //         //
  //         //     orderItem[i] = GetDataListResponseData();
  //         //     orderItem[i] = productList[j];
  //         //     break;
  //         //   } else {
  //         //     orderItem.add(productList[j]);
  //         //     break;
  //         //   }
  //         // } else {
  //         //
  //         // }
  //       }
  //       // break;
  //     }
  //   }
  //
  //   print(orderItem.length);
  //
  //
  //   List categoryList = [];
  //   List subCategoryList = [];
  //   List productAPIList = [];
  //   List packageList = [];
  //   List quantityList = [];
  //   List salesPriceList = [];
  //   List taxList = [];
  //   List isBoxList = [];
  //   List isProductName = [];
  //   if (orderItem.isNotEmpty) {
  //     List<GetDataListResponseData> apiList = [];
  //     for (int js = 0; js < orderItem.length; js++) {
  //       apiList = orderItem.toSet().toList();
  //     }
  //
  //     for (int k = 0; k < apiList.length; k++) {
  //       categoryList.add(apiList[k].categoryId);
  //       subCategoryList.add(apiList[k].subCategoryId);
  //       productAPIList.add(apiList[k].productId);
  //       packageList.add(apiList[k].boxSize);
  //       quantityList.add(apiList[k].quantityCount);
  //       salesPriceList.add(apiList[k].salePrice);
  //       isProductName.add(apiList[k].name);
  //       taxList.add(apiList[k].taxId);
  //       isBoxList.add(apiList[k].isBox);
  //       var amountTax;
  //       var amount;
  //       // if (apiList[k].isBox == 1) {
  //       //   amountTax = (((double.parse(apiList[k].boxSize.toString()) * double.parse(apiList[k].quantityCount!.toString())) * double.parse(apiList[k].sellingPrice!.toString())) * double.parse(apiList[k].tax.toString())) / 100;
  //       //   amount = (double.parse(apiList[k].boxSize.toString()) * double.parse(apiList[k].quantityCount!.toString())) * double.parse(apiList[k].sellingPrice!.toString());
  //       //   apiList[k].amountWithoutTax = amount.toString();
  //       //   apiList[k].amountOnlyTax = amountTax.toString();
  //       //   apiList[k].finalAmount = (amount + amountTax).toString();
  //       // } else {
  //       amountTax = ((double.parse(apiList[k].quantityCount.toString()) * double.parse(apiList[k].salePrice.toString())) * double.parse(apiList[k].tax.toString())) / 100;
  //       amount = (double.parse(apiList[k].quantityCount!.toString())) * double.parse(apiList[k].salePrice.toString());
  //       apiList[k].amountWithoutTax = amount.toString();
  //       apiList[k].amountOnlyTax = amountTax.toString();
  //       apiList[k].finalAmount = (amount + amountTax).toString();
  //       // }
  //     }
  //
  //     orderTotal.value = (apiList.fold<double>(0, (sum, item) => sum + double.parse(item.amountWithoutTax.toString()))).toString();
  //     orderTax.value = (apiList.fold<double>(0, (sum, item) => sum + double.parse(item.amountOnlyTax.toString()))).toString();
  //     orderFinalTotal.value = (double.parse(orderTotal.value) + double.parse(orderTax.value)).toString();
  //   }
  //
  //   print(orderTotal.value);
  //   print(orderTax.value);
  //   print(orderFinalTotal.value);
  //   update();
  //
  //   print(categoryList);
  //   print(subCategoryList);
  //   print(productAPIList);
  //   print(packageList);
  //   print(quantityList);
  //   print(isProductName);
  //   print(salesPriceList);
  //   print(taxList);
  //   print(isBoxList);
  //
  //
  //   // print(getDetailsData!.orderTotalWithoutTax);
  //   // print(orderTotal.value);
  //   // print(getDetailsData!.orderTax);
  //   // print(orderTax.value);
  //   // print(getDetailsData!.orderTotal);
  //   // print(orderFinalTotal.value);
  //   // print(getDetailsData!.status);
  //   // print(getDetailsData!.discountType);
  //   // print(getDetailsData!.orderDate!.split(".").first);
  //   //
  //   /// api call
  //
  //   if (categoryList.isNotEmpty) {
  //     try {
  //       String rawData =
  //           '{"sales_manager_id": "${getDetailsData!.salesManagerId}","customer_id": ${getDetailsData!.customerId},"item_category": ${categoryList},"item_subcategory": ${subCategoryList},"item_name": ${productAPIList},"package_val": ${packageList},"item_quantity": ${quantityList},"item_sale_priec": ${salesPriceList},"item_tax_id": ${taxList},"is_box": ${isBoxList},"order_total_without_tax": ${orderTotal.value},"order_tax": ${orderTax.value},"discount_type": ${getDetailsData!.discountType},"extra_discount": "${getDetailsData!.extraDiscount}","order_total": "${orderFinalTotal.value}","comments": "${getDetailsData!.comments}","delivery_note": "${getDetailsData!.deliveryNote}","customer_sign": "${getDetailsData!.customerSign}","status": "${getDetailsData!.status}","order_date":"${getDetailsData!.orderDate!.split(".").first}'}';
  //
  //       final data = await APIFunction().apiCall(
  //         apiName: "${Constants.orders}/${orderId}",
  //         context: Get.context!,
  //         token: accessToken,
  //         type: "put",
  //         rawData: rawData,
  //       );
  //
  //       GetDetailsResponseModel model = GetDetailsResponseModel.fromJson(data);
  //
  //       if (model.data != null) {
  //         Get.put(OrderDetailsController());
  //         Get.put(MyOrdersController());
  //         Get.find<OrderDetailsController>().update();
  //         Get.find<MyOrdersController>().id.value = orderId;
  //         Get.find<HomeController>().addOrder.value = false;
  //         Get.find<HomeController>().isSelected.value = 2;
  //         Get.find<HomeController>().isOrderDetails.value = true;
  //         Get.find<HomeController>().isOrderEdit.value = true;
  //         print(Get.find<MyOrdersController>().id.value);
  //
  //         Get.find<HomeController>().update();
  //         update();
  //         Get.back();
  //       } else {
  //
  //       }
  //     } on Exception catch (error) {
  //       utils.showSnackBar(context: Get.context!, message: "The name has already been taken.");
  //     }
  //   }
  // }

  // worked on it

  editOrderAPI() async {
    // Get order ID
    String currentOrderId = orderId.toString();

    if (currentOrderId.isEmpty || currentOrderId == "0") {
      Get.snackbar("Error", "Order information not available");
      return;
    }

    try {
      // Add selected products to existing order items
      for (int i = 0; i < productList.length; i++) {
        final product = productList[i];
        final quantityStr = product.quantityCount?.toString() ?? "0";

        if (quantityStr != "0" && quantityStr.isNotEmpty) {
          // Check if product already exists in order
          bool productExists = false;

          for (int j = 0; j < orderItem.length; j++) {
            // Safe string comparison of product IDs
            final orderProductId = orderItem[j].productId?.toString() ?? '';
            final newProductId = product.id?.toString() ?? '';

            if (orderProductId == newProductId && orderProductId.isNotEmpty) {
              // Update existing product quantity
              final existingQty =
                  int.tryParse(orderItem[j].quantityCount?.toString() ?? "0") ??
                      0;
              final newQty = int.tryParse(quantityStr) ?? 0;
              orderItem[j].quantityCount = (existingQty + newQty).toString();
              productExists = true;
              break;
            }
          }

          // Add new product if it doesn't exist
          if (!productExists) {
            // Create new order item with safe field assignments
            final newOrderItem = GetDataListResponseData(
              id: product.id,
              productId: product.id,
              name: product.name,
              sellingPrice: product.sellingPrice,
              salePrice: product.sellingPrice,
              quantityCount: quantityStr,
              categoryId: product.categoryId,
              subCategoryId: product.subCategoryId,
              boxSize: product.boxSize ?? 1,
              taxId: product.taxId,
              isBox: product.isBox ?? 0,
              tax: product.tax,
              stock: product.stock,
              createdAt: product.createdAt,
              updatedAt: product.updatedAt,
              deletedAt: product.deletedAt,
              maximumSellingPrice: product.maximumSellingPrice,
              isEdit: product.isEdit ?? false,
              imageUrl: product.imageUrl,
              productImage: product.productImage,
              isUnitSelected: product.isUnitSelected ?? 1,
              isWrongData: product.isWrongData ?? false,
              taxDetail: product.taxDetail,
            );

            orderItem.add(newOrderItem);
          }
        }
      }

      // Prepare API data with safe type conversions
      List<dynamic> categoryList = [];
      List<dynamic> subCategoryList = [];
      List<dynamic> productAPIList = [];
      List<dynamic> packageList = [];
      List<dynamic> quantityList = [];
      List<dynamic> salesPriceList = [];
      List<dynamic> taxList = [];
      List<dynamic> isBoxList = [];

      if (orderItem.isNotEmpty) {
        for (int k = 0; k < orderItem.length; k++) {
          final item = orderItem[k];

          // Safe conversion to appropriate types
          categoryList.add(item.categoryId ?? 0);
          subCategoryList.add(item.subCategoryId ?? 0);
          productAPIList.add(item.productId ?? item.id ?? 0);
          packageList.add(item.boxSize ?? 1);
          quantityList
              .add(int.tryParse(item.quantityCount?.toString() ?? "0") ?? 0);

          // Handle price fields safely
          final salePrice = item.salePrice ?? item.sellingPrice;
          salesPriceList
              .add(double.tryParse(salePrice?.toString() ?? "0") ?? 0);

          taxList.add(item.taxId ?? 0);
          isBoxList.add(item.isBox ?? 0);

          // Calculate amounts with error handling
          try {
            final breakdown = PriceCalculator.calculate(
              quantity: item.quantityCount,
              price: salePrice,
              tax: item.tax,
              boxSize: item.boxSize,
              isBox: item.isBox,
            );

            item.amountWithoutTax =
                breakdown.amountWithoutTax.toStringAsFixed(2);
            item.amountOnlyTax = breakdown.amountOnlyTax.toStringAsFixed(2);
            item.finalAmount = breakdown.finalAmount.toStringAsFixed(2);
          } catch (e) {
            item.amountWithoutTax = "0";
            item.amountOnlyTax = "0";
            item.finalAmount = "0";
          }
        }

        // Calculate totals safely
        try {
          double totalWithoutTax = 0;
          double totalTax = 0;

          for (final item in orderItem) {
            totalWithoutTax +=
                double.tryParse(item.amountWithoutTax?.toString() ?? "0") ?? 0;
            totalTax +=
                double.tryParse(item.amountOnlyTax?.toString() ?? "0") ?? 0;
          }

          orderTotal.value = totalWithoutTax.toString();
          orderTax.value = totalTax.toString();
          orderFinalTotal.value = (totalWithoutTax + totalTax).toString();
        } catch (e) {
          orderTotal.value = "0";
          orderTax.value = "0";
          orderFinalTotal.value = "0";
        }
      }

      // Make API call to update existing order
      if (categoryList.isNotEmpty && getDetailsData != null) {
        try {
          final requestData = {
            "sales_manager_id":
                getDetailsData!.salesManagerId?.toString() ?? "",
            "customer_id": getDetailsData!.customerId ?? 0,
            "delivery_agent_id": getDetailsData!.deliveryAgentId,
            "item_category": categoryList,
            "item_subcategory": subCategoryList,
            "item_name": productAPIList,
            "package_val": packageList,
            "item_quantity": quantityList,
            "item_sale_priec": salesPriceList,
            "item_tax_id": taxList,
            "is_box": isBoxList,
            "order_total_without_tax": double.tryParse(orderTotal.value) ?? 0,
            "order_tax": double.tryParse(orderTax.value) ?? 0,
            "discount_type": getDetailsData!.discountType ?? 0,
            "extra_discount": getDetailsData!.extraDiscount?.toString() ?? "0",
            "order_total": orderFinalTotal.value,
            "comments": getDetailsData!.comments?.toString() ?? "null",
            "delivery_note": getDetailsData!.deliveryNote?.toString() ?? "null",
            "customer_sign": getDetailsData!.customerSign?.toString() ?? "null",
            "status": getDetailsData!.status?.toString() ?? "3",
            "order_date": getDetailsData!.orderDate?.split(".").first ??
                DateTime.now().toString().split(" ").first
          };

          String rawData = jsonEncode(requestData);

          final data = await APIFunction().apiCall(
            apiName: "${Constants.orders}/$currentOrderId",
            context: Get.context!,
            token: accessToken,
            type: "put",
            rawData: rawData,
          );

          // Check if API call was successful
          if (data != null) {
            // Preserve customer ID for next operations
            final homeController = Get.find<HomeController>();
            if (getDetailsData?.customerId != null) {
              homeController.isCustomerId.value =
                  getDetailsData!.customerId.toString();
              customerId = getDetailsData!.customerId
                  .toString(); // Update local customerId too
            }

            // Reset product quantities but stay on page
            for (var product in productList) {
              product.quantityCount = "0";
            }

            utils.showSnackBar(
                context: Get.context!,
                message:
                    "Products added successfully! You can add more products or go back to order details.");
            update();
          } else {
            utils.showSnackBar(
                context: Get.context!, message: "Failed to update order");
          }
        } catch (error) {
          utils.showSnackBar(
              context: Get.context!, message: "Error updating order: $error");
        }
      } else {
        utils.showSnackBar(
            context: Get.context!,
            message: "No products selected or order data missing");
      }
    } catch (error) {
      utils.showSnackBar(
          context: Get.context!, message: "Error adding products: $error");
    }
  }

  /// add to cart api
  addToCartAPI() async {
    print(
        "HomeController customerId: ${Get.find<HomeController>().isCustomerId.value}");

    // Check if we're adding to an existing order
    final homeController = Get.find<HomeController>();
    final isEditingOrder = homeController.isOrderEdit.value;

    if (isEditingOrder) {
      await editOrderAPI();
      return;
    }

    final requestedCustomerId = customerId?.toString().trim() ?? "";
    final storedCustomerId = homeController.isCustomerId.value.trim();
    final resolvedCustomerId =
        requestedCustomerId.isNotEmpty ? requestedCustomerId : storedCustomerId;

    if (resolvedCustomerId.isEmpty) {
      utils.showSnackBar(
        context: Get.context!,
        message: "Customer information is not available",
      );
      return;
    }

    if (loginData?.id == null) {
      utils.showSnackBar(
        context: Get.context!,
        message: "Sales manager information is not available",
      );
      return;
    }

    customerId = resolvedCustomerId;

    // Original logic for creating new orders

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

        // Use product's category ID, with fallback to controller value
        var prodCatId = productList[i].categoryId;
        if (prodCatId == null || prodCatId.toString().isEmpty) {
          categoryList.add(categoryId.value.isNotEmpty
              ? int.tryParse(categoryId.value)
              : null);
        } else {
          categoryList.add(prodCatId);
        }

        // Handle subcategory: use product's subcategory if available and not empty
        var productSubCatId = productList[i].subCategoryId;
        if (productSubCatId == null ||
            productSubCatId.toString().isEmpty ||
            productSubCatId.toString() == "null") {
          // If subCategoryId from controller is also empty, use null
          if (subCategoryId.value.isEmpty || subCategoryId.value == "null") {
            subCategoryList.add(null);
          } else {
            var subCatInt = int.tryParse(subCategoryId.value);
            subCategoryList.add(subCatInt);
          }
        } else {
          subCategoryList.add(productSubCatId);
        }
      }
    }

    if (productIdList.isNotEmpty) {
      try {
        final requestData = {
          "customer_id": int.tryParse(resolvedCustomerId) ?? resolvedCustomerId,
          "sales_manager_id": loginData!.id,
          "category_id": categoryList,
          "sub_category_id": subCategoryList,
          "product_id": productIdList,
          "price": priceList,
          "quantity": quantityList,
          "tax_id": taxIdList,
          "is_box": isBoxList,
        };
        final rawData = jsonEncode(requestData);

        print("📦 Cart API Request Data:");
        print("Customer ID: $customerId");
        print("Products count: ${productIdList.length}");
        print("Sub Categories: $subCategoryList");
        print("Raw Data: $rawData");

        final data = await APIFunction().apiCall(
          apiName: Constants.cart,
          context: Get.context!,
          token: accessToken,
          type: "expense",
          rawData: rawData,
        );

        GetDataListResponseModel model =
            GetDataListResponseModel.fromJson(data);

        if (model.data != null) {
          customerCartId = customerId;
          isAddedData.value = false;
          cartLength = model.data!.length.toString();
          Get.find<HomeController>().update();
          await getStorageData.saveString("customerId", customerCartId);

          isCategory.value = true;
          isSubCategory.value = false;
          isProduct.value = false;
          getCategoriesAPI(categoryId: "0");
          update();
          utils.showSnackBar(
              context: Get.context!, message: "Successfully added to cart");
          update();
        } else {
          print("⚠️ Cart API returned null data");
        }
      } catch (e) {
        print("❌ Cart API Error: $e");
        utils.showSnackBar(
            context: Get.context!,
            message: "Failed to add to cart: ${e.toString()}");
      }
    } else {
      utils.showSnackBar(
          context: Get.context!, message: "Please select at least one product");
    }
  }

  void validateQuantity(int index) {
    final product = productList[index];
    final qtyStr = product.quantityCount ?? "";
    final stockStr = product.stock?.toString() ?? "0";

    if (qtyStr.isEmpty || qtyStr == "0") {
      product.isWrongData = false; // No error for empty/zero quantity
      return;
    }

    final qty = double.tryParse(qtyStr) ?? 0;
    final stock = double.tryParse(stockStr) ?? 0;

    product.isWrongData = (qty <= 0 || qty > stock);
  }

  /// Search sub-categories
  void searchSubCategories({required String text}) {
    if (text.isEmpty) {
      // Restore original list when search is cleared
      categoryList = tempCategoryList;
    } else {
      // Filter categories based on search text
      categoryList = tempCategoryList
          .where((category) =>
              category.name!.toLowerCase().contains(text.toLowerCase()))
          .toList();
    }
    update();
  }

  /// Search products
  void searchProducts({required String text}) {
    if (text.isEmpty) {
      // Restore original list when search is cleared
      productList = List.from(currentSubCategoryProducts);
    } else {
      // Filter products based on search text
      productList = currentSubCategoryProducts
          .where((product) =>
              product.name!.toLowerCase().contains(text.toLowerCase()))
          .toList();
    }
    update();
  }
}
