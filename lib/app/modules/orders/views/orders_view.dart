import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:true_leaf_inventory_app/app/modules/orders/controllers/orders_controller.dart';
import 'package:true_leaf_inventory_app/app/widgets/custom_image.dart';
import '../../../widgets/all_import.dart';

class OrdersView extends GetView<OrdersController> {
  const OrdersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdersController>(
      assignId: true,
      init: OrdersController(),
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.5.h),
            GestureDetector(
              onTap: () {
                if (controller.isProduct.value) {
                  controller.isCategory.value = true;
                  controller.isSubCategory.value = false;
                  controller.isProduct.value = false;
                  controller.getCategoriesAPI(categoryId: "0");
                  controller.update();
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.5.h),
                child: Row(
                  children: [
                    controller.productList.isNotEmpty
                        ? Icon(
                            Icons.arrow_back_ios_sharp,
                            size: 15,
                          )
                        : Container(),
                    SizedBox(width: controller.productList.isNotEmpty ? 1.h : 0),
                    AppText(
                      controller.productList.isNotEmpty
                          ? "Go back to categories"
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
            (controller.categoryList.isEmpty && controller.productList.isEmpty) || (controller.productList.length == 0 && controller.isProduct.value)
                ? Expanded(
                    child: Center(
                      child: AppText(
                        controller.noData.value,
                        fontSize: 13.sp,
                        color: AppColors.greyColor,
                      ),
                    ),
                  )
                : Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1.5.h),
                      child: controller.isProduct.value
                          ? DynamicHeightGridView(
                              itemCount: controller.productList.length,
                              physics: BouncingScrollPhysics(),
                              crossAxisCount: 2,
                              builder: (ctx, index) {
                                return GestureDetector(
                                  onTap: () {
                                    var amount;
                                    var amountTax;

                                    /// add
                                    controller.orderItemList.add(OrderItemResponseData(
                                      productName: controller.productList[index].name.toString(),
                                      product_id: controller.productList[index].id.toString(),
                                      salesPrice: TextEditingController(text: controller.productList[index].sellingPrice.toString()),
                                      stock: TextEditingController(text: controller.productList[index].stock.toString()),
                                      tax: controller.productList[index].tax,
                                      taxId: controller.productList[index].taxId.toString(),
                                      taxData: controller.productList[index].taxDetail!.title,
                                    ));

                                    controller.isSubCategory.value = false;
                                    //
                                    // /// First get index wise amount
                                    // if (controller.orderItemList[index].boxUnit == 1) {
                                    //   amountTax = (((double.parse(controller.orderItemList[index].boxSize.toString()) * double.parse(controller.orderItemList[index].quality!.text)) * double.parse(controller.orderItemList[index].salesPrice!.text)) *
                                    //           double.parse(controller.orderItemList[index].tax.toString())) /
                                    //       100;
                                    //   amount = (double.parse(controller.orderItemList[index].boxSize.toString()) * double.parse(controller.orderItemList[index].quality!.text)) * int.parse(controller.orderItemList[index].salesPrice!.text);
                                    //   controller.orderItemList[index].amountWithoutTax = amount.toString();
                                    //   controller.orderItemList[index].amountOnlyTax = amountTax.toString();
                                    //   controller.orderItemList[index].amount!.text = (amount + amountTax).toString();
                                    // } else {
                                    //   amountTax = ((double.parse(controller.orderItemList[index].quality!.text) * double.parse(controller.orderItemList[index].salesPrice!.text)) * double.parse(controller.orderItemList[index].tax.toString())) / 100;
                                    //   amount = (double.parse(controller.orderItemList[index].quality!.text)) * double.parse(controller.orderItemList[index].salesPrice!.text);
                                    //   controller.orderItemList[index].amountWithoutTax = amount.toString();
                                    //   controller.orderItemList[index].amountOnlyTax = amountTax.toString();
                                    //   controller.orderItemList[index].amount!.text = (amount + amountTax).toString();
                                    // }
                                    //
                                    // /// count order total
                                    //
                                    // for (int i = 0; i < controller.orderItemList.length; i++) {
                                    //   controller.orderTotal.value = (controller.orderItemList.fold<double>(0, (sum, item) => sum + double.parse(item.amountWithoutTax.toString()))).toString();
                                    //   controller.orderTax.value = (controller.orderItemList.fold<double>(0, (sum, item) => sum + double.parse(item.amountOnlyTax.toString()))).toString();
                                    //   controller.orderFinalTotal.value = (double.parse(controller.orderTotal.value) + double.parse(controller.orderTax.value)).toString();
                                    // }

                                    print("controller.orderTotal.value");
                                    print(controller.orderItemList);
                                    print(controller.orderItemList[index]);
                                    print(controller.orderTotal.value);
                                    print(controller.orderTax.value);
                                    print(controller.orderFinalTotal.value);
                                    controller.update();
                                  },
                                  child: Card(
                                      elevation: 3,
                                      color: AppColors.whiteColor,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: Container(
                                              height: 25.h,
                                              child: CustomImageView(
                                                imagePath: controller.productList[index].imageUrl != null ? "${Constants.imageBaseUrl}${controller.productList[index].imageUrl}" : AppImages.dummy,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 1.h),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 1.5.h),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                AppText(
                                                  controller.productList[index].name.toString(),
                                                  maxLines: 10,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13.sp,
                                                  color: AppColors.primaryColor,
                                                ),
                                                SizedBox(height: 0.5.h),
                                                Row(
                                                  children: [
                                                    AppText(
                                                      "\$ ",
                                                      maxLines: 10,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 12.sp,
                                                      color: Color(0XFF44474d),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 1.5.h, vertical: 2),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        border: Border.all(
                                                          color: Color(0xffe9e7ea),
                                                        ),
                                                      ),
                                                      child: AppText(
                                                        "${controller.productList[index].sellingPrice.toString()}",
                                                        maxLines: 10,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 12.sp,
                                                        color: Color(0XFF44474d),
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Image.asset(
                                                      AppImages.ic_stock,
                                                      scale: 3.8,
                                                    ),
                                                    SizedBox(width: 1.h),
                                                    AppText(
                                                      "${controller.productList[index].stock.toString()}",
                                                      maxLines: 10,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 12.sp,
                                                      color: Color(0XFF44474d),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 0.5.h),
                                                AppText(
                                                  "Taxes: ${controller.productList[index].taxDetail?.tax.toString()}%",
                                                  maxLines: 10,
                                                  fontSize: 12.sp,
                                                  color: Color(0XFF44474d),
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
                                                            controller.update();
                                                            controller.orderItemList.add(OrderItemResponseData(
                                                              boxUnit: controller.productList[index].isUnitSelected,
                                                            ));
                                                            print(controller.orderItemList.length);
                                                            print("controller.orderItemList[0].boxUnit");

                                                            /// Counting
                                                            // var amount;
                                                            // var amountTax;
                                                            //
                                                            // /// First get index wise amount
                                                            //
                                                            // if (controller.orderItemList[index].boxUnit == 1) {
                                                            //   amountTax = (((double.parse(controller.orderItemList[index].boxSize.toString()) * double.parse(controller.orderItemList[index].quality!.text)) *
                                                            //               double.parse(controller.orderItemList[index].salesPrice!.text)) *
                                                            //           double.parse(controller.orderItemList[index].tax.toString())) /
                                                            //       100;
                                                            //   amount = (double.parse(controller.orderItemList[index].boxSize.toString()) * double.parse(controller.orderItemList[index].quality!.text)) *
                                                            //       double.parse(controller.orderItemList[index].salesPrice!.text);
                                                            //   controller.orderItemList[index].amountWithoutTax = amount.toString();
                                                            //   controller.orderItemList[index].amountOnlyTax = amountTax.toString();
                                                            //   controller.orderItemList[index].amount!.text = (amount + amountTax).toString();
                                                            // } else {
                                                            //   amountTax = ((double.parse(controller.orderItemList[index].quality!.text) * double.parse(controller.orderItemList[index].salesPrice!.text)) *
                                                            //           double.parse(controller.orderItemList[index].tax.toString())) /
                                                            //       100;
                                                            //   amount = (double.parse(controller.orderItemList[index].quality!.text)) * double.parse(controller.orderItemList[index].salesPrice!.text);
                                                            //   controller.orderItemList[index].amountWithoutTax = amount.toString();
                                                            //   controller.orderItemList[index].amountOnlyTax = amountTax.toString();
                                                            //   controller.orderItemList[index].amount!.text = (amount + amountTax).toString();
                                                            // }
                                                            //
                                                            // /// count order total
                                                            //
                                                            // for (int i = 0; i < controller.orderItemList.length; i++) {
                                                            //   controller.orderTotal.value = (controller.orderItemList.fold<double>(0, (sum, item) => sum + double.parse(item.amountWithoutTax.toString()))).toString();
                                                            //   controller.orderTax.value = (controller.orderItemList.fold<double>(0, (sum, item) => sum + double.parse(item.amountOnlyTax.toString()))).toString();
                                                            //   controller.orderFinalTotal.value = (double.parse(controller.orderTotal.value) + double.parse(controller.orderTax.value)).toString();
                                                            // }
                                                            controller.update();
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                height: 15,
                                                                width: 15,
                                                                padding: EdgeInsets.all(1.5),
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
                                                              SizedBox(width: 10),
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
                                                ),
                                                SizedBox(height: 1.h),
                                                Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (int.parse(controller.productList[index].quantityCount!.text) > 0) {
                                                          controller.productList[index].quantityCount!.text = (int.parse(controller.productList[index].quantityCount!.text) - 1).toString();
                                                        }
                                                        controller.update();
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
                                                    Expanded(
                                                      child: TextFormField(
                                                        readOnly: controller.productList[index].isEdit ? false : true,
                                                        style: TextStyle(color: Colors.black, fontSize: 13.sp),
                                                        controller: controller.productList[index].quantityCount,
                                                        keyboardType: TextInputType.number,
                                                        decoration: InputDecoration(
                                                          border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(5),
                                                              borderSide: BorderSide(
                                                                color: Color(0xffe9e7ea),
                                                              )),
                                                          focusedBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(5),
                                                              borderSide: BorderSide(
                                                                color: Color(0xffe9e7ea),
                                                              )),
                                                          enabledBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(5),
                                                              borderSide: BorderSide(
                                                                color: Color(0xffe9e7ea),
                                                              )),
                                                          errorBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(5),
                                                              borderSide: BorderSide(
                                                                color: Color(0xffe9e7ea),
                                                              )),
                                                          disabledBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(5),
                                                              borderSide: BorderSide(
                                                                color: Color(0xffe9e7ea),
                                                              )),
                                                        ),
                                                        onChanged: (value) {
                                                          controller.update();
                                                          var amount;
                                                          var amountTax;
                                                          print(value);
                                                          print("valuevaluevaluevaluevalue");
                                                          if (value.isNotEmpty) {
                                                            print(controller.orderItemList[index].boxUnit);
                                                            print(controller.productList[index].boxSize);
                                                            print(controller.productList[index].quantityCount!.text);
                                                            print(controller.productList[index].sellingPrice);
                                                            print(controller.productList[index].taxDetail!.tax);
                                                            print("controller.orderItemList[index].boxUnit");

                                                            /// First get index wise amount
                                                            if (controller.orderItemList[index].boxUnit == 1) {
                                                              amountTax = (((double.parse(controller.productList[index].boxSize.toString()) * double.parse(controller.productList[index].quantityCount!.text)) *
                                                                          double.parse(controller.productList[index].sellingPrice.toString())) *
                                                                      double.parse(controller.productList[index].taxDetail!.tax.toString())) /
                                                                  100;
                                                              amount = (double.parse(controller.productList[index].boxSize.toString()) * double.parse(controller.productList[index].quantityCount!.text)) *
                                                                  int.parse(controller.productList[index].sellingPrice.toString());
                                                              controller.orderItemList[index].amountWithoutTax = amount.toString();
                                                              controller.orderItemList[index].amountOnlyTax = amountTax.toString();
                                                            } else {
                                                              amountTax = ((double.parse(controller.productList[index].quantityCount!.text) * double.parse(controller.productList[index].sellingPrice.toString())) *
                                                                      double.parse(controller.productList[index].taxDetail!.tax.toString())) /
                                                                  100;
                                                              amount = (double.parse(controller.productList[index].quantityCount!.text)) * double.parse(controller.productList[index].sellingPrice.toString());
                                                              controller.orderItemList[index].amountWithoutTax = amount.toString();
                                                              controller.orderItemList[index].amountOnlyTax = amountTax.toString();
                                                            }

                                                            /// count order total
                                                            print(controller.orderItemList.length);
                                                            print("controller.orderItemList.length");
                                                            // for (int i = 0; i < controller.orderItemList.length; i++) {
                                                            //   controller.orderTotal.value = (controller.orderItemList.fold<double>(0, (sum, item) => sum + double.parse(item.amountWithoutTax.toString()))).toString();
                                                            //   controller.orderTax.value = (controller.orderItemList.fold<double>(0, (sum, item) => sum + double.parse(item.amountOnlyTax.toString()))).toString();
                                                            //   controller.orderFinalTotal.value = (double.parse(controller.orderTotal.value) + double.parse(controller.orderTax.value)).toString();
                                                            // }
                                                            controller.update();
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(width: 1.h),
                                                    GestureDetector(
                                                      onTap: () {
                                                        controller.productList[index].quantityCount!.text = (int.parse(controller.productList[index].quantityCount!.text) + 1).toString();
                                                        controller.update();
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                          color: Color(0xffe0e2ea),
                                                          shape: BoxShape.circle,
                                                        ),
                                                        child: Icon(
                                                          Icons.add,
                                                          size: 15,
                                                          color: AppColors.tableColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(top: 2, left: 5),
                                                  child: AppText(
                                                    controller.productList[index].quantityCount!.text.isEmpty
                                                        ? "Please Enter Quantity"
                                                        : controller.orderItemList[index].boxUnit == 1
                                                            ? (double.parse(controller.productList[index].boxSize.toString()) * double.parse(controller.productList[index].quantityCount!.text)) >
                                                                    double.parse(controller.productList[index].stock.toString())
                                                                ? "Quantity can't be greater than In Stock"
                                                                : controller.orderItemList[index].boxUnit == 0
                                                                    ? double.parse(controller.productList[index].quantityCount!.text) > double.parse(controller.productList[index].stock.toString())
                                                                        ? "Quantity can't be greater than In Stock"
                                                                        : ""
                                                                    : ""
                                                            : controller.orderItemList[index].boxUnit == 0
                                                                ? double.parse(controller.productList[index].quantityCount!.text) > double.parse(controller.productList[index].stock.toString())
                                                                    ? "Quantity can't be greater than In Stock"
                                                                    : ""
                                                                : "",
                                                    color: AppColors.darkRedColor,
                                                    fontSize: 10.sp,
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.bottomRight,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      controller.productList[index].isEdit = true;
                                                      controller.update();
                                                    },
                                                    child: Icon(
                                                      Icons.edit,
                                                      size: 18,
                                                      color: AppColors.tableColor,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 1.h),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 1.h),
                                        ],
                                      )),
                                );
                              },
                            )
                          : DynamicHeightGridView(
                              itemCount: controller.categoryList.length,
                              physics: BouncingScrollPhysics(),
                              crossAxisCount: 2,
                              builder: (ctx, index) {
                                return GestureDetector(
                                  onTap: () {
                                    if (controller.isSubCategory.value) {
                                      controller.orderItemList.add(OrderItemResponseData(
                                        subCategoryName: controller.categoryList[index].name.toString(),
                                        sub_category_id: controller.categoryList[index].id.toString(),
                                      ));
                                      controller.getProduct(subCategoryId: controller.categoryList[index].id, type: "subCategory");
                                    } else {
                                      controller.isSubCategory.value = true;
                                      controller.categoryName.value = controller.categoryList[index].name.toString();
                                      controller.orderItemList.add(OrderItemResponseData(
                                        categoryName: controller.categoryList[index].name.toString(),
                                        category_id: controller.categoryList[index].id.toString(),
                                      ));
                                      controller.getCategoriesAPI(categoryId: controller.categoryList[index].id);
                                    }
                                    controller.update();
                                  },
                                  child: Card(
                                      elevation: 3,
                                      color: AppColors.whiteColor,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: Container(
                                              height: 25.h,
                                              child: CustomImageView(
                                                imagePath: controller.categoryList[index].imageUrl != null ? "${Constants.imageBaseUrl}${controller.categoryList[index].imageUrl}" : AppImages.dummy,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 1.h),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 1.5.h),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: AppText(
                                                    controller.categoryList[index].name.toString(),
                                                    maxLines: 10,
                                                    fontSize: 12.sp,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.arrow_forward,
                                                  color: AppColors.arrowColor,
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
                            ),
                    ),
                  )
          ],
        );
      },
    );
  }
}
