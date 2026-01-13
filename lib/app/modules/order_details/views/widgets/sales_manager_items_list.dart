import 'package:true_leaf_inventory_app/app/modules/order_details/controllers/order_details_controller.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';
import 'package:true_leaf_inventory_app/app/widgets/app_button.dart';

class SalesManagerItemsList extends StatelessWidget {
  final OrderDetailsController controller;

  const SalesManagerItemsList({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSalesManager = controller.loginData?.roles?[0].title == "Sales Manager";
    if (!isSalesManager || controller.orderItem.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.h),
          child: Row(
            children: [
              const Icon(
                Icons.shopping_cart_outlined,
                size: 20,
                color: AppColors.primaryColor,
              ),
              const SizedBox(width: 8),
              AppText(
                "Order Items",
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.1),
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
        const SizedBox(height: 12),
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
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: OptimizedNetworkImage(
                        imageUrl: controller.orderItem[index].imageUrl != null
                            ? "${Constants.imageBaseUrl}${controller.orderItem[index].imageUrl}"
                            : AppImages.dummy,
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
                          controller.orderItem[index].name.toString(),
                          fontSize: 15.sp,
                        ),
                        if (controller.orderItem[index].descriptionInvoice != null &&
                            controller.orderItem[index].descriptionInvoice!.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: 0.5.h),
                            child: AppText(
                              controller.orderItem[index].descriptionInvoice.toString(),
                              fontSize: 11.sp,
                              color: Colors.grey[600],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        GestureDetector(
                          onTap: () {
                            controller.sellingPriceText.text =
                                controller.orderItem[index].salePrice.toString();
                            Get.defaultDialog(
                              title: "Edit Price",
                              content: StatefulBuilder(
                                builder: (context, setState) {
                                  return SizedBox(
                                    width: 200,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextFormField(
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13.sp,
                                          ),
                                          controller: controller.sellingPriceText,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            hintText: "Edit Price",
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(5),
                                              borderSide: const BorderSide(color: Color(0xffe9e7ea)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(5),
                                              borderSide: const BorderSide(color: AppColors.blackColor),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(5),
                                              borderSide: const BorderSide(color: AppColors.blackColor),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(5),
                                              borderSide: const BorderSide(color: AppColors.blackColor),
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(5),
                                              borderSide: const BorderSide(color: AppColors.blackColor),
                                            ),
                                          ),
                                          onChanged: (value) {
                                            controller.update();
                                            setState(() {});
                                          },
                                        ),
                                        SizedBox(height: 0.5.h),
                                        if (controller.orderItem[index].isBox == "1" ||
                                            controller.orderItem[index].isBox == 1)
                                          AppText(
                                            controller.sellingPriceText.text.isEmpty
                                                ? "Sales Price can't be 0"
                                                : double.parse(controller.sellingPriceText.text) <
                                                        double.parse(controller.orderItem[index].sellingPrice.toString())
                                                    ? "Sales Price can't be less than Min Selling Price"
                                                    : "",
                                            fontSize: 11.sp,
                                            color: AppColors.darkRedColor,
                                          ),
                                        if (controller.orderItem[index].isBox == "0" ||
                                            controller.orderItem[index].isBox == 0)
                                          AppText(
                                            controller.sellingPriceText.text.isEmpty ||
                                                    double.parse(controller.sellingPriceText.text) == 0
                                                ? "Sales Price can't be 0"
                                                : "",
                                            fontSize: 11.sp,
                                            color: AppColors.darkRedColor,
                                          ),
                                        SizedBox(height: 2.h),
                                        AppButton(
                                          title: "Save",
                                          onTap: () {
                                            if (controller.orderItem[index].isBox == "1" ||
                                                controller.orderItem[index].isBox == 1) {
                                              if (double.parse(controller.sellingPriceText.text) <
                                                  double.parse(controller.orderItem[index].sellingPrice.toString())) {
                                                return;
                                              }
                                              Get.back(result: controller.sellingPriceText.text);
                                              controller.update();
                                            } else {
                                              if (controller.sellingPriceText.text.isEmpty ||
                                                  double.parse(controller.sellingPriceText.text) == 0) {
                                                return;
                                              }
                                              Get.back(result: controller.sellingPriceText.text);
                                              controller.update();
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ).then((value) {
                              if (value != null) {
                                var amountTax;
                                var amount;
                                controller.orderItem[index].salePrice = value;
                                amountTax = ((double.parse(controller.orderItem[index].quantityCount.toString()) *
                                            double.parse(controller.orderItem[index].salePrice.toString())) *
                                        double.parse(controller.orderItem[index].tax.toString())) /
                                    100;
                                amount = double.parse(controller.orderItem[index].quantityCount!.toString()) *
                                    double.parse(controller.orderItem[index].salePrice.toString());
                                controller.orderItem[index].amountWithoutTax = amount.toString();
                                controller.orderItem[index].amountOnlyTax = amountTax.toString();
                                controller.orderItem[index].finalAmount = (amount + amountTax).toString();
                                controller.update();
                                controller.getDetailsData!.orderTotalWithoutTax = (controller.orderItem.fold<double>(
                                        0,
                                        (sum, item) =>
                                            sum + double.parse(item.amountWithoutTax.toString())))
                                    .toString();
                                controller.getDetailsData!.orderTax = (controller.orderItem.fold<double>(
                                        0,
                                        (sum, item) =>
                                            sum + double.parse(item.amountOnlyTax.toString())))
                                    .toString();
                                controller.getDetailsData!.orderTotal = (double.parse(controller.getDetailsData!.orderTotalWithoutTax) +
                                        double.parse(controller.getDetailsData!.orderTax))
                                    .toString();
                                controller.update();
                              }
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 1.5.h, vertical: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: const Color(0xffe9e7ea),
                              ),
                            ),
                            child: AppText(
                              "\$${controller.orderItem[index].salePrice.toString()}",
                              fontSize: 15.sp,
                              color: const Color(0XFF44474d),
                            ),
                          ),
                        ),
                        AppText(
                          "Taxes: ${controller.orderItem[index].tax.toString()}%",
                          fontSize: 15.sp,
                          color: const Color(0XFF44474d),
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                var amountTax;
                                var amount;
                                final homeController = Get.find<HomeController>();
                                if (homeController.isOrderDetails.value && homeController.isOrderEdit.value) {
                                  if (double.parse(controller.orderItem[index].quantityCount.toString()) > 0.5) {
                                    controller.orderItem[index].quantityCount =
                                        (double.parse(controller.orderItem[index].quantityCount.toString()) - 0.5)
                                            .toString();
                                  }
                                  amountTax = ((double.parse(controller.orderItem[index].quantityCount.toString()) *
                                              double.parse(controller.orderItem[index].salePrice.toString())) *
                                          double.parse(controller.orderItem[index].tax.toString())) /
                                      100;
                                  amount = double.parse(controller.orderItem[index].quantityCount!.toString()) *
                                      double.parse(controller.orderItem[index].salePrice.toString());
                                  controller.orderItem[index].amountWithoutTax = amount.toString();
                                  controller.orderItem[index].amountOnlyTax = amountTax.toString();
                                  controller.orderItem[index].finalAmount = (amount + amountTax).toString();
                                  controller.update();
                                  controller.getDetailsData!.orderTotalWithoutTax = (controller.orderItem.fold<double>(
                                          0,
                                          (sum, item) =>
                                              sum + double.parse(item.amountWithoutTax.toString())))
                                      .toString();
                                  controller.getDetailsData!.orderTax = (controller.orderItem.fold<double>(
                                          0,
                                          (sum, item) =>
                                              sum + double.parse(item.amountOnlyTax.toString())))
                                      .toString();
                                  controller.getDetailsData!.orderTotal = (double.parse(controller.getDetailsData!.orderTotalWithoutTax) +
                                          double.parse(controller.getDetailsData!.orderTax))
                                      .toString();
                                  controller.orderItem[index].quantityCount!.isEmpty
                                      ? controller.isWrongData.value = true
                                      : controller.orderItem[index].isUnitSelected == 1
                                          ? (double.parse(controller.orderItem[index].boxSize.toString()) *
                                                      double.parse(controller.orderItem[index].quantityCount!)) >
                                                  double.parse(controller.orderItem[index].stock.toString())
                                              ? controller.isWrongData.value = true
                                              : controller.orderItem[index].isUnitSelected == 0
                                                  ? double.parse(controller.orderItem[index].quantityCount!.text) >
                                                          double.parse(controller.orderItem[index].stock.toString())
                                                      ? controller.isWrongData.value = true
                                                      : ""
                                                  : controller.isWrongData.value = false
                                          : controller.orderItem[index].isUnitSelected == 0
                                              ? double.parse(controller.orderItem[index].quantityCount!) >
                                                      double.parse(controller.orderItem[index].stock.toString())
                                                  ? controller.isWrongData.value = true
                                                  : ""
                                              : controller.isWrongData.value = false;
                                  controller.update();
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
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
                                  size: 20,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                            SizedBox(width: 0.5.h),
                            Expanded(
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
                                child: Center(
                                  child: AppText(
                                    controller.orderItem[index].quantityCount.toString(),
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 0.5.h),
                            GestureDetector(
                              onTap: () async {
                                var amountTax;
                                var amount;
                                final homeController = Get.find<HomeController>();
                                if (homeController.isOrderDetails.value && homeController.isOrderEdit.value) {
                                  controller.orderItem[index].quantityCount =
                                      (double.parse(controller.orderItem[index].quantityCount.toString()) + 0.5)
                                          .toString();
                                  amountTax = ((double.parse(controller.orderItem[index].quantityCount.toString()) *
                                              double.parse(controller.orderItem[index].salePrice.toString())) *
                                          double.parse(controller.orderItem[index].tax.toString())) /
                                      100;
                                  amount = double.parse(controller.orderItem[index].quantityCount!.toString()) *
                                      double.parse(controller.orderItem[index].salePrice.toString());
                                  controller.orderItem[index].amountWithoutTax = amount.toString();
                                  controller.orderItem[index].amountOnlyTax = amountTax.toString();
                                  controller.orderItem[index].finalAmount = (amount + amountTax).toString();
                                  controller.update();
                                  controller.getDetailsData!.orderTotalWithoutTax = (controller.orderItem.fold<double>(
                                          0,
                                          (sum, item) =>
                                              sum + double.parse(item.amountWithoutTax.toString())))
                                      .toString();
                                  controller.getDetailsData!.orderTax = (controller.orderItem.fold<double>(
                                          0,
                                          (sum, item) =>
                                              sum + double.parse(item.amountOnlyTax.toString())))
                                      .toString();
                                  controller.getDetailsData!.orderTotal = (double.parse(controller.getDetailsData!.orderTotalWithoutTax) +
                                          double.parse(controller.getDetailsData!.orderTax))
                                      .toString();
                                  controller.orderItem[index].quantityCount.isEmpty
                                      ? controller.isWrongData.value = true
                                      : controller.orderItem[index].isUnitSelected == 1
                                          ? (double.parse(controller.orderItem[index].boxSize.toString()) *
                                                      double.parse(controller.orderItem[index].quantityCount!)) >
                                                  double.parse(controller.orderItem[index].stock.toString())
                                              ? controller.isWrongData.value = true
                                              : controller.orderItem[index].isUnitSelected == 0
                                                  ? double.parse(controller.orderItem[index].quantityCount) >
                                                          double.parse(controller.orderItem[index].stock.toString())
                                                      ? controller.isWrongData.value = true
                                                      : ""
                                                  : controller.isWrongData.value = false
                                          : controller.orderItem[index].isUnitSelected == 0
                                              ? double.parse(controller.orderItem[index].quantityCount) >
                                                      double.parse(controller.orderItem[index].stock.toString())
                                                  ? controller.isWrongData.value = true
                                                  : ""
                                              : controller.isWrongData.value = false;
                                  controller.update();
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
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
                                  size: 20,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Get.find<HomeController>().isOrderDetails.value &&
                                    Get.find<HomeController>().isOrderEdit.value
                                ? GestureDetector(
                                    onTap: () {
                                      controller.deleteProduct(index: index);
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
