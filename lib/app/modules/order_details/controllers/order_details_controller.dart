import 'dart:io';
import 'dart:ui' as ui;

import 'package:file_selector/file_selector.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:true_leaf_inventory_app/app/models/details_response_model.dart';
import 'package:true_leaf_inventory_app/app/models/get_all_data_model.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';
import 'package:pdf/widgets.dart' as pw;

class OrderDetailsController extends GetxController {
  var id;

  OrderDetailsController({this.id});

  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();

  GetDetailsData? getDetailsData;
  List<GetDataListResponseData> orderItem = [];
  TextEditingController comments = TextEditingController();
  TextEditingController sellingPriceText = TextEditingController();

  LoginSignUpData? loginData;
  var signImage = "".obs;
  var isWrongData = false.obs;
  
  // Delivery Agent Management
  List<LoginSignUpData> deliveryAgents = [];
  var selectedDeliveryAgent = Rxn<LoginSignUpData>();
  var isLoadingAgents = false.obs;
  var showDeliveryAgentSelector = false.obs;

  @override
  void onInit() {
    orderDetails();
    loadDeliveryAgents();
    super.onInit();
  }

  @override
  void onReady() {
    // Force refresh if data is not loaded
    if (getDetailsData == null) {
      orderDetails();
    }
    super.onReady();
  }

  // Force refresh order details - useful when navigating from different screens
  void refreshOrderDetails() {
    getDetailsData = null;
    orderItem.clear();
    orderDetails();
  }

  getLoginData() async {
    final data = await getStorageData.readObject(getStorageData.loginData);
    if (data != null) {
      loginData = LoginSignUpData.fromJson(data);
      // Check if current user is a delivery agent - they shouldn't be able to change driver
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
            // Silently handle parsing errors
          }
        }
        
