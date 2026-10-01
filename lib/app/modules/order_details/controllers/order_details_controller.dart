import 'dart:io';
import 'dart:ui' as ui;

import 'package:file_selector/file_selector.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:true_leaf_inventory_app/app/models/details_response_model.dart';
import 'package:true_leaf_inventory_app/app/models/get_all_data_model.dart';
import 'package:true_leaf_inventory_app/app/utils/price_calculator.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';
import 'package:pdf/pdf.dart';
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

  void recalculateItem(int index) {
    final item = orderItem[index];
    final breakdown = PriceCalculator.calculate(
      quantity: item.quantityCount,
      price: item.salePrice,
      tax: item.tax,
      boxSize: item.boxSize,
      isBox: item.isBox,
    );
    item.amountWithoutTax = breakdown.amountWithoutTax.toStringAsFixed(2);
    item.amountOnlyTax = breakdown.amountOnlyTax.toStringAsFixed(2);
    item.finalAmount = breakdown.finalAmount.toStringAsFixed(2);
  }

  void recalculateOrderTotals() {
    for (var index = 0; index < orderItem.length; index++) {
      recalculateItem(index);
    }
    final totalWithoutTax = orderItem.fold<double>(
      0,
      (sum, item) =>
          sum +
          (double.tryParse(item.amountWithoutTax?.toString() ?? '0') ?? 0),
    );
    final totalTax = orderItem.fold<double>(
      0,
      (sum, item) =>
          sum + (double.tryParse(item.amountOnlyTax?.toString() ?? '0') ?? 0),
    );
    getDetailsData?.orderTotalWithoutTax = totalWithoutTax.toStringAsFixed(2);
    getDetailsData?.orderTax = totalTax.toStringAsFixed(2);
    getDetailsData?.orderTotal =
        (totalWithoutTax + totalTax).toStringAsFixed(2);
  }

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
          String orderDeliveryAgentId =
              getDetailsData!.deliveryAgentId.toString();
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

      String deliveryAgentId =
          selectedDeliveryAgent.value?.id?.toString() ?? "null";

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
        "delivery_agent_id": deliveryAgentIdInt?.toString() ??
            "", // Always include, use empty string if null
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
        "order_date": getDetailsData!.orderDate?.split(".").first ??
            DateTime.now().toString().split(" ").first
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
          print(
              "Updated order delivery_agent_id: ${orderData['delivery_agent_id']}");
          print("Response order ID: ${orderData['id']}");
          print("Response status: ${orderData['status']}");

          // Check if the delivery agent was actually updated
          var responseDeliveryAgentId = orderData['delivery_agent_id'];
          var responseIdAsInt = responseDeliveryAgentId is String
              ? int.tryParse(responseDeliveryAgentId)
              : responseDeliveryAgentId;

          if (responseIdAsInt == deliveryAgentIdInt) {
            print(
                "SUCCESS: Delivery agent was updated correctly! ID: $deliveryAgentIdInt");

            // Show success message only if the update was actually successful
            Get.snackbar(
              "Success",
              "Delivery driver assigned successfully to ${selectedDeliveryAgent.value?.name}",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          } else {
            print(
                "ISSUE: Delivery agent was not updated. Expected: $deliveryAgentIdInt, Got: $responseIdAsInt (original: $responseDeliveryAgentId)");

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
        } // Refresh order details to get updated data
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
        if (myOrdersController.id.value.isNotEmpty &&
            myOrdersController.id.value != "0") {
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
      print(
          'Current delivery_agent_id from API: ${getDetailsData?.deliveryAgentId}');
      print(
          'delivery_agent_id type: ${getDetailsData?.deliveryAgentId.runtimeType}');

      encodeData(imageUrl: model.order?.customerSign?.split(",").last);

      // Load delivery agents after order details are loaded
      loadDeliveryAgents();

      // Initialize comments field with order notes
      if (getDetailsData?.comments != null &&
          getDetailsData!.comments.toString().isNotEmpty) {
        comments.text = getDetailsData!.comments.toString();
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
            '{"sales_manager_id": "${getDetailsData!.salesManagerId}","customer_id": "${getDetailsData!.customerId}","delivery_agent_id": "${getDetailsData!.deliveryAgentId ?? ""}","item_category": ${categoryList},"item_subcategory": ${subCategoryList},"item_name": ${productList},"package_val": ${packageList},"item_quantity": ${quantityList},"item_sale_priec": ${salesPriceList},"item_tax_id": ${taxList},"is_box": ${isBoxList},"order_total_without_tax": ${getDetailsData!.orderTotalWithoutTax},"order_tax": ${getDetailsData!.orderTax},"discount_type": ${getDetailsData!.discountType},"extra_discount": "${getDetailsData!.extraDiscount}","order_total": "${getDetailsData!.orderTotal}","comment": ${jsonEncode(commentList)},"comments": ${jsonEncode(comments.text)},"delivery_note": "${getDetailsData!.deliveryNote}","customer_sign": "${signImage.value.isNotEmpty ? signImage.value : getDetailsData!.customerSign}","status": "${getDetailsData!.status}","order_date":"${getDetailsData!.orderDate!.split(".").first}","delivery_pic":"${fileURL.value}"}';

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
    orderItem.removeAt(index);
    recalculateOrderTotals();
    update();
  }

  String documentFileName(String documentType) {
    final customerName =
        getDetailsData?.customer?.name?.trim().isNotEmpty == true
            ? getDetailsData!.customer!.name!.trim()
            : 'Customer';
    final orderNumber = getDetailsData?.id?.toString() ??
        getDetailsData?.orderId?.toString() ??
        'Unknown';
    final fileName = '$customerName - Order $orderNumber - $documentType.pdf';

    return fileName.replaceAll(RegExp(r'[<>:"/\\|?*\x00-\x1F]'), '_');
  }

  Future<Uint8List> generateInvoicePdf() async {
    print('🔍 Generating invoice PDF...');
    print('� Order ID: ${getDetailsData?.id}');
    print('�📦 Order items count: ${orderItem.length}');
    print('💰 Order total: ${getDetailsData?.orderTotal}');
    print('👤 Customer: ${getDetailsData?.customer?.name}');
    print('📊 getDetailsData is null: ${getDetailsData == null}');
    print('📊 orderItem is empty: ${orderItem.isEmpty}');

    // Check if data is loaded
    if (getDetailsData == null) {
      print('❌ ERROR: getDetailsData is null! Cannot generate PDF.');
      Get.snackbar(
        "Error",
        "Order data not loaded. Please wait and try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      throw Exception('Order data not loaded');
    }

    if (orderItem.isEmpty) {
      print('⚠️ WARNING: Order has no items!');
    }

    recalculateOrderTotals();

    final pdf = pw.Document();

    // Load logo, fallback to placeholder if not found
    pw.MemoryImage? logo;
    try {
      logo = pw.MemoryImage(
        (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List(),
      );
      print('✅ Logo loaded successfully');
    } catch (e) {
      print('⚠️ Logo not found, continuing without it: $e');
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return [
            // Header with logo and customer info
            pw.Container(
              padding: pw.EdgeInsets.only(bottom: 20),
              decoration: pw.BoxDecoration(
                border: pw.Border(
                    bottom: pw.BorderSide(color: PdfColors.black, width: 2)),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  if (logo != null)
                    pw.Image(logo,
                        width: 80, height: 80, fit: pw.BoxFit.contain)
                  else
                    pw.Container(
                        width: 80, height: 80, color: PdfColors.grey200),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          getDetailsData?.customer?.name?.toString() ??
                              'Customer',
                          style: pw.TextStyle(
                            fontSize: 22,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                          ),
                          textAlign: pw.TextAlign.right,
                          maxLines: 2,
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          'Order #${getDetailsData?.id?.toString() ?? "N/A"}',
                          style: pw.TextStyle(
                            fontSize: 16,
                            color: PdfColors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 16),

            // Invoice details
            pw.Text(
              'Invoice Date: ${DateFormat('dd MMM yyyy').format(DateTime.now())}',
              style: pw.TextStyle(fontSize: 12, color: PdfColors.black),
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              'Company: ${getDetailsData?.customer?.companyName ?? "N/A"}',
              style: pw.TextStyle(fontSize: 11, color: PdfColors.black),
            ),
            pw.Text(
              'Contact: ${getDetailsData?.customer?.contactName ?? "N/A"}',
              style: pw.TextStyle(fontSize: 11, color: PdfColors.black),
            ),

            pw.SizedBox(height: 16),
            pw.Divider(thickness: 2, color: PdfColors.black),
            pw.SizedBox(height: 8),

            // Order items title
            pw.Text(
              'Order Items:',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 14,
                color: PdfColors.black,
              ),
            ),
            pw.SizedBox(height: 8),

            // Items table
            pw.TableHelper.fromTextArray(
              border: pw.TableBorder.all(color: PdfColors.black, width: 1),
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 10,
                color: PdfColors.black,
              ),
              cellStyle: pw.TextStyle(
                fontSize: 10,
                color: PdfColors.black,
              ),
              headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
              cellHeight: 28,
              columnWidths: {
                0: pw.FlexColumnWidth(4.8),
                1: pw.FlexColumnWidth(0.9),
                2: pw.FlexColumnWidth(1.2),
                3: pw.FlexColumnWidth(0.9),
                4: pw.FlexColumnWidth(1.6),
                5: pw.FlexColumnWidth(1.3),
              },
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.center,
                2: pw.Alignment.centerRight,
                3: pw.Alignment.center,
                4: pw.Alignment.centerRight,
                5: pw.Alignment.centerRight,
              },
              headers: [
                'Product',
                'Qty',
                'Price',
                'Tax %',
                'Tax Amount',
                'Total'
              ],
              data: orderItem.isEmpty
                  ? [
                      ['No items in this order', '', '', '', '', '']
                    ]
                  : orderItem.map((item) {
                      print(
                          '📄 Adding item: ${item.name} - Qty: ${item.quantityCount}');

                      // Format prices to 2 decimal places
                      String formatPrice(dynamic price) {
                        if (price == null) return '0.00';
                        double priceValue =
                            double.tryParse(price.toString()) ?? 0.0;
                        return priceValue.toStringAsFixed(2);
                      }

                      String formatQuantity(dynamic quantity) {
                        final quantityValue =
                            double.tryParse(quantity?.toString() ?? '') ?? 0;
                        return quantityValue.toStringAsFixed(2);
                      }

                      String formatRate(dynamic rate) {
                        final rateValue =
                            double.tryParse(rate?.toString() ?? '') ?? 0;
                        return '${rateValue.toStringAsFixed(0)}%';
                      }

                      return [
                        item.name?.toString() ?? 'N/A',
                        formatQuantity(item.quantityCount),
                        '\$${formatPrice(item.salePrice)}',
                        formatRate(item.tax),
                        '\$${formatPrice(item.amountOnlyTax)}',
                        '\$${formatPrice(item.finalAmount)}',
                      ];
                    }).toList(),
            ),

            pw.SizedBox(height: 16),
            pw.Divider(thickness: 2),
            pw.SizedBox(height: 8),

            // Totals section
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      'Subtotal: \$${(double.tryParse(getDetailsData?.orderTotalWithoutTax?.toString() ?? "0") ?? 0.0).toStringAsFixed(2)}',
                      style: pw.TextStyle(fontSize: 12, color: PdfColors.black),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Taxes & charges: \$${(double.tryParse(getDetailsData?.orderTax?.toString() ?? "0") ?? 0.0).toStringAsFixed(2)}',
                      style: pw.TextStyle(fontSize: 12, color: PdfColors.black),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Container(
                      padding: pw.EdgeInsets.all(8),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.grey300,
                        borderRadius: pw.BorderRadius.circular(4),
                      ),
                      child: pw.Text(
                        'Grand Total: \$${(double.tryParse(getDetailsData?.orderTotal?.toString() ?? "0") ?? 0.0).toStringAsFixed(2)}',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 14,
                          color: PdfColors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Notes section if available
            if (getDetailsData?.comments != null &&
                getDetailsData!.comments.toString().trim().isNotEmpty &&
                getDetailsData!.comments.toString() != 'null') ...[
              pw.SizedBox(height: 20),
              pw.Divider(color: PdfColors.black),
              pw.Text(
                'Notes:',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 14,
                  color: PdfColors.black,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                getDetailsData!.comments.toString(),
                style: pw.TextStyle(fontSize: 12, color: PdfColors.black),
              ),
            ],
          ];
        },
      ),
    );

    print('✅ Invoice PDF generated successfully');
    return pdf.save();
  }

  Future<Uint8List> generatePackagingSlipPdf() async {
    final pdf = pw.Document();

    // Load logo, fallback to placeholder if not found
    pw.MemoryImage? logo;
    try {
      logo = pw.MemoryImage(
        (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List(),
      );
    } catch (e) {
      print('Logo not found, continuing without it: $e');
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return [
            // Header with logo and customer info
            pw.Container(
              padding: pw.EdgeInsets.only(bottom: 20),
              decoration: pw.BoxDecoration(
                border: pw.Border(
                    bottom: pw.BorderSide(color: PdfColors.black, width: 2)),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  if (logo != null)
                    pw.Image(logo,
                        width: 80, height: 80, fit: pw.BoxFit.contain)
                  else
                    pw.Container(
                        width: 80, height: 80, color: PdfColors.grey200),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          getDetailsData?.customer?.name?.toString() ??
                              'Customer',
                          style: pw.TextStyle(
                            fontSize: 22,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                          ),
                          textAlign: pw.TextAlign.right,
                          maxLines: 2,
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          'Order #${getDetailsData?.id?.toString() ?? "N/A"}',
                          style: pw.TextStyle(
                            fontSize: 16,
                            color: PdfColors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 16),

            // Packaging slip details
            pw.Text(
              'Packaging Date: ${DateFormat('dd MMM yyyy').format(DateTime.now())}',
              style: pw.TextStyle(fontSize: 12, color: PdfColors.black),
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              'Company: ${getDetailsData?.customer?.companyName ?? "N/A"}',
              style: pw.TextStyle(fontSize: 11, color: PdfColors.black),
            ),
            pw.Text(
              'Order Date: ${getDetailsData?.orderDate ?? "N/A"}',
              style: pw.TextStyle(fontSize: 11, color: PdfColors.black),
            ),

            pw.SizedBox(height: 16),
            pw.Divider(thickness: 2, color: PdfColors.black),
            pw.SizedBox(height: 8),

            // Items to pack title
            pw.Text(
              'Items to Pack:',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 14,
                color: PdfColors.black,
              ),
            ),
            pw.SizedBox(height: 8),

            // Items table
            pw.TableHelper.fromTextArray(
              border: pw.TableBorder.all(color: PdfColors.black, width: 1),
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 12,
                color: PdfColors.black,
              ),
              cellStyle: pw.TextStyle(
                fontSize: 12,
                color: PdfColors.black,
              ),
              headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
              cellHeight: 40,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.center,
              },
              headers: ['Product', 'Quantity'],
              data: orderItem.map((item) {
                return [
                  item.name?.toString() ?? 'N/A',
                  item.quantityCount?.toString() ?? '0',
                ];
              }).toList(),
            ),

            pw.SizedBox(height: 32),
            pw.Container(
              padding: pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey200,
                borderRadius: pw.BorderRadius.circular(4),
              ),
              child: pw.Text(
                'Please ensure all items are packed and checked.',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontStyle: pw.FontStyle.italic,
                  color: PdfColors.black,
                ),
              ),
            ),

            // Notes section if available
            if (getDetailsData?.comments != null &&
                getDetailsData!.comments.toString().trim().isNotEmpty &&
                getDetailsData!.comments.toString() != 'null') ...[
              pw.SizedBox(height: 20),
              pw.Divider(color: PdfColors.black),
              pw.Text(
                'Notes:',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 14,
                  color: PdfColors.black,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                getDetailsData!.comments.toString(),
                style: pw.TextStyle(fontSize: 12, color: PdfColors.black),
              ),
            ],
          ];
        },
      ),
    );

    return pdf.save();
  }
}
