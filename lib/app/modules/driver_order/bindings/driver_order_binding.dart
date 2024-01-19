import 'package:get/get.dart';

import '../controllers/driver_order_controller.dart';

class DriverOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DriverOrderController>(
      () => DriverOrderController(),
    );
  }
}
