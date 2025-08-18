import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';
import 'package:true_leaf_inventory_app/app/widgets/app_button.dart';
import 'package:true_leaf_inventory_app/app/widgets/custom_image.dart';
import '../controllers/order_details_controller.dart';

class OrderDetailsView extends GetView<OrderDetailsController> {
  final id;

  const OrderDetailsView({this.id, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderDetailsController>(
      assignId: true,
      init: OrderDetailsController(id: id),
      builder: (controller) {
        return controller.getDetailsData == null
            ? Container()
            : Scaffold(
                backgroundColor: AppColors.greyLightColor,
                body: Column(
                  children: [
                    // Header Section
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.5.h),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Removed duplicate back button - using app bar back button instead
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  'Order Details',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.blackColor,
                                ),
                                AppText(
                                  'Order ID: $id',
                                  fontSize: 12.sp,
                                  color: Colors.grey[600]!,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Content Area
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          utils.hideKeyboard(context);
                        },
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.all(1.h),
                          children: [
                            SizedBox(height: 1.h),
                            
                            // Customer Information Card
                            if (controller.getDetailsData!.customer != null)
                              Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.business,
                                            size: 20,
                                            color: AppColors.primaryColor,
                                          ),
                                          SizedBox(width: 8),
                                          AppText(
                                            "Customer Information",
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 12),
                                      
                                      if (controller.getDetailsData!.customer!.companyName != null)
                                        DetailsBox(
                                          title: "Company Name",
                                          value: controller.getDetailsData!.customer!.companyName,
                                        ),
                                      
                                      if (controller.getDetailsData!.customer!.contactName != null)
                                        DetailsBox(
                                          title: "Contact Person",
                                          value: controller.getDetailsData!.customer!.contactName,
                                        ),
                                      
                                      DetailsBox(
                                        title: "Customer Name",
                                        value: controller.getDetailsData!.customer!.name,
                                      ),
                                      
                                      if (controller.loginData?.roles?[0].title == "Delivery Agent" &&
                                          controller.getDetailsData!.customer!.address != null)
                                        DetailsBox(
                                          title: "Address",
                                          value: controller.getDetailsData!.customer?.address,
                                        ),
                                      
                                      if (controller.loginData?.roles?[0].title == "Delivery Agent" &&
                                          controller.getDetailsData!.customer?.phoneNumber != null)
                                        DetailsBox(
                                          title: "Phone Number",
                                          value: controller.getDetailsData!.customer!.phoneNumber,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            
                            SizedBox(height: 1.h),
                            
                            // Delivery Agent Selection Card
                            Obx(() {
                              if (!controller.showDeliveryAgentSelector.value) {
                                return SizedBox();
                              }
                              
                              return Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.local_shipping,
                                            size: 20,
                                            color: AppColors.primaryColor,
                                          ),
                                          SizedBox(width: 8),
                                          AppText(
                                            "Delivery Driver",
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          Spacer(),
                                          if (controller.selectedDeliveryAgent.value != null)
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.green.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(12),
                                                border: Border.all(color: Colors.green.withOpacity(0.3)),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(Icons.check_circle, size: 14, color: Colors.green),
                                                  SizedBox(width: 4),
                                                  AppText(
                                                    "Assigned",
                                                    fontSize: 10.sp,
                                                    color: Colors.green[700]!,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                      SizedBox(height: 12),
                                      
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey[300]!),
                                          borderRadius: BorderRadius.circular(8),
                                          color: Colors.white,
                                        ),
                                        child: controller.isLoadingAgents.value
                                            ? Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 16,
                                                      height: 16,
                                                      child: CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color: AppColors.primaryColor,
                                                      ),
                                                    ),
                                                    SizedBox(width: 8),
                                                    AppText(
                                                      "Loading drivers...",
                                                      fontSize: 12.sp,
                                                      color: Colors.grey[600]!,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : DropdownButtonHideUnderline(
                                                child: DropdownButton<LoginSignUpData>(
                                                  isExpanded: true,
                                                  hint: AppText(
                                                    "Select a delivery driver",
                                                    fontSize: 12.sp,
                                                    color: Colors.grey[600]!,
                                                  ),
                                                  value: controller.selectedDeliveryAgent.value,
                                                  onChanged: (LoginSignUpData? newValue) {
                                                    controller.selectDeliveryAgent(newValue);
                                                  },
                                                  items: [
                                                    DropdownMenuItem<LoginSignUpData>(
                                                      value: null,
                                                      child: AppText(
                                                        "No driver assigned",
                                                        fontSize: 12.sp,
                                                        color: Colors.grey[600]!,
                                                      ),
                                                    ),
                                                    ...controller.deliveryAgents.map((LoginSignUpData agent) {
                                                      return DropdownMenuItem<LoginSignUpData>(
                                                        value: agent,
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              width: 30,
                                                              height: 30,
                                                              decoration: BoxDecoration(
                                                                color: AppColors.primaryColor.withOpacity(0.1),
                                                                borderRadius: BorderRadius.circular(15),
                                                              ),
                                                              child: Icon(
                                                                Icons.person,
                                                                size: 16,
                                                                color: AppColors.primaryColor,
                                                              ),
                                                            ),
                                                            SizedBox(width: 8),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  AppText(
                                                                    agent.name ?? "Unknown Driver",
                                                                    fontSize: 12.sp,
                                                                    fontWeight: FontWeight.w500,
                                                                    maxLines: 1,
                                                                  ),
                                                                  AppText(
                                                                    agent.email ?? "No email",
                                                                    fontSize: 10.sp,
                                                                    color: Colors.grey[600]!,
                                                                    maxLines: 1,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ],
                                                ),
                                              ),
                                      ),
                                      
                                      SizedBox(height: 12),
                                      
                                      Row(
                                        children: [
                                          Expanded(
                                            child: AppButton(
                                              title: "Update Driver",
                                              onTap: () {
                                                controller.updateDeliveryAgent();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                            
                            SizedBox(height: 1.h),
                            
                            // Add Product Button
                            if (Get.find<HomeController>().isOrderDetails.value &&
                                Get.find<HomeController>().isOrderEdit.value)
                              Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: AppButton(
                                    title: "Add Product",
                                    isIcon: true,
                                    icon: Icons.add,
                                    onTap: () {
                                      print("add product");
                                      Get.find<HomeController>()
                                          .isOrderDetails
                                          .value = false;
                                      Get.find<HomeController>()
                                          .isCustomerDetails
                                          .value = false;
                                      Get.find<HomeController>()
                                          .isSelected
                                          .value = 5;
                                      print("ididididid $id");
                                      Get.find<HomeController>()
                                          .isCustomerId
                                          .value = id;
                                      Get.find<HomeController>()
                                          .addOrder
                                          .value = true;
                                      Get.find<HomeController>().update();
                                    },
                                  ),
                                ),
                              ),
                            
                            SizedBox(height: 1.h),
                            
                            // Order Items Section
                            if (controller.loginData?.roles?[0].title == "Sales Manager" && 
                                controller.orderItem.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 1.h),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.shopping_cart_outlined,
                                          size: 20,
                                          color: AppColors.primaryColor,
                                        ),
                                        SizedBox(width: 8),
                                        AppText(
                                          "Order Items",
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        Spacer(),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryColor.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: AppText(
                                            "${controller.orderItem.length} items",
                                            fontSize: 12.sp,
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  
                                  // Order Items List
                                  ...List.generate(
                                    controller.orderItem.length,
                                    (index) => Card(
                                      elevation: 2,
                                      margin: EdgeInsets.only(bottom: 1.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      color: AppColors.whiteColor,
                                      child: Padding(
                                        padding: EdgeInsets.all(12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CustomImageView(
                                        imagePath: controller.orderItem[index]
                                                    .imageUrl !=
                                                null
                                            ? "${Constants.imageBaseUrl}${controller.orderItem[index].imageUrl}"
                                            : AppImages.dummy,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 2.h),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppText(
                                          controller.orderItem[index].name
                                              .toString(),
                                          fontSize: 15.sp,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            controller.sellingPriceText.text =
                                                controller
                                                    .orderItem[index].salePrice
                                                    .toString();
                                            Get.defaultDialog(
                                              title: "Edit Price",
                                              content: StatefulBuilder(
                                                  builder: (context, setState) {
                                                return Container(
                                                  width: 200,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      TextFormField(
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 13.sp),
                                                        controller: controller
                                                            .sellingPriceText,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              "Edit Price",
                                                          border:
                                                              OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: Color(
                                                                        0xffe9e7ea),
                                                                  )),
                                                          focusedBorder: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              borderSide: BorderSide(
                                                                  color: AppColors
                                                                      .blackColor)),
                                                          enabledBorder: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              borderSide: BorderSide(
                                                                  color: AppColors
                                                                      .blackColor)),
                                                          errorBorder: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              borderSide: BorderSide(
                                                                  color: AppColors
                                                                      .blackColor)),
                                                          disabledBorder: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              borderSide: BorderSide(
                                                                  color: AppColors
                                                                      .blackColor)),
                                                        ),
                                                        onChanged: (value) {
                                                          controller.update();
                                                          setState(() {});
                                                          print(controller
                                                              .orderItem[index]
                                                              .isBox);
                                                          print(
                                                              "controller.orderItem[index].isBox");
                                                        },
                                                      ),
                                                      SizedBox(height: 0.5.h),
                                                      if (controller
                                                                  .orderItem[
                                                                      index]
                                                                  .isBox ==
                                                              "1" ||
                                                          controller
                                                                  .orderItem[
                                                                      index]
                                                                  .isBox ==
                                                              1)
                                                        AppText(
                                                          controller
                                                                  .sellingPriceText
                                                                  .text
                                                                  .isEmpty
                                                              ? "Sales Price can't be 0"
                                                              : double.parse(controller
                                                                          .sellingPriceText
                                                                          .text) <
                                                                      double.parse(controller
                                                                          .orderItem[
                                                                              index]
                                                                          .sellingPrice
                                                                          .toString())
                                                                  ? "Sales Price can't be less than Min Selling Price"
                                                                  : "",
                                                          fontSize: 11.sp,
                                                          color: AppColors
                                                              .darkRedColor,
                                                        ),
                                                      if (controller
                                                                  .orderItem[
                                                                      index]
                                                                  .isBox ==
                                                              "0" ||
                                                          controller
                                                                  .orderItem[
                                                                      index]
                                                                  .isBox ==
                                                              0)
                                                        AppText(
                                                          controller
                                                                      .sellingPriceText
                                                                      .text
                                                                      .isEmpty ||
                                                                  double.parse(controller
                                                                          .sellingPriceText
                                                                          .text) ==
                                                                      0
                                                              ? "Sales Price can't be 0"
                                                              : "",
                                                          fontSize: 11.sp,
                                                          color: AppColors
                                                              .darkRedColor,
                                                        ),
                                                      SizedBox(height: 2.h),
                                                      AppButton(
                                                          title: "Save",
                                                          onTap: () {
                                                            if (controller
                                                                        .orderItem[
                                                                            index]
                                                                        .isBox ==
                                                                    "1" ||
                                                                controller
                                                                        .orderItem[
                                                                            index]
                                                                        .isBox ==
                                                                    1) {
                                                              if (double.parse(
                                                                      controller
                                                                          .sellingPriceText
                                                                          .text) <
                                                                  double.parse(controller
                                                                      .orderItem[
                                                                          index]
                                                                      .sellingPrice
                                                                      .toString())) {
                                                              } else {
                                                                Get.back(
                                                                    result: controller
                                                                        .sellingPriceText
                                                                        .text);
                                                                controller
                                                                    .update();
                                                              }
                                                            } else {
                                                              if (controller
                                                                      .sellingPriceText
                                                                      .text
                                                                      .isEmpty ||
                                                                  double.parse(controller
                                                                          .sellingPriceText
                                                                          .text) ==
                                                                      0) {
                                                              } else {
                                                                Get.back(
                                                                    result: controller
                                                                        .sellingPriceText
                                                                        .text);
                                                                controller
                                                                    .update();
                                                              }
                                                            }
                                                          }),
                                                    ],
                                                  ),
                                                );
                                              }),
                                            ).then((value) {
                                              if (value != null) {
                                                var amountTax;
                                                var amount;
                                                print("value not null");
                                                controller.orderItem[index]
                                                    .salePrice = value;
                                                print(controller
                                                    .orderItem[index]
                                                    .salePrice);
                                                amountTax = ((double.parse(
                                                                controller
                                                                    .orderItem[
                                                                        index]
                                                                    .quantityCount
                                                                    .toString()) *
                                                            double.parse(controller
                                                                .orderItem[
                                                                    index]
                                                                .salePrice
                                                                .toString())) *
                                                        double.parse(controller
                                                            .orderItem[index]
                                                            .tax
                                                            .toString())) /
                                                    100;
                                                amount = (double.parse(
                                                        controller
                                                            .orderItem[index]
                                                            .quantityCount!
                                                            .toString())) *
                                                    double.parse(controller
                                                        .orderItem[index]
                                                        .salePrice
                                                        .toString());
                                                controller.orderItem[index]
                                                        .amountWithoutTax =
                                                    amount.toString();
                                                controller.orderItem[index]
                                                        .amountOnlyTax =
                                                    amountTax.toString();
                                                controller.orderItem[index]
                                                        .finalAmount =
                                                    (amount + amountTax)
                                                        .toString();
                                                // }
                                                controller.update();

                                                controller.getDetailsData!
                                                        .orderTotalWithoutTax =
                                                    (controller.orderItem.fold<
                                                                double>(
                                                            0,
                                                            (sum, item) =>
                                                                sum +
                                                                double.parse(item
                                                                    .amountWithoutTax
                                                                    .toString())))
                                                        .toString();
                                                controller.getDetailsData!
                                                    .orderTax = (controller
                                                        .orderItem
                                                        .fold<double>(
                                                            0,
                                                            (sum, item) =>
                                                                sum +
                                                                double.parse(item
                                                                    .amountOnlyTax
                                                                    .toString())))
                                                    .toString();
                                                controller.getDetailsData!
                                                    .orderTotal = (double.parse(
                                                            controller
                                                                .getDetailsData!
                                                                .orderTotalWithoutTax) +
                                                        double.parse(controller
                                                            .getDetailsData!
                                                            .orderTax))
                                                    .toString();

                                                controller.update();
                                              } else {
                                                print("value are null");
                                              }
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 1.5.h, vertical: 2),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                color: Color(0xffe9e7ea),
                                              ),
                                            ),
                                            child: AppText(
                                              "\$${controller.orderItem[index].salePrice.toString()}",
                                              fontSize: 15.sp,
                                              color: Color(0XFF44474d),
                                            ),
                                          ),
                                        ),
                                        AppText(
                                          "Taxes: ${controller.orderItem[index].tax.toString()}%",
                                          fontSize: 15.sp,
                                          color: Color(0XFF44474d),
                                        ),
                                        SizedBox(height: 1.h),
                                        Row(
                                          children: [
                                            ...List.generate(
                                              2,
                                              (subIndex) => Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 2.h),
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    var amountTax;
                                                    var amount;
                                                    if (Get.find<
                                                                HomeController>()
                                                            .isOrderDetails
                                                            .value &&
                                                        Get.find<
                                                                HomeController>()
                                                            .isOrderEdit
                                                            .value) {
                                                      controller
                                                          .orderItem[index]
                                                          .isBox = subIndex;
                                                      controller
                                                              .orderItem[index]
                                                              .isUnitSelected =
                                                          subIndex;

                                                      /// working on it
                                                      // if (await controller.orderItem[index].isBox == 1) {
                                                      //   amountTax = (((double.parse(controller.orderItem[index].boxSize.toString()) * double.parse(controller.orderItem[index].quantityCount!.toString())) *
                                                      //       double.parse(controller.orderItem[index].salePrice!.toString())) *
                                                      //       double.parse(controller.orderItem[index].tax.toString())) /
                                                      //       100;
                                                      //   amount = (double.parse(controller.orderItem[index].boxSize.toString()) * double.parse(controller.orderItem[index].quantityCount!.toString())) *
                                                      //       double.parse(controller.orderItem[index].salePrice!.toString());
                                                      //   controller.orderItem[index].amountWithoutTax = amount.toString();
                                                      //   controller.orderItem[index].amountOnlyTax = amountTax.toString();
                                                      //   controller.orderItem[index].finalAmount = (amount + amountTax).toString();
                                                      // } else {
                                                      amountTax = ((double.parse(controller
                                                                      .orderItem[
                                                                          index]
                                                                      .quantityCount
                                                                      .toString()) *
                                                                  double.parse(controller
                                                                      .orderItem[
                                                                          index]
                                                                      .salePrice
                                                                      .toString())) *
                                                              double.parse(controller
                                                                  .orderItem[
                                                                      index]
                                                                  .tax
                                                                  .toString())) /
                                                          100;
                                                      amount = (double.parse(
                                                              controller
                                                                  .orderItem[
                                                                      index]
                                                                  .quantityCount!
                                                                  .toString())) *
                                                          double.parse(
                                                              controller
                                                                  .orderItem[
                                                                      index]
                                                                  .salePrice
                                                                  .toString());
                                                      controller
                                                              .orderItem[index]
                                                              .amountWithoutTax =
                                                          amount.toString();
                                                      controller
                                                              .orderItem[index]
                                                              .amountOnlyTax =
                                                          amountTax.toString();
                                                      controller
                                                              .orderItem[index]
                                                              .finalAmount =
                                                          (amount + amountTax)
                                                              .toString();
                                                      // }
                                                      controller.update();

                                                      controller.getDetailsData!
                                                              .orderTotalWithoutTax =
                                                          (controller.orderItem.fold<
                                                                  double>(
                                                              0,
                                                              (sum, item) =>
                                                                  sum +
                                                                  double.parse(item
                                                                      .amountWithoutTax
                                                                      .toString()))).toString();
                                                      controller.getDetailsData!
                                                          .orderTax = (controller
                                                              .orderItem
                                                              .fold<double>(
                                                                  0,
                                                                  (sum, item) =>
                                                                      sum +
                                                                      double.parse(item
                                                                          .amountOnlyTax
                                                                          .toString())))
                                                          .toString();
                                                      controller.getDetailsData!
                                                          .orderTotal = (double
                                                                  .parse(controller
                                                                      .getDetailsData!
                                                                      .orderTotalWithoutTax) +
                                                              double.parse(controller
                                                                  .getDetailsData!
                                                                  .orderTax))
                                                          .toString();

                                                      controller.update();
                                                    }
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        height: 15,
                                                        width: 15,
                                                        padding:
                                                            EdgeInsets.all(1.5),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: (controller.orderItem[index].isBox ==
                                                                          0 &&
                                                                      subIndex ==
                                                                          0) ||
                                                                  (controller.orderItem[index].isBox ==
                                                                          1 &&
                                                                      subIndex ==
                                                                          1)
                                                              ? AppColors
                                                                  .tableColor
                                                              : Color(
                                                                  0XFF44474d),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                        ),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: (controller.orderItem[index].isBox ==
                                                                            0 &&
                                                                        subIndex ==
                                                                            0) ||
                                                                    (controller.orderItem[index].isBox ==
                                                                            1 &&
                                                                        subIndex ==
                                                                            1)
                                                                ? AppColors
                                                                    .tableColor
                                                                : AppColors
                                                                    .whiteColor,
                                                            border: Border.all(
                                                              color: AppColors
                                                                  .whiteColor,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      AppText(
                                                        subIndex == 0
                                                            ? "Unit"
                                                            : "Box",
                                                        fontSize: 12.sp,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 1.h),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                var amountTax;
                                                var amount;
                                                if (Get.find<HomeController>()
                                                        .isOrderDetails
                                                        .value &&
                                                    Get.find<HomeController>()
                                                        .isOrderEdit
                                                        .value) {
                                                  if (int.parse(controller
                                                          .orderItem[index]
                                                          .quantityCount
                                                          .toString()) >
                                                      0) {
                                                    controller.orderItem[index]
                                                            .quantityCount =
                                                        (int.parse(controller
                                                                    .orderItem[
                                                                        index]
                                                                    .quantityCount
                                                                    .toString()) -
                                                                1)
                                                            .toString();
                                                  }

                                                  ///
                                                  // if (await controller.orderItem[index].isBox == 1) {
                                                  //   amountTax = (((double.parse(controller.orderItem[index].boxSize.toString()) * double.parse(controller.orderItem[index].quantityCount!.toString())) *
                                                  //       double.parse(controller.orderItem[index].salePrice!.toString())) *
                                                  //       double.parse(controller.orderItem[index].tax.toString())) /
                                                  //       100;
                                                  //   amount = (double.parse(controller.orderItem[index].boxSize.toString()) * double.parse(controller.orderItem[index].quantityCount!.toString())) *
                                                  //       double.parse(controller.orderItem[index].salePrice!.toString());
                                                  //   controller.orderItem[index].amountWithoutTax = amount.toString();
                                                  //   controller.orderItem[index].amountOnlyTax = amountTax.toString();
                                                  //   controller.orderItem[index].finalAmount = (amount + amountTax).toString();
                                                  // } else {
                                                  amountTax = ((double.parse(controller
                                                                  .orderItem[
                                                                      index]
                                                                  .quantityCount
                                                                  .toString()) *
                                                              double.parse(controller
                                                                  .orderItem[
                                                                      index]
                                                                  .salePrice
                                                                  .toString())) *
                                                          double.parse(controller
                                                              .orderItem[index]
                                                              .tax
                                                              .toString())) /
                                                      100;
                                                  amount = (double.parse(
                                                          controller
                                                              .orderItem[index]
                                                              .quantityCount!
                                                              .toString())) *
                                                      double.parse(controller
                                                          .orderItem[index]
                                                          .salePrice
                                                          .toString());
                                                  controller.orderItem[index]
                                                          .amountWithoutTax =
                                                      amount.toString();
                                                  controller.orderItem[index]
                                                          .amountOnlyTax =
                                                      amountTax.toString();
                                                  controller.orderItem[index]
                                                          .finalAmount =
                                                      (amount + amountTax)
                                                          .toString();
                                                  // }
                                                  controller.update();

                                                  controller.getDetailsData!
                                                          .orderTotalWithoutTax =
                                                      (controller.orderItem.fold<
                                                                  double>(
                                                              0,
                                                              (sum, item) =>
                                                                  sum +
                                                                  double.parse(item
                                                                      .amountWithoutTax
                                                                      .toString())))
                                                          .toString();
                                                  controller.getDetailsData!
                                                      .orderTax = (controller
                                                          .orderItem
                                                          .fold<double>(
                                                              0,
                                                              (sum, item) =>
                                                                  sum +
                                                                  double.parse(item
                                                                      .amountOnlyTax
                                                                      .toString())))
                                                      .toString();
                                                  controller.getDetailsData!
                                                      .orderTotal = (double
                                                              .parse(controller
                                                                  .getDetailsData!
                                                                  .orderTotalWithoutTax) +
                                                          double.parse(controller
                                                              .getDetailsData!
                                                              .orderTax))
                                                      .toString();

                                                  controller
                                                          .orderItem[index]
                                                          .quantityCount!
                                                          .isEmpty
                                                      ? controller.isWrongData
                                                          .value = true
                                                      : controller
                                                                  .orderItem[
                                                                      index]
                                                                  .isUnitSelected ==
                                                              1
                                                          ? (double.parse(controller.orderItem[index].boxSize.toString()) * double.parse(controller.orderItem[index].quantityCount!)) >
                                                                  double.parse(controller
                                                                      .orderItem[
                                                                          index]
                                                                      .stock
                                                                      .toString())
                                                              ? controller
                                                                  .isWrongData
                                                                  .value = true
                                                              : controller.orderItem[index].isUnitSelected ==
                                                                      0
                                                                  ? double.parse(controller.orderItem[index].quantityCount!.text) >
                                                                          double.parse(controller.orderItem[index].stock.toString())
                                                                      ? controller.isWrongData.value = true
                                                                      : ""
                                                                  : controller.isWrongData.value = false
                                                          : controller.orderItem[index].isUnitSelected == 0
                                                              ? double.parse(controller.orderItem[index].quantityCount!) > double.parse(controller.orderItem[index].stock.toString())
                                                                  ? controller.isWrongData.value = true
                                                                  : ""
                                                              : controller.isWrongData.value = false;
                                                  controller.update();
                                                }
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: Color(0xffe0e2ea),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.remove,
                                                  size: 15,
                                                  color: AppColors.tableColor,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 1.h),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 1.h,
                                                  vertical: 1.5.h),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                    color: Color(0xffe9e7ea),
                                                  )),
                                              child: AppText(controller
                                                  .orderItem[index]
                                                  .quantityCount
                                                  .toString()),
                                            ),
                                            SizedBox(width: 1.h),
                                            GestureDetector(
                                              onTap: () async {
                                                var amountTax;
                                                var amount;
                                                if (Get.find<HomeController>()
                                                        .isOrderDetails
                                                        .value &&
                                                    Get.find<HomeController>()
                                                        .isOrderEdit
                                                        .value) {
                                                  controller.orderItem[index]
                                                          .quantityCount =
                                                      await (int.parse(controller
                                                                  .orderItem[
                                                                      index]
                                                                  .quantityCount
                                                                  .toString()) +
                                                              1)
                                                          .toString();

                                                  amountTax = ((double.parse(controller
                                                                  .orderItem[
                                                                      index]
                                                                  .quantityCount
                                                                  .toString()) *
                                                              double.parse(controller
                                                                  .orderItem[
                                                                      index]
                                                                  .salePrice
                                                                  .toString())) *
                                                          double.parse(controller
                                                              .orderItem[index]
                                                              .tax
                                                              .toString())) /
                                                      100;
                                                  amount = (double.parse(
                                                          controller
                                                              .orderItem[index]
                                                              .quantityCount!
                                                              .toString())) *
                                                      double.parse(controller
                                                          .orderItem[index]
                                                          .salePrice
                                                          .toString());
                                                  controller.orderItem[index]
                                                          .amountWithoutTax =
                                                      amount.toString();
                                                  controller.orderItem[index]
                                                          .amountOnlyTax =
                                                      amountTax.toString();
                                                  controller.orderItem[index]
                                                          .finalAmount =
                                                      (amount + amountTax)
                                                          .toString();

                                                  controller.update();

                                                  controller.getDetailsData!
                                                          .orderTotalWithoutTax =
                                                      (controller.orderItem.fold<
                                                                  double>(
                                                              0,
                                                              (sum, item) =>
                                                                  sum +
                                                                  double.parse(item
                                                                      .amountWithoutTax
                                                                      .toString())))
                                                          .toString();
                                                  controller.getDetailsData!
                                                      .orderTax = (controller
                                                          .orderItem
                                                          .fold<double>(
                                                              0,
                                                              (sum, item) =>
                                                                  sum +
                                                                  double.parse(item
                                                                      .amountOnlyTax
                                                                      .toString())))
                                                      .toString();
                                                  controller.getDetailsData!
                                                      .orderTotal = (double
                                                              .parse(controller
                                                                  .getDetailsData!
                                                                  .orderTotalWithoutTax) +
                                                          double.parse(controller
                                                              .getDetailsData!
                                                              .orderTax))
                                                      .toString();

                                                  ///
                                                  controller.orderItem[index]
                                                          .quantityCount.isEmpty
                                                      ? controller.isWrongData.value =
                                                          true
                                                      : controller.orderItem[index].isUnitSelected ==
                                                              1
                                                          ? (double.parse(controller.orderItem[index].boxSize.toString()) * double.parse(controller.orderItem[index].quantityCount!)) >
                                                                  double.parse(controller
                                                                      .orderItem[
                                                                          index]
                                                                      .stock
                                                                      .toString())
                                                              ? controller
                                                                  .isWrongData
                                                                  .value = true
                                                              : controller.orderItem[index].isUnitSelected ==
                                                                      0
                                                                  ? double.parse(controller.orderItem[index].quantityCount) >
                                                                          double.parse(controller.orderItem[index].stock
                                                                              .toString())
                                                                      ? controller.isWrongData.value =
                                                                          true
                                                                      : ""
                                                                  : controller
                                                                      .isWrongData
                                                                      .value = false
                                                          : controller.orderItem[index].isUnitSelected == 0
                                                              ? double.parse(controller.orderItem[index].quantityCount) > double.parse(controller.orderItem[index].stock.toString())
                                                                  ? controller.isWrongData.value = true
                                                                  : ""
                                                              : controller.isWrongData.value = false;
                                                  controller.update();
                                                }
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                decoration: const BoxDecoration(
                                                  color: Color(0xffe0e2ea),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.add,
                                                  size: 15,
                                                  color: AppColors.tableColor,
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                            Get.find<HomeController>()
                                                        .isOrderDetails
                                                        .value &&
                                                    Get.find<HomeController>()
                                                        .isOrderEdit
                                                        .value
                                                ? GestureDetector(
                                                    onTap: () {
                                                      controller.deleteProduct(
                                                          index: index);
                                                    },
                                                    child: Image.asset(
                                                      AppImages.ic_delete,
                                                      height: 4.h,
                                                      width: 4.h,
                                                    ),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                        SizedBox(height: 1.h),
                                        CustomTextFormField(
                                          hintText:
                                              "Enter your description here",
                                          label: "Description",
                                          readOnly: Get.find<HomeController>()
                                                      .isOrderDetails
                                                      .value &&
                                                  Get.find<HomeController>()
                                                      .isOrderEdit
                                                      .value
                                              ? false
                                              : true,
                                          controller: controller
                                              .orderItem[index].comment,
                                          onChanged: (value) {
                                            print(value);
                                            print(controller.orderItem[index]
                                                .comment!.text);
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                                ],
                              ),
                      if (controller.loginData?.roles?[0].title ==
                          "Delivery Agent")
                        ...List.generate(
                          controller.orderItem.length,
                          (index) => Card(
                            elevation: 3,
                            color: AppColors.whiteColor,
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CustomImageView(
                                        imagePath: controller.orderItem[index]
                                                    .imageUrl !=
                                                null
                                            ? "${Constants.imageBaseUrl}${controller.orderItem[index].imageUrl}"
                                            : AppImages.dummy,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 2.h),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppText(
                                          controller.orderItem[index].name
                                              .toString(),
                                          fontSize: 15.sp,
                                          maxLines: 2,
                                        ),
                                        SizedBox(height: 1.h),
                                        AppText(
                                          "Qty.: ${controller.orderItem[index].quantity.toString()}",
                                          fontSize: 13.sp,
                                          color: Color(0XFF44474d),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      SizedBox(height: 2.h),
                      controller.loginData?.roles?[0].title == "Sales Manager"
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AppText(
                                      "Total",
                                      fontSize: 13.sp,
                                      color: Color(0XFF44474d),
                                    ),
                                    AppText(
                                      "\$ ${controller.getDetailsData!.orderTotalWithoutTax.toString()}",
                                      fontSize: 14.sp,
                                      color: Color(0XFF44474d),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 1.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AppText(
                                      "Taxes & charges",
                                      fontSize: 13.sp,
                                      color: Color(0XFF44474d),
                                    ),
                                    AppText(
                                      "\$ ${controller.getDetailsData!.orderTax.toString()}",
                                      fontSize: 14.sp,
                                      color: Color(0XFF44474d),
                                    ),
                                  ],
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AppText(
                                      "Grand Total",
                                      color: AppColors.primaryColor,
                                      fontSize: 14.sp,
                                    ),
                                    AppText(
                                      "\$ ${controller.getDetailsData!.orderTotal.toString()}",
                                      fontSize: 15.sp,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                Get.find<HomeController>()
                                            .isOrderDetails
                                            .value &&
                                        Get.find<HomeController>()
                                            .isOrderEdit
                                            .value
                                    ? Row(
                                        children: [
                                          Expanded(
                                            child: AppButton(
                                              color:
                                                  AppColors.secondButtonColor,
                                              title: 'Cancel',
                                              onTap: () {
                                                Get.find<HomeController>()
                                                    .isOrderEdit
                                                    .value = false;
                                                Get.find<HomeController>()
                                                    .isOrderDetails
                                                    .value = false;
                                                // Safely update MyOrdersController only if on My Orders tab
                                                var homeController = Get.find<HomeController>();
                                                if (homeController.isSelected.value == 2) {
                                                  try {
                                                    Get.find<MyOrdersController>()
                                                        .update();
                                                  } catch (e) {
                                                    print("MyOrdersController not found in cancel: $e");
                                                  }
                                                }
                                                Get.find<HomeController>()
                                                    .update();
                                              },
                                            ),
                                          ),
                                          SizedBox(width: 4.h),
                                          Expanded(
                                            child: AppButton(
                                              onTap: () async {
                                                if (controller
                                                        .isWrongData.value ==
                                                    false) {
                                                  controller.editOrderAPI();
                                                }
                                              },
                                              title: 'Update',
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          AppButton(
                                            title: "Edit Order",
                                            isIcon: true,
                                            icon: Icons.edit,
                                            onTap: () {
                                              Get.find<HomeController>()
                                                  .isOrderEdit
                                                  .value = true;
                                              Get.find<HomeController>()
                                                  .update();
                                              controller.update();
                                            },
                                          ),
                                        ],
                                      ),
                              ],
                            )
                          : (controller.loginData?.id ==
                                      controller
                                          .getDetailsData!.deliveryAgentId) &&
                                  (controller.getDetailsData!.status != "1") &&
                                  (controller.orderItem.isNotEmpty)
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      "Customer Signature",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),
                                    SizedBox(height: 2.h),
                                    controller.bytesImage == null
                                        ? Column(
                                            children: [
                                              Container(
                                                height: 25.h,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Color(0xffb0b0b3),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: SfSignaturePad(
                                                  key: controller
                                                      .signatureGlobalKey,
                                                  minimumStrokeWidth: 1,
                                                  maximumStrokeWidth: 3,
                                                  strokeColor: Colors.black,
                                                ),
                                              ),
                                              SizedBox(height: 2.h),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: AppButton(
                                                        title: "Clear",
                                                        onTap: () async {
                                                          controller
                                                              .signatureGlobalKey
                                                              .currentState!
                                                              .clear();
                                                          controller.update();
                                                        }),
                                                  ),
                                                  SizedBox(width: 2.h),
                                                  Expanded(
                                                    child: AppButton(
                                                        title: "Save",
                                                        onTap: () async {
                                                          controller
                                                              .handleSaveButtonPressed();
                                                          controller.update();
                                                        }),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        : Container(
                                            height: 25.h,
                                            child: Image.memory(
                                              controller.bytesImage!,
                                            ),
                                          ),
                                    SizedBox(height: 2.h),
                                    CustomTextFormField(
                                      readOnly: true,
                                      label: controller.imageFile.value == ""
                                          ? 'PO File'
                                          : controller.imageFile.value
                                              .split("/")
                                              .last,
                                      hintText: controller.imageFile.value == ""
                                          ? 'Choose File'
                                          : controller.imageFile.value
                                              .split("/")
                                              .last,
                                      // suffix: Text('Pick File'),
                                      onTap: () async {
                                        print("on tap call thy 6e");
                                        controller.getFile();
                                      },
                                    ),
                                    SizedBox(height: 2.h),
                                    CustomTextFormField(
                                      hintText: "Enter your comment",
                                      label: "Comment",
                                      controller: controller.comments,
                                      readOnly: controller.loginData?.id ==
                                              controller.getDetailsData!
                                                  .deliveryAgentId
                                          ? false
                                          : true,
                                      validator: (value) =>
                                          Validators.requiredEmail(value),
                                    ),
                                    SizedBox(height: 5.h),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: AppButton(
                                            color: AppColors.secondButtonColor,
                                            title: 'Cancel',
                                            onTap: () {
                                              Get.find<HomeController>()
                                                  .isSelected
                                                  .value = 1;
                                              Get.find<HomeController>()
                                                  .update();
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 4.h),
                                        Expanded(
                                          child: AppButton(
                                            onTap: () async {
                                              if (controller.imageEncoded.value
                                                  .isNotEmpty) {
                                                controller.editOrderAPI();
                                              } else {
                                                await controller
                                                    .uploadFileAPI();
                                                await controller
                                                    .handleSaveButtonPressed();
                                                controller.editOrderAPI();
                                              }
                                            },
                                            title: 'Update',
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 2.h),
                                  ],
                                )
                              : Container(),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        child: Row(
                          children: [
                            Flexible(
                              child: AppButton(
                                title: "Invoice",
                                isIcon: true,
                                icon: Icons.picture_as_pdf,
                                onTap: () async {
                                  final pdfData =
                                      await controller.generateInvoicePdf();
                                  await Printing.sharePdf(
                                      bytes: pdfData, filename: 'invoice.pdf');
                                },
                              ),
                            ),
                            SizedBox(width: 8),
                            Flexible(
                              child: AppButton(
                                title: "Package",
                                isIcon: true,
                                icon: Icons.local_shipping,
                                onTap: () async {
                                  final pdfData = await controller.generatePackagingSlipPdf();
                                  await Printing.sharePdf(bytes: pdfData, filename: 'packaging_slip.pdf');
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }

  Widget DetailsBox({
    required String title,
    String? value,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.all(1.5.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.greyLightColor,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.blackColor,
              ),
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            flex: 3,
            child: Text(
              value ?? 'N/A',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.normal,
                color: AppColors.greyColor,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
