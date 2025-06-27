import '../modules/orders/controllers/orders_controller.dart';
import 'all_import.dart';

class BreadcrumbBar extends StatelessWidget {
  final OrdersController controller;
  const BreadcrumbBar(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final view = controller.currentView.value;
      String title;

      switch (view) {
        case ViewLevel.subCategories:
          title = "Sub-categories (${controller.categoryName.value})";
          break;
        case ViewLevel.products:
          title = "Go back to categories";
          break;
        default:
          title = "Categories";
      }

      return GestureDetector(
        onTap: () {
          if (controller.inSubCategories) {
            controller.resetToCategories();
          } else if (controller.inProducts) {
            if (controller.isAddedData.value) {
              Get.defaultDialog(
                title: "Discard changes?",
                middleText: "You have unsaved changes. Discard and go back?",
                textCancel: "Cancel",
                textConfirm: "Discard",
                onConfirm: () {
                  controller.resetToCategories();
                  Get.back();
                },
              );
            } else {
              controller.resetToCategories();
            }
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.5.h),
          child: Row(
            children: [
              if (view != ViewLevel.categories)
                const Icon(Icons.arrow_back_ios_sharp, size: 15),
              if (view != ViewLevel.categories) SizedBox(width: 1.h),
              AppText(title, fontSize: 13.sp, fontWeight: FontWeight.w600),
            ],
          ),
        ),
      );
    });
  }
}
