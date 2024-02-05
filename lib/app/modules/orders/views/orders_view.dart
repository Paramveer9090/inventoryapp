import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
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
                  controller.isSubCategory.value = false;
                  controller.isCategory.value = true;
                  controller.getCategoriesAPI(categoryId: "0");
                  controller.update();
                }
                if (controller.isProduct.value) {
                  if (controller.isAddedData.value) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return DeletePopup(
                          isDelete: true,
                          isConfirmation: true,
                          confirmationText: "You don't save your data",
                          onTap: () {
                            Get.back();
                            controller.isAddedData.value = false;
                            controller.isCategory.value = true;
                            controller.isSubCategory.value = false;
                            controller.isProduct.value = false;
                            controller.getCategoriesAPI(categoryId: "0");
                            controller.update();
                          },
                        );
                      },
                    );
                  } else {
                    controller.isCategory.value = true;
                    controller.isSubCategory.value = false;
                    controller.isProduct.value = false;
                    controller.getCategoriesAPI(categoryId: "0");
                    controller.update();
                  }
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.5.h),
                child: Row(
                  children: [
                    controller.productList.isNotEmpty || controller.isSubCategory.value
                        ? Icon(
                            Icons.arrow_back_ios_sharp,
                            size: 15,
                          )
                        : Container(),
                    SizedBox(width: controller.productList.isNotEmpty || controller.isSubCategory.value ? 1.h : 0),
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
                          ? Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 70),
                                  child: DynamicHeightGridView(
                                    // shrinkWrap: true,
                                    itemCount: controller.productList.length,
                                    physics: BouncingScrollPhysics(),
                                    crossAxisCount: /*orientation == Orientation.portrait ? 2 :*/ 2,
                                    builder: (ctx, index) {
                                      return Card(
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
                                                        GestureDetector(
                                                          onTap: () {
                                                            controller.sellingPriceText.text = controller.productList[index].sellingPrice.toString();
                                                            Get.defaultDialog(
                                                              title: "Edit Price",
                                                              content: StatefulBuilder(builder: (context, setState) {
                                                                return Container(
                                                                  width: 200,
                                                                  child: Column(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      TextFormField(
                                                                        style: TextStyle(color: Colors.black, fontSize: 13.sp),
                                                                        controller: controller.sellingPriceText,
                                                                        keyboardType: TextInputType.number,
                                                                        decoration: InputDecoration(
                                                                          hintText: "Edit Price",
                                                                          border: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(5),
                                                                              borderSide: BorderSide(
                                                                                color: Color(0xffe9e7ea),
                                                                              )),
                                                                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: AppColors.blackColor)),
                                                                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: AppColors.blackColor)),
                                                                          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: AppColors.blackColor)),
                                                                          disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: AppColors.blackColor)),
                                                                        ),
                                                                        onChanged: (value) {
                                                                          controller.update();
                                                                          setState(() {});
                                                                          print(controller.productList[index].isUnitSelected);
                                                                          print("controller.productList[index].isBox");
                                                                        },
                                                                      ),
                                                                      SizedBox(height: 0.5.h),
                                                                      if (controller.productList[index].isUnitSelected == "1" || controller.productList[index].isUnitSelected == 1)
                                                                        AppText(
                                                                          double.parse(controller.sellingPriceText.text) < double.parse(controller.productList[index].sellingPrice.toString()) ? "Sales Price can't be less than Min Selling Price" : "",
                                                                          fontSize: 11.sp,
                                                                          color: AppColors.darkRedColor,
                                                                        ),
                                                                      if (controller.productList[index].isUnitSelected == "0" || controller.productList[index].isUnitSelected == 0)
                                                                        AppText(
                                                                          controller.sellingPriceText.text.isEmpty || double.parse(controller.sellingPriceText.text) == 0 ? "Sales Price can't be 0" : "",
                                                                          fontSize: 11.sp,
                                                                          color: AppColors.darkRedColor,
                                                                        ),
                                                                      SizedBox(height: 2.h),
                                                                      AppButton(
                                                                          title: "Save",
                                                                          onTap: () {
                                                                            if (controller.productList[index].isUnitSelected == "1" || controller.productList[index].isUnitSelected == 1) {
                                                                              if (double.parse(controller.sellingPriceText.text) < double.parse(controller.productList[index].sellingPrice.toString())) {
                                                                              } else {
                                                                                Get.back(result: controller.sellingPriceText.text);
                                                                                controller.update();
                                                                              }
                                                                            } else {
                                                                              if (controller.sellingPriceText.text.isEmpty || double.parse(controller.sellingPriceText.text) == 0) {
                                                                              } else {
                                                                                Get.back(result: controller.sellingPriceText.text);
                                                                                controller.update();
                                                                              }
                                                                            }
                                                                          }),
                                                                    ],
                                                                  ),
                                                                );
                                                              }),
                                                            ).then((value) {
                                                              if (value != null) {
                                                                print("value not null");
                                                                controller.productList[index].sellingPrice = value;
                                                                print(controller.productList[index].sellingPrice);
                                                                controller.update();
                                                              } else {
                                                                print("value are null");
                                                              }
                                                            });
                                                          },
                                                          child: Container(
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
                                                                controller.isAddedData.value = true;
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
                                                            controller.isAddedData.value = true;
                                                            if (int.parse(controller.productList[index].quantityCount!) > 0) {
                                                              controller.productList[index].quantityCount = (int.parse(controller.productList[index].quantityCount!) - 1).toString();
                                                            }
                                                            for (int i = 0; i < controller.productList.length; i++) {
                                                              if (controller.productList[i].quantityCount != "0") {
                                                                controller.isAddToCartButton.value = true;
                                                                break;
                                                              } else {
                                                                controller.isAddToCartButton.value = false;
                                                              }
                                                            }
                                                            print("controller.isAddToCartButton.value");
                                                            print(controller.isAddToCartButton.value);

                                                            controller.productList[index].quantityCount!.isEmpty
                                                                ? controller.isWrongData.value = true
                                                                : controller.productList[index].isUnitSelected == 1
                                                                    ? (double.parse(controller.productList[index].boxSize.toString()) * double.parse(controller.productList[index].quantityCount!)) > double.parse(controller.productList[index].stock.toString())
                                                                        ? controller.isWrongData.value = true
                                                                        : controller.productList[index].isUnitSelected == 0
                                                                            ? double.parse(controller.productList[index].quantityCount!.text) > double.parse(controller.productList[index].stock.toString())
                                                                                ? controller.isWrongData.value = true
                                                                                : ""
                                                                            : controller.isWrongData.value = false
                                                                    : controller.productList[index].isUnitSelected == 0
                                                                        ? double.parse(controller.productList[index].quantityCount!) > double.parse(controller.productList[index].stock.toString())
                                                                            ? controller.isWrongData.value = true
                                                                            : ""
                                                                        : controller.isWrongData.value = false;
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
                                                            child: Center(
                                                          child: AppText(controller.productList[index].quantityCount),
                                                        )),
                                                        SizedBox(width: 1.h),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            controller.isAddedData.value = true;
                                                            controller.productId.value = await controller.productList[index].id.toString();
                                                            controller.productName.value = await controller.productList[index].name.toString();
                                                            controller.productList[index].quantityCount = await (int.parse(controller.productList[index].quantityCount) + 1).toString();
                                                            for (int i = 0; i < controller.productList.length; i++) {
                                                              print("controller.productList[i].quantityCount");
                                                              print(controller.productList[i].quantityCount);
                                                              if (controller.productList[i].quantityCount != "0") {
                                                                controller.isAddToCartButton.value = true;
                                                                break;
                                                              } else {
                                                                controller.isAddToCartButton.value = false;
                                                              }
                                                            }
                                                            print("controller.isAddToCartButton.value");
                                                            print(controller.isAddToCartButton.value);

                                                            ///
                                                            controller.productList[index].quantityCount.isEmpty
                                                                ? controller.isWrongData.value = true
                                                                : controller.productList[index].isUnitSelected == 1
                                                                    ? (double.parse(controller.productList[index].boxSize.toString()) * double.parse(controller.productList[index].quantityCount!)) > double.parse(controller.productList[index].stock.toString())
                                                                        ? controller.isWrongData.value = true
                                                                        : controller.productList[index].isUnitSelected == 0
                                                                            ? double.parse(controller.productList[index].quantityCount) > double.parse(controller.productList[index].stock.toString())
                                                                                ? controller.isWrongData.value = true
                                                                                : ""
                                                                            : controller.isWrongData.value = false
                                                                    : controller.productList[index].isUnitSelected == 0
                                                                        ? double.parse(controller.productList[index].quantityCount) > double.parse(controller.productList[index].stock.toString())
                                                                            ? controller.isWrongData.value = true
                                                                            : ""
                                                                        : controller.isWrongData.value = false;
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
                                                        controller.productList[index].quantityCount.isEmpty
                                                            ? "Please Enter Quantity"
                                                            : controller.productList[index].isUnitSelected == 1
                                                                ? (double.parse(controller.productList[index].boxSize.toString()) * double.parse(controller.productList[index].quantityCount!)) > double.parse(controller.productList[index].stock.toString())
                                                                    ? "Quantity can't be greater than In Stock"
                                                                    : controller.productList[index].isUnitSelected == 0
                                                                        ? double.parse(controller.productList[index].quantityCount) > double.parse(controller.productList[index].stock.toString())
                                                                            ? "Quantity can't be greater than In Stock"
                                                                            : ""
                                                                        : ""
                                                                : controller.productList[index].isUnitSelected == 0
                                                                    ? double.parse(controller.productList[index].quantityCount) > double.parse(controller.productList[index].stock.toString())
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
                                                          Get.defaultDialog(
                                                            title: "Add Quantity",
                                                            content: Container(
                                                              width: 200,
                                                              child: Column(
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: [
                                                                  TextFormField(
                                                                    style: TextStyle(color: Colors.black, fontSize: 13.sp),
                                                                    controller: controller.quantityText,
                                                                    keyboardType: TextInputType.number,
                                                                    decoration: InputDecoration(
                                                                      hintText: "Add Quantity",
                                                                      border: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(5),
                                                                          borderSide: BorderSide(
                                                                            color: Color(0xffe9e7ea),
                                                                          )),
                                                                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: AppColors.blackColor)),
                                                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: AppColors.blackColor)),
                                                                      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: AppColors.blackColor)),
                                                                      disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: AppColors.blackColor)),
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 2.h),
                                                                  AppButton(
                                                                      title: "Save",
                                                                      onTap: () {
                                                                        controller.isAddedData.value = true;
                                                                        controller.quantityText.text.isEmpty
                                                                            ? controller.isWrongData.value = true
                                                                            : controller.productList[index].isUnitSelected == 1
                                                                                ? (double.parse(controller.productList[index].boxSize.toString()) * double.parse(controller.quantityText.text)) > double.parse(controller.productList[index].stock.toString())
                                                                                    ? controller.isWrongData.value = true
                                                                                    : controller.productList[index].isUnitSelected == 0
                                                                                        ? double.parse(controller.quantityText.text) > double.parse(controller.productList[index].stock.toString())
                                                                                            ? controller.isWrongData.value = true
                                                                                            : ""
                                                                                        : controller.isWrongData.value = false
                                                                                : controller.productList[index].isUnitSelected == 0
                                                                                    ? double.parse(controller.quantityText.text) > double.parse(controller.productList[index].stock.toString())
                                                                                        ? controller.isWrongData.value = true
                                                                                        : controller.isWrongData.value = false
                                                                                    : controller.isWrongData.value = false;
                                                                        controller.update();
                                                                        Get.back(result: controller.quantityText.text);
                                                                      }),
                                                                ],
                                                              ),
                                                            ),
                                                          ).then((value) {
                                                            print(value);
                                                            if (value != null) {
                                                              controller.productList[index].quantityCount = value;
                                                              controller.update();
                                                            }
                                                          });
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
                                          ));
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  child: SizedBox(
                                    height: 50,
                                    child: Get.find<HomeController>().isOrderEdit.value
                                        ? AppButton(
                                            title: "Add Product",
                                            onTap: () {
                                              print("add product thy 6e");
                                              print(orderId);
                                              if (orderId.isNotEmpty) {
                                                controller.editOrderAPI();
                                              }
                                            },
                                          )
                                        : controller.isAddToCartButton.value
                                            ? AppButton(
                                                title: "Add to cart",
                                                onTap: () {
                                                  if (controller.isWrongData.value == false) {
                                                    controller.addToCartAPI();
                                                  }
                                                },
                                              )
                                            : Container(),
                                  ),
                                ),
                              ],
                            )
                          : OrientationBuilder(
                              builder: (BuildContext context, Orientation orientation) {
                                return DynamicHeightGridView(
                                  itemCount: controller.categoryList.length,
                                  physics: BouncingScrollPhysics(),
                                  crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
                                  builder: (ctx, index) {
                                    return GestureDetector(
                                      onTap: () async {
                                        if (controller.isSubCategory.value) {
                                          controller.subCategoryName.value = await controller.categoryList[index].name.toString();
                                          controller.subCategoryId.value = await controller.categoryList[index].id.toString();

                                          controller.getProduct(subCategoryId: controller.categoryList[index].id, type: "subCategory");
                                        } else {
                                          controller.isSubCategory.value = true;
                                          controller.categoryName.value = await controller.categoryList[index].name.toString();
                                          controller.categoryId.value = await controller.categoryList[index].id.toString();
                                          print("sub category api call");
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

/*AppButton(
                                      title: "Add to cart",
                                      /*onTap: () async {
                                        await getStorageData.removeData("cartValueList");
                                        utils.showSnackBar(context: context, message: "data clear");
                                        controller.update();
                                      },*/
                                      onTap: () async {
                                        List<GetDataListResponseData> cartList = [];
                                        if (getStorageData.readObject("cartValueList") != null) {
                                          print("not null value");
                                          List jsonDataList = await getStorageData.readObject("cartValueList");
                                          cartList = jsonDataList.map((item) => GetDataListResponseData.fromJson(item)).toList();
                                        } else {
                                          print("null value");
                                        }

                                        print(cartList.length);
                                        print(controller.productList.length);
                                        print("gjuierhuer");

                                        int l = cartList.length;
                                        int k = controller.productList.length;
                                        bool whichListIsBig = l < k;

                                        print(whichListIsBig);
                                        print("whichListIsBig");

                                        if (whichListIsBig) {
                                          if (cartList.isNotEmpty) {
                                            for (int i = 0; i < controller.productList.length; i++) {
                                              for (int j = 0; j < cartList.length; j++) {
                                                if (controller.productList[i].id == cartList[j].id) {
                                                  cartList[j] = controller.productList[i];
                                                  print("replace value");
                                                } else {
                                                  if (controller.productList[i].quantityCount != "0") {
                                                    cartList.add(controller.productList[i]);
                                                    print("add new");
                                                  }
                                                }
                                              }
                                            }
                                          } else {
                                            for (int i = 0; i < controller.productList.length; i++) {
                                              if (controller.productList[i].quantityCount != "0") {
                                                cartList.add(controller.productList[i]);
                                              }
                                            }
                                            print(cartList.length);
                                            print("cart list empty and add new");
                                          }
                                        } else {
                                          for (int i = 0; i < cartList.length; i++) {
                                            for (int j = 0; j < controller.productList.length; j++) {
                                              print("cartList[i].id");
                                              print(cartList[i].id);
                                              print(controller.productList[j].id);
                                              if (cartList[i].id == controller.productList[j].id) {
                                                cartList[i] = controller.productList[j];
                                                print("replace valueeee");
                                              } else {
                                                if (controller.productList[j].quantityCount != "0" && cartList[i].id != controller.productList[j].id) {
                                                  print(jsonEncode(controller.productList[j]));
                                                  cartList.add(controller.productList[j]);
                                                  print("cartList[i].quantityCount");
                                                }
                                              }
                                              break;
                                            }
                                            break;
                                          }
                                        }
                                        print(cartList);
                                        print(cartList.length);
                                        print("cartList.length");
                                        controller.update();

                                        // for (int i = 0; i < controller.productList.length; i++) {
                                        //   if (controller.productList[i].quantityCount != "0") {
                                        //     print(jsonEncode(controller.productList[i]));
                                        //     cartList.add(controller.productList[i]);
                                        //     print("cartList[i].quantityCount");
                                        //   }
                                        // }

                                        log(jsonEncode(cartList));
                                        await getStorageData.saveObject("cartValueList", cartList.cast<GetDataListResponseData>());
                                        utils.showSnackBar(context: context, message: "Successfully added");
                                        print(getStorageData.readObject("cartValueList"));

                                        print("cartListcartListcartListcartListcartListcartList");
                                        controller.update();
                                      },
                                    ),*/
