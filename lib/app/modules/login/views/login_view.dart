import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';
import 'package:true_leaf_inventory_app/app/widgets/app_button.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
      assignId: true,
      builder: (controller) {
        final formKey = GlobalKey<FormState>();
        return Scaffold(
          backgroundColor: AppColors.primaryColor,
          body: GestureDetector(
            onTap: () {
              utils.hideKeyboard(context);
            },
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Hero(
                          tag: "splash_logo",
                          transitionOnUserGestures: true,
                          child: Image.asset(
                            AppImages.appLogo,
                            height: 20.h,
                            width: 20.h,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        AppText(
                          'Login',
                          fontSize: 18.sp,
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: 6.h),
                        CustomTextFormField(
                          hintText: "Enter your email",
                          label: AppStrings.email,
                          controller: controller.email,
                          validator: (value) => Validators.requiredEmail(value),
                        ),
                        SizedBox(height: 2.5.h),
                        CustomTextFormField(
                          label: AppStrings.password,
                          suffixVisibility: true,
                          obscureText: true,
                          hintText: "Enter your password",
                          controller: controller.password,
                          validator: (value) => Validators.password(value),
                        ),
                        SizedBox(height: 6.h),
                        AppButton(
                          title: AppStrings.login,
                          fontSize: 13.sp,
                          onTap: () {
                            // if (formKey.currentState!.validate()) {
                            //   controller.loginAPI();
                            // }
                            if (controller.isValidation()) {
                              controller.loginAPI();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
