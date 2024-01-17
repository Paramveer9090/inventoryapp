import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';
import 'package:true_leaf_inventory_app/app/widgets/app_button.dart';
import '../controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChangePasswordController>(
      assignId: true,
      init: ChangePasswordController(),
      builder: (controller) {
        return ListView(
          padding: EdgeInsets.all(12),
          children: [
            SizedBox(height: 2.h),
            CustomTextFormField(
              label: 'New Password',
              obscureText: true,
              suffixVisibility: true,
              hintText: "Enter New Password",
              controller: controller.newPassword,
              validator: (value) {
                if (value!.isEmpty) {
                  return Validators.password(value);
                } else if (controller.newPassword.text.length < 8) {
                  return "The password must be at least 8 characters.";
                }
              },
            ),
            SizedBox(height: 16),
            CustomTextFormField(
              label: 'Confirm Password',
              hintText: "Enter Confirm Password",
              obscureText: true,
              suffixVisibility: true,
              controller: controller.repeatPassword,
              validator: (value) {
                if (value!.isEmpty) {
                  return Validators.password(value);
                } else if (controller.newPassword.text != controller.repeatPassword.text) {
                  return "New password and Repeat password does not match";
                }
              },
            ),
            SizedBox(height: 35),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    color: AppColors.secondButtonColor,
                    title: 'Cancel',
                    onTap: () {
                      Get.find<HomeController>().isSelected.value = 0;
                      Get.find<HomeController>().update();
                    },
                  ),
                ),
                SizedBox(width: 4.h),
                Expanded(
                  child: AppButton(
                    onTap: () async {
                      if (controller.isValidation()) {
                        controller.changePasswordAPI();
                      }
                    },
                    title: 'Save',
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
    ;
  }
}
