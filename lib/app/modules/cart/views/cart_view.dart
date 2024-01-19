import 'package:flutter/material.dart';

import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';
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
        return ListView.builder(
          itemCount: controller.orderItem.length,
          padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 2.h),
          itemBuilder: (context, index) {
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
                          imagePath: controller.orderItem[index].productImage != null ? "${Constants.imageBaseUrl}${controller.orderItem[index].productImage}" : AppImages.dummy,
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
                          controller.orderItem[index].productName.toString(),
                          fontSize: 15.sp,
                        ),
                        AppText(
                          "\$${controller.orderItem[index].sellingPrice.toString()}",
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
                                        color: (controller.orderItem[index].boxUnit == 0 && subIndex == 0) || (controller.orderItem[index].boxUnit == 1 && subIndex == 1) ? AppColors.tableColor : Color(0XFF44474d),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: (controller.orderItem[index].boxUnit == 0 && subIndex == 0) || (controller.orderItem[index].boxUnit == 1 && subIndex == 1) ? AppColors.tableColor : AppColors.whiteColor,
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
                              child: AppText(controller.orderItem[index].quality!.text),
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
                            SizedBox(width: 10.h),
                            Image.asset(
                              AppImages.ic_delete,
                              height: 4.h,
                              width: 4.h,
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Container(
                          width: 25.h,
                          child: CustomTextFormField(
                            hintText: "Enter your description here",
                            label: "Description",
                            validator: (value) => Validators.requiredEmail(value),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
