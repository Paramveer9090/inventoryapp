import 'package:flutter_animate/flutter_animate.dart';
import '../../../widgets/all_import.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: SplashController(),
      assignId: true,
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.primaryColor,
          body: Center(
              child: Hero(
            tag: "splash_logo",
            child: Animate(
              effects: [ScaleEffect()],
              child: Image.asset(
                AppImages.appLogo,
                height: 25.h,
                width: 25.h,
              ),
            ),
          )),
        );
      },
    );
  }
}
