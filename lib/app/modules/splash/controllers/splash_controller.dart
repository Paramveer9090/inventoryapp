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
//https://stackoverflow.com/questions/70016690/flutter-how-to-store-a-list-in-getstorage#:~:text=First%2C%20you%20need%20to%20define,convert%20your%20model%20to%20String.&text=readWithGetStorage()%20this%20method%20returns%20last%20added%20string.
