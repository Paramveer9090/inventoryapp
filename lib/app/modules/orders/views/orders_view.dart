import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/services.dart';
import 'package:true_leaf_inventory_app/app/modules/orders/controllers/orders_controller.dart';
import 'package:true_leaf_inventory_app/app/widgets/app_button.dart';
import 'package:true_leaf_inventory_app/app/widgets/custom_image.dart';

import '../../../widgets/all_import.dart';

class OrdersView extends GetView<OrdersController> {
  final customerId;

  const OrdersView({this.customerId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdersController>(
      assignId: true,
      init: OrdersController(customerId: customerId),
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.5.h),
            GestureDetector(
              onTap: () async {
                if (controller.isSubCategory.value && controller.isProduct.value == false) {
                  // Going back from subcategories to categories
                  controller.isSubCategory.value = false;
                  controller.isCategory.value = true;
                  controller.isAddToCartButton.value = false;
                  controller.getCategoriesAPI(categoryId: "0"); // Always go to root categories
                  controller.update();
                }
                if (controller.isProduct.value) {
                  if (controller.cameFromCategoryWithNoSubcategories.value) {
                    // Go back to main categories
                    controller.isCategory.value = true;
                    controller.isSubCategory.value = false;
                    controller.isProduct.value = false;
                    controller.isAddToCartButton.value = false;
                    controller.getCategoriesAPI(categoryId: "0");
                    controller.update();
                  } else {
                    // Usual logic: go back to subcategories
                    controller.isCategory.value = false;
                    controller.isSubCategory.value = true;
                    controller.isProduct.value = false;
                    controller.isAddToCartButton.value = false;
                    controller.getCategoriesAPI(categoryId: controller.parentCategoryId.value);
                    controller.update();
                  }
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.5.h),
                child: Row(
                  children: [
                    controller.isProduct.value || controller.isSubCategory.value
                        ? const Icon(
                            Icons.arrow_back_ios_sharp,
                            size: 15,
                          )
                        : Container(),
                    SizedBox(
                        width: controller.isProduct.value ||
                                controller.isSubCategory.value
                            ? 1.h
                            : 0),
                    AppText(
                      controller.isProduct.value
                          ? "Go back to sub categories" // Updated text
                          : controller.isSubCategory.value
                              ? "${"Sub Categories"} (${controller.categoryName.value})"
                              : "Categories",
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 1.h),
            (controller.categoryList.isEmpty &&
                        controller.productList.isEmpty) ||
                    (controller.productList.length == 0 &&
                        controller.isProduct.value)
                ? Expanded(
                    child: Center(
                      child: AppText(
                        (controller.productList.length == 0 &&
                                controller.isProduct.value)
                            ? "No Product found"
                            : controller.noData.value,
                        fontSize: 13.sp,
                        color: AppColors.greyColor,
                      ),
                    ),
                  )
                : Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1.5.h),
                      child: controller.isProduct.value
                          ? OrientationBuilder(builder:
                              (BuildContext context, Orientation orientation) {
                              print(
                                  "🖼️ Rendering ${controller.productList.length} product cards");
                              return Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        bottom:
                                            controller.isAddToCartButton.value
                                                ? 70
                                                : 0),
                                    child: DynamicHeightGridView(
                                      itemCount: controller.productList.length,
                                      physics: const BouncingScrollPhysics(),
                                      crossAxisCount:
                                          orientation == Orientation.portrait
                                              ? 2
                                              : 4,
                                      builder: (ctx, index) {
                                        return Card(
                                            elevation: 3,
                                            color: AppColors.whiteColor,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: Container(
                                                    height: 25.h,
                                                    child: CustomImageView(
                                                      imagePath: controller
                                                                  .productList[
                                                                      index]
                                                                  .imageUrl !=
                                                              null
                                                          ? "${Constants.imageBaseUrl}${controller.productList[index].imageUrl}"
                                                          : AppImages.dummy,
                                                      fit: BoxFit.cover,
                                                      width: double.infinity,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 1.h),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 1.5.h),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      AppText(
                                                        controller
                                                            .productList[index]
                                                            .name
                                                            .toString(),
                                                        maxLines: 10,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 13.sp,
                                                        color: AppColors
                                                            .primaryColor,
                                                      ),
                                                      SizedBox(height: 2.h),
                                                      Row(
                                                        children: [
                                                          AppText(
                                                            "\$ ",
                                                            maxLines: 10,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 12.sp,
                                                            color: const Color(
                                                                0XFF44474d),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              controller
                                                                      .sellingPriceText
                                                                      .text =
                                                                  controller
                                                                      .productList[
                                                                          index]
                                                                      .sellingPrice
                                                                      .toString();
                                                              Get.defaultDialog(
                                                                title:
                                                                    "Edit Price",
                                                                content: StatefulBuilder(
                                                                    builder:
                                                                        (context,
                                                                            setState) {
                                                                  return Container(
                                                                    width: 200,
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        TextFormField(
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 13.sp),
                                                                          controller:
                                                                              controller.sellingPriceText,
                                                                          keyboardType:
                                                                              TextInputType.number,
                                                                          decoration:
                                                                              InputDecoration(
                                                                            hintText:
                                                                                "Edit Price",
                                                                            border: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(5),
                                                                                borderSide: const BorderSide(
                                                                                  color: Color(0xffe9e7ea),
                                                                                )),
                                                                            focusedBorder:
                                                                                OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: AppColors.blackColor)),
                                                                            enabledBorder:
                                                                                OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: AppColors.blackColor)),
                                                                            errorBorder:
                                                                                OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: AppColors.blackColor)),
                                                                            disabledBorder:
                                                                                OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: AppColors.blackColor)),
                                                                          ),
                                                                          onChanged:
                                                                              (value) {
                                                                            controller.update();
                                                                            setState(() {});
                                                                          },
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                0.5.h),
                                                                        AppText(
                                                                          controller.sellingPriceText.text.isEmpty || double.tryParse(controller.sellingPriceText.text) == null || double.parse(controller.sellingPriceText.text) <= 0
                                                                              ? "Sales Price can't be 0"
                                                                              : "",
                                                                          fontSize:
                                                                              11.sp,
                                                                          color:
                                                                              AppColors.darkRedColor,
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                2.h),
                                                                        AppButton(
                                                                            title:
                                                                                "Save",
                                                                            onTap:
                                                                                () {
                                                                              if (controller.sellingPriceText.text.isEmpty || double.tryParse(controller.sellingPriceText.text) == null || double.parse(controller.sellingPriceText.text) <= 0) {
                                                                                // Show error or do nothing
                                                                              } else {
                                                                                Get.back(result: controller.sellingPriceText.text);
                                                                                controller.update();
                                                                              }
                                                                            }),
                                                                      ],
                                                                    ),
                                                                  );
                                                            }),
                                                              );
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          1.5.h,
                                                                      vertical:
                                                                          2),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                border:
                                                                    Border.all(
                                                                  color: Color(
                                                                      0xffe9e7ea),
                                                                ),
                                                              ),
                                                              child: AppText(
                                                                "${controller.productList[index].sellingPrice.toString()}",
                                                                maxLines: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 12.sp,
                                                                color: const Color(
                                                                    0XFF44474d),
                                                              ),
                                                            ),
                                                          ),
                                                          const Spacer(),
                                                          Image.asset(
                                                            AppImages.ic_stock,
                                                            scale: 3.8,
                                                          ),
                                                          SizedBox(width: 1.h),
                                                          AppText(
                                                            "${controller.productList[index].stock.toString()}",
                                                            maxLines: 10,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 12.sp,
                                                            color: const Color(
                                                                0XFF44474d),
                                                          ),
                                                        ],
                                                      ),
                                                      /* SizedBox(height: 0.5.h),
                                                      AppText(
                                                        "Taxes: ${controller.productList[index].taxDetail?.tax.toString()}%",
                                                        maxLines: 10,
                                                        fontSize: 12.sp,
                                                        color: const Color(0XFF44474d),
                                                      ),
                                                      SizedBox(height: 0.8.h),
                                                      Row(
                                                        children: [
                                                          ...List.generate(
                                                            2,
                                                            (subIndex) => Expanded(
                                                              child: GestureDetector(
                                                                onTap: () {
                                                                  controller.productList[index].isUnitSelected = subIndex;
                                                                  controller.productList[index].isBox = subIndex;
                                                                  controller.isAddedData.value = true;
                                                                  controller.update();
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    Container(
                                                                      height: 15,
                                                                      width: 15,
                                                                      padding: const EdgeInsets.all(1.5),
                                                                      decoration: BoxDecoration(
                                                                        color: controller.productList[index].isUnitSelected == subIndex ? AppColors.tableColor : Color(0XFF44474d),
                                                                        borderRadius: BorderRadius.circular(50),
                                                                      ),
                                                                      child: Container(
                                                                        decoration: BoxDecoration(
                                                                          color: controller.productList[index].isUnitSelected == subIndex ? AppColors.tableColor : AppColors.whiteColor,
                                                                          border: Border.all(
                                                                            color: AppColors.whiteColor,
                                                                          ),
                                                                          borderRadius: BorderRadius.circular(50),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(width: 10),
                                                                    AppText(
                                                                      subIndex == 0 ? "Unit" : "Box",
                                                                      fontSize: 12.sp,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: controller.productList[index].boxSize == null ? 0 : 0.5.h),
                                                      Align(
                                                        alignment: Alignment.bottomRight,
                                                        child: controller.productList[index].boxSize == null
                                                            ? Container()
                                                            : AppText(
                                                                "Box Size: ${controller.productList[index].boxSize}",
                                                                fontSize: 10.sp,
                                                              ),
                                                      ), */
                                                      SizedBox(height: 1.h),
                                                      Row(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              controller
                                                                  .isAddedData
                                                                  .value = true;

                                                              if (int.parse(controller
                                                                      .productList[
                                                                          index]
                                                                      .quantityCount!) >
                                                                  0) {
                                                                controller
                                                                    .productList[
                                                                        index]
                                                                    .quantityCount = (int.parse(controller
                                                                            .productList[index]
                                                                            .quantityCount!) -
                                                                        1)
                                                                    .toString();
                                                              }

                                                              // Check if any product has quantity > 0 for cart button
                                                              for (int i = 0;
                                                                  i <
                                                                      controller
                                                                          .productList
                                                                          .length;
                                                                  i++) {
                                                                if (controller
                                                                        .productList[
                                                                            i]
                                                                        .quantityCount !=
                                                                    "0") {
                                                                  controller
                                                                      .isAddToCartButton
                                                                      .value = true;
                                                                  break;
                                                                } else {
                                                                  controller
                                                                      .isAddToCartButton
                                                                      .value = false;
                                                                }
                                                              }

                                                              // REPLACE THE COMPLEX VALIDATION WITH THIS:
                                                              controller
                                                                  .validateQuantity(
                                                                      index);
                                                              controller
                                                                  .update();
                                                            },
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: Color(
                                                                    0xffe0e2ea),
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child: const Icon(
                                                                Icons.remove,
                                                                size: 15,
                                                                color: AppColors
                                                                    .tableColor,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 1.h),

                                                          Expanded(
                                                              child: Center(
                                                            child: AppText(controller
                                                                .productList[
                                                                    index]
                                                                .quantityCount),
                                                          )),
                                                          SizedBox(width: 1.h),

                                                          // PLUS BUTTON
                                                          GestureDetector(
                                                            onTap: () async {
                                                              controller
                                                                  .isAddedData
                                                                  .value = true;

                                                              final product =
                                                                  controller
                                                                          .productList[
                                                                      index];
                                                              final qty = int.tryParse(
                                                                      product.quantityCount ??
                                                                          "0") ??
                                                                  0;
                                                              final stock =
                                                                  int.tryParse(product
                                                                              .stock
                                                                              ?.toString() ??
                                                                          "0") ??
                                                                      0;

                                                              final nextQty =
                                                                  qty + 1;

                                                              if (nextQty <=
                                                                  stock) {
                                                                product.quantityCount =
                                                                    nextQty
                                                                        .toString();
                                                                controller.isAddToCartButton.value =
                                                                    controller
                                                                        .productList
                                                                        .any((p) =>
                                                                            p.quantityCount !=
                                                                            "0");
                                                                controller
                                                                    .validateQuantity(
                                                                        index);
                                                                controller
                                                                    .update();
                                                              }
                                                            },
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: Color(
                                                                    0xffe0e2ea),
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child: const Icon(
                                                                Icons.add,
                                                                size: 15,
                                                                color: AppColors
                                                                    .tableColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 2,
                                                                left: 5),
                                                        child: AppText(
                                                          (() {
                                                            final product =
                                                                controller
                                                                        .productList[
                                                                    index];
                                                            final qtyStr = product
                                                                    .quantityCount ??
                                                                "";
                                                            final stockStr = product
                                                                    .stock
                                                                    ?.toString() ??
                                                                "0";

                                                            if (qtyStr.isEmpty)
                                                              return "Please Enter Quantity";

                                                            final qty =
                                                                double.tryParse(
                                                                        qtyStr) ??
                                                                    0;
                                                            final stock =
                                                                double.tryParse(
                                                                        stockStr) ??
                                                                    0;

                                                            if (qty > stock)
                                                              return "Quantity can't be greater than In Stock";
                                                            return "";
                                                          })(),
                                                          color: AppColors
                                                              .darkRedColor,
                                                          fontSize: 10.sp,
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .bottomRight,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            controller
                                                                    .quantityText
                                                                    .text =
                                                                controller
                                                                    .productList[
                                                                        index]
                                                                    .quantityCount
                                                                    .toString();
                                                            Get.defaultDialog(
                                                              title:
                                                                  "Add Quantity",
                                                              content: StatefulBuilder(
                                                                  builder: (context,
                                                                      setState) {
                                                                return Container(
                                                                    width: 200,
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        TextFormField(
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 13.sp),
                                                                          controller:
                                                                              controller.quantityText,
                                                                          keyboardType:
                                                                              TextInputType.number,
                                                                          inputFormatters: [
                                                                            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                                                                          ],
                                                                          decoration:
                                                                              InputDecoration(
                                                                            hintText:
                                                                                "Add Quantity",
                                                                            border: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(5),
                                                                                borderSide: const BorderSide(
                                                                                  color: Color(0xffe9e7ea),
                                                                                )),
                                                                            focusedBorder:
                                                                                OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: AppColors.blackColor)),
                                                                            enabledBorder:
                                                                                OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: AppColors.blackColor)),
                                                                            errorBorder:
                                                                                OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: AppColors.blackColor)),
                                                                            disabledBorder:
                                                                                OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: AppColors.blackColor)),
                                                                          ),
                                                                          onChanged:
                                                                              (value) {
                                                                            controller.update();
                                                                            setState(() {});
                                                                          },
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                0.5.h),
                                                                        AppText(
                                                                          controller.quantityText.text.isEmpty || double.tryParse(controller.quantityText.text) == null || double.parse(controller.quantityText.text) <= 0
                                                                              ? "Quantity can't be 0"
                                                                              : double.tryParse(controller.quantityText.text) != null && 
                                                                                double.tryParse(controller.productList[index].stock?.toString() ?? "0") != null &&
                                                                                double.parse(controller.quantityText.text) > double.parse(controller.productList[index].stock.toString())
                                                                                  ? "Quantity can't be greater than In Stock"
                                                                                  : "",
                                                                          color:
                                                                              AppColors.darkRedColor,
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                2.h),
                                                                        AppButton(
                                                                            title:
                                                                                "Save",
                                                                            onTap:
                                                                                () {
                                                                              controller.isAddedData.value = true;

                                                                              // Only unit logic:
                                                                              if (controller.quantityText.text.isEmpty || double.tryParse(controller.quantityText.text) == null || double.parse(controller.quantityText.text) <= 0) {
                                                                                controller.productList[index].isWrongData = true;
                                                                              } else if (double.parse(controller.quantityText.text) > double.parse(controller.productList[index].stock.toString())) {
                                                                                controller.productList[index].isWrongData = true;
                                                                              } else {
                                                                                controller.productList[index].isWrongData = false;
                                                                              }
                                                                              controller.update();
                                                                              if (controller.productList[index].isWrongData != true) {
                                                                                // Update cart button based on all products
                                                                                controller.isAddToCartButton.value = controller.productList.any((p) => (p.quantityCount ?? "0") != "0");
                                                                                Get.back(result: controller.quantityText.text);
                                                                              }
                                                                            }),
                                                                      ],
                                                                    ));
                                                              }),
                                                            ).then((value) {
                                                              print(value);
                                                              if (value !=
                                                                  null) {
                                                                controller
                                                                    .productList[
                                                                        index]
                                                                    .quantityCount = value;
                                                                controller
                                                                    .update();
                                                              }
                                                            });
                                                          },
                                                          child: const Icon(
                                                            Icons.edit,
                                                            size: 18,
                                                            color: AppColors
                                                                .tableColor,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 1.h),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 1.h),
                                              ],
                                            ));
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    child: SizedBox(
                                      height: 50,
                                      child: Get.find<HomeController>().isOrderEdit.value &&
                                              controller.isAddToCartButton.value
                                          ? AppButton(
                                              title: "Add Product",
                                              isIcon: true,
                                              icon: Icons.add,
                                              onTap: () async {
                                                try {
                                                  print("=== ADD PRODUCT DEBUG ===");
                                                  
                                                  final homeController = Get.find<HomeController>();
                                                  print("HomeController isCustomerId: '${homeController.isCustomerId.value}'");
                                                  print("Controller customerId: '${controller.customerId}'");
                                                  print("Widget customerId: '${customerId}'");
                                                  
                                                  // Try to get customer ID from multiple sources
                                                  String actualCustomerId = '';
                                                  
                                                  if (homeController.isCustomerId.value.isNotEmpty) {
                                                    actualCustomerId = homeController.isCustomerId.value;
                                                    print("Using customer ID from HomeController");
                                                  } else if (controller.customerId != null && controller.customerId.toString().isNotEmpty) {
                                                    actualCustomerId = controller.customerId.toString();
                                                    print("Using customer ID from Controller");
                                                  } else if (customerId != null && customerId.toString().isNotEmpty) {
                                                    actualCustomerId = customerId.toString();
                                                    print("Using customer ID from Widget");
                                                  }
                                                  
                                                  print("Final customer ID: '$actualCustomerId'");
                                                  
                                                  if (actualCustomerId.isEmpty) {
                                                    print("ERROR: Could not determine customer ID!");
                                                    Get.snackbar("Error", "Customer information not available");
                                                    return;
                                                  }
                                                  
                                                  // Set the customer ID in HomeController
                                                  homeController.isCustomerId.value = actualCustomerId;
                                                  
                                                  // Validate products have quantities
                                                  final selectedProducts = controller.productList
                                                      .where((product) => (product.quantityCount ?? "0") != "0")
                                                      .toList();
                                                  
                                                  if (selectedProducts.isEmpty) {
                                                    Get.snackbar("Error", "Please select at least one product");
                                                    return;
                                                  }
                                                  
                                                  print("Selected products count: ${selectedProducts.length}");
                                                  
                                                  // Call the add to cart API
                                                  await controller.addToCartAPI();
                                                  
                                                  print("Add to existing order completed");
                                                  
                                                } catch (e) {
                                                  print("ERROR in Add Product: $e");
                                                  Get.snackbar("Error", "Failed to add product: $e");
                                                }
                                              },
                                            )
                                          : controller.isAddToCartButton.value
                                              ? AppButton(
                                                  title: "Add to cart",
                                                  onTap: () async {
                                                    try {
                                                      bool isWrong = controller.productList.any((p) => p.isWrongData == true);
                                                      controller.update();
                                                      
                                                      if (!isWrong) {
                                                        await controller.addToCartAPI();
                                                      } else {
                                                        utils.showSnackBar(
                                                          context: context,
                                                          message: "Please fix quantity errors first",
                                                        );
                                                      }
                                                    } catch (e) {
                                                      utils.showSnackBar(
                                                        context: context,
                                                        message: "Failed to add to cart: ${e.toString()}",
                                                      );
                                                    }
                                                  },
                                                )
                                              : Container(),
                                    ),
                                  ),
                                ],
                              );
                            })
                          : OrientationBuilder(
                              builder: (BuildContext context,
                                  Orientation orientation) {
                                print(
                                    '🔨 Rendering ${controller.productList.length} product cards');
                                return DynamicHeightGridView(
                                  itemCount: controller.categoryList.length,
                                  physics: const BouncingScrollPhysics(),
                                  crossAxisCount:
                                      orientation == Orientation.portrait
                                          ? 2
                                          : 4,
                                  builder: (ctx, index) {
                                    return GestureDetector(
                                      onTap: () async {
                                        if (controller.isSubCategory.value) {
                                          // Selecting a subcategory to view products
                                          print("product id ${controller.categoryList[index].id}");
                                          controller.subCategoryName.value = controller.categoryList[index].name.toString();
                                          controller.subCategoryId.value = controller.categoryList[index].id.toString();
                                          controller.currentSubCategoryId.value = controller.categoryList[index].id.toString();
                                          controller.getProduct(
                                            subCategoryId: controller.categoryList[index].id,
                                            type: "subCategory"
                                          );
                                        } else {
                                          // Selecting a main category to view subcategories
                                          controller.isSubCategory.value = true;
                                          controller.categoryName.value = controller.categoryList[index].name.toString();
                                          controller.categoryId.value = controller.categoryList[index].id.toString();
                                          
                                          // Store the parent category ID for back navigation
                                          controller.parentCategoryId.value = controller.categoryList[index].id.toString();
                                          controller.currentCategoryId.value = controller.categoryList[index].id.toString();
                                          
                                          print("Sub category id ${controller.categoryList[index].id}");
                                          controller.getCategoriesAPI(categoryId: controller.categoryList[index].id.toString());
                                        }
                                        controller.update();
                                      },
                                      child: Card(
                                          elevation: 3,
                                          color: AppColors.whiteColor,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: Container(
                                                  height: 25.h,
                                                  child: CustomImageView(
                                                    imagePath: controller
                                                                .categoryList[
                                                                    index]
                                                                .imageUrl !=
                                                            null
                                                        ? "${Constants.imageBaseUrl}${controller.categoryList[index].imageUrl}"
                                                        : AppImages.dummy,
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 1.h),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 1.5.h),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: AppText(
                                                        controller
                                                            .categoryList[index]
                                                            .name
                                                            .toString(),
                                                        maxLines: 10,
                                                        fontSize: 12.sp,
                                                      ),
                                                    ),
                                                    const Icon(
                                                      Icons.arrow_forward,
                                                      color:
                                                          AppColors.arrowColor,
                                                      size: 20,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 1.h),
                                            ],
                                          )),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  )
          ],
        );
      },
    );
  }
}
