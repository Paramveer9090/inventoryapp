import 'package:true_leaf_inventory_app/app/modules/driver_order/controllers/driver_order_controller.dart';
import 'package:true_leaf_inventory_app/app/widgets/consistent_icon.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class DriverHomeShell extends StatelessWidget {
  final HomeController controller;

  const DriverHomeShell({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
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
        appBar: _DriverAppBar(controller: controller),
        bottomNavigationBar: _DriverBottomNav(controller: controller),
        body: _DriverBody(controller: controller),
      ),
    );
  }
}

class _DriverAppBar extends StatelessWidget implements PreferredSizeWidget {
  final HomeController controller;

  const _DriverAppBar({Key? key, required this.controller}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true,
      centerTitle: true,
      backgroundColor: AppColors.primaryColor,
      title: AppText(
        controller.isOrderDetails.value
            ? AppStrings.orderDetail
            : controller.titleDeliveryList[controller.isSelected.value],
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
          : const SizedBox.shrink(),
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
    );
  }
}

class _DriverBottomNav extends StatelessWidget {
  final HomeController controller;

  const _DriverBottomNav({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Container(
        height: 10.h,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: const BorderRadius.vertical(
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
                child: ConsistentIcon(
                  iconPath: controller.isSelected.value == index
                      ? controller.selectedDeliveryIconList[index]
                      : controller.iconDeliveryList[index],
                  isSelected: controller.isSelected.value == index,
                  containerSize: 5.h,
                  iconSize: 3.2.h,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DriverBody extends StatelessWidget {
  final HomeController controller;

  const _DriverBody({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      child: Center(
        child: controller.screensDelivery[controller.isSelected.value],
      ),
    );
  }
}
