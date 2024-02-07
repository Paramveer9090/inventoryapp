import 'dart:io';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:true_leaf_inventory_app/app/models/details_response_model.dart';
import 'package:true_leaf_inventory_app/app/models/get_all_data_model.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

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

  @override
  void onInit() {
    orderDetails();
    super.onInit();
  }

  getLoginData() async {
    final data = await getStorageData.readObject(getStorageData.loginData);
    if (data != null) {
      loginData = LoginSignUpData.fromJson(data);
    }
    update();
  }

  var imageEncoded = "".obs;

  handleSaveButtonPressed() async {
    final data = await signatureGlobalKey.currentState!.toImage(pixelRatio: 3.0);
    final bytes = await data.toByteData(format: ui.ImageByteFormat.png);
    imageEncoded.value = base64.encode(bytes!.buffer.asUint8List());
    update();
  }

  /// Order Details
  orderDetails() async {
    await getLoginData();

    if (await id == null || id == "") {
      print("assign value");
      id = orderId;
    }
    print(id);
    print(orderId);
    print("orderIdorderIdorderIdorderId");
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
      encodeData(imageUrl: model.order?.customerSign?.split(",").last);

      /// count

      var amountTax;
      var amount;
      for (int i = 0; i < orderItem.length; i++) {
        // if (orderItem[i].isBox == 1) {
        //   amountTax = (((double.parse(orderItem[i].boxSize.toString()) * double.parse(orderItem[i].quantityCount!.toString())) * double.parse(orderItem[i].salePrice!.toString())) * double.parse(orderItem[i].tax.toString())) / 100;
        //   amount = (double.parse(orderItem[i].boxSize.toString()) * double.parse(orderItem[i].quantityCount!.toString())) * double.parse(orderItem[i].salePrice!.toString());
        //   orderItem[i].amountWithoutTax = amount.toString();
        //   orderItem[i].amountOnlyTax = amountTax.toString();
        //   orderItem[i].finalAmount = (amount + amountTax).toString();
        // } else {
        amountTax = ((double.parse(orderItem[i].quantityCount.toString()) * double.parse(orderItem[i].salePrice.toString())) * double.parse(orderItem[i].tax.toString())) / 100;
        amount = (double.parse(orderItem[i].quantityCount!.toString())) * double.parse(orderItem[i].salePrice.toString());
        orderItem[i].amountWithoutTax = amount.toString();
        orderItem[i].amountOnlyTax = amountTax.toString();
        orderItem[i].finalAmount = (amount + amountTax).toString();
        // }
      }

      update();
    } else {
      update();
    }
  }

  Uint8List? bytesImage;

  encodeData({imageUrl}) {
    if (imageUrl != null) {
      String _imgString = imageUrl;
      bytesImage = Base64Decoder().convert(_imgString);

      update();
    }
  }

  getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      imageFile.value = result.files.single.path!;
      print(file);
      print(imageFile.value);
      print("filefilefilefilefilefilefile");
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
        "upload_image": MultipartFile.fromFileSync(imageFile.value, filename: imageFile.value.split("/").last),
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
    } on Exception catch (error) {
      utils.showSnackBar(context: Get.context!, message: "The name has already been taken.");
    }
  }

  editOrderAPI() async {
    print("after call api call");
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
            '{"sales_manager_id": "${getDetailsData!.salesManagerId}","customer_id": "${getDetailsData!.customerId}","item_category": ${categoryList},"item_subcategory": ${subCategoryList},"item_name": ${productList},"package_val": ${packageList},"item_quantity": ${quantityList},"item_sale_priec": ${salesPriceList},"item_tax_id": ${taxList},"is_box": ${isBoxList},"order_total_without_tax": ${getDetailsData!.orderTotalWithoutTax},"order_tax": ${getDetailsData!.orderTax},"discount_type": ${getDetailsData!.discountType},"extra_discount": "${getDetailsData!.extraDiscount}","order_total": "${getDetailsData!.orderTotal}","comment": ${jsonEncode(commentList)},"comments": "${comments.text}","delivery_note": "${getDetailsData!.deliveryNote}","customer_sign": "${signImage.value.isNotEmpty ? signImage.value : getDetailsData!.customerSign}","status": "${getDetailsData!.status}","order_date":"${getDetailsData!.orderDate!.split(".").first}","delivery_pic":"${fileURL.value}"}';

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
          Get.find<MyOrdersController>().update();
          Get.find<HomeController>().update();
          update();
        } else {
          print("In else part");
        }
      } on Exception catch (error) {
        utils.showSnackBar(context: Get.context!, message: "The name has already been taken.");
      }
    }
  }

  /// delete product

  deleteProduct({index}) {
    var amountTax;
    var amount;

    for (int i = 0; i < orderItem.length; i++) {
      // if (orderItem[i].isBox == 1) {
      //   amountTax = (((double.parse(orderItem[i].boxSize.toString()) * double.parse(orderItem[i].quantityCount!.toString())) * double.parse(orderItem[i].salePrice!.toString())) * double.parse(orderItem[i].tax.toString())) / 100;
      //   amount = (double.parse(orderItem[i].boxSize.toString()) * double.parse(orderItem[i].quantityCount!.toString())) * double.parse(orderItem[i].salePrice!.toString());
      //   orderItem[i].amountWithoutTax = amount.toString();
      //   orderItem[i].amountOnlyTax = amountTax.toString();
      //   orderItem[i].finalAmount = (amount + amountTax).toString();
      // } else {
      amountTax = ((double.parse(orderItem[i].quantityCount.toString()) * double.parse(orderItem[i].salePrice.toString())) * double.parse(orderItem[i].tax.toString())) / 100;
      amount = (double.parse(orderItem[i].quantityCount!.toString())) * double.parse(orderItem[i].salePrice.toString());
      orderItem[i].amountWithoutTax = amount.toString();
      orderItem[i].amountOnlyTax = amountTax.toString();
      orderItem[i].finalAmount = (amount + amountTax).toString();
      // }
    }
    var orderTotalWithoutTax;
    orderTotalWithoutTax = orderItem.fold<double>(0, (sum, item) => sum + double.parse(item.amountWithoutTax.toString()));
    getDetailsData!.orderTotalWithoutTax = orderTotalWithoutTax - double.parse(orderItem[index].amountWithoutTax);
    var orderTax;
    orderTax = orderItem.fold<double>(0, (sum, item) => sum + double.parse(item.amountOnlyTax.toString()));
    getDetailsData!.orderTax = orderTax - double.parse(orderItem[index].amountOnlyTax);

    getDetailsData!.orderTotal = double.parse(getDetailsData!.orderTotalWithoutTax.toString()) + double.parse(getDetailsData!.orderTax.toString());

    orderItem.removeAt(index);
    update();
  }
}

// if (isApiData.value == false) {
//   if (addProductList.isNotEmpty) {
//     for (int i = 0; i < addProductList.length; i++) {
//       print("list add thy 6e");
//       print(addProductList[i].sellingPrice);
//       print(addProductList[i].tax);
//       print(addProductList[i].isBox);
//       print(addProductList[i].quantity);
//       orderItem.add(
//         OrderItem(
//           name: addProductList[i].name,
//           sellingPrice: addProductList[i].sellingPrice,
//           tax: addProductList[i].tax,
//           isBox: addProductList[i].isBox,
//           quantity: addProductList[i].quantity,
//         ),
//       );
//     }
//   }
// }
