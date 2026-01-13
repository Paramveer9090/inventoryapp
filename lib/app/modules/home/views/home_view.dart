import 'package:true_leaf_inventory_app/app/modules/home/views/widgets/driver_home_shell.dart';
import 'package:true_leaf_inventory_app/app/modules/home/views/widgets/sales_home_shell.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      assignId: true,
      builder: (controller) {
        final isSalesManager = controller.loginData?.roles?[0].title == "Sales Manager";

        if (accessToken != null && isSalesManager) {
          Get.put(ProductsController());
        }

        if (isSalesManager) {
          return SalesHomeShell(controller: controller);
        }

        if (accessToken != null) {
          return DriverHomeShell(controller: controller);
        }

        return Container();
      },
    );
  }
}
