import 'package:flutter/services.dart';
import 'package:true_leaf_inventory_app/app/models/details_response_model.dart';
import 'package:true_leaf_inventory_app/app/modules/cart/controllers/cart_controller.dart';
import 'package:true_leaf_inventory_app/app/utils/responsive_helper.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';
import 'package:true_leaf_inventory_app/app/widgets/app_button.dart';

class CartItemCard extends StatelessWidget {
  final CartController controller;
  final CartDetails data;
  final int index;

  const CartItemCard({Key? key, required this.controller, required this.data, required this.index}) : super(key: key);

  void _recalculateTotals() {
    controller.amountTax = ((double.parse(controller.orderItemList[index].quantity.toString()) * double.parse(controller.orderItemList[index].price.toString())) * double.parse(controller.orderItemList[index].tax.toString())) / 100;
    controller.amount = double.parse(controller.orderItemList[index].quantity!.toString()) * double.parse(controller.orderItemList[index].price.toString());
    controller.orderItemList[index].amountWithoutTax = controller.amount.toString();
    controller.orderItemList[index].amountOnlyTax = controller.amountTax.toString();
    controller.orderItemList[index].finalAmount = (controller.amount + controller.amountTax).toString();
    controller.orderTotal.value = controller.orderItemList
        .fold<double>(0, (sum, item) => sum + double.parse(item.amountWithoutTax.toString()))
        .toStringAsFixed(2);
    controller.orderTax.value = controller.orderItemList
        .fold<double>(0, (sum, item) => sum + double.parse(item.amountOnlyTax.toString()))
        .toStringAsFixed(2);
    controller.orderFinalTotal.value = (double.parse(controller.orderTotal.value) + double.parse(controller.orderTax.value)).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: AppColors.whiteColor,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 100,
              width: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: OptimizedNetworkImage(
                  imageUrl: data.imageUrl != null ? "${Constants.imageBaseUrl}${data.imageUrl}" : AppImages.dummy,
                  fit: BoxFit.contain,
                  width: 100,
                  height: 100,
                ),
              ),
            ),
            SizedBox(width: 2.h),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    data.productName.toString(),
                    fontSize: 15.sp,
                  ),
                  AppText(
                    "\$${data.price.toString()}",
                    fontSize: 15.sp,
                    color: const Color(0XFF44474d),
                  ),
                  AppText(
                    "Taxes: ${data.tax.toString()}%",
                    fontSize: 15.sp,
                    color: const Color(0XFF44474d),
                  ),
                  SizedBox(height: 1.h),
                  Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              controller.isAddedData.value = true;
                              if (double.parse(data.quantity.toString()) > 1) {
                                data.quantity = (double.parse(data.quantity.toString()) - 1).toString();
                              }
                              _recalculateTotals();
                              data.quantity!.isEmpty
                                  ? controller.isWrongData.value = true
                                  : double.parse(data.quantity.toString()) > double.parse(data.stock.toString())
                                      ? controller.isWrongData.value = true
                                      : controller.isWrongData.value = false;
                              controller.update();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withValues(alpha: 0.1),
                                border: Border.all(
                                  color: AppColors.primaryColor.withValues(alpha: 0.5),
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.remove,
                                size: 18,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                          SizedBox(width: 0.3.h),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                controller.quantityText.text = data.quantity.toString();
                                Get.defaultDialog(
                                  title: "Edit Quantity",
                                  barrierDismissible: false,
                                  content: StatefulBuilder(builder: (dialogContext, dialogSetState) {
                                    return SingleChildScrollView(
                                      child: SizedBox(
                                        width: ResponsiveHelper.getDialogWidth(context),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            TextFormField(
                                              style: TextStyle(color: Colors.black, fontSize: 13.sp),
                                              controller: controller.quantityText,
                                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                                              ],
                                              decoration: InputDecoration(
                                                hintText: "Enter Quantity",
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(5),
                                                  borderSide: const BorderSide(color: Color(0xffe9e7ea)),
                                                ),
                                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: AppColors.blackColor)),
                                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: AppColors.blackColor)),
                                                errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: AppColors.blackColor)),
                                                disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: AppColors.blackColor)),
                                              ),
                                              onChanged: (value) {
                                                dialogSetState(() {});
                                              },
                                            ),
                                            SizedBox(height: 0.5.h),
                                            AppText(
                                              controller.quantityText.text.isEmpty ||
                                                      double.tryParse(controller.quantityText.text) == null ||
                                                      double.parse(controller.quantityText.text) <= 0
                                                  ? "Quantity can't be 0"
                                                  : double.tryParse(controller.quantityText.text) != null &&
                                                          double.tryParse(data.stock?.toString() ?? "0") != null &&
                                                          double.parse(controller.quantityText.text) > double.parse(data.stock.toString())
                                                      ? "Quantity can't be greater than In Stock"
                                                      : "",
                                              color: AppColors.darkRedColor,
                                            ),
                                            SizedBox(height: 2.h),
                                            AppButton(
                                              title: "Save",
                                              onTap: () {
                                                controller.isAddedData.value = true;
                                                if (controller.quantityText.text.isEmpty ||
                                                    double.tryParse(controller.quantityText.text) == null ||
                                                    double.parse(controller.quantityText.text) <= 0) {
                                                  controller.isWrongData.value = true;
                                                } else if (double.parse(controller.quantityText.text) > double.parse(data.stock.toString())) {
                                                  controller.isWrongData.value = true;
                                                } else {
                                                  controller.isWrongData.value = false;
                                                }
                                                controller.update();
                                                if (controller.isWrongData.value != true) {
                                                  Get.back(result: controller.quantityText.text);
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
                                    data.quantity = value;
                                    _recalculateTotals();
                                    controller.update();
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
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
                                      data.quantity?.toString() ?? "0",
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 0.3.h),
                          GestureDetector(
                            onTap: () async {
                              controller.isAddedData.value = true;
                              controller.productId.value = await data.productId.toString();
                              controller.productName.value = await data.productName.toString();
                              data.quantity = (double.parse(data.quantity.toString()) + 1).toString();
                              _recalculateTotals();
                              data.quantity!.isEmpty
                                  ? controller.isWrongData.value = true
                                  : double.parse(data.quantity.toString()) > double.parse(data.stock.toString())
                                      ? controller.isWrongData.value = true
                                      : controller.isWrongData.value = false;
                              controller.update();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withValues(alpha: 0.1),
                                border: Border.all(
                                  color: AppColors.primaryColor.withValues(alpha: 0.5),
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 18,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                          SizedBox(width: 0.8.h),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: GestureDetector(
                              onTap: () {
                                controller.quantityText.text = data.quantity.toString();
                                Get.defaultDialog(
                                  title: "Add Quantity",
                                  content: StatefulBuilder(builder: (context, setState) {
                                    return SizedBox(
                                      width: ResponsiveHelper.getDialogWidth(context),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextFormField(
                                            style: TextStyle(color: Colors.black, fontSize: 13.sp),
                                            controller: controller.quantityText,
                                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                                            ],
                                            decoration: InputDecoration(
                                              hintText: "Add Quantity",
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(5),
                                                borderSide: const BorderSide(
                                                  color: Color(0xffe9e7ea),
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: AppColors.blackColor)),
                                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: AppColors.blackColor)),
                                              errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: AppColors.blackColor)),
                                              disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: AppColors.blackColor)),
                                            ),
                                            onChanged: (value) {
                                              controller.quantityText.text.isEmpty
                                                  ? controller.isWrongData.value = true
                                                  : data.isBox == 1
                                                      ? (double.parse(data.boxSize.toString()) * double.parse(controller.quantityText.text)) >
                                                              double.parse(data.stock.toString())
                                                          ? controller.isWrongData.value = true
                                                          : data.isBox == 0
                                                              ? double.parse(controller.quantityText.text) > double.parse(data.stock.toString())
                                                                  ? controller.isWrongData.value = true
                                                                  : ""
                                                              : controller.isWrongData.value = false
                                                      : data.isBox == 0
                                                          ? double.parse(controller.quantityText.text) > double.parse(data.stock.toString())
                                                              ? controller.isWrongData.value = true
                                                              : controller.isWrongData.value = false
                                                          : controller.isWrongData.value = false;
                                              controller.update();
                                              setState(() {});
                                            },
                                          ),
                                          SizedBox(height: 0.5.h),
                                          AppText(
                                            controller.quantityText.text.isEmpty || double.parse(controller.quantityText.text) <= 0
                                                ? "Quantity can't be 0"
                                                : data.isBox == 1
                                                    ? (double.parse(data.boxSize.toString()) * double.parse(controller.quantityText.text.toString())) >
                                                            double.parse(data.stock.toString())
                                                        ? "Quantity can't be greater than In Stock"
                                                        : data.isBox == 0
                                                            ? double.parse(controller.quantityText.text.toString()) > double.parse(data.stock.toString())
                                                                ? "Quantity can't be greater than In Stock"
                                                                : ""
                                                            : ""
                                                    : data.isBox == 0
                                                        ? double.parse(controller.quantityText.text.toString()) > double.parse(data.stock.toString())
                                                            ? "Quantity can't be greater than In Stock"
                                                            : ""
                                                        : "",
                                            color: AppColors.darkRedColor,
                                          ),
                                          SizedBox(height: 2.h),
                                          AppButton(
                                            title: "Save",
                                            onTap: () {
                                              controller.isAddedData.value = true;
                                              controller.update();
                                              if (controller.quantityText.text.isEmpty ||
                                                  controller.isWrongData.value ||
                                                  double.parse(controller.quantityText.text) <= 0) {
                                                return;
                                              }
                                              Get.back(result: controller.quantityText.text);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ).then((value) {
                                  if (value != null) {
                                    data.quantity = value;
                                    _recalculateTotals();
                                    controller.update();
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.primaryColor,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  size: 16,
                                  color: AppColors.tableColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 0.3.h),
                          GestureDetector(
                            onTap: () {
                              final lastIndex = controller.orderItemList.length - 1;
                              if (lastIndex == 0) {
                                showDialog(
                                  context: context,
                                  builder: (dialogContext) {
                                    return DeletePopup(
                                      type: "product",
                                      onTap: () {
                                        controller.deleteCartListAPI(isBack: true);
                                      },
                                    );
                                  },
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (dialogContext) {
                                    return DeletePopup(
                                      type: "product",
                                      onTap: () {
                                        controller.deleteCartAPI(id: data.productId, index: index);
                                      },
                                    );
                                  },
                                );
                              }
                            },
                            child: Image.asset(
                              AppImages.ic_delete,
                              height: 3.5.h,
                              width: 3.5.h,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2, left: 5),
                        child: AppText(
                          data.quantity == null
                              ? "Please Enter Quantity"
                              : double.parse(data.quantity.toString()) > double.parse(data.stock.toString())
                                  ? "Quantity can't be greater than In Stock"
                                  : "",
                          color: AppColors.darkRedColor,
                          maxLines: 2,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