        // Set currently assigned delivery agent
        if (getDetailsData?.deliveryAgentId != null) {
          // Convert both to string for comparison to handle type mismatches
          String orderDeliveryAgentId = getDetailsData!.deliveryAgentId.toString();
          selectedDeliveryAgent.value = deliveryAgents.firstWhereOrNull(
            (agent) => agent.id.toString() == orderDeliveryAgentId,
          );
          
        } else {
          selectedDeliveryAgent.value = null;
        }
      }
      
      isLoadingAgents.value = false;
      update();
    } catch (e) {
      isLoadingAgents.value = false;
      update();
    }
  }

  // Set selected delivery agent
  void selectDeliveryAgent(LoginSignUpData? agent) {
    selectedDeliveryAgent.value = agent;
    update();
  }

  // Update delivery agent for the order
  updateDeliveryAgent() async {
    try {
      if (getDetailsData == null || orderItem.isEmpty) {
        Get.snackbar(
          "Error",
          "Order data not available",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      String deliveryAgentId = selectedDeliveryAgent.value?.id?.toString() ?? "null";
      
      // Validate that delivery agent ID is a positive integer
      int? deliveryAgentIdInt;
      if (deliveryAgentId != "null") {
        deliveryAgentIdInt = int.tryParse(deliveryAgentId);
        if (deliveryAgentIdInt == null || deliveryAgentIdInt <= 0) {
          Get.snackbar(
            "Error",
            "Invalid delivery agent ID",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }
      }
      
      // Prepare order items data
      List categoryList = [];
      List subCategoryList = [];
      List productAPIList = [];
      List packageList = [];
      List quantityList = [];
      List salesPriceList = [];
      List taxList = [];
      List isBoxList = [];

      for (int i = 0; i < orderItem.length; i++) {
        categoryList.add(orderItem[i].categoryId);
        subCategoryList.add(orderItem[i].subCategoryId);
        productAPIList.add(orderItem[i].productId);
        packageList.add(orderItem[i].boxSize);
        quantityList.add(orderItem[i].quantityCount);
        salesPriceList.add(orderItem[i].salePrice);
        taxList.add(orderItem[i].taxId);
        isBoxList.add(orderItem[i].isUnitSelected);
      }

      // Include ALL required fields as per API validation
      final requestData = {
        "sales_manager_id": getDetailsData!.salesManagerId?.toString() ?? "",
        "customer_id": getDetailsData!.customerId ?? 0,
        "delivery_agent_id": deliveryAgentIdInt?.toString() ?? "", // Always include, use empty string if null
        "item_category": categoryList,
        "item_subcategory": subCategoryList,
        "item_name": productAPIList,
        "package_val": packageList,
        "item_quantity": quantityList,
        "item_sale_priec": salesPriceList,
        "item_tax_id": taxList,
        "is_box": isBoxList,
        "order_total_without_tax": getDetailsData!.orderTotalWithoutTax ?? 0,
        "order_tax": getDetailsData!.orderTax ?? 0,
        "discount_type": getDetailsData!.discountType ?? 0,
        "extra_discount": getDetailsData!.extraDiscount?.toString() ?? "0",
        "order_total": getDetailsData!.orderTotal ?? 0,
        "comments": getDetailsData!.comments?.toString() ?? "null",
        "delivery_note": getDetailsData!.deliveryNote?.toString() ?? "null",
        "customer_sign": getDetailsData!.customerSign?.toString() ?? "null",
        "status": "1",
        "order_date": getDetailsData!.orderDate?.split(".").first ?? DateTime.now().toString().split(" ").first
      };

      String rawData = jsonEncode(requestData);
      final data = await APIFunction().apiCall(
        apiName: "${Constants.orders}/${id}",
        context: Get.context ?? Get.overlayContext!,
        token: accessToken,
        type: "put",
        rawData: rawData,
      );

        if (data != null) {
          print("API Update Response received");
          
          // Check if the response contains the updated delivery_agent_id
          if (data is Map && data.containsKey('data')) {
            var orderData = data['data'];
            print("Updated order delivery_agent_id: ${orderData['delivery_agent_id']}");
            print("Response order ID: ${orderData['id']}");
            print("Response status: ${orderData['status']}");
            
            // Check if the delivery agent was actually updated
            var responseDeliveryAgentId = orderData['delivery_agent_id'];
            var responseIdAsInt = responseDeliveryAgentId is String ? int.tryParse(responseDeliveryAgentId) : responseDeliveryAgentId;
            
            if (responseIdAsInt == deliveryAgentIdInt) {
              print("SUCCESS: Delivery agent was updated correctly! ID: $deliveryAgentIdInt");
              
              // Show success message only if the update was actually successful
              Get.snackbar(
                "Success",
                "Delivery driver assigned successfully to ${selectedDeliveryAgent.value?.name}",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            } else {
              print("ISSUE: Delivery agent was not updated. Expected: $deliveryAgentIdInt, Got: $responseIdAsInt (original: $responseDeliveryAgentId)");
              
              Get.snackbar(
                "Warning", 
                "Delivery driver assignment may not have been successful",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.orange,
                colorText: Colors.white,
              );
            }
          } else {
            print("API response does not contain 'data' field: $data");
          }        // Refresh order details to get updated data
        try {
          orderDetails();
        } catch (refreshError) {
          print("Error refreshing order details: $refreshError");
        }
        
        // Remove the generic success message since we now have specific ones above
        // Get.snackbar(
        //   "Success",
        //   "Delivery driver updated successfully",
        //   snackPosition: SnackPosition.BOTTOM,
        //   backgroundColor: Colors.green,
        //   colorText: Colors.white,
        // );
      }
    } catch (e) {
      print('Error updating delivery agent: $e');
      Get.snackbar(
        "Error",
        "Failed to update delivery driver",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  var imageEncoded = "".obs;

  handleSaveButtonPressed() async {
    final data =
        await signatureGlobalKey.currentState!.toImage(pixelRatio: 3.0);
    final bytes = await data.toByteData(format: ui.ImageByteFormat.png);
    imageEncoded.value = base64.encode(bytes!.buffer.asUint8List());
    update();
  }

  /// Order Details
  orderDetails() async {
    await getLoginData();

    // Improved ID handling - check constructor parameter first, then MyOrdersController, then global orderId
    if (id == null || id == "" || id == "0") {
      // Try to get from MyOrdersController if available
      try {
        var myOrdersController = Get.find<MyOrdersController>();
        if (myOrdersController.id.value.isNotEmpty && myOrdersController.id.value != "0") {
          id = myOrdersController.id.value;
          print("Using ID from MyOrdersController: $id");
        } else {
          id = orderId;
          print("Using global orderId: $id");
        }
      } catch (e) {
        // MyOrdersController not found, use global orderId
        id = orderId;
        print("Using global orderId (fallback): $id");
      }
    } else {
      print("Using constructor ID: $id");
    }

    if (id == null || id == "" || id == "0") {
      print("ERROR: No valid order ID found");
      Get.snackbar(
        "Error",
        "Order ID not found. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    print("Fetching order details for ID: $id");

    final data = await APIFunction().apiCall(
      apiName: "${Constants.orders}/${id}",
      context: Get.context!,
      token: accessToken,
      type: "get",
      isLoading: false,
    );

    GetDetailsResponseModel model = GetDetailsResponseModel.fromJson(data);

    if (model.order != null) {
      getDetailsData = model.order!;
      orderItem = model.order!.orderItem!;
      
      // Debug: Print customer and order info
      print('Order ID: ${getDetailsData?.id}');
      print('Customer ID: ${getDetailsData?.customerId}');
      print('Customer data available: ${getDetailsData?.customer != null}');
      if (getDetailsData?.customer != null) {
        print('Customer name: ${getDetailsData?.customer?.name}');
      }
      print('Current delivery_agent_id from API: ${getDetailsData?.deliveryAgentId}');
      print('delivery_agent_id type: ${getDetailsData?.deliveryAgentId.runtimeType}');
      
      encodeData(imageUrl: model.order?.customerSign?.split(",").last);

      // Load delivery agents after order details are loaded
      loadDeliveryAgents();

      /// count

      var amountTax;
      var amount;
      for (int i = 0; i < orderItem.length; i++) {
        amountTax = ((double.parse(orderItem[i].quantityCount.toString()) *
                    double.parse(orderItem[i].salePrice.toString())) *
                double.parse(orderItem[i].tax.toString())) /
            100;
        amount = (double.parse(orderItem[i].quantityCount!.toString())) *
            double.parse(orderItem[i].salePrice.toString());
        orderItem[i].amountWithoutTax = amount.toString();
        orderItem[i].amountOnlyTax = amountTax.toString();
        orderItem[i].finalAmount = (amount + amountTax).toString();
      }

      update();
    } else {
      update();
    }
  }

  Uint8List? bytesImage;

  encodeData({imageUrl}) {
    if (imageUrl != null && imageUrl.toString().isNotEmpty) {
      String _imgString = imageUrl.toString();
      
      // Check if the string is a valid Base64 string
      // Base64 strings should be multiples of 4 in length and contain only valid Base64 characters
      if (_imgString.length % 4 == 0 && 
          RegExp(r'^[A-Za-z0-9+/]*={0,2}$').hasMatch(_imgString) &&
          _imgString.length > 4) {
        try {
          bytesImage = Base64Decoder().convert(_imgString);
          update();
        } catch (e) {
          print('Error decoding Base64 image: $e');
          bytesImage = null;
        }
      } else {
        print('Invalid Base64 format for customer signature: $_imgString');
        bytesImage = null;
      }
    } else {
      bytesImage = null;
    }
  }

  Future<void> getFile() async {
    // If you don’t care about filtering types, you can omit acceptedTypeGroups altogether:
    // final XFile? picked = await openFile();
    //
    // To filter, define one or more XTypeGroup:
    final typeGroup = XTypeGroup(
      label: 'any',
      extensions: ['*'], // pick all file types
    );
    final XFile? picked = await openFile(acceptedTypeGroups: [typeGroup]);

    if (picked != null) {
      // picked.path is equivalent to result.files.single.path
      imageFile.value = picked.path;

      // If you need a dart:io File object:
      final file = File(picked.path);
      
      // Validate file exists and get file info
      if (await file.exists()) {
        final fileSize = await file.length();
        final fileName = file.path.split('/').last;
        
        print('Selected file: $fileName');
        print('File size: ${(fileSize / 1024).toStringAsFixed(2)} KB');
        
        // Optional: Check file size limit (e.g., 10MB)
        const maxFileSize = 10 * 1024 * 1024; // 10MB in bytes
        if (fileSize > maxFileSize) {
          Get.snackbar(
            "Error",
            "File size too large. Please select a file smaller than 10MB.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }
      } else {
        Get.snackbar(
          "Error",
          "Selected file does not exist.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if (imageFile.isNotEmpty) {
        uploadFileAPI();
      }
    }
    update();
  }

  var fileURL = "".obs;
  var imageFile = "".obs;

  uploadFileAPI() async {
    try {
      FormData formData = FormData.fromMap({
        "upload_image": MultipartFile.fromFileSync(imageFile.value,
            filename: imageFile.value.split("/").last),
      });

      final data = await APIFunction().apiCall(
        apiName: Constants.uploadImage,
        context: Get.context!,
        token: accessToken,
        params: formData,
      );

      GetDetailsResponseModel model = GetDetailsResponseModel.fromJson(data);

      if (model.data != null) {
        fileURL.value = await model.data!.imageUrl!;
        print(fileURL.value);
        print("fileURL.value");
        update();
      } else {
        print("In else part");
      }
    } on Exception {
      utils.showSnackBar(
          context: Get.context!, message: "The name has already been taken.");
    }
  }

  editOrderAPI() async {
    print("editOrderAPI() called - updating order details/items");
    List categoryList = [];
    List subCategoryList = [];
    List productList = [];
    List packageList = [];
    List quantityList = [];
    List salesPriceList = [];
    List taxList = [];
    List isBoxList = [];
    List commentList = [];
    for (int i = 0; i < orderItem.length; i++) {
      categoryList.add(orderItem[i].categoryId);
      subCategoryList.add(orderItem[i].subCategoryId);
      productList.add(orderItem[i].productId);
      packageList.add(orderItem[i].boxSize);
      quantityList.add(orderItem[i].quantityCount);
      salesPriceList.add(orderItem[i].salePrice);
      taxList.add(orderItem[i].taxId);
      isBoxList.add(orderItem[i].isBox);
      commentList.add(orderItem[i].comment?.text);
    }
    update();

    if (categoryList.isNotEmpty) {
      try {
        String rawData =
            '{"sales_manager_id": "${getDetailsData!.salesManagerId}","customer_id": "${getDetailsData!.customerId}","delivery_agent_id": "${getDetailsData!.deliveryAgentId ?? ""}","item_category": ${categoryList},"item_subcategory": ${subCategoryList},"item_name": ${productList},"package_val": ${packageList},"item_quantity": ${quantityList},"item_sale_priec": ${salesPriceList},"item_tax_id": ${taxList},"is_box": ${isBoxList},"order_total_without_tax": ${getDetailsData!.orderTotalWithoutTax},"order_tax": ${getDetailsData!.orderTax},"discount_type": ${getDetailsData!.discountType},"extra_discount": "${getDetailsData!.extraDiscount}","order_total": "${getDetailsData!.orderTotal}","comment": ${jsonEncode(commentList)},"comments": "${comments.text}","delivery_note": "${getDetailsData!.deliveryNote}","customer_sign": "${signImage.value.isNotEmpty ? signImage.value : getDetailsData!.customerSign}","status": "${getDetailsData!.status}","order_date":"${getDetailsData!.orderDate!.split(".").first}","delivery_pic":"${fileURL.value}"}';

        final data = await APIFunction().apiCall(
          apiName: "${Constants.orders}/${id}",
          context: Get.context!,
          token: accessToken,
          type: "put",
          rawData: rawData,
        );

        GetDetailsResponseModel model = GetDetailsResponseModel.fromJson(data);

        if (model.data != null) {
          Get.find<HomeController>().isOrderEdit.value = false;
          Get.find<HomeController>().isOrderDetails.value = false;
          // Safely update MyOrdersController only if on My Orders tab
          var homeController = Get.find<HomeController>();
          if (homeController.isSelected.value == 2) {
            try {
              Get.find<MyOrdersController>().update();
            } catch (e) {
              print("MyOrdersController not found in editOrderAPI: $e");
            }
          }
          Get.find<HomeController>().update();
          update();
        } else {
          print("In else part");
        }
      } on Exception {
        utils.showSnackBar(
            context: Get.context!, message: "The name has already been taken.");
      }
    }
  }

  /// delete product

  deleteProduct({index}) {
    var amountTax;
    var amount;

    for (int i = 0; i < orderItem.length; i++) {
      amountTax = ((double.parse(orderItem[i].quantityCount.toString()) *
                  double.parse(orderItem[i].salePrice.toString())) *
              double.parse(orderItem[i].tax.toString())) /
          100;
      amount = (double.parse(orderItem[i].quantityCount!.toString())) *
          double.parse(orderItem[i].salePrice.toString());
      orderItem[i].amountWithoutTax = amount.toString();
      orderItem[i].amountOnlyTax = amountTax.toString();
      orderItem[i].finalAmount = (amount + amountTax).toString();
    }
    var orderTotalWithoutTax;
    orderTotalWithoutTax = orderItem.fold<double>(
        0, (sum, item) => sum + double.parse(item.amountWithoutTax.toString()));
    getDetailsData!.orderTotalWithoutTax =
        orderTotalWithoutTax - double.parse(orderItem[index].amountWithoutTax);
    var orderTax;
    orderTax = orderItem.fold<double>(
        0, (sum, item) => sum + double.parse(item.amountOnlyTax.toString()));
    getDetailsData!.orderTax =
        orderTax - double.parse(orderItem[index].amountOnlyTax);

    getDetailsData!.orderTotal =
        double.parse(getDetailsData!.orderTotalWithoutTax.toString()) +
            double.parse(getDetailsData!.orderTax.toString());

    orderItem.removeAt(index);
    update();
  }

  Future<Uint8List> generateInvoicePdf() async {
    final pdf = pw.Document();
    final logo = pw.MemoryImage(
      (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List(),
    );

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Image(logo, width: 80),
                  pw.Text('INVOICE',
                      style: pw.TextStyle(
                          fontSize: 32, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                  'Company: ${getDetailsData?.customer?.companyName ?? ""}'),
              pw.Text(
                  'Contact: ${getDetailsData?.customer?.contactName ?? ""}'),
              pw.Text('Customer: ${getDetailsData?.customer?.name ?? ""}'),
              pw.Divider(),
              pw.Text('Order Items:',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.TableHelper.fromTextArray(
                headers: ['Product', 'Qty', 'Price', 'Tax', 'Total'],
                data: orderItem
                    .map((item) => [
                          item.name ?? '',
                          item.quantityCount?.toString() ?? '',
                          '\$${item.salePrice ?? ''}',
                          '${item.tax ?? ''}%',
                          '\$${item.finalAmount ?? ''}',
                        ])
                    .toList(),
              ),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                          'Total: \$${getDetailsData?.orderTotalWithoutTax ?? ""}'),
                      pw.Text(
                          'Taxes & charges: \$${getDetailsData?.orderTax ?? ""}'),
                      pw.Text(
                          'Grand Total: \$${getDetailsData?.orderTotal ?? ""}',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
  
  Future<Uint8List> generatePackagingSlipPdf() async {
    final pdf = pw.Document();
    final logo = pw.MemoryImage(
      (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List(),
    );

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Image(logo, width: 80),
                  pw.Text('PACKAGING SLIP',
                      style: pw.TextStyle(
                          fontSize: 28, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(height: 16),
              pw.Text('Customer: ${getDetailsData?.customer?.name ?? ""}'),
              pw.Text('Order ID: ${getDetailsData?.id ?? ""}'),
              pw.Text('Order Date: ${getDetailsData?.orderDate ?? ""}'),
              pw.Divider(),
              pw.Text('Items to Pack:',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.TableHelper.fromTextArray(
                headers: ['Product', 'Qty'],
                data: orderItem
                    .map((item) => [
                          item.name ?? '',
                          item.quantityCount?.toString() ?? '',
                        ])
                    .toList(),
              ),
              pw.SizedBox(height: 32),
              pw.Text('Please ensure all items are packed and checked.',
                  style: pw.TextStyle(fontSize: 14)),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
