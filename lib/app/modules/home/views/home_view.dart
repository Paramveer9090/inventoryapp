import 'package:true_leaf_inventory_app/app/modules/cart/views/cart_view.dart';
import 'package:true_leaf_inventory_app/app/modules/customers/controllers/customers_controller.dart';
import 'package:true_leaf_inventory_app/app/modules/driver_order/controllers/driver_order_controller.dart';
import 'package:true_leaf_inventory_app/app/modules/orders/views/orders_view.dart';
import 'package:true_leaf_inventory_app/app/modules/products/views/products_view.dart';

import '../../../widgets/all_import.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      assignId: true,
      builder: (controller) {
        if (accessToken != null &&
            controller.loginData!.roles![0].title == "Sales Manager") {
          Get.put(ProductsController());
        }
        return controller.loginData?.roles![0].title == "Sales Manager"
            ? PopScope(
                canPop: false,
                onPopInvokedWithResult: (didPop, result) async {
                  if (didPop) return;
                  print("ordersordersordersorders");
                  print(controller.addOrder.value);
                  print(controller.isOrderEdit.value);
                  print(orderId);
                  print(customerCartId);

                  // print("will pop scope");
                  // print(controller.isCart.value);
                  // print(controller.isOrderDetails.value && controller.isOrderEdit.value);
                  // print(controller.isOrderDetails.value);
                  // print(Get.find<ProductsController>().productDetails.value && controller.isDrawerSelected.value == 1 && controller.isSelected.value == 4);
                  if (Get.find<ProductsController>().productDetails.value &&
                      controller.isDrawerSelected.value == 1 &&
                      controller.isSelected.value == 4) {
                    Get.find<ProductsController>().productDetails.value = false;
                    Get.find<ProductsController>().update();
                    controller.update();
                    // return true;
                  } else if (controller.isCart.value) {
                    if (controller.isSelected.value == 5) {
                      controller.isSelected.value = 0;
                    }
                    Future.delayed(
                      Duration(milliseconds: 1),
                      () {
                        controller.isCart.value = false;
                      },
                    );
                    controller.update();
                    // return true;
                  } else if (controller.isOrderEdit.value &&
                      controller.addOrder.value) {
                    controller.addOrder.value = false;
                    controller.isSelected.value = 2;
                    controller.isOrderDetails.value = true;
                    controller.update();
                  } else if (controller.isOrderDetails.value &&
                      controller.isOrderEdit.value) {
                    controller.isOrderDetails.value = false;
                    controller.isOrderEdit.value = false;
                    Get.find<MyOrdersController>().update();
                    controller.update();
                  } else if (controller.isOrderDetails.value) {
                    controller.isOrderDetails.value = false;
                    Get.find<MyOrdersController>().update();
                    controller.update();
                  } else if (controller.isCustomerDetails.value) {
                    controller.isCustomerDetails.value = false;
                    Get.find<CustomersController>().update();
                    controller.update();
                  }
                },
                child: Scaffold(
                  key: controller.key,
                  backgroundColor: AppColors.primaryColor,
                  appBar: AppBar(
                    forceMaterialTransparency: true,
                    centerTitle: true,
                    backgroundColor: AppColors.primaryColor,
                    title: AppText(
                      Get.find<ProductsController>().productDetails.value
                          ? AppStrings.productDetails
                          : controller.addOrder.value
                              ? AppStrings.orders
                              : controller.isOrderDetails.value &&
                                      controller.isOrderEdit.value
                                  ? AppStrings.editOrder
                                  : controller.isOrderDetails.value
                                      ? AppStrings.orderDetail
                                      : controller.isCart.value
                                          ? AppStrings.cart
                                          : controller.isCustomerDetails.value
                                              ? AppStrings.customersDetails
                                              : controller.titleList[
                                                  controller.isSelected.value],
                      fontSize: 14.sp,
                      color: AppColors.whiteColor,
                    ),
                    leading: Get.find<ProductsController>()
                                .productDetails
                                .value &&
                            controller.isDrawerSelected.value == 1 &&
                            controller.isSelected.value == 4
                        ? GestureDetector(
                            onTap: () {
                              Get.find<ProductsController>()
                                  .productDetails
                                  .value = false;
                              Get.find<ProductsController>().update();
                              controller.update();
                            },
                            child: Icon(
                              Icons.arrow_back_outlined,
                              color: AppColors.whiteColor,
                            ),
                          )
                        : controller.isCart.value
                            ? GestureDetector(
                                onTap: () {
                                  if (controller.isSelected.value == 5) {
                                    controller.isSelected.value = 0;
                                  }

                                  print(controller.isSelected.value);
                                  Future.delayed(
                                    Duration(milliseconds: 1),
                                    () {
                                      controller.isCart.value = false;
                                    },
                                  );
                                  controller.update();
                                },
                                child: Icon(
                                  Icons.arrow_back_outlined,
                                  color: AppColors.whiteColor,
                                ),
                              )
                            : controller.isOrderEdit.value &&
                                    controller.addOrder.value
                                ? GestureDetector(
                                    onTap: () {
                                      controller.addOrder.value = false;
                                      controller.isSelected.value = 2;
                                      controller.isOrderDetails.value = true;
                                      controller.update();
                                    },
                                    child: Icon(
                                      Icons.arrow_back_outlined,
                                      color: AppColors.whiteColor,
                                    ),
                                  )
                                : controller.isOrderDetails.value &&
                                        controller.isOrderEdit.value
                                    ? GestureDetector(
                                        onTap: () {
                                          controller.isOrderDetails.value =
                                              false;
                                          controller.isOrderEdit.value = false;
                                          Get.find<MyOrdersController>()
                                              .update();
                                          controller.update();
                                        },
                                        child: Icon(
                                          Icons.arrow_back_outlined,
                                          color: AppColors.whiteColor,
                                        ),
                                      )
                                    : controller.isOrderDetails.value
                                        ? GestureDetector(
                                            onTap: () {
                                              controller.isOrderDetails.value =
                                                  false;
                                              Get.find<MyOrdersController>()
                                                  .update();
                                              controller.update();
                                            },
                                            child: Icon(
                                              Icons.arrow_back_outlined,
                                              color: AppColors.whiteColor,
                                            ),
                                          )
                                        : controller.isCustomerDetails.value
                                            ? GestureDetector(
                                                onTap: () {
                                                  controller.isCustomerDetails
                                                      .value = false;
                                                  Get.find<
                                                          CustomersController>()
                                                      .update();
                                                  controller.update();
                                                },
                                                child: Icon(
                                                  Icons.arrow_back_outlined,
                                                  color: AppColors.whiteColor,
                                                ),
                                              )
                                            : Container(),
                    actions: [
                      controller.isCart.value
                          ? Container()
                          : GestureDetector(
                              onTap: () async {
                                if (await controller.addOrder.value) {
                                  controller.addOrder.value = false;
                                }
                                if (await controller.isCustomerDetails.value) {
                                  controller.isCustomerDetails.value = false;
                                }

                                controller.isCart.value = true;
                                controller.update();
                              },
                              child: Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 2.2.h),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Image.asset(
                                      AppImages.ic_cart,
                                      height: 3.h,
                                      width: 3.h,
                                    ),
                                    Positioned(
                                      top: -15,
                                      right: -10,
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: Color(0xffba1a1a),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: AppText(
                                            cartLength,
                                            color: AppColors.whiteColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                  bottomNavigationBar: Container(
                    color: Colors.white,
                    child: Container(
                      height: 10.h,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ...List.generate(
                            controller.iconList.length,
                            (index) => GestureDetector(
                              onTap: () {
                                if (controller.isDrawerSelected.value != 0) {
                                  controller.isDrawerSelected.value = 0;
                                }
                                if (controller.addOrder.value) {
                                  controller.addOrder.value = false;
                                }
                                if (controller.isCustomerDetails.value) {
                                  controller.isCustomerDetails.value = false;
                                }
                                if (controller.isCart.value) {
                                  controller.isCart.value = false;
                                }
                                if (controller.isOrderDetails.value &&
                                    controller.isOrderEdit.value) {
                                  controller.isOrderDetails.value = false;
                                  controller.isOrderEdit.value = false;
                                }
                                if (controller.isOrderDetails.value) {
                                  controller.isOrderDetails.value = false;
                                }

                                controller.isSelected.value = index;
                                controller.update();
                                if (controller.isSelected.value == 4) {
                                  controller.key.currentState!.openDrawer();
                                }
                              },
                              child: Image.asset(
                                controller.isSelected.value == index
                                    ? controller.selectedIconList[index]
                                    : controller.iconList[index],
                                height: 3.5.h,
                                width: 3.5.h,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onDrawerChanged: (value) {
                    if (value == false &&
                        controller.isDrawerSelected.value == 0) {
                      controller.isSelected.value = 0;
                      controller.update();
                    }
                  },
                  drawer: Drawer(
                    backgroundColor: AppColors.primaryColor,
                    child: controller.loginData == null
                        ? Container()
                        : ListView(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10.h),
                              Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 2.h),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppText(
                                        "Welcome,",
                                        fontSize: 13.sp,
                                        color: Colors.white,
                                      ),
                                      SizedBox(height: 1.h),
                                      AppText(
                                        controller.loginData!.name.toString(),
                                        fontSize: 22.sp,
                                        color: Colors.white,
                                      ),
                                      SizedBox(height: 1.h),
                                      Divider(),
                                      SizedBox(height: 1.h),
                                      ...List.generate(
                                          controller.drawerList.length,
                                          (drawerIndex) {
                                        return GestureDetector(
                                          onTap: () {
                                            controller.isDrawerSelected.value =
                                                drawerIndex + 1;

                                            if (drawerIndex == 3) {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return DeletePopup(
                                                    isDelete: true,
                                                    onTap: () {
                                                      controller.logout();
                                                    },
                                                  );
                                                },
                                              );
                                            } else if (drawerIndex == 0) {
                                              controller.isSelected.value = 4;
                                              Get.back();
                                            } else if (drawerIndex == 1) {
                                              controller.isSelected.value = 1;
                                              Get.back();
                                            } else if (drawerIndex == 2) {
                                              controller.isSelected.value = 2;
                                              Get.back();
                                            }
                                            controller.update();
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2.5.h,
                                                horizontal: 3.h),
                                            margin: EdgeInsets.symmetric(
                                                vertical: 1.h),
                                            decoration: BoxDecoration(
                                              // color: controller.isDrawerSelected.value == drawerIndex ? AppColors.tableColor.withOpacity(0.3) : AppColors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Image.asset(
                                                  controller.drawerImageList[
                                                      drawerIndex],
                                                  height: 2.8.h,
                                                  width: 2.8.h,
                                                ),
                                                SizedBox(width: 2.h),
                                                AppText(
                                                  controller
                                                      .drawerList[drawerIndex],
                                                  fontSize: 14.sp,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                    ],
                                  )),
                            ],
                          ),
                  ),
                  body: Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: Center(
                      child: controller.isDrawerSelected.value == 1 &&
                              controller.isSelected.value == 4
                          ? ProductsView()
                          : controller.addOrder.value
                              ? OrdersView(
                                  customerId: controller.isCustomerId.value)
                              : controller.isCart.value
                                  ? CartView()
                                  : controller
                                      .screens[controller.isSelected.value],
                    ),
                  ),
                ),
              )
            : accessToken != null
                ? PopScope(
                    canPop: false,
                    onPopInvokedWithResult: (didPop, result) async {
                      if (didPop) return;
                      if (controller.isOrderDetails.value) {
                        controller.isOrderDetails.value = false;
                        Get.find<DriverOrderController>().update();
                        controller.isSelected.value = 1;
                      }
                      controller.update();
                    },
                    child: Scaffold(
                      backgroundColor: AppColors.primaryColor,
                      appBar: AppBar(
                        forceMaterialTransparency: true,
                        centerTitle: true,
                        backgroundColor: AppColors.primaryColor,
                        title: AppText(
                          controller.isOrderDetails.value
                              ? AppStrings.orderDetail
                              : controller.titleDeliveryList[
                                  controller.isSelected.value],
                          fontSize: 14.sp,
                          color: AppColors.whiteColor,
                        ),
                        leading: controller.isOrderDetails.value
                            ? GestureDetector(
                                onTap: () {
                                  controller.isOrderDetails.value = false;
                                  Get.find<DriverOrderController>().update();
                                  controller.update();
                                },
                                child: Icon(
                                  Icons.arrow_back_outlined,
                                  color: AppColors.whiteColor,
                                ),
                              )
                            : Container(),
                        actions: [
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return DeletePopup(
                                    isDelete: true,
                                    onTap: () {
                                      controller.logout();
                                    },
                                  );
                                },
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 1.8.h),
                              child: Icon(
                                Icons.login_outlined,
                                color: AppColors.whiteColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      bottomNavigationBar: Container(
                        color: Colors.white,
                        child: Container(
                          height: 10.h,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(30),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ...List.generate(
                                controller.iconDeliveryList.length,
                                (index) => GestureDetector(
                                  onTap: () {
                                    controller.isSelected.value = index;
                                    if (controller.isOrderDetails.value) {
                                      controller.isOrderDetails.value = false;
                                    }
                                    controller.update();
                                  },
                                  child: Image.asset(
                                    controller.isSelected.value == index
                                        ? controller
                                            .selectedDeliveryIconList[index]
                                        : controller.iconDeliveryList[index],
                                    height: 3.5.h,
                                    width: 3.5.h,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      body: Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                        child: Center(
                          child: controller
                              .screensDelivery[controller.isSelected.value],
                        ),
                      ),
                    ),
                  )
                : Container();
      },
    );
  }
}
