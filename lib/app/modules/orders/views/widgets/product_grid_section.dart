import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/services.dart';

import '../../controllers/orders_controller.dart';
import '../../../../utils/responsive_helper.dart';
import '../../../../widgets/all_import.dart';
import '../../../../widgets/app_button.dart';

class ProductGridSection extends StatelessWidget {
  final OrdersController controller;
  final dynamic customerId;

  const ProductGridSection({Key? key, required this.controller, this.customerId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      key: ValueKey('products_${controller.productList.length}'),
      builder: (BuildContext context, BoxConstraints constraints) {
        // Responsive grid columns for phones and tablets
        final crossAxisCount = constraints.maxWidth > 1200
            ? 6
            : constraints.maxWidth > 900
                ? 5
                : constraints.maxWidth > 600
                    ? 4
                    : 2;

        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Padding(
              padding:
                  EdgeInsets.only(bottom: controller.isAddToCartButton.value ? 70 : 0),
              child: DynamicHeightGridView(
                itemCount: controller.productList.length,
                physics: const BouncingScrollPhysics(),
                crossAxisCount: crossAxisCount,
                builder: (ctx, index) {
                  final product = controller.productList[index];
                  return Card(
                    elevation: 3,
                    color: AppColors.whiteColor,
                    child: Padding(
                      padding: EdgeInsets.all(1.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              height: 140,
                              width: double.infinity,
                              child: OptimizedNetworkImage(
                                imageUrl: product.imageUrl != null
                                    ? "${Constants.imageBaseUrl}${product.imageUrl}"
                                    : AppImages.dummy,
                                fit: BoxFit.contain,
                                width: double.infinity,
                                height: 140,
                              ),
                            ),
                          ),
                          SizedBox(height: 1.h),
                          AppText(
                            product.name.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w600,
                            fontSize: 11.sp,
                            color: AppColors.primaryColor,
                          ),
                          if (product.descriptionInvoice != null &&
                              product.descriptionInvoice!.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(top: 0.3.h),
                              child: AppText(
                                product.descriptionInvoice.toString(),
                                fontSize: ResponsiveHelper.getResponsiveFontSize(
                                    context, 8.sp, 10.sp),
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
                                fontWeight: FontWeight.w600,
                                fontSize: ResponsiveHelper.getResponsiveFontSize(
                                    context, 10.sp, 13.sp),
                                color: const Color(0XFF44474d),
                              ),
                              Flexible(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.sellingPriceText.text =
                                        product.sellingPrice.toString();
                                    Get.defaultDialog(
                                      title: "Edit Price",
                                      content: StatefulBuilder(
                                          builder: (context, setState) {
                                        return SizedBox(
                                          width: 200,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TextFormField(
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        ResponsiveHelper.getResponsiveFontSize(
                                                            context, 13.sp, 16.sp)),
                                                controller:
                                                    controller.sellingPriceText,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  hintText: "Edit Price",
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      borderSide: const BorderSide(
                                                        color: Color(0xffe9e7ea),
                                                      )),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      borderSide: const BorderSide(
                                                          color: AppColors.blackColor)),
                                                  enabledBorder: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      borderSide: const BorderSide(
                                                          color: AppColors.blackColor)),
                                                  errorBorder: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      borderSide: const BorderSide(
                                                          color: AppColors.blackColor)),
                                                  disabledBorder: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      borderSide: const BorderSide(
                                                          color: AppColors.blackColor)),
                                                ),
                                                onChanged: (value) {
                                                  controller.update();
                                                  setState(() {});
                                                },
                                              ),
                                              SizedBox(height: 0.5.h),
                                              AppText(
                                                controller.sellingPriceText.text
                                                            .isEmpty ||
                                                        double.tryParse(controller
                                                                .sellingPriceText
                                                                .text) ==
                                                            null ||
                                                        double.parse(controller
                                                                .sellingPriceText
                                                                .text) <=
                                                            0
                                                    ? "Sales Price can't be 0"
                                                    : "",
                                                fontSize: ResponsiveHelper
                                                    .getResponsiveFontSize(
                                                        context, 11.sp, 13.sp),
                                                color: AppColors.darkRedColor,
                                              ),
                                              SizedBox(height: 2.h),
                                              AppButton(
                                                title: "Save",
                                                onTap: () {
                                                  if (controller.sellingPriceText
                                                          .text.isEmpty ||
                                                      double.tryParse(controller
                                                              .sellingPriceText
                                                              .text) ==
                                                          null ||
                                                      double.parse(controller
                                                              .sellingPriceText
                                                              .text) <=
                                                          0) {
                                                    return;
                                                  }
                                                  Get.back(
                                                      result: controller
                                                          .sellingPriceText
                                                          .text);
                                                  controller.update();
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 1.5.h, vertical: 2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: const Color(0xffe9e7ea),
                                      ),
                                    ),
                                    child: AppText(
                                      product.sellingPrice.toString(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10.sp,
                                      color: const Color(0XFF44474d),
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
                                product.stock.toString(),
                                maxLines: 10,
                                fontWeight: FontWeight.w600,
                                fontSize: 10.sp,
                                color: const Color(0XFF44474d),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  controller.isAddedData.value = true;

                                  double currentQty =
                                      double.tryParse(product.quantityCount ??
                                              "0") ??
                                          0;

                                  if (currentQty > 0) {
                                    currentQty = currentQty - 1;
                                    if (currentQty < 0) currentQty = 0;

                                    product.quantityCount = currentQty ==
                                            currentQty.toInt()
                                        ? currentQty.toInt().toString()
                                        : currentQty.toString();
                                  }

                                  for (int i = 0;
                                      i < controller.productList.length;
                                      i++) {
                                    if (controller.productList[i].quantityCount !=
                                        "0") {
                                      controller.isAddToCartButton.value = true;
                                      break;
                                    } else {
                                      controller.isAddToCartButton.value = false;
                                    }
                                  }

                                  controller.validateQuantity(index);
                                  controller.update();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor
                                        .withValues(alpha: 0.1),
                                    border: Border.all(
                                      color: AppColors.primaryColor
                                          .withValues(alpha: 0.5),
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.remove,
                                    size: 20,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                              SizedBox(width: 0.5.h),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.quantityText.text =
                                        product.quantityCount.toString();
                                    Get.defaultDialog(
                                      title: "Edit Quantity",
                                      barrierDismissible: false,
                                      content: StatefulBuilder(
                                          builder: (dialogContext, dialogSetState) {
                                        return SingleChildScrollView(
                                          child: SizedBox(
                                            width: 200,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                TextFormField(
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13.sp),
                                                  controller:
                                                      controller.quantityText,
                                                  keyboardType:
                                                      const TextInputType
                                                          .numberWithOptions(
                                                              decimal: true),
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter.allow(
                                                        RegExp(r'^\d*\.?\d*')),
                                                  ],
                                                  decoration: InputDecoration(
                                                    hintText: "Enter Quantity",
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                5),
                                                        borderSide:
                                                            const BorderSide(
                                                          color:
                                                              Color(0xffe9e7ea),
                                                        )),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(5),
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: AppColors
                                                                        .blackColor)),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(5),
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: AppColors
                                                                        .blackColor)),
                                                    errorBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                5),
                                                        borderSide:
                                                            const BorderSide(
                                                                color: AppColors
                                                                    .blackColor)),
                                                    disabledBorder:
                                                        OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(5),
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: AppColors
                                                                        .blackColor)),
                                                  ),
                                                  onChanged: (value) {
                                                    dialogSetState(() {});
                                                  },
                                                ),
                                                SizedBox(height: 0.5.h),
                                                AppText(
                                                  controller.quantityText.text
                                                              .isEmpty ||
                                                          double.tryParse(controller
                                                                  .quantityText
                                                                  .text) ==
                                                              null ||
                                                          double.parse(controller
                                                                  .quantityText
                                                                  .text) <=
                                                              0
                                                      ? "Quantity can't be 0"
                                                      : double.tryParse(controller
                                                                      .quantityText
                                                                      .text) !=
                                                                  null &&
                                                              double.tryParse(product
                                                                      .stock
                                                                      ?.toString() ??
                                                                  "0") !=
                                                                  null &&
                                                              double.parse(controller
                                                                      .quantityText
                                                                      .text) >
                                                                  double.parse(product
                                                                      .stock
                                                                      .toString())
                                                          ? "Quantity can't be greater than In Stock"
                                                          : "",
                                                  color: AppColors.darkRedColor,
                                                ),
                                                SizedBox(height: 2.h),
                                                AppButton(
                                                  title: "Save",
                                                  onTap: () {
                                                    controller.isAddedData.value =
                                                        true;

                                                    if (controller.quantityText
                                                            .text.isEmpty ||
                                                        double.tryParse(controller
                                                                .quantityText
                                                                .text) ==
                                                            null ||
                                                        double.parse(controller
                                                                .quantityText
                                                                .text) <=
                                                            0) {
                                                      product.isWrongData =
                                                          true;
                                                    } else if (double.parse(
                                                            controller
                                                                .quantityText
                                                                .text) >
                                                        double.parse(product
                                                            .stock
                                                            .toString())) {
                                                      product.isWrongData =
                                                          true;
                                                    } else {
                                                      product.isWrongData =
                                                          false;
                                                    }
                                                    controller.update();
                                                    if (product.isWrongData !=
                                                        true) {
                                                      controller.isAddToCartButton
                                                          .value = controller
                                                              .productList
                                                              .any((p) =>
                                                                  (p.quantityCount ??
                                                                          "0") !=
                                                                      "0");
                                                      Get.back(
                                                          result: controller
                                                              .quantityText
                                                              .text);
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                    ).then((value) {
                                      if (value != null) {
                                        product.quantityCount = value;
                                        controller.update();
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor
                                          .withValues(alpha: 0.1),
                                      border: Border.all(
                                        color: AppColors.primaryColor
                                            .withValues(alpha: 0.5),
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AppText(
                                          product.quantityCount ?? "0",
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
                              GestureDetector(
                                onTap: () async {
                                  controller.isAddedData.value = true;

                                  final qty = double.tryParse(
                                          product.quantityCount ?? "0") ??
                                      0.0;
                                  final stock = double.tryParse(
                                          product.stock?.toString() ?? "0") ??
                                      0.0;
                                  final nextQty = qty + 1;

                                  if (nextQty <= stock) {
                                    product.quantityCount = nextQty ==
                                            nextQty.toInt()
                                        ? nextQty.toInt().toString()
                                        : nextQty.toString();
                                    controller.isAddToCartButton.value =
                                        controller.productList.any(
                                            (p) => p.quantityCount != "0");
                                    controller.validateQuantity(index);
                                    controller.update();
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor
                                        .withValues(alpha: 0.1),
                                    border: Border.all(
                                      color: AppColors.primaryColor
                                          .withValues(alpha: 0.5),
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    size: 20,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2, left: 5),
                            child: AppText(
                              (() {
                                final qtyStr = product.quantityCount ?? "";
                                final stockStr = product.stock?.toString() ?? "0";

                                if (qtyStr.isEmpty) return "Please Enter Quantity";

                                final qty = double.tryParse(qtyStr) ?? 0;
                                final stock = double.tryParse(stockStr) ?? 0;

                                if (qty > stock) {
                                  return "Quantity can't be greater than In Stock";
                                }
                                return "";
                              })(),
                              color: AppColors.darkRedColor,
                              fontSize: 10.sp,
                            ),
                          ),
                          SizedBox(height: 1.h),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
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
                            final homeController = Get.find<HomeController>();

                            String actualCustomerId = '';
                            if (homeController.isCustomerId.value.isNotEmpty) {
                              actualCustomerId = homeController.isCustomerId.value;
                            } else if (controller.customerId != null &&
                                controller.customerId.toString().isNotEmpty) {
                              actualCustomerId = controller.customerId.toString();
                            } else if (customerId != null &&
                                customerId.toString().isNotEmpty) {
                              actualCustomerId = customerId.toString();
                            }

                            if (actualCustomerId.isEmpty) {
                              Get.snackbar(
                                  "Error", "Customer information not available");
                              return;
                            }

                            homeController.isCustomerId.value = actualCustomerId;

                            final selectedProducts = controller.productList
                                .where((product) =>
                                    (product.quantityCount ?? "0") != "0")
                                .toList();

                            if (selectedProducts.isEmpty) {
                              Get.snackbar(
                                  "Error", "Please select at least one product");
                              return;
                            }

                            await controller.addToCartAPI();
                          } catch (e) {
                            Get.snackbar(
                                "Error", "Failed to add product: $e");
                          }
                        },
                      )
                    : controller.isAddToCartButton.value
                        ? AppButton(
                            title: "Add to cart",
                            onTap: () async {
                              try {
                                final isWrong = controller.productList
                                    .any((p) => p.isWrongData == true);
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
                                  message:
                                      "Failed to add to cart: ${e.toString()}",
                                );
                              }
                            },
                          )
                        : const SizedBox.shrink(),
              ),
            ),
          ],
        );
      },
    );
  }
}
