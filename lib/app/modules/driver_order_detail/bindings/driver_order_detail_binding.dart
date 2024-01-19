import 'package:get/get.dart';

import '../controllers/driver_order_detail_controller.dart';

class DriverOrderDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DriverOrderDetailController>(
      () => DriverOrderDetailController(),
    );
  }
}
