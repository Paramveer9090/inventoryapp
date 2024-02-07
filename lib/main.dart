import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';
import 'package:true_leaf_inventory_app/main_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  Loading();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends GetView<MainController> {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
      init: MainController(),
      assignId: true,
      builder: (controller) {
        return Sizer(
          builder: (BuildContext context, Orientation orientation, DeviceType deviceType) {
            return GetMaterialApp(
              title: "Application",
              initialRoute: AppPages.INITIAL,
              getPages: AppPages.routes,
              theme: AppColors.lightTheme,
              builder: EasyLoading.init(),
              debugShowCheckedModeBanner: false,
            );
          },
        );
      },
    );
  }
}
