import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:true_leaf_inventory_app/app/models/report_model.dart';
import 'package:true_leaf_inventory_app/app/modules/customer_details/views/customer_details_view.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';
import 'package:true_leaf_inventory_app/app/widgets/app_button.dart';
import 'package:true_leaf_inventory_app/app/widgets/custom_search_bar.dart';

import '../controllers/customers_controller.dart';

class CustomersView extends GetView<CustomersController> {
  const CustomersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomersController>(
      assignId: true,
      init: CustomersController(),
      builder: (controller) {
        return Get.find<HomeController>().isCustomerDetails.value
            ? CustomerDetailsView(id: controller.id.value)
            : Column(
                children: [
                  SizedBox(height: 2.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.h),
                    child: CustomSearchBar(
                      hint: 'Search',
                      onChanged: (value) {
                        controller.search(text: value);
                        controller.update();
                      },
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppButton(
                        title: "Create Order",
                        onTap: () {
                          Get.find<HomeController>().addOrder.value = true;
                          Get.find<HomeController>().update();
                        }),
                  ),
                  SizedBox(height: 2.h),
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.customerList.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        Customers data = controller.customerList[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                controller.id.value = data.id.toString();
                                controller.update();
                                Get.find<HomeController>().isCustomerDetails.value = true;
                                Get.find<HomeController>().update();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        AppText(
                                          data.companyName.toString(),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15.sp,
                                          color: AppColors.primaryColor,
                                        ),
                                        SizedBox(height: 0.5.h),
                                        AppText(
                                          data.name.toString(),
                                          fontSize: 13.sp,
                                          color: Color(0XFF44474d),
                                        ),
                                        SizedBox(height: 0.5.h),
                                        AppText(
                                          data.phoneNumber.toString(),
                                          color: Color(0XFF44474d),
                                          fontSize: 13.sp,
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: AppColors.arrowColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
      },
    );
  }
}
