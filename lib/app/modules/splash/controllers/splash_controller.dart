import 'dart:async';

import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    NextScreen();
    super.onInit();
  }

  NextScreen() async {
    final data = await getStorageData.readObject(getStorageData.loginData);
    update();

    Timer(
      Duration(seconds: 2),
      () {
        if (data != null) {
          Get.offAllNamed(Routes.HOME);
        } else {
          Get.toNamed(Routes.LOGIN);
        }
      },
    );
  }
}
