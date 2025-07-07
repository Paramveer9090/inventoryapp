import 'package:flutter/services.dart'; // Add this import
import 'package:get_storage/get_storage.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';
import 'package:true_leaf_inventory_app/main_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configure system UI to avoid navigation bar overlap
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent, // Make nav bar transparent
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarColor: Colors.transparent, // Make status bar transparent
    statusBarIconBrightness: Brightness.dark,
  ));
  
  // Make app draw behind system bars
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge, // This allows drawing behind system UI
  );
  
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
              title: "True Leaf Inventory",
              initialRoute: AppPages.INITIAL,
              getPages: AppPages.routes,
              theme: AppColors.lightTheme,
              builder: (context, child) {
                // Wrap with SafeArea at app level
                return SafeArea(
                  top: false, // Let status bar show
                  bottom: true, // Handle navigation bar
                  child: EasyLoading.init()(context, child),
                );
              },
              debugShowCheckedModeBanner: false,
            );
          },
        );
      },
    );
  }
}
