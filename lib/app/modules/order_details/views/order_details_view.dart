import 'package:true_leaf_inventory_app/app/modules/product_details/views/product_details_view.dart';
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
            : ListView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 3.h),
                children: [
                  controller.getDetailsData!.customer == null || controller.getDetailsData!.customer!.companyName == null
                      ? Container()
                      : DetailsBox(
                          title: "Company Name",
                          value: controller.getDetailsData!.customer!.companyName,
                        ),
                  controller.getDetailsData!.customer == null || controller.getDetailsData!.customer!.contactName == null
                      ? Container()
                      : DetailsBox(
                          title: "Contact Person",
                          value: controller.getDetailsData!.customer!.contactName,
                        ),
                  controller.getDetailsData!.customer == null
                      ? Container()
                      : DetailsBox(
                          title: "Customer Name",
                          value: controller.getDetailsData!.customer!.name,
                        ),
                  controller.loginData?.roles?[0].title == "Delivery Agent" && (controller.getDetailsData!.customer == null || controller.getDetailsData!.customer!.address != null)
                      ? DetailsBox(
                          title: "Address",
                          value: controller.getDetailsData!.customer!.address,
                        )
                      : Container(),
                  controller.loginData?.roles?[0].title == "Delivery Agent" && controller.getDetailsData!.customer!.phoneNumber != null
                      ? DetailsBox(
                          title: "Phone Number",
                          value: controller.getDetailsData!.customer!.phoneNumber,
                        )
                      : Container(),
                  if (controller.loginData?.roles?[0].title == "Sales Manager")
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
                                    imagePath: controller.orderItem[index].image_url != null ? "${Constants.imageBaseUrl}${controller.orderItem[index].image_url}" : AppImages.dummy,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                              ),
                              SizedBox(width: 2.h),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    controller.orderItem[index].name.toString(),
                                    fontSize: 15.sp,
                                  ),
                                  AppText(
                                    "\$${controller.orderItem[index].salePrice.toString()}",
                                    fontSize: 15.sp,
                                    color: Color(0XFF44474d),
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
                                          padding: EdgeInsets.symmetric(horizontal: 2.h),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 15,
                                                width: 15,
                                                padding: EdgeInsets.all(1.5),
                                                decoration: BoxDecoration(
                                                  color: (controller.orderItem[index].isBox == 0 && subIndex == 0) || (controller.orderItem[index].isBox == 1 && subIndex == 1) ? AppColors.tableColor : Color(0XFF44474d),
                                                  borderRadius: BorderRadius.circular(50),
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: (controller.orderItem[index].isBox == 0 && subIndex == 0) || (controller.orderItem[index].isBox == 1 && subIndex == 1) ? AppColors.tableColor : AppColors.whiteColor,
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
                                    ],
                                  ),
                                  SizedBox(height: 1.h),
                                  Row(
                                    children: [
                                      GestureDetector(
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
                                        child: AppText(controller.orderItem[index].quantity.toString()),
                                      ),
                                      SizedBox(width: 1.h),
                                      GestureDetector(
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
                                  SizedBox(height: 1.h),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.h),
                                    decoration: BoxDecoration(
                                      color: Color(0xffecebed),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        AppText(
                                          "Description",
                                          fontSize: 13.sp,
                                          color: Color(0xffa6b9cf),
                                        ),
                                        AppText(
                                          "Description",
                                          maxLines: 10,
                                          color: Color(0xffb0b0b3),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (controller.loginData?.roles?[0].title == "Delivery Agent")
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
                                    imagePath: controller.orderItem[index].image_url != null ? "${Constants.imageBaseUrl}${controller.orderItem[index].image_url}" : AppImages.dummy,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                              ),
                              SizedBox(width: 2.h),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    controller.orderItem[index].name.toString(),
                                    fontSize: 15.sp,
                                  ),
                                  SizedBox(height: 1.h),
                                  AppText(
                                    "Qty.: ${controller.orderItem[index].quantity.toString()}",
                                    fontSize: 13.sp,
                                    color: Color(0XFF44474d),
                                  ),
                                ],
                              )
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppButton(
                                  title: "Edit Order",
                                  isIcon: true,
                                  icon: Icons.edit,
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        )
                      : controller.loginData?.id == controller.getDetailsData!.deliveryAgentId
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // FutureBuilder<Unit8List>(future: future, builder: builder)
                                // Container(
                                //   height: 25.h,
                                //   child: Image.memory(controller.decodedImage!),
                                // ),
                                // AppText(
                                //   "Customer Signature",z
                                //   fontWeight: FontWeight.w600,
                                //   fontSize: 14.sp,
                                // ),
                                // SizedBox(height: 2.h),
                                // controller.getDetailsData!.customerSign != null && controller.getDetailsData!.customerSign != "sign"
                                //     ? Container(height: 25.h, child: Image.network(controller.getDetailsData!.customerSign.toString()))
                                //     : Container(
                                //         height: 25.h,
                                //         decoration: BoxDecoration(
                                //           border: Border.all(
                                //             color: Color(0xffb0b0b3),
                                //           ),
                                //           borderRadius: BorderRadius.circular(15),
                                //         ),
                                //         child: SfSignaturePad(
                                //           key: controller.signatureGlobalKey,
                                //           minimumStrokeWidth: 1,
                                //           maximumStrokeWidth: 3,
                                //           strokeColor: Colors.black,
                                //         ),
                                //       ),
                                SizedBox(height: 2.h),
                                CustomTextFormField(
                                  hintText: "Enter your comment",
                                  label: "Comment",
                                  readOnly: controller.loginData?.id == controller.getDetailsData!.deliveryAgentId ? false : true,
                                  validator: (value) => Validators.requiredEmail(value),
                                ),
                                SizedBox(height: 5.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: AppButton(
                                        color: AppColors.secondButtonColor,
                                        title: 'Cancel',
                                        onTap: () {
                                          Get.find<HomeController>().isSelected.value = 1;
                                          Get.find<HomeController>().update();
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 4.h),
                                    Expanded(
                                      child: AppButton(
                                        onTap: () async {
                                          controller.handleSaveButtonPressed();
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
                ],
              );
      },
    );
  }
}
