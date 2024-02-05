import 'package:true_leaf_inventory_app/app/models/details_response_model.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';
import 'package:true_leaf_inventory_app/app/widgets/app_button.dart';
import 'package:true_leaf_inventory_app/app/widgets/custom_image.dart';
import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      assignId: true,
      init: CartController(),
      builder: (controller) {
        return controller.isCongratulations.value
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.h),
                child: Column(
                  children: [
                    SizedBox(height: 8.h),
                    Image.asset(
                      AppImages.ic_congratulations,
                      height: 15.h,
                      width: 15.h,
                    ),
                    SizedBox(height: 5.h),
                    AppText(
                      "Congratulations!",
                      fontSize: 23.sp,
                      color: Color(0xff38A171),
                    ),
                    SizedBox(height: 5.h),
                    AppText(
                      "Your order has been placed successfully.",
                      fontSize: 15.sp,
                      textAlign: TextAlign.center,
                      color: Color(0XFF44474d),
                    ),
                    SizedBox(height: 2.h),
                    AppButton(
                      title: "Go back to dashboard",
                      isIcon: true,
                      icon: Icons.arrow_back_ios_new,
                      onTap: () {
                        Get.find<HomeController>().isCart.value = false;
                        Get.find<HomeController>().isSelected.value = 0;
                        Get.find<HomeController>().update();
                      },
                    )
                  ],
                ),
              )
            : controller.orderItemList.isEmpty
                ? Center(
                    child: AppText(
                      controller.noData.value,
                      fontSize: 13.sp,
                      color: AppColors.greyColor,
                    ),
                  )
                : ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      ListView.builder(
                        itemCount: controller.orderItemList.length,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 2.h),
                        itemBuilder: (context, index) {
                          CartDetails? data = controller.orderItemList[index];
                          return Card(
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
                                        imagePath: data.imageUrl != null ? "${Constants.imageBaseUrl}${data.imageUrl}" : AppImages.dummy,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
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
                                          color: Color(0XFF44474d),
                                        ),
                                        AppText(
                                          "Taxes: ${data.tax.toString()}%",
                                          fontSize: 15.sp,
                                          color: Color(0XFF44474d),
                                        ),
                                        SizedBox(height: 1.h),
                                        Row(
                                          children: [
                                            ...List.generate(
                                              2,
                                              (subIndex) => Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 2.h),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    data.isBox = subIndex;
                                                    print(data.isBox);
                                                    print("data.isBox");
                                                    controller.update();
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        height: 15,
                                                        width: 15,
                                                        padding: EdgeInsets.all(1.5),
                                                        decoration: BoxDecoration(
                                                          color: (data.isBox == 0 && subIndex == 0) || (data.isBox == 1 && subIndex == 1) ? AppColors.tableColor : Color(0XFF44474d),
                                                          borderRadius: BorderRadius.circular(50),
                                                        ),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            color: (data.isBox == 0 && subIndex == 0) || (data.isBox == 1 && subIndex == 1) ? AppColors.tableColor : AppColors.whiteColor,
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
                                        SizedBox(height: 1.h),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    controller.isAddedData.value = true;
                                                    if (int.parse(data.quantity.toString()) > 0) {
                                                      data.quantity = (int.parse(data.quantity.toString()) - 1).toString();
                                                    }

                                                    controller.amountTax = ((double.parse(controller.orderItemList[index].quantity.toString()) * double.parse(controller.orderItemList[index].price.toString())) * double.parse(controller.orderItemList[index].tax.toString())) / 100;
                                                    controller.amount = (double.parse(controller.orderItemList[index].quantity!.toString())) * double.parse(controller.orderItemList[index].price.toString());
                                                    controller.orderItemList[index].amountWithoutTax = controller.amount.toString();
                                                    controller.orderItemList[index].amountOnlyTax = controller.amountTax.toString();
                                                    controller.orderItemList[index].finalAmount = (controller.amount + controller.amountTax).toString();

                                                    controller.orderTotal.value = (controller.orderItemList.fold<double>(0, (sum, item) => sum + double.parse(item.amountWithoutTax.toString()))).toString();
                                                    controller.orderTax.value = (controller.orderItemList.fold<double>(0, (sum, item) => sum + double.parse(item.amountOnlyTax.toString()))).toString();
                                                    controller.orderFinalTotal.value = (double.parse(controller.orderTotal.value) + double.parse(controller.orderTax.value)).toString();

                                                    data.quantity!.isEmpty
                                                        ? controller.isWrongData.value = true
                                                        : /*data.isBox == 1
                                                            ? (double.parse(data.boxSize.toString()) * double.parse(data.quantity!)) > double.parse(data.stock.toString())
                                                                ? controller.isWrongData.value = true
                                                                : data.isBox == 0
                                                                    ? double.parse(data.quantity!.text) > double.parse(data.stock.toString())
                                                                        ? controller.isWrongData.value = true
                                                                        : ""
                                                                    : controller.isWrongData.value = false
                                                            : data.isBox == 0
                                                                ?*/
                                                        double.parse(data.quantity.toString()) > double.parse(data.stock.toString())
                                                            ? controller.isWrongData.value = true
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
                                                Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.5.h),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(
                                                        color: Color(0xffe9e7ea),
                                                      )),
                                                  child: AppText(data.quantity.toString()),
                                                ),
                                                SizedBox(width: 1.h),
                                                GestureDetector(
                                                  onTap: () async {
                                                    controller.isAddedData.value = true;
                                                    controller.productId.value = await data.productId.toString();
                                                    controller.productName.value = await data.productName.toString();
                                                    data.quantity = await (int.parse(data.quantity.toString()) + 1).toString();

                                                    controller.amountTax = ((double.parse(controller.orderItemList[index].quantity.toString()) * double.parse(controller.orderItemList[index].price.toString())) * double.parse(controller.orderItemList[index].tax.toString())) / 100;
                                                    controller.amount = (double.parse(controller.orderItemList[index].quantity!.toString())) * double.parse(controller.orderItemList[index].price.toString());
                                                    controller.orderItemList[index].amountWithoutTax = controller.amount.toString();
                                                    controller.orderItemList[index].amountOnlyTax = controller.amountTax.toString();
                                                    controller.orderItemList[index].finalAmount = (controller.amount + controller.amountTax).toString();

                                                    controller.orderTotal.value = (controller.orderItemList.fold<double>(0, (sum, item) => sum + double.parse(item.amountWithoutTax.toString()))).toString();
                                                    controller.orderTax.value = (controller.orderItemList.fold<double>(0, (sum, item) => sum + double.parse(item.amountOnlyTax.toString()))).toString();
                                                    controller.orderFinalTotal.value = (double.parse(controller.orderTotal.value) + double.parse(controller.orderTax.value)).toString();

                                                    ///
                                                    data.quantity!.isEmpty
                                                        ? controller.isWrongData.value = true
                                                        : /*data.isBox == 1
                                                            ? (double.parse(data.boxSize.toString()) * double.parse(data.quantity!)) > double.parse(data.stock.toString())
                                                                ? controller.isWrongData.value = true
                                                                : data.isBox == 0
                                                                    ? double.parse(data.quantity) > double.parse(data.stock.toString())
                                                                        ? controller.isWrongData.value = true
                                                                        : ""
                                                                    : controller.isWrongData.value = false
                                                            : data.isBox == 0
                                                                ?*/
                                                        double.parse(data.quantity.toString()) > double.parse(data.stock.toString())
                                                            ? controller.isWrongData.value = true
                                                            : /*""
                                                                : */
                                                            controller.isWrongData.value = false;
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
                                                Spacer(),
                                                GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return DeletePopup(
                                                          type: "product",
                                                          onTap: () {
                                                            controller.deleteCartAPI(id: data.productId, index: index);
                                                          },
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Image.asset(
                                                    AppImages.ic_delete,
                                                    height: 4.h,
                                                    width: 4.h,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 2, left: 5),
                                              child: AppText(
                                                data.quantity == null
                                                    ? "Please Enter Quantity"
                                                    : /* data.isBox == 1
                                                        ? (double.parse(data.boxSize.toString()) * double.parse(data.quantity.toString())) > double.parse(data.stock.toString())
                                                            ? "Quantity can't be greater than In Stock"
                                                            : data.isBox == 0
                                                                ? double.parse(data.quantity) > double.parse(data.stock.toString())
                                                                    ? "Quantity can't be greater than In Stock"
                                                                    : ""
                                                                : ""
                                                        :
                                                    data.isBox == 0
                                                        ?*/
                                                    double.parse(data.quantity.toString()) > double.parse(data.stock.toString())
                                                        ? "Quantity can't be greater than In Stock"
                                                        : /* ""
                                                        : */
                                                        "",
                                                color: AppColors.darkRedColor,
                                                maxLines: 2,
                                                fontSize: 10.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 1.h),
                                        CustomTextFormField(
                                          hintText: "Enter your description here",
                                          label: "Description",
                                          controller: data.comment,
                                          validator: (value) => Validators.requiredEmail(value),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText(
                                  "Total",
                                  fontSize: 13.sp,
                                  color: Color(0XFF44474d),
                                ),
                                AppText(
                                  "\$ ${controller.orderTotal.value}",
                                  fontSize: 14.sp,
                                  color: Color(0XFF44474d),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText(
                                  "Taxes & charges",
                                  fontSize: 13.sp,
                                  color: Color(0XFF44474d),
                                ),
                                AppText(
                                  "\$ ${controller.orderTax.value}",
                                  fontSize: 14.sp,
                                  color: Color(0XFF44474d),
                                ),
                              ],
                            ),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText(
                                  "Grand Total",
                                  color: AppColors.primaryColor,
                                  fontSize: 14.sp,
                                ),
                                AppText(
                                  "\$ ${controller.orderFinalTotal.value}",
                                  fontSize: 15.sp,
                                ),
                              ],
                            ),
                            SizedBox(height: 5.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppButton(
                                  title: "Place order",
                                  isIcon: true,
                                  icon: Icons.shopping_cart,
                                  onTap: () {
                                    print(controller.isWrongData.value);
                                    if (controller.isWrongData.value == false) {
                                      controller.postOrderAPI();
                                    }
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 2.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppButton(
                                  title: "Add To Cart",
                                  color: AppColors.primaryColor,
                                  isIcon: true,
                                  icon: Icons.shopping_cart,
                                  onTap: () {
                                    Get.find<HomeController>().isCart.value = false;
                                    Get.find<HomeController>().isCustomerDetails.value = false;
                                    Get.find<HomeController>().isSelected.value = 5;

                                    Get.find<HomeController>().isCustomerId.value = controller.customerId.value;
                                    print("ididididid ${Get.find<HomeController>().isCustomerId.value}");
                                    Get.find<HomeController>().addOrder.value = true;
                                    Get.find<HomeController>().update();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
      },
    );
  }
}
