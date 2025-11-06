import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/services.dart';
import 'package:true_leaf_inventory_app/app/modules/orders/controllers/orders_controller.dart';
import 'package:true_leaf_inventory_app/app/widgets/app_button.dart';

import '../../../widgets/all_import.dart';

class OrdersView extends GetView<OrdersController> {
  final customerId;

  const OrdersView({this.customerId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: GetBuilder<OrdersController>(
        assignId: true,
        init: OrdersController(customerId: customerId),
        builder: (controller) {
          return GestureDetector(
            onTap: () {
              // Dismiss keyboard when tapping outside
              FocusScope.of(context).unfocus();
            },
            child: Column(
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
            // Add Search Field for Sub-Category and Product views
            Obx(() {
              if (controller.isSubCategory.value || controller.isProduct.value) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.5.h, vertical: 1.h),
                  child: CustomSearchBar(
                    hint: controller.isProduct.value 
                        ? 'Search products...' 
                        : 'Search sub-categories...',
                    onChanged: (value) {
                      if (controller.isProduct.value) {
                        // Search products
                        controller.searchProducts(text: value);
                      } else {
                        // Search sub-categories
                        controller.searchSubCategories(text: value);
                      }
                    },
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
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
                          ? LayoutBuilder(
                              key: ValueKey('products_${controller.productList.length}'),
                              builder: (BuildContext context, BoxConstraints constraints) {
                                // Responsive grid columns for different screen sizes
                                // Optimized for phones, tablets, and large tablets
                                final crossAxisCount = constraints.maxWidth > 1200 ? 6  // Large tablets (iPad Pro, etc)
                                                     : constraints.maxWidth > 900 ? 5   // Medium tablets
                                                     : constraints.maxWidth > 600 ? 4   // Small tablets / landscape phones
                                                     : 2;                                // Phones (portrait)
                                
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
                                      crossAxisCount: crossAxisCount,
                                      builder: (ctx, index) {
                                        return Card(
                                            elevation: 3,
                                            color: AppColors.whiteColor,
                                            child: Padding(
                                              padding: EdgeInsets.all(1.h),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(12),
                                                    child: Container(
                                                      height: 140,
                                                      width: double.infinity,
                                                      child: OptimizedNetworkImage(
                                                        imageUrl: controller
                                                                    .productList[
                                                                        index]
                                                                    .imageUrl !=
                                                                null
                                                            ? "${Constants.imageBaseUrl}${controller.productList[index].imageUrl}"
                                                            : AppImages.dummy,
                                                        fit: BoxFit.contain,
                                                        width: double.infinity,
                                                        height: 140,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 1.h),
                                                  AppText(
                                                    controller
                                                        .productList[index]
                                                        .name
                                                        .toString(),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                    fontSize: 13.sp,
                                                    color: AppColors
                                                        .primaryColor,
                                                  ),
                                                  if (controller.productList[index].descriptionInvoice != null &&
                                                      controller.productList[index].descriptionInvoice!.isNotEmpty)
                                                    Padding(
                                                      padding: EdgeInsets.only(top: 0.3.h),
                                                      child: AppText(
                                                        controller.productList[index].descriptionInvoice.toString(),
                                                        fontSize: 9.sp,
                                                        color: Colors.grey[600],
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  SizedBox(height: 0.8.h),
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
                                                          Flexible(
                                                            child: GestureDetector(
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
                                                                maxLines: 1,
                                                                overflow: TextOverflow.ellipsis,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 12.sp,
                                                                color: const Color(
                                                                    0XFF44474d),
                                                              ),
                                                            ),
                                                          ),
                                                          ),
                                                          SizedBox(width: 1.h),
                                                          Image.asset(
                                                            AppImages.ic_stock,
                                                            scale: 3.8,
                                                          ),
                                                          SizedBox(width: 0.5.h),
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

                                                              double currentQty = double.tryParse(controller
                                                                      .productList[
                                                                          index]
                                                                      .quantityCount ?? "0") ?? 0;
                                                              
                                                              if (currentQty > 0) {
                                                                // Decrement by 1
                                                                currentQty = currentQty - 1;
                                                                if (currentQty < 0) currentQty = 0;
                                                                
                                                                // Format: remove unnecessary .0
                                                                controller.productList[index].quantityCount = 
                                                                    currentQty == currentQty.toInt() 
                                                                      ? currentQty.toInt().toString()
                                                                      : currentQty.toString();
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
                                                                      .all(8),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: AppColors.primaryColor.withValues(alpha: 0.1),
                                                                border: Border.all(
                                                                  color: AppColors.primaryColor.withValues(alpha: 0.5),
                                                                  width: 1.5,
                                                                ),
                                                                borderRadius: BorderRadius.circular(8),
                                                              ),
                                                              child: const Icon(
                                                                Icons.remove,
                                                                size: 20,
                                                                color: AppColors
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 0.5.h),

                                                          Expanded(
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
                                                                  title: "Edit Quantity",
                                                                  barrierDismissible: false,
                                                                  content: StatefulBuilder(
                                                                      builder: (dialogContext,
                                                                          dialogSetState) {
                                                                    return SingleChildScrollView(
                                                                      child: Container(
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
                                                                                  TextInputType.numberWithOptions(decimal: true),
                                                                              inputFormatters: [
                                                                                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                                                                              ],
                                                                              decoration:
                                                                                  InputDecoration(
                                                                                hintText:
                                                                                    "Enter Quantity",
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
                                                                                dialogSetState(() {});
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
                                                                        )),
                                                                    );
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
                                                              child: Container(
                                                                padding: EdgeInsets.symmetric(
                                                                  horizontal: 6, 
                                                                  vertical: 4
                                                                ),
                                                                decoration: BoxDecoration(
                                                                  color: AppColors.primaryColor.withValues(alpha: 0.1),
                                                                  border: Border.all(
                                                                    color: AppColors.primaryColor.withValues(alpha: 0.5),
                                                                    width: 1.5,
                                                                  ),
                                                                  borderRadius: BorderRadius.circular(6),
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    AppText(
                                                                      controller.productList[index].quantityCount ?? "0",
                                                                      fontSize: 13.sp,
                                                                      fontWeight: FontWeight.w600,
                                                                      color: AppColors.primaryColor,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 0.5.h),

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
                                                              final qty = double.tryParse(
                                                                      product.quantityCount ??
                                                                          "0") ??
                                                                  0.0;
                                                              final stock =
                                                                  double.tryParse(product
                                                                              .stock
                                                                              ?.toString() ??
                                                                          "0") ??
                                                                      0.0;

                                                              final nextQty =
                                                                  qty + 1;

                                                              if (nextQty <=
                                                                  stock) {
                                                                // Format: remove unnecessary .0
                                                                product.quantityCount =
                                                                    nextQty == nextQty.toInt() 
                                                                      ? nextQty.toInt().toString()
                                                                      : nextQty.toString();
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
                                                                      .all(8),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: AppColors.primaryColor.withValues(alpha: 0.1),
                                                                border: Border.all(
                                                                  color: AppColors.primaryColor.withValues(alpha: 0.5),
                                                                  width: 1.5,
                                                                ),
                                                                borderRadius: BorderRadius.circular(8),
                                                              ),
                                                              child: const Icon(
                                                                Icons.add,
                                                                size: 20,
                                                                color: AppColors
                                                                    .primaryColor,
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
                                                      SizedBox(height: 1.h),
                                                ],
                                              ),
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
                          : LayoutBuilder(
                              key: ValueKey('categories_${controller.categoryList.length}'),
                              builder: (BuildContext context,
                                  BoxConstraints constraints) {
                                // Responsive grid columns for different screen sizes
                                final crossAxisCount = constraints.maxWidth > 1200 ? 6  // Large tablets
                                                     : constraints.maxWidth > 900 ? 5   // Medium tablets
                                                     : constraints.maxWidth > 600 ? 4   // Small tablets
                                                     : 2;                                // Phones
                                
                                return DynamicHeightGridView(
                                  itemCount: controller.categoryList.length,
                                  physics: const BouncingScrollPhysics(),
                                  crossAxisCount: crossAxisCount,
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
                                          child: SizedBox(
                                            height: 250, // Fixed card height for categories
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: Container(
                                                    height: 150, // Fixed image height
                                                    width: double.infinity,
                                                    child: OptimizedNetworkImage(
                                                      imageUrl: controller
                                                                  .categoryList[
                                                                      index]
                                                                  .imageUrl !=
                                                              null
                                                          ? "${Constants.imageBaseUrl}${controller.categoryList[index].imageUrl}"
                                                          : AppImages.dummy,
                                                      fit: BoxFit.contain,
                                                      width: double.infinity,
                                                      height: 150,
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
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
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
                                            ),
                                          )),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  )
          ],
        ),
        );
      },
      ),
    );
  }
}
